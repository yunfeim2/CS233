




module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;

    reg [2:0] control = 0;
    reg carryin = 0;
    always #4 carryin = !carryin;

    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        # 8 control = 3'h2;
        # 8 control = 3'h3;
        # 8 control = 3'h4;
        # 8 control = 3'h5;
        # 8 control = 3'h6;
        # 8 control = 3'h7;

        # 8 $finish; // wait 16 time units and then end the simulation
    end

    wire out, carryout;
    alu1 al1(out, carryout, A, B, carryin, control);
    initial begin
        $display("ALU1 test");
        $monitor("A: %d  B: %d  carryin: %d  carryout: %d  control: %d  out: %d (at time %t)", A, B, carryin, carryout, control, out, $time);
    end
endmodule
