#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"

uint64
sys_trace(void)
{
  int mask;
  argint(0, &mask);
  myproc()->trace_mask = mask;
  return 0;
}

uint64
sys_sandbox(void)
{
  int mask;
  argint(0, &mask);
  myproc()->sandbox_mask = mask;
  return 0;
}

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0;
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  int n;
  uint64 addr;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;
  argint(0, &pid);
  return kkill(pid);
}

uint64
sys_uptime(void)
{
  uint xticks;
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_sandbox_cmd(void)
{
  char allowed[16];
  
  // Get the allowed command name argument
  if(argstr(0, allowed, sizeof(allowed)) < 0) {
    return -1;
  }
  
  struct proc *p = myproc();
  p->sandbox_cmd = 1;
  safestrcpy(p->sandbox_allowed, allowed, sizeof(p->sandbox_allowed));
  return 0;
}

uint64
sys_sandbox_path(void)
{
  char prefix[128];
  
  if(argstr(0, prefix, sizeof(prefix)) < 0) {
    return -1;
  }
  
  struct proc *p = myproc();
  p->sandbox_path = 1;
  safestrcpy(p->sandbox_prefix, prefix, sizeof(p->sandbox_prefix));
  return 0;
}
