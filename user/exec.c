#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if(argc < 2) {
        printf("Usage: exec command [args...]\n");
        exit(1);
    }
    
    printf("exec would run: %s\n", argv[1]);
    exit(0);
}
