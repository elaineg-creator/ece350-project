module servooutput(reset, clock, signal);
    input reset, clock;
    output signal;

    reg count = 0;
    reg signal = 0;

always @(posedge clock) begin           
        if(reset) begin                             //if reset is triggered, set signal to on (1) and reset count
            signal <= 1;
            count <= 0;
        end else begin
            if(count < 1) begin
                count <= count + 1;
            end else if(count == 1) begin             //if 2 cycles passed, set signal to off (0)
                signal <= 0;
            end
        end
    end

endmodule