`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset, start, stop, servo1, servo2, servo3, onLED, signal1LED, signal2LED, arduino_reset, audioOut, audioEn);
	input clock, reset;
	input start, stop;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	//servos
	output servo1, servo2, servo3, onLED;
	output signal1LED, signal2LED, arduino_reset;

	//sound
	wire sound_signal;
	output audioOut, audioEn;

	//assign arduino_reset = reset;


	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "minutesound";

	//clock divider for 1kHz

	localparam kHz = 1000;
	localparam NEWCLK_FREQ = 1*kHz; // new clock frequency
    localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

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

	
	// Main Processing Unit
	processor CPU(.clock(clk1kHz), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		//servos
		.servo1(servo1), .servo2(servo2), .servo3(servo3),
		
		.start(start), .stop(stop), .onLED(onLED), .signal1LED(signal1LED), .signal2LED(signal2LED), .arduino_reset(arduino_reset),
		
		.sound_signal(sound_signal)); 

	play_sound sound(.clock(clock), .signal(sound_signal), .audioOut(audioOut), .audioEn(audioEn));	 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clk1kHz), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clk1kHz), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clk1kHz), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
