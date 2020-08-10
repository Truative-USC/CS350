#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"


#include "mmu.h"

#define N  1000

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

int
main(int argc, char *argv[])
{
	int val = my_atoi(argv[1]);
	printf(1, "%d was entered:\n", val);

	if ( (val % 2) == 0){
		printf(1, "      /\\_/\\\n");
		printf(1, " /\\  / o o \\\n");
		printf(1, "//\\\\ \\~(*)~/\n");
		printf(1, "`  \\/   ^ /\n");
		printf(1, "   | \\|| || \n");
		printf(1, "   \\ '|| || \n");
		printf(1, "    \\)()-())\n");
	}
	else {
		printf(1, "   / \\__\n");
		printf(1, "  (    @\\___\n");
		printf(1, "  /         O\n");
		printf(1, " /   (_____/\n");
		printf(1, "/_____/   U\n");
	}

	getpinfo(argv[1]);
	exit();
}
