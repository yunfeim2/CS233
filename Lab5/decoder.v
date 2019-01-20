// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;

    wire myadd, mysub, myand, myor, mynor, myxor, myaddi, myandi, myori, myxori;

      assign myadd = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
      assign mysub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
      assign myand = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
      assign myor = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
      assign mynor = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
      assign myxor = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);

      assign myaddi = (opcode == `OP_ADDI);
      assign myandi = (opcode == `OP_ANDI);
      assign myori = (opcode == `OP_ORI);
      assign myxori = (opcode == `OP_XORI);

      assign except = ~(myadd | mysub | myand | myor | mynor | myxor | myaddi | myandi | myori | myxori) ? 1:0;
      assign writeenable = (myadd | mysub | myand | myor | mynor | myxor | myaddi | myandi | myori | myxori) ? 1:0;
      assign rd_src = (myaddi | myandi | myori | myxori) ? 1:0;
      assign alu_src2 = (myaddi | myandi | myori | myxori) ? 1:0;

      assign alu_op[0] = (mysub | myor | myori | myxor | myxori) ? 1:0;
      assign alu_op[1] = (myadd | myaddi | mysub | mynor | myxor | myxori) ? 1:0;
      assign alu_op[2] = (myand | myandi | myor | myori | mynor | myxor | myxori) ? 1:0;

endmodule // mips_decode
