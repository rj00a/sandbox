
// Deterministic Finite Automata approach

#include <stdio.h>
#include <stdbool.h>

bool zthru9(char c) {
    return c >= '0' && c <= '9';
}

bool is_number(const char *s) {
    int state = 0;
    
    while (*s == ' ')
        s++;
    
    if (*s == '+' || *s == '-')
        s++;
    
    if (zthru9(*s)) {
        s++;
        state = 4;
    } else if (*s == '.' && zthru9(*(s + 1))) {
        s += 2;
        state = 1;
    } else
        return false;
    
    for (;;) {
        switch (state) {
            case 4:
                while (zthru9(*s))
                    s++;
                if (*s == '.') {
                    s++;
                    state = 1;
                } else if (*s == 'e' || *s == 'E') {
                    s++;
                    if (*s == '+' || *s == '-')
                        s++;
                    state = 2;
                } else {
                    if (*s == '.')
                        s++;
                    state = 3;
                }
                break;
            case 1:
                while (zthru9(*s))
                    s++;
                if (*s == 'e' || *s == 'E') {
                    s++;
                    if (*s == '+' || *s == '-')
                        s++;
                    state = 2;
                } else
                    state = 3;
                break;
            case 2:
                if (!zthru9(*s))
                    return false;
                s++;
                while (zthru9(*s))
                    s++;
                state = 3;
                break;
            case 3:
                while (*s == ' ')
                    s++;
                return !*s;
        }
    }
}

int main(void) {
    puts(is_number("-420.69e+4") ? "true" : "false");
}