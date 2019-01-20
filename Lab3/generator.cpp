// a code generator for the ALU chain in the 32-bit ALU
// look at example_generator.cpp for inspiration

// make generator
// ./generator
#include <cstdio>
using std::printf;

int main(){
  for(int i = 1; i < 32; i ++){
    printf("    alu1 a%d(out[%d], carryout[%d], A[%d], B[%d], carryout[%d], control);\n", i, i, i, i, i, i - 1);
  }
  return 0;
}
