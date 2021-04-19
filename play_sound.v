module play_sound(
    input        sys_clk, 		// System Clock Input 100 Mhz
    input        proc_clk,
    input        signal,   // Pulse when reaching 1 minute
    output       audioOut,	// PWM signal to the audio jack
    output       audioEn);	// Audio Enable

    localparam kHz = 1000;
	localparam SYSTEM_FREQ = 1*kHz; //system freq (in processor)

    assign audioEn = index < 5;  // Enable Audio Output

    reg[10:0] FREQs[0:5];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end

    // set threshold for the frequencies
	wire[31:0] threshold;
	assign threshold = (SYSTEM_FREQ / FREQs[index]) >> 1;

    reg[2:0] index = 5; //last index or whatever
    reg[31:0] index_counter = 0;
    always @(posedge proc_clk) begin
        if(signal) begin
            index <= 0;
            index_counter <= 0;
        end else if(index < 5) begin
            if(index_counter < 499) begin
                index_counter <= index_counter + 1;
            end else if(index_counter == 500) begin
                index_counter <= 0;
                index <= index + 1;
            end 
        end
    end

	// set counter
	reg sound_clock = 0;
	reg[31:0] counter = 0;
	always @(posedge sys_clk) begin
		if (counter < threshold - 1)
			counter <= counter + 1;
		else begin
            counter <= 0;
            sound_clock <= ~sound_clock;
		end
	end

	// Use mux to output set duty cycle to 90% or 10%
	wire[6:0] duty_cycle;
	assign duty_cycle = sound_clock ? 7'd90 : 7'd10; // 90% on high clock, 10% on low

	// Implementing the PWMSerializer module
	PWMSerializer pmw(
		.clk(sys_clk),
		.reset(1'b0),
		.duty_cycle(duty_cycle),
		.signal(audioOut));

endmodule