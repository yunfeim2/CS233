module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here

    wire   [31:0] intercycle_q;
    wire   [31:0] cyclecoter_q;
    wire   [31:0] cyclecnter_d;
    wire   isequal1;   // Cycle counter and inter counter
    wire   isequal2;   //0xffff001c
    wire   isequal3;   //0xffff006c
    wire   TimerRead;
    wire   TimerWrite;
    wire   Acknowledge;
    wire   Interlreset;

    register #(, 32'hffffffff) Interrupt_cycle(intercycle_q, data, clock, TimerWrite, reset);
    register Cycle_counter(cyclecoter_q, cyclecnter_d, clock, 1'h1, reset);
    assign isequal1 = (intercycle_q == cyclecoter_q) ? 1:0;
    assign isequal2 = (32'hffff001c == address) ? 1:0;
    assign isequal3 = (32'hffff006c == address) ? 1:0;
    or TimerA(TimerAddress, isequal2, isequal3);
    and TimerR(TimerRead, isequal2, MemRead);
    and TimerW(TimerWrite, isequal2, MemWrite);
    and Ack(Acknowledge, isequal3, MemWrite);
    or InterlR(Interlreset, Acknowledge, reset);
    tristate Tricycle(cycle, cyclecoter_q, TimerRead);
    alu32 aluCycle(cyclecnter_d, , , `ALU_ADD, cyclecoter_q, 32'h1);
    register #(1) InterLine(TimerInterrupt, 1'h1, clock, isequal1, Interlreset);



    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
