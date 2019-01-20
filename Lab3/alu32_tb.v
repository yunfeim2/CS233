//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 5; B = 2; control = `ALU_SUB;
        # 10 A = 2; B = 5; control = `ALU_SUB;
        # 10 A = 2; B = 2; control = `ALU_SUB;
        # 10 A = 32'hffffffff; B = 32'hffffffff; control = `ALU_AND;
        # 10 A = 32'hffffffff; B = 32'hffffffff; control = `ALU_OR;
        # 10 A = 32'hffffffff; B = 32'hffffffff; control = `ALU_NOR;
        # 10 A = 32'hffffffff; B = 32'hffffffff; control = `ALU_XOR;
        # 10 A = 32'hffffffff; B = 0; control = `ALU_AND;
        # 10 A = 32'hffffffff; B = 0; control = `ALU_OR;
        # 10 A = 32'hffffffff; B = 0; control = `ALU_NOR;
        # 10 A = 32'hffffffff; B = 0; control = `ALU_XOR;
        # 10 A = 0; B = 32'hffffffff; control = `ALU_AND;
        # 10 A = 0; B = 32'hffffffff; control = `ALU_OR;
        # 10 A = 0; B = 32'hffffffff; control = `ALU_NOR;
        # 10 A = 0; B = 32'hffffffff; control = `ALU_XOR;
        # 10 A = 0; B = 0; control = `ALU_AND;
        # 10 A = 0; B = 0; control = `ALU_OR;
        # 10 A = 0; B = 0; control = `ALU_NOR;
        # 10 A = 0; B = 0; control = `ALU_XOR;
        # 10 A = 2147483647; B = 1; control = `ALU_ADD;
        # 10 A = 2147483647; B = 0; control = `ALU_ADD;
        # 10 B = 2147483647; A = 1; control = `ALU_ADD;
        # 10 B = 2147483647; A = 2147483647; control = `ALU_ADD;
        # 10 B = 2147483647; A = 0; control = `ALU_ADD;
        # 10 B = 1000000000; A = 1147483647; control = `ALU_ADD;
        # 10 B = 1000000001; A = 1147483647; control = `ALU_ADD;
        # 10 A = 0; B = 2147483647; control = `ALU_SUB;
        # 10 A = -1; B = 2147483647; control = `ALU_SUB;
        # 10 A = -2; B = 2147483647; control = `ALU_SUB;
        # 10 A = 2147483647; B = 2147483647; control = `ALU_SUB;
        # 10 A = 2147483648; B = 2147483648; control = `ALU_SUB;
        # 10 A = 32'hfffffffe; B = 2147483647; control = `ALU_SUB;
        # 10 A = 1; B = 32'h7ffffff0; control = `ALU_SUB;
        // add more test cases here!

        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);
    initial begin
        $display("         A          B OV Z N C          O\n");
        $monitor("%d %d  %d %d %d %d %d (at time %t)", A, B, overflow, zero, negative, control, out, $time);
    end
endmodule // alu32_test
