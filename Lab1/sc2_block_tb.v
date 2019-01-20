module sc2_test;

	reg a_in, b_in, cin_in;

	wire s_out, c_out;

	sc2_block sc2(s_out, c_out, a_in, b_in, cin_in);

	initial begin
		$dumpfile("sc2.vcd");                  // name of dump file to create
        $dumpvars(0,sc2_test);

        a_in = 0; b_in = 0; cin_in = 0; # 10;             // set initial values and wait 10 time units
        a_in = 0; b_in = 0; cin_in = 1; # 10;
        a_in = 0; b_in = 1; cin_in = 0; # 10;
        a_in = 0; b_in = 1; cin_in = 1; # 10;
        a_in = 1; b_in = 0; cin_in = 0; # 10;
        a_in = 1; b_in = 0; cin_in = 1; # 10;
        a_in = 1; b_in = 1; cin_in = 0; # 10;
        a_in = 1; b_in = 1; cin_in = 1; # 10;

        $finish;
	end

	initial
        $monitor("At time %2t, a_in = %d b_in = %d cin_in = %d s_out = %d cout_out = %d",
                 $time, a_in, b_in, cin_in, s_out, c_out);


endmodule // sc2_test
