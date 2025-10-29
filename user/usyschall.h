// user/usyscall.h
#ifndef _USYSCALL_H_
#define _USYSCALL_H_

// This numeric value must match kernel's USYSCALL.
// Most xv6 variants place USYSCALL at 0xFFFFF000.
#define USYSCALL 0xFFFFF000

struct usyscall {
  int pid;   // Process ID (kernel writes, user reads)
};

#endif // _USYSCALL_H_

