// user/print_kpgtbl.c

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (kpgtbl() < 0) {
    fprintf(2, "kpgtbl failed\n");
    exit(1);
  }
  exit(0);
}
