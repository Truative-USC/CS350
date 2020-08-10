#ifndef KTHREAD_H_
#define KTHREAD_H_

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "kthread.h"
#include <stdbool.h>
#include <stdio.h>

struct kthread_table {
	struct spinlock mutexLock[MAX_MUTEXES];
	struct kthread_mutex_t  threads[MAX_MUTEXES];
} mutexTable;

extern struct {
	struct spinlock lock;
	struct proc proc[NPROC];
} ptable;

extern int conjoin(struct thread * t);
extern int kThreadState(void);
extern bool checkUse(void);
extern void wakeup(void *chan);
extern struct thread *allocthread(struct proc * p);
// struct kthrea {

// }
struct kthread_mutex_t* returnMutex(int id) {
	struct kthread_mutex_t *k = &mutexTable.threads[id];
	return k;
}


int kthread_id() {
	if ((proc == 0 && thread == 0)) {
		return -1; //DNE
	}
	return thread->tid; //Return ID
}

int kthread_mutex_unlock(int mutex_id) {

	struct kthread_mutex_t  *k = returnMutex(mutex_id);
	// struct thread *t;
	if (k->threadLocked == UNUSED) {
		return -1;
	}
	acquire(k->ptableLock);
	if (k->threadLocked == 0) {
		release(k->ptableLock);
		return -1;
	}
	if ( !(k->queue[0] == 0 ) ) {
		struct thread *temp = k->queue[k->firstThread];
		if (temp == 0) {
			panic("Cannot remove thread");
		}
		else {
			for (int j = 1; j < NTHREAD; j++) {
				k->queue[j - 1] = k->queue[j];
				if (k->queue[j] == 0) {
					break;
				}
			}
			k->lastThread = k->lastThread - 1;
			k->queue[NTHREAD - 1] = 0;
		}
		if (k->lastThread) {
			//funcition not done
			return 0;
		}
	}
	return 0;
}


int kthread_mutex_lock(int mutex_id) {

	struct kthread_mutex_t *k = &mutexTable.threads[mutex_id];

	acquire(k->ptableLock);

	if (k->threadLocked == 1) { //if the thread is locked
		if (k->lastThread == NTHREAD) {
			panic("Overflow");
		}
		k->queue[k->lastThread] = thread;
		k->lastThread = k->lastThread + 1;
		release(k->ptableLock);
		acquire(&ptable.lock);
		thread->state = TINVALID;
		sched();
		acquire(k->ptableLock);
		release(&ptable.lock);
	}
	return 0;

}




int kthread_create(void* (*start_funct) (), void* stack, int stack_size) {
	acquire(&ptable.lock);
	thread = allocthread(proc);
	if (thread == 0) {
		cprintf("cannot find thread");
		release(&ptable.lock);
		return -1;

	}
	thread->state = TRUNNABLE;
	cprintf("start_funct=%d\n", ((int)start_funct));
	thread->tf->ebp = thread->tf->esp;
	thread->tf->esp = (uint)(stack + stack_size);
	thread->tf->eip = (uint)start_funct;
	release(&ptable.lock);
	return thread->tid;
}

int kthread_mutex_alloc() {
	cprintf("%s", "LEROYYY JENKINS");
	int mutex_index = 0;

	for (struct kthread_mutex_t  *k = mutexTable.threads; k < &mutexTable.threads[MAX_MUTEXES]; k++) {

		if (k->status == mutex_unused) {
			k->id = mutex_index;
			k->firstThread = 0;
			k->lastThread = 0;
			k->ptableLock = &mutexTable.mutexLock[mutex_index];
			k->status = mutex_used;
			return k->id;

		}
		else {
			mutex_index++;
		}
	}
	return -1; //return -1 on failure
}

int kthread_mutex_dealloc(int mutex_id) {
	struct kthread_mutex_t  *k;
	int deactive = -1;
	for (k = mutexTable.threads; k  < &mutexTable.threads[MAX_MUTEXES]; k++) {
		if ((k->id == mutex_id) && (k->threadLocked == 0) && k->status == mutex_used) { //Mutex has not been locked
			k->status = mutex_unused;
			k->id = deactive;
			return 0;
		}
		else {
			return -1;
		}
	}
	return -1;
}


struct thread* returnThread(int mutex_id) {

	struct thread *t;

	for (t = thread->parent->threads; t < &thread->parent->threads[NTHREAD]; t++) {
		if (t->tid == mutex_id) {
			return t;
		}
	}
	return (struct thread *) - 1;
}

int kthread_join(int thread ) {
	struct thread *t;
	struct thread *joinThread;
	if (thread < 0) {
		return -1;
	}
	int go = 1;
	int locatedThread = 0;
	while (go) {

		locatedThread = 0;
		t = returnThread(thread);
		if (t == (struct thread*)(-1) ) {
			continue;
		} else {
			joinThread = t;
			locatedThread = 1;
			int sucessJoin = conjoin(t);
			if (sucessJoin) {
				release(&ptable.lock);

				return 0;
			}

		}
	}

	if (locatedThread == 0) {
		release(&ptable.lock);
		return -1;

	}

	sleep(joinThread, &ptable.lock);
	return -1;
}





void kthread_exit() {
	acquire(&ptable.lock);
	thread->state = TZOMBIE;
	int state = kThreadState();
	if (state == 1) {
		release(&ptable.lock);
		exit();
	}
	wakeup(thread);
	release(&ptable.lock);

}

struct thread* initThread(struct thread* t ) {
	t->chan = 0;
	t->context = 0;
	t->tid = 0;
	return t;
}

#endif //ending KTHREAD_H_ ifndef

