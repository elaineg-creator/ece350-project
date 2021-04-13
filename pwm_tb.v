`timescale 1ns / 1ps

module pwm_tb;

    reg clock;
    reg [6:0] duty_cycle;
    wire signal;

    pwm pwmGenerate(.clock(clock), .signal(signal));

    //compile with iverilog -o pwm -c files.txt -s pwm_tb

    initial begin
        clock = 0;
        //reset = 0;
        //signal = 0;
        #2000000;
        //reset = 1;
        #1000000;
        //reset = 0;

        // #200000000;
        // reset = 1;

        // #10;
        // reset = 0;

        #10000000000000000;
        $finish;
    end

    always
        #5 clock = ~clock;

    initial begin
        $dumpfile("Wave.vcd");
        $dumpvars(0, pwm_tb);
    end

endmodule
