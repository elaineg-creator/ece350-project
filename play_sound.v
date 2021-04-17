
module play_sound(
    input        clk, 		// System Clock Input 100 Mhz
    input        signal,   // Pulse when reaching 1 minute
    output       audioOut,	// PWM signal to the audio jack
    output       audioEn);	// Audio Enable

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	assign audioEn = (index < 5 && index > 0);  // Change this number to reflect how many notes

	// Initialize the frequency array.
	reg[12:0] FREQs[0:63];
	initial begin
		$readmemh("play_sound.mem", FREQs);
	end


  // Calculate counter threshold with respect to frequency given. 1s = 1Hz
	wire[31:0] threshold, threshold1s;
	assign threshold = (SYSTEM_FREQ / (FREQs[index] * 2)) - 1;
  assign threshold1s = SYSTEM_FREQ / 2 - 1;

  // Slow down the clock to frequency of the note
	reg clkWanted = 0;
  reg clk1s = 0;
	reg[31:0] counter = 0;
  reg[31:0] counter1s = 0;
	always @(posedge clk) begin
		if(counter < threshold)
			counter <= counter + 1;
		else begin
			counter <= 0;
			clkWanted <= ~clkWanted;
		end
	end

  // Slow down the clock to 1Hz.
  // This is used so each note is played 1s.
  always @(posedge clk) begin
    if(counter1s < threshold1s)
      counter1s <= counter1s + 1;
    else begin
      counter1s <= 0;
      clk1s <= ~clk1s;
    end
  end

  // Advance index by 1 each second, which changes the frequency that's read
  // in the frequency array.
  wire [5:0] counterout, index;
  counter whichnote (clk1s, signal, counterout);
  assign index = &counterout ? 6'b0 : counterout;


  // Set duty cycle and use PWM serializer.
	wire[6:0] duty_cycle;
	assign duty_cycle = clkWanted ?  7'd90 : 7'd10;
	PWMSerializer pwm(.clk(clk), .reset(1'b0), .duty_cycle(duty_cycle), .signal(audioOut));

endmodule
