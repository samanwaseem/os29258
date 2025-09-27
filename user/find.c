#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

// Fixed regex functions
int matchhere(char *pattern, char *text);
int matchstar(int c, char *pattern, char *text);

int match(char *pattern, char *text) {
    if(pattern[0] == '^')
        return matchhere(pattern+1, text);
    do {
        if(matchhere(pattern, text))
            return 1;
    } while(*text++ != '\0');
    return 0;
}

int matchhere(char *pattern, char *text) {
    if(pattern[0] == '\0')
        return 1;
    if(pattern[1] == '*')
        return matchstar(pattern[0], pattern+2, text);
    if(pattern[0] == '$' && pattern[1] == '\0')
        return *text == '\0';
    if(*text != '\0' && (pattern[0] == '.' || pattern[0] == *text))
        return matchhere(pattern+1, text+1);
    return 0;
}

int matchstar(int c, char *pattern, char *text) {
    do {
        if(matchhere(pattern, text))
            return 1;
    } while(*text != '\0' && (*text++ == c || c == '.'));
    return 0;
}

void find(char *path, char *pattern) {
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, 0)) < 0) {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    if(st.type == T_FILE) {
        if(match(pattern, path)) {
            printf("%s\n", path);
        }
        close(fd);
        return;
    }

    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
        printf("find: path too long\n");
        close(fd);
        return;
    }
    
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';

    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
        if(de.inum == 0)
            continue;
            
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;

        if(stat(buf, &st) < 0) {
            printf("find: cannot stat %s\n", buf);
            continue;
        }

        if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
            continue;

        if(st.type == T_FILE) {
            if(match(pattern, de.name)) {
                printf("%s\n", buf);
            }
        } else if(st.type == T_DIR) {
            find(buf, pattern);
        }
    }
    close(fd);
}

int main(int argc, char *argv[]) {
    if(argc != 3) {
        fprintf(2, "Usage: find directory pattern\n");
        exit(1);
    }
    find(argv[1], argv[2]);
    exit(0);
}
