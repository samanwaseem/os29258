#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]){
  int n = (argc>1)? atoi(argv[1]) : 10;
  int p2c[2], c2p[2];
  if(pipe(p2c)<0 || pipe(c2p)<0){ 
     printf("pipe\n"); exit(1);
  }
  int pid = fork();
  if(pid<0){
     printf("fork\n"); exit(1);
  }

//for child
  if(pid==0){
            
    close(p2c[1]); close(c2p[0]);

    for(int i=0;i<n;i++){
      int v;
      if(read(p2c[0], &v, sizeof(v))!=sizeof(v)) break;
      printf("child got %d\n", v);
      if(write(c2p[1], &v, sizeof(v))!=sizeof(v)) break;
    }

    exit(0);

//for parent
  }else{               
    close(p2c[0]); close(c2p[1]);
    for(int i=1;i<=n;i++){
      int v = i;
      if(write(p2c[1], &v, sizeof(v))!=sizeof(v)) break;
      if(read(c2p[0], &v, sizeof(v))!=sizeof(v)) break;
      printf("parent got %d\n", v);
    }

    wait(0);
    exit(0);
  }
  return 0;
}

