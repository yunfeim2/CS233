// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
    wire [31:0] nextPC;
    wire writeenable, rd_src, alu_src2;
    wire [4:0] Rdest;
    wire [31:0] rsData;
    wire [31:0] rtData;

    wire [2:0] alu_op;
    wire [5:0] opcode;
    wire [5:0] funct;
    wire mem_read, word_we, byte_we, byte_load, lui, slt, addm, zero;

    wire [31:0] A;
    wire [31:0] B;
    wire [15:0] afff;
    wire [31:0] imm32;
    wire [31:0] out;
    wire negative;
    wire [31:0] b_offset;

    wire [31:0] nextPC_0;
    wire [31:0] nextPC_1;
    wire [31:0] nextPC_2;
    wire [31:0] nextPC_3;

    wire [31:0] data_out;
    wire [31:0] addr;
    wire [31:0] data_in;
    wire [7:0] b_load1;
    wire [31:0] b_load;

    wire [31:0] mem_read1;
    wire [31:0] slt1;
    wire [31:0] mem_read0;
    wire [31:0] lui0;
    wire [31:0] lui1;
    wire [31:0] rdData;

    wire [1:0] control_type;
    wire overflow;
    wire true_negative;

    wire [31:0] addm_out;
    wire [31:0] mem_read_;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, writeenable, clock, reset);
    mux2v #(5) m1(Rdest, inst[15:11], inst[20:16], rd_src);
    /* add other modules */

    //rf-alu
    assign A = rsData;
    assign afff = {16{inst[15]}};
    assign imm32 = {afff,inst[15:0]};
    assign b_offset = {imm32[29:0],2'b00};
    mux2v m2(B, rtData, imm32, alu_src2);
    alu32 alu_2(out, overflow, zero, negative, A, B, alu_op);

    //Register_alus
    alu32 alu_1(nextPC_0, , , , PC, 32'h4, `ALU_ADD);
    alu32 alu_3(nextPC_1, , , , nextPC_0, b_offset, `ALU_ADD);
    assign nextPC_2 = {PC[31:28], inst[25:0], 2'b00};
    assign nextPC_3 = A;
    mux4v m3(nextPC, nextPC_0, nextPC_1, nextPC_2, nextPC_3, control_type);

    //data_memory
    mux2v mx_addm(addr,out,rsData,addm);
    data_mem dm(data_out, addr, rtData, word_we, byte_we, clock, reset);
    mux4v #(8) m4(b_load1, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
    assign b_load = {24'b0, b_load1};

    mux2v m5(mem_read1, data_out, b_load, byte_load);
    mux2v #(1) helper_slt(true_negative,negative,~negative,(slt&&overflow));
    assign slt1 = {{31{1'b0}},true_negative};
    mux2v m6(mem_read0, out, slt1, slt);

    mux2v m7(mem_read_, mem_read0, mem_read1, mem_read);
    assign lui1 = {inst[15:0], 16'b0};
    mux2v m9(lui0, mem_read_, addm_out, addm);
    mux2v m8(rdData, lui0, lui1, lui);

    //decoder
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    mips_decode decoder1(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);

    alu32 alu_addm(addm_out,,,,data_out,rtData,`ALU_ADD);




endmodule // full_machine
