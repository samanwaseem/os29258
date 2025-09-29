#include "kernel/types.h"
#include "user/user.h"
#define BUFSIZE 1

//divisibility by 5 or 6

int main(int argc, char *argv[]) {
//correct number of argument 2: program name and arg. if arg just name or value, error
if(argc != 2){
printf("usage: sixfive file\n");
exit(1);
}

//file descriptor
int fd = open(argv[1], 0);
if(fd < 0){
printf("cannot open %s\n", argv[1]);
exit(1);
}

char num_buf[32];
int num_index = 0;
int in_number = 0;
char buf[BUFSIZE];

while (read(fd, buf, BUFSIZE) > 0){
char c = buf[0];

if (c >= '0' && c <= '9'){
if (!in_number){
in_number = 1;
num_index = 0;
}
if(num_index < sizeof(num_buf) - 1){
num_buf[num_index++] = c;
}
} else {
if (in_number) {
num_buf[num_index] = '\0';
int number = atoi(num_buf);
if (number%5 == 0 || number%6 == 0){
printf("%d\n", number);
}
in_number = 0; }
}
}

if (in_number) {
num_buf[num_index] = '\0';
int number = atoi(num_buf);
if (number%5 == 0 || number%6 == 0) {
printf("%d\n", number);
}
}
close(fd);
exit(0);
}


