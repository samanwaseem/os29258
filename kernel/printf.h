#ifndef _PRINTF_H_
#define _PRINTF_H_

int printf(char*, ...) __attribute__ ((format (printf, 1, 2)));
void panic(char*) __attribute__((noreturn));
void printfinit(void);

#endif /* _PRINTF_H_ */
