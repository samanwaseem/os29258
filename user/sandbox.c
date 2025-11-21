
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int 
main(int argc, char *argv[]) 
{
    if (argc < 4) {
        fprintf(2, "usage: sandbox mask path command [args...]\n");
        exit(1);
    }

    int mask = atoi(argv[1]);
    char *path = argv[2];
    char *cmd = argv[3];
    char **cmd_argv = &argv[3];
    
    int pid = fork();

    if (pid == 0) {
        // Child process
        
        // Apply the sandbox restriction
        if (interpose(mask, path) < 0) {
            fprintf(2, "sandbox: interpose failed\n");
            exit(1);
        }
        
        // Execute the command (e.g., cat, grep)
        exec(cmd, cmd_argv);
        
        // If exec returns, it failed
        fprintf(2, "sandbox: exec %s failed\n", cmd);
        exit(1);
    } else if (pid > 0) {
        // Parent process waits
        wait(0);
    } else {
        fprintf(2, "sandbox: fork failed\n");
    }
    
    exit(0);
}
