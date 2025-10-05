#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc < 3) {
    fprintf(2, "Usage: sandbox_path allowed_path_prefix command [args...]\n");
    exit(1);
  }

  if(sandbox_path(argv[1]) < 0) {
    fprintf(2, "sandbox_path failed\n");
    exit(1);
  }
  
  exec(argv[2], &argv[2]);
  exit(0);
}
