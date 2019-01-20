/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
   		message_out[i] = 0;    // Initialize all elements to zero.
	}

	// TODO: write your code here
  int count = length / 8;
  while(count > 0){
    char temp1 = 0;
    char a = 1;
    for(int j = 0; j < 8; j++){
      char temp = 0;
      unsigned char b = 128;
      for(int i = 0; i < 8; i ++){
        temp1 = (message_in[7 - i + length - count * 8] & a);
        if(temp1){
          temp |= b;
        }
        b = b >> 1;
      }
      message_out[length - count * 8 + j] = temp;
      a = a << 1;
    }
    count--;
  }
	return message_out;
}
