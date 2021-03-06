#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "pstat.h"
// #include <stdlib.h>


struct proc* q0[64];
struct proc* q1[64];
struct proc* q2[64];
int c0 = -1;
int c1 = -1;
int c2 = -1;
int quantumTime[3] = {1, 2, 8};
struct sched_stat_t pstat_var[64];



struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);
extern void getpinfo(void);
static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;

  if (readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;

  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  // cprintf("%s ,%d ", "BEG VAL: ", c0);

  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;


  pstat_var[p->pid].start_tick[0] = 0;
  pstat_var[p->pid].start_tick[1] = 0;
  pstat_var[p->pid].start_tick[2] = 0;
  pstat_var[p->pid].currDur = 0;

  pstat_var[p->pid].priority[0] = p->priority;
  // pstat_var[p->pid].inuse = 1;
  p->priority = 0;
  p->clicks = 0;
  pstat_var[p->pid].pid = p->pid;


  c0++;
  q0[c0] = p;
  // getpinfo();
  release(&ptable.lock);
  cprintf("%s ,%d ", "WAS NOT FOUND OF ALLOC PROC VAL: ", c0);

  return 0;

found:
  p->pid = nextpid++;


  pstat_var[p->pid].start_tick[0] = 0;
  pstat_var[p->pid].priority[0] = p->priority;
  // pstat_var[p->pid].inuse = 1;
  p->state = EMBRYO;
  pstat_var[p->pid].pid = p->pid;
  p->priority = 0;
  p->clicks = 0;
  c0++;
  q0[c0] = p;
  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0) {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof * p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof * p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof * p->context);
  p->context->eip = (uint)forkret;

  //Initialization of added data members
  p->printSys = 0; //Initially turning off printsys
  p->numCalls = 0; //Setting the current number of calls to 0
  // cprintf("%s ,%d ", "END OF ALLOC PROC VAL: ", c0);

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0) {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if (n < 0) {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0) {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
    if (curproc->ofile[fd]) {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->parent == curproc) {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;) {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE) {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed) {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{


  struct proc *p;
  struct cpu *c = mycpu();
  // c->proc = 0;
  int i;


  for (;;) {

    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.

    acquire(&ptable.lock);



    if (c0 != -1) {


      for ( i = 0; i <= c0; i++) {
        if (q0[i]->state != RUNNABLE) {

          continue;
        }
        else {

          p = q0[i];
          c->proc = q0[i];
          p->clicks++;
          switchuvm(p);
          p->state = RUNNING;
          swtch(&(c->scheduler), p->context);
          switchkvm();

          //cprintf("In Q1 | Process %d\n", p->pid);

          pstat_var[p->pid].start_tick[0] = p->clicks;

          //pstat_var[p->pid].times[0] += 1;
          //cprintf("Times for q0: %d\n", pstat_var[p->pid].times[0]);

          pstat_var[p->pid].priority[pstat_var[p->pid].schedulingState] = p->priority;
          pstat_var[p->pid].schedulingState++;

          //cprintf("Current Priority for CPU %d: %d\n", p->pid, p->priority);

          //keeps adding clicks till it reaches the max for that priority
          if (p->clicks == quantumTime[0]) {
            //cprintf("CPU %d Changing priority from q0 to q1\n", p->pid);

            //pstat_var[p->pid].start_tick[0] = p->clicks;
            pstat_var[p->pid].times[0] += 1;

            //setup next priority queue
            c1++;
            p->priority = p->priority + 1;
            pstat_var[p->pid].start_tick[1] = pstat_var[p->pid].start_tick[0] + quantumTime[0];

            pstat_var[p->pid].duration[pstat_var[p->pid].currDur] = quantumTime[0];
            //pstat_var[p->pid].currDur++;
            //cprintf("Changing priority from %d to %d\n", pstat_var[p->pid].priority[pstat_var[p->pid].schedulingState], p->priority);
            pstat_var[p->pid].priority[pstat_var[p->pid].schedulingState] = p->priority;
            q1[c1] = c->proc;
            q0[i] = 0;
            for (int j = i; j <= c0 - 1; j++) {
              q0[j] = q0[j + 1];
            }
            q0[c0] = 0;
            p->clicks = 0;
            c0--;

          }
          pstat_var[p->pid].currDur++;

        }

        c->proc = 0;
      }
    }

    if (c1 != -1) {

      for ( i = 0; i <= c1; i++) {

        if (q1[i]->state != RUNNABLE) {

          continue;

        }


        else {
          p = q1[i];
          c->proc = q1[i];
          p->clicks++;
          switchuvm(p);
          p->state = RUNNING;
          swtch(&(c->scheduler), p->context);
          switchkvm();

          //pstat_var[p->pid].start_tick[1] = p->clicks;
          //pstat_var[p->pid].times[1] += 1;
          //pstat_var[p->pid].duration[pstat_var[p->pid].currDur] = quantumTime[1];
          //pstat_var[p->pid].currDur++;

          pstat_var[p->pid].priority[pstat_var[p->pid].schedulingState] = p->priority;
          pstat_var[p->pid].schedulingState++;

          //cprintf("Current Priority for CPU %d: %d\n", p->pid, p->priority);
          
          if (p->clicks == quantumTime[1]) {
            //cprintf("CPU %d Changing priority from q1 to q2\n", p->pid);
            //cprintf("C0: %d, C2: %d, C3: %d", c0, c1, c2);
            //cprintf("%d QUANTUM TIMEEEEE\n", quantumTime[2]);

            pstat_var[p->pid].times[1] += 1;

            c2++;
            p->priority = p->priority + 1;
            pstat_var[p->pid].start_tick[2] = pstat_var[p->pid].start_tick[1] + quantumTime[1];

            pstat_var[p->pid].duration[pstat_var[p->pid].currDur] = quantumTime[1];

            int stateVal = pstat_var[p->pid].schedulingState;
            //cprintf("Changing priority from %d to %d\n", pstat_var[p->pid].priority[stateVal], p->priority);
            pstat_var[p->pid].priority[stateVal] = p->priority;

            q2[c2] = p;
            q1[i] = 0;
            for (int j = i; j <= c1 - 1; j++) {
              q1[j] = q1[j + 1];
            }
            q1[c1] = 0;
            p->clicks = 0;
            c1--;

          }

          pstat_var[p->pid].currDur++;
        }

        c->proc = 0;
      }
    }
    if (c2 != -1) {
      //cprintf("REACHED THE THIRD QUEUE FDSIOWFJOEIWJ");

      for ( i = 0; i <= c2; i++) {

        if (q2[i]->state != RUNNABLE) {
          continue;
        }
        else {
          p = q2[i];
          c->proc = q2[i];
          p->clicks++;
          switchuvm(p);
          p->state = RUNNING;
          swtch(&(c->scheduler), p->context);
          switchkvm();

          //pstat_var[p->pid].start_tick[1] = p->clicks;
          //pstat_var[p->pid].times[1] += 1;
          //pstat_var[p->pid].duration[pstat_var[p->pid].currDur] = quantumTime[1];
          //pstat_var[p->pid].currDur++;

          pstat_var[p->pid].priority[pstat_var[p->pid].schedulingState] = p->priority;
          pstat_var[p->pid].schedulingState++;

          //cprintf("Current Priority for CPU %d: %d\n", p->pid, p->priority);
          
          if (p->clicks == quantumTime[2]) {
            //cprintf("CPU %d Changing priority from q2 to q2\n", p->pid);
            //cprintf("%d QUANTUM TIMEEEEE\n", quantumTime[2]);

            pstat_var[p->pid].times[2] += 1;

            c2++;
            //p->priority = p->priority + 1;
            pstat_var[p->pid].start_tick[2] = pstat_var[p->pid].start_tick[2] + quantumTime[2];

            pstat_var[p->pid].duration[pstat_var[p->pid].currDur] = quantumTime[2];

            int stateVal = pstat_var[p->pid].schedulingState;
            //cprintf("Changing priority from %d to %d\n", pstat_var[p->pid].priority[stateVal], p->priority);
            pstat_var[p->pid].priority[stateVal] = p->priority;

            q2[c2] = p;
            q2[i] = 0;
            for (int j = i; j <= c2 - 1; j++) {
              q2[j] = q2[j + 1];
            }
            q2[c2] = 0;
            p->clicks = 0;
            c2--;

          }

          pstat_var[p->pid].currDur++;
        }
      }
    }
    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.


    // Process is done running for now.
    // It should have changed its p->state before coming back.



    release(&ptable.lock);



  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock) { //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock) { //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  //Possibly...Line P-<state...DO NOT WRAP FUNCITON...POSIBLEEEE

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->state == SLEEPING && p->chan == chan) {
      p->state = RUNNABLE;


      p->clicks = 0;
      if (p->priority == 0) {
        c0++;
        for (int i = c0; i > 0; i--) {
          q0[i] = q0[i - 1];
          // q0[i]->state = RUNNABLE;
        }
        q0[0] = p;
      }
      else if (p->priority == 1) {
        c1++;
        for (int i = c1; i > 0; i--) {
          q1[i] = q1[i - 1];
        }
        q1[0] = p;
      }
      else {
        c2++;
        for (int i = c2; i > 0; i--) {
          q2[i] = q2[i - 1];
        }
        q2[0] = p;
      }

      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == SLEEPING && p->chan == chan) {
          p->state = RUNNABLE;

        }

    }
  }

}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid) {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
    [UNUSED]    "unused",
    [EMBRYO]    "embryo",
    [SLEEPING]  "sleep ",
    [RUNNABLE]  "runble",
    [RUNNING]   "run   ",
    [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING) {
      getcallerpcs((uint*)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}



// ATOI FUNCTION FROM STACKOVERFLOW TO CONVERT %S ARG0 TO %d
int my_atoi(const char* input) {
  int accumulator = 0,
      curr_val = 0,
      sign = 1;
  int i = 0;


  if (input[0] == '-') {
    sign = -1;
    i++;
  }

  if (input[0] == '+')
    i++;


  while (input[i] != '\0') {

    curr_val = (int)(input[i] - '0');

    // If atoi finds a char that cannot be converted to a numeric 0-9
    // it returns the value parsed in the first portion of the string.
    // (thanks to Iharob Al Asimi for pointing this out)
    if (curr_val < 0 || curr_val > 9)
      return accumulator;

    // Let's store the last value parsed in the accumulator,
    // after a shift of the accumulator itself.
    accumulator = accumulator * 10 + curr_val;
    i++;
  }

  return sign * accumulator;
}

void getpHelper(int id) {

// argint(0, &id);



  int internalID = my_atoi((char*)id);


  cprintf("******************************** \n");
  for (int i = 0; i < 64; i++ ) {
    int statPID = pstat_var[i].pid;
    if (internalID == statPID) {
      cprintf("Name: CPU Intestive, PID= ");
      cprintf("%d\n", statPID);
      cprintf("ticks= {");
      for (int j = 0; j < 3; j++) {
        cprintf("%d", quantumTime[j]);
        if (j == 2) {
          cprintf("");
        }
        else {
          cprintf(", ");
        }
      }
      cprintf("} \n");
      cprintf("times={");
      for (int k = 0; k < 3; k++) {
        cprintf("%d", pstat_var[internalID].times[k]);
        if (k == 2) {
          cprintf("");
        }
        else {
          cprintf(", ");
        }
      }
      cprintf("} \n");

      cprintf("******************************** \n");


      for (int l = 0; l < pstat_var[internalID].schedulingState; l++) {
        cprintf("start = ");
        cprintf("%d", pstat_var[internalID].start_tick[pstat_var[internalID].priority[l]]);
        cprintf(", duration= ");
        cprintf("%d", pstat_var[internalID].duration[l]);
        cprintf(", priority= ");
        cprintf("%d", pstat_var[internalID].priority[l]);
        cprintf("\n ");

      }


      break;

    }
    else {
      continue;
    }


  }
}



