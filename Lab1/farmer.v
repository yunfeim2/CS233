// Complete the farmer module in this file
// Don't put any code in this file besides the farmer circuit

module farmer(e, f, x, g, b);

	output e;

	input f, x, g, b;

	wire w1, w2, w3, w4, w5, w7, w8, w9;

	xor a1(w1, x, g);
	not n1(w3, w1);
	xor a2(w2, g, b);
	not n2(w4, w2);
  xor a3(w5, f, x);
	xor a5(w7, f, b);
	and aa1(w8, w5, w3);
	and aa2(w9, w7, w4);
	or o1(e, w8, w9);

endmodule // farmer
