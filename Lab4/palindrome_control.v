
module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output load, select, palindrome, done;
	input go, a_ne_b, front_ge_back;
	input clock, reset;

	wire sGar, sStar, sCom, sDonp, sDonn;
	wire toGar = reset | (sGar & ~go);
	wire toStar = (sDonp | sDonn | sStar | sGar) & go & ~reset;
	wire toComp = ((sStar & ~go) | (sCom & ~a_ne_b & ~front_ge_back)) & ~reset;
	wire todonp = (sCom & front_ge_back & ~reset) | (sDonp & ~go & ~reset);
	wire todonn = (sCom & a_ne_b & ~reset) | (sDonn & ~go & ~reset);

	dffe ssGar(sGar, toGar, clock, 1'b1, 1'b0);
	dffe ssStar(sStar, toStar, clock, 1'b1, 1'b0);
	dffe ssComp(sCom, toComp, clock, 1'b1, 1'b0);
	dffe ssdonp(sDonp, todonp, clock, 1'b1, 1'b0);
	dffe ssdonn(sDonn, todonn, clock, 1'b1, 1'b0);

	assign load = sCom | sStar ? 1:0;
	assign select = sCom ? 1:0;
	assign palindrome = sDonp ? 1:0;
	assign done = sDonp | sDonn ? 1:0;

endmodule // palindrome_control 
