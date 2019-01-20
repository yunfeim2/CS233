/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	int number = input;
	
	int a1 = 0x55555555;
	number = (a1 & number) + (a1 & (number >> 1));
	int a2 = 0x33333333;
	number = (a2 & number) + (a2 & (number >> 2));
	int a3 = 0x0f0f0f0f;
	number = (a3 & number) + (a3 & (number >> 4));
	int a4 = 0x00ff00ff;
	number = (a4 & number) + (a4 & (number >> 8));
	int a5 = 0x0000ffff;
	number = (a5 & number) + (a5 & (number >> 16));

	input = number;

	return input;
}
