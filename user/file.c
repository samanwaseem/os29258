#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

// Simple exact match function for testing
int exact_match(char *pattern, char *text) {
    return strcmp(pattern, text) == 0;
}

void
find(char *path, char *pattern)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  printf("DEBUG: searching in %s for %s\n", path, pattern); // DEBUG

  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  printf("DEBUG: path type = %d\n", st.type); // DEBUG

  if(st.type == T_FILE){
    if(exact_match(pattern, path)){
      printf("FOUND: %s\n", path);
    }
    close(fd);
    return;
  }

  if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    printf("find: path too long\n");
    close(fd);
    return;
  }
  
  strcpy(buf, path);
  p = buf+strlen(buf);
  *p++ = '/';
  
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
    if(de.inum == 0)
      continue;
      
    memmove(p, de.name, DIRSIZ);
    p[DIRSIZ] = 0;
    
    printf("DEBUG: checking %s\n", buf); // DEBUG
    
    if(stat(buf, &st) < 0){
      printf("find: cannot stat %s\n", buf);
      continue;
    }
    
    if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
      continue;

    if(st.type == T_FILE){
      if(exact_match(pattern, de.name)) {
        printf("FOUND: %s\n", buf);
      }
    } else if(st.type == T_DIR){
      find(buf, pattern);
    }
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  if(argc != 3){
    fprintf(2, "Usage: find directory pattern\n");
    exit(1);
  }
  find(argv[1], argv[2]);
  exit(0);
}
