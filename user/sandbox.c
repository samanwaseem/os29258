#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc < 3) {
    fprintf(2, "Usage: %s mask command [args...]\n", argv[0]);
    exit(1);
  }

  int mask = atoi(argv[1]);
  if(sandbox(mask) < 0) {  // CHANGE FROM trace() TO sandbox()
    fprintf(2, "%s: sandbox failed\n", argv[0]);
    exit(1);
  }
  
  exec(argv[2], &argv[2]);
  fprintf(2, "%s: exec %s failed\n", argv[0], argv[2]);
  exit(1);
}
