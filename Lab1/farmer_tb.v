module farmer_test;

	reg f_in, x_in, g_in, b_in;

	wire e_out;

	farmer f1(e_out, f_in, x_in, g_in, b_in);

	initial begin

		$dumpfile("f1.vcd");
		$dumpvars(0, farmer_test);

		f_in = 0; x_in = 0; g_in = 0; b_in = 0; # 10;
		f_in = 0; x_in = 0; g_in = 0; b_in = 1; # 10;
		f_in = 0; x_in = 0; g_in = 1; b_in = 0; # 10;
		f_in = 0; x_in = 0; g_in = 1; b_in = 1; # 10;
		f_in = 0; x_in = 1; g_in = 0; b_in = 0; # 10;
		f_in = 0; x_in = 1; g_in = 0; b_in = 1; # 10;
		f_in = 0; x_in = 1; g_in = 1; b_in = 0; # 10;
		f_in = 0; x_in = 1; g_in = 1; b_in = 1; # 10;
		f_in = 1; x_in = 0; g_in = 0; b_in = 0; # 10;
		f_in = 1; x_in = 0; g_in = 0; b_in = 1; # 10;
		f_in = 1; x_in = 0; g_in = 1; b_in = 0; # 10;
		f_in = 1; x_in = 0; g_in = 1; b_in = 1; # 10;
		f_in = 1; x_in = 1; g_in = 0; b_in = 0; # 10;
		f_in = 1; x_in = 1; g_in = 0; b_in = 1; # 10;
		f_in = 1; x_in = 1; g_in = 1; b_in = 0; # 10;
		f_in = 1; x_in = 1; g_in = 1; b_in = 1; # 10;

		$finish;
	end

	initial
		$monitor("At time %2t, f_in = %d x_in = %d g_in = %d b_in = %d e_out = %d",
						$time, f_in, x_in, g_in, b_in, e_out);


endmodule // farmer_test
