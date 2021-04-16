module pwm(
    input clock,              // System Clock
    //input reset,            // Reset the counter
    output reg signal = 0   // Output PWM signal
    );

	localparam kHz = 1000;
	localparam NEWCLK_FREQ = 1*kHz; // new clock frequency
    localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency
    
    // PWM window is system freq/desired freq
    localparam PULSE_WINDOW = NEWCLK_FREQ/50;               //50 Hz or 20 ms
    localparam PULSE_HALF   = PULSE_WINDOW >> 1;
    localparam PULSE_BITS   = $clog2(PULSE_HALF) + 1;

    wire [31:0] CounterLimit;                                   //clock divider for testing with vivado
    assign CounterLimit = (SYSTEM_FREQ / NEWCLK_FREQ) >> 1;
    reg clk1kHz = 0;
    reg[31:0] counter = 0;
    always @(posedge clock) begin
        if (counter < CounterLimit - 1)
            counter <= counter + 1;
        else begin
            counter <= 0;
            clk1kHz <= ~clk1kHz;
        end
    end

    reg[6:0] resCount = 0;
    reg reset = 1;                      //temporary reset signal for testing, will be input from processor later

    always @(posedge clk1kHz) begin
        if (resCount < 1) begin
            resCount <= resCount + 1;
        end else begin
            reset = 0;
        end
    end

    
    // Use a counter to determine the correct pwm signal frequency
    reg[PULSE_BITS-1:0] pulseCounter = 0;

    reg[10:0] turnCount = 0;
    reg pulseOn = 0;

    always @(posedge clk1kHz or posedge reset) begin
        if(reset) begin
            pulseCounter <= 0;
            pulseOn <= 1;
        end else begin
            if(pulseCounter < PULSE_WINDOW-1) begin
                pulseCounter <= pulseCounter + 1;
            end else begin
                pulseCounter <= 0;
            end
            if (turnCount < 110 && pulseOn == 1) begin          //~# of pulses is turnCount / 20, right now it is 6 pulses
                turnCount <= turnCount + 1;
            end else begin
                pulseOn <= 0;
                turnCount <= 0;
            end            
        end


    end


    // The pulse is high when the counter is less than the specified duty_cycle, right now it is high for 2ms 
    wire lessThan;
	wire[4:0] duty_cycle;
	assign duty_cycle = 4'd2;                          //duty_cycle = 0.2*pulse_window since 2/20 = 2 
    assign lessThan = pulseCounter < duty_cycle;
    
    // Captured the lessThan signal on the negative edge after it has stabilized
    always @(negedge clk1kHz) begin
        if(pulseOn == 1) begin
            signal <= lessThan;
        end else begin
            signal <= 0;
        end
        //signal <= lessThan;
    end
	
endmodule