`timescale 1ns / 1ps

module pwm_tb;

    reg clock, reset;
    reg [6:0] duty_cycle;
    wire signal;

    pwm pwmGenerate(.clk(clock), .reset(reset), .signal(signal));

    initial begin
        clock = 0;
        reset = 0;
        //signal = 0;
        #10000000000;
        $finish;
    end

    always
        #5 clock = ~clock;

    initial begin
        $dumpfile("Wave.vcd");
        $dumpvars(0, pwm_tb);
    end

endmodule
