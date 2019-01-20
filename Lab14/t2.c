#include "declarations.h"

void
t2(float * restrict A, float * restrict B) {
    for (int nl = 0; nl < 10000000; nl ++) {
        #pragma clang loop vectorize_width(8) interleave(disable) distribute(disable)
        for (int i = 0; i < LEN2 ; i += 1) {
            A[i] = B[i] * A[i];
        }
        A[0] ++;
    }
}
