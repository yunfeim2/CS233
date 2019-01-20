`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire   [31:0] user_status;
    wire   [31:0] cause_register;
    wire   [31:0] status_register;
    wire   [31:0] decoder_output;
    wire   exception_level;
    wire   ELR_reset;
    wire   [29:0] EPCR_q;
    wire   [29:0] EPCR_d;
    wire   EPCR_enable;


    assign cause_register[31:16] = 16'b0;
    assign cause_register[15] = TimerInterrupt;
    assign cause_register[14: 0] = 15'b0;
    assign status_register[31:16] = 16'b0;
    assign status_register[ 7: 2] = 6'b0;
    assign status_register[15: 8] = user_status[15: 8];
    assign status_register[1] = exception_level;
    assign status_register[0] = user_status[0];

    decoder32 d1(decoder_output, regnum, MTC0);
    register USR(user_status, wr_data, clock, decoder_output[12], reset);

    or ELR_re(ELR_reset, reset, ERET);
    register #(1) ELR(exception_level, 1'b1, clock, TakenInterrupt, ELR_reset);

    mux2v #(30) EPCR_mux(EPCR_d, wr_data[31:2], next_pc, TakenInterrupt);
    or EPCR_en(EPCR_enable, decoder_output[14], TakenInterrupt);
    register #(30) EPC_R(EPCR_q, EPCR_d, clock, EPCR_enable, reset);
    assign EPC = EPCR_q;
    mux32v rd_max(rd_data,0,0,0,0,0,0,0,0,0,0,0,0, status_register, cause_register, {EPCR_q, 2'b0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, regnum);

    assign TakenInterrupt = ((cause_register[15]&&status_register[15])&&(~status_register[1]&&status_register[0]));


endmodule
