#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/riscv.h"

void main(void) {
   
    int size = 4096 * 500; 
    char *mem = sbrk(size); 
    
    if ((long long)mem == -1) {
        exit(1); 
    }

    
    for (int i = 0; i < size; i++) {

        if (mem[i] >= 'a' && mem[i] <= 'z') { 
            
            int len = 0;
            while (mem[i + len] != 0 && len < 20) {
                len++;
            }
            
            if (len >= 3 && len < 20) {

                printf("%s\n", &mem[i]);
                exit(0);
            }
        }
    }
    
    exit(0);
}
