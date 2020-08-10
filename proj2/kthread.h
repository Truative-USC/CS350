#ifndef XV6_PUBLIC_KTHREAD_H
#define XV6_PUBLIC_KTHREAD_H

// #include "proc.h"


#define NTHREAD			16
#define MAX_MUTEXES 	64


// extern enum procstate;

enum mutex_state {mutex_used, mutex_unused, mutex_zombie};

struct kthread_mutex_t  {
  int id; //thread id
  int threadLocked; //is the thread locked
  enum mutex_state status; // Current status of thread state
  int stack; //check if the stack is fully allocated or not
  struct thread *queue[NTHREAD];
  int firstThread; //The first thread in the queue
  int lastThread; //The Last thread in the queue
  struct spinlock * ptableLock; //
};




void kthread_exit();
int kthread_create(void* (*start_func) (), void* stack, int stack_size);
int kthread_id();
int kthread_mutex_alloc(void);
int kthread_mutex_dealloc(int mutex_id);
int kthread_mutex_lock(int mutex_id);
int kthread_mutex_unlock(int mutex_id);
int kthread_join(int thread_id);



#endif