//creating a new system call that retrieves the system tick counter

//tick is the time between two interrupts from the timer chip

#include "../kernel/types.h" 
#include "../user/user.h"
#include "kernel/stat.h"

int main(void){
//functionality added in kernel
printf("uptime: %d ticks\n", uptime());
exit(0);

}


