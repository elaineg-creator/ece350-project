module pwm(
    input clk,              // System Clock
    input reset,            // Reset the counter
    output reg signal = 0   // Output PWM signal
    );

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency
    
    // PWM window is system freq/desired freq
    localparam PULSE_WINDOW = SYSTEM_FREQ/50;
    localparam PULSE_HALF   = PULSE_WINDOW >> 1;
    localparam PULSE_BITS   = $clog2(PULSE_HALF) + 1;
    
    // Use a counter to determine when the pulse is HIGH
    reg[PULSE_BITS-1:0] pulseCounter = 0;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            pulseCounter <= 0;
        end else begin
            if(pulseCounter < PULSE_WINDOW-1) begin
                pulseCounter <= pulseCounter + 1;
            end else begin
                pulseCounter <= 0;
            end
        end
    end
    
    // The pulse is high when the counter is less than the specified duty_cycle
    wire lessThan;
	wire[19:0] duty_cycle;
	assign duty_cycle = 20'd200000;
    assign lessThan = pulseCounter < duty_cycle;
    
    // Captured the lessThan signal on the negative edge after it has stabilized
    always @(negedge clk) begin
        signal <= lessThan;
    end
	
endmodule