// user/time.c

#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    printf("%d\n", time());
    exit(0);
}
