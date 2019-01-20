// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire myadd, mysub, myand, myor, mynor, myxor, myaddi, myandi, myori, myxori;
    wire mybne, mybeq, myj, myjr, mylui, myslt, mylw, mylbu, mysw, mysb, myaddm;

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

      assign mybne = (opcode == `OP_BNE);
      assign mybeq = (opcode == `OP_BEQ);
      assign myj = (opcode == `OP_J);
      assign myjr = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
      assign mylui = (opcode == `OP_LUI);
      assign myslt = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
      assign mylw = (opcode == `OP_LW);
      assign mylbu = (opcode == `OP_LBU);
      assign mysw = (opcode == `OP_SW);
      assign mysb = (opcode == `OP_SB);
      assign myaddm = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);

      assign except = ~(myadd | mysub | myand | myor | mynor | myxor | myaddi | myandi | myori | myxori | mybne | mybeq | myj | myjr | mylui | myslt | mylw | mylbu | mysw | mysb | myaddm) ? 1:0;
      assign writeenable = (myadd | mysub | myand | myor | mynor | myxor | myaddi | myandi | myori | myxori | mylui | myslt | mylw | mylbu | myaddm) ? 1:0;
      assign rd_src = (myaddi | myandi | myori | myxori | mylui | mylw | mylbu) ? 1:0;
      assign alu_src2 = (myaddi | myandi | myori | myxori | mylw | mylbu | mysw | mysb) ? 1:0;

      assign alu_op[0] = (mysub | myor | myori | myxor | myxori | myslt | mybeq | mybne) ? 1:0;
      assign alu_op[1] = (myadd | myaddi | mysub | mynor | myxor | myxori | myslt | mylw | mylbu | mysw | mysb | mybeq | mybne | myaddm) ? 1:0;
      assign alu_op[2] = (myand | myandi | myor | myori | mynor | myxor | myxori) ? 1:0;

      assign control_type[0] = ((mybeq & zero) | (mybne & ~zero) | myjr);
      assign control_type[1] = (myj | myjr);
      assign mem_read = (mylw | mylbu | myaddm) ? 1 : 0;
      assign word_we = mysw;
      assign byte_we = mysb;
      assign byte_load = mylbu;

      assign lui = mylui;
      assign slt = myslt;
      assign addm = myaddm;


endmodule // mips_decode
