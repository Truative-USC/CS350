#include "types.h"
#include "stat.h"
#include "user.h"
#include "x86.h"

extern void procdump();

void exitMain(char* data) {
	free(data);
	exit();
}


int main()
{
	//declarations
	int processID = fork();
	char *data = (char *)malloc(4096); //heap
	int inc = 1;
	
	// son
	if (processID == 0) {

		//child processes before
		printf(1, "Before Change\n");
		printf(1, "ProcDump Call 2 \n");
		procdump();

		//new values to sit in different pages
		for (int i = 0; i < 4096; i++) {
			data[i] += inc;
		}
		//child processes after
		printf(1, "After Change\n");
		printf(1, "ProcDump Call 3 \n");

		procdump();

		exit();
	}
	else {
		wait();
	}
	exitMain(data);
	return 1;
}