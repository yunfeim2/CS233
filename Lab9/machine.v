module machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0]  inst;

   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];

   wire [4:0]   wr_regnum;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET;
   wire         PCSrc, zero, negative;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data;    //wr_data is at below

   wire Takeninterrupt;                             //new wire
   wire TimerInterrupt, TimerAddress;               //new wire
   wire [31:0]  wr_data0, wr_data;                  //new wire
   wire [31:0]  rd_data;                            //new wire
   wire [29:0]  EPC;                                //new wire
   wire NotIO;                                      //new wire
   wire [29:0]  TakeI0;                             //new wire
   wire [29:0]  TakeI_out;                          //new wire


   register #(30, 30'h100000) PC_reg(PC[31:2], TakeI_out, clk, /* enable */1'b1, reset); //PC_next[31:2] has been modified to TakeI_out
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;

   instruction_memory imem (inst, PC[31:2]);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET,
                      inst);

   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
   alu32 alu(alu_out_data, zero, negative, ALUOp, rd1_data, B_data);

   data_mem data_memory(load_data, alu_out_data, rd2_data, MemRead && NotIO, MemWrite && NotIO, clk, reset); // MemRead and Memwrite are changed

   mux2v #(32) wb_mux(wr_data0, alu_out_data, load_data, MemToReg); //wr_data to wr_data0
   mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

   //new module
    timer t1(TimerInterrupt, load_data, TimerAddress, 
            rd2_data, alu_out_data, MemRead, MemWrite, clk, reset);
    
    mux2v #(32) wb_mux2(wr_data, wr_data0, rd_data, MFC0);
    cp0 cp(rd_data, EPC, Takeninterrupt,
            rd2_data, rd, next_PC, MTC0, ERET, TimerInterrupt, clk, reset);
    
    assign NotIO = ~TimerAddress;

    mux2v #(30) ERET1(TakeI0, next_PC[31:2], EPC, ERET);
    mux2v #(30) TakeI(TakeI_out, TakeI0, 30'b100000000000000000000001100000, Takeninterrupt);

endmodule // machine
