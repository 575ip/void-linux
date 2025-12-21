#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    const char *ddcutil = "/usr/bin/ddcutil";
    const char *bus = "3";

    if (setgid(0) != 0 || setuid(0) != 0)
        return 1;

    if (argc < 2)
        return 1;

    if (strcmp(argv[1], "get") == 0) {
        execl(ddcutil, ddcutil, "--bus", bus, "getvcp", "10", (char *)NULL);
    } else if (strcmp(argv[1], "up") == 0) {
        execl(ddcutil, ddcutil, "--bus", bus, "setvcp", "10", "+", "5", (char *)NULL);
    } else if (strcmp(argv[1], "down") == 0) {
        execl(ddcutil, ddcutil, "--bus", bus, "setvcp", "10", "-", "5", (char *)NULL);
    } else if (strcmp(argv[1], "set") == 0 && argc >= 3) {
        execl(ddcutil, ddcutil, "--bus", bus, "setvcp", "10", argv[2], (char *)NULL);
    } else {
        return 1;
    }

    return 1;
}
