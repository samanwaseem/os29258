#include "kernel/types.h"
#include "user/user.h"
#include "fcntl.h"
#define BUFSIZE 1

//number % 5 or 6

//count arg, hold arg
int main(int argc, char *argv[]) {
    if(argc != 2){
        printf("usage: sixfive file\n");
        exit(1);
   }
//file handling: hhp3 youtube
//file descriptor
    int fd = open(argv[1], O_RDONLY);
    if(fd < 0){
        printf("cannot open %s\n", argv[1]);
        exit(1);
  }

char c; //one character read at a time
char num_buf[32];
int n = 0;
char buf[BUFSIZE];
int in_number = 0'
char *separators = "-\e\t\n./,";

while (read(fd, buf, BUFSIZE) > 0){
char c = buf[0];
        
//check if current character is digit
if (c >= '0' && c <= '9'){
if (!in_number){
in_number = 1;
int num_index = 0;
}
if(num_index < sizeof(num_buf) - 1){
 num_buf[num_index++] = c;
}
} else {
//separator?
if (in_number) {
num_buf[num_index] = '\0';
int number = atoi(num_buf);
                
//check if divisible by 5 or 6
if (number%5 == 0 || number%6 == 0){
printf("%d\n", number);
}
in_number = 0;
}
}
}
    
//number at end
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

