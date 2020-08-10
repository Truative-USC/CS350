
#ifndef _PSTAT_H_
#define _PSTAT_H_
#define NTICKS 500
#define NSCHEDSTATS 1500

/*
 * responsible for recording the scheduling state per process at a particular tick
 * e.g. a process can have an array of sched_stat_t's, with each of them holding the info
 * of a scheduling round of the process
 */
struct sched_stat_t
{
  int start_tick[3];	//the number of ticks when this process is scheduled
  int duration[NTICKS];  	//number of ticks the process is running before it gives up the CPU
  int priority[NTICKS];	//the priority of the process when it's scheduled
  int pid;
  int running;
  int currDur;
  int times[3];
  int schedulingState;
};

#endif
