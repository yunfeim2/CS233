module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:2]  PC_plus4_DE;
    wire [31:0]  inst;
    // new wire
    wire [31:0]  inst_DE;

    // changed from inst to inst_DE
    wire [31:0]  imm = {{ 16{inst_DE[15]} }, inst_DE[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst_DE[25:21];
    wire [4:0]   rt = inst_DE[20:16];
    wire [4:0]   rd = inst_DE[15:11];
    wire [5:0]   opcode = inst_DE[31:26];
    wire [5:0]   funct = inst_DE[5:0];

    wire [4:0]   wr_regnum;
    // new wire
    wire [4:0]   wr_regnum_MW;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    // new wire
    wire         RegWrite_MW, MemToReg_MW, MemWrite_MW, MemRead_MW;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

    // new wire
    wire [31:0]  alu_out_data_MW, rd2_data_MW, rd1_data_final, rd2_data_final;

    // new wire
    wire Stall, Flush, ForwardA, ForwardB;

    assign Stall = ((rs == wr_regnum_MW && rs != 0) || (rt == wr_regnum_MW && rt != 0)) && MemRead_MW;
    assign Flush = PCSrc || reset;
    assign ForwardA = (rs == wr_regnum_MW && rs != 0) && RegWrite_MW;
    assign ForwardB = (rt == wr_regnum_MW && rt != 0) && RegWrite_MW;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~Stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    // changed from PC_plus4 to PC_plus4_DE
    adder30 target_PC_adder(PC_target, PC_plus4_DE, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // new register
    register #(30) PC_plus4_Reg(PC_plus4_DE, PC_plus4, clk, ~Stall, Flush);
    register #(32) Inst_Reg(inst_DE, inst, clk, ~Stall, Flush);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);
    // new register
    register #(1) MemWrite_reg(MemWrite_MW, MemWrite, clk, 1'b1, Flush);
    register #(1) MemRead_reg(MemRead_MW, MemRead, clk, 1'b1, Flush);
    register #(1) MemToReg_reg(MemToReg_MW, MemToReg, clk, 1'b1, Flush);
    register #(1) RegWrite_reg(RegWrite_MW, RegWrite, clk, 1'b1, Flush);
    register #(5) wr_regnum_reg(wr_regnum_MW, wr_regnum, clk, 1'b1, Flush);
    register #(32) rd2_data_reg(rd2_data_MW, rd2_data_final, clk, 1'b1, Flush);
    register #(32) alu_out_data_reg(alu_out_data_MW, alu_out_data, clk, 1'b1, Flush);


    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    mux2v #(32) imm_mux(B_data, rd2_data_final, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data_final, B_data);

    // new mux
    mux2v #(32) rd1_data_mux(rd1_data_final, rd1_data, alu_out_data_MW, ForwardA);
    mux2v #(32) rd2_data_mux(rd2_data_final, rd2_data, alu_out_data_MW, ForwardB);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

endmodule // pipelined_machine
