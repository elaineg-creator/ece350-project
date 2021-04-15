/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB,                   // I: Data from port B of RegFile

    //servo outputs
    servo1, servo2, servo3,

    //start
    start, startLED,
    signal1LED
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    //servos
    output servo1, servo2, servo3;
    output signal1LED;

    assign signal1LED = signal1;

    //start
    input start;
    output startLED;
    wire startOn;

    assign startOn = start;
    assign startLED = startOn;

	/* YOUR CODE STARTS HERE */


    //wires for grader
    wire [1:0] ALUinA, ALUinB, selectA, selectB;
    wire WMbp, stall, MWstall, isNotEqual, isLessThan;
    wire [31:0] oOut, bOut, ir2MW, aluOut, branchbypassA, branchbypassB, branchImme;

    //PC to F/D
    wire [31:0] pcNext, pcOut, ir2FD;
    wire cout1, flushJ, flushB;
    reg_32 PC(pcOut, pcNext, clock, 1'b1, reset);
    assign address_imem = pcOut;

    assign ir2FD = (flushJ || flushB) ? 32'b0 : q_imem;

    //F/D to D/X
    wire [31:0] pc2DX, ir2DX, new2DX;
    wire[4:0] ctrl_readRegB1;
    FDpipe FD(pcNext, pc2DX, ir2FD, ir2DX, clock, reset, (stall || countstatus), MWstall);  //stall if normal stall logic or second counter is occuring
    assign new2DX = ((stall || countstatus) | flushJ) ? 32'b0 : ir2DX;                      //if stall, pass nop to DX
    assign ctrl_readRegA = ir2DX[21:17];
    assign ctrl_readRegB1 = (~ir2DX[31] & ~ir2DX[30] & ~ir2DX[29] & ~ir2DX[28] & ~ir2DX[27]) ? ir2DX[16:12] : ir2DX[26:22];              //to go to regfile
    assign ctrl_readRegB = (ir2DX[31] & ~ir2DX[30] & ir2DX[29] & ir2DX[28] & ~ir2DX[27]) ? 5'b11110 : ctrl_readRegB1;
    
    assign branchImme = {{15{ir2DX[16]}}, ir2DX[16:0]};
    mux_4 BRANCHA(branchbypassA, selectA, oOut, data_writeReg, data_readRegA, aluOut);  
    mux_4 BRANCHB(branchbypassB, selectB, oOut, data_writeReg, data_readRegB, aluOut);  
    branchcomparator BC(branchbypassA, branchbypassB, isLessThan, isNotEqual);

    //second counter, if countstatus is 1, stall
    wire countstatus, countreset;
    assign countreset = (ir2DX[31] & ir2DX[30] & ir2DX[29] & ir2DX[28] & ir2DX[27]);
    secondctrl SECOND(countreset, clock, countstatus);

    //output 1 to servos after second/minute/hour passed for 2 cycles
    //each servo will have different rd associated with it 
    wire signal1, reset1;
    assign reset1 = (ir2DX[31] & ir2DX[30] & ~ir2DX[29] & ~ir2DX[28] & ~ir2DX[27] & ~ir2DX[26] & ~ir2DX[25] & ~ir2DX[24] & ~ir2DX[23] & ir2DX[22]);     //output for seconds motor, servo 1 (r1)
    servooutput SERVO1(reset1, clock, signal1);
    assign servo1 = signal1;

    wire signal2, reset2;
    assign reset2 = (ir2DX[31] & ir2DX[30] & ~ir2DX[29] & ~ir2DX[28] & ~ir2DX[27] & ~ir2DX[26] & ~ir2DX[25] & ~ir2DX[24] & ir2DX[23] & ~ir2DX[22]);     //output for minutes motor, servo 2 (r2)
    servooutput SERVO2(reset2, clock, signal2);
    assign servo2 = signal2;

    wire signal3, reset3;
    assign reset3 = (ir2DX[31] & ir2DX[30] & ~ir2DX[29] & ~ir2DX[28] & ~ir2DX[27] & ~ir2DX[26] & ~ir2DX[25] & ~ir2DX[24] & ir2DX[23] & ir2DX[22]);     //output for seconds motor, servo 3 (r3)
    servooutput SERVO3(reset3, clock, signal3);
    assign servo3 = signal3;

    //D/X to X/M
    wire [31:0] pc2MUX, regAOut, regBOut, ir2XM, in2ALUB, sxImme, bypassB, in2ALUA;
    wire [4:0] aluOP;
    wire ALUoverflow, isImme;
    DXpipe DX(pc2DX, pc2MUX, data_readRegA, data_readRegB, regAOut, regBOut, new2DX, ir2XM, clock, reset, MWstall);

    mux_4 ALU2A(in2ALUA, ALUinA, oOut, data_writeReg, regAOut, 32'bz);                                                                  //bypassing muxs for ALU
    mux_4 ALU2B(bypassB, ALUinB, oOut, data_writeReg, regBOut, 32'bz);

    assign sxImme = {{15{ir2XM[16]}}, ir2XM[16:0]};

    assign isImme = (~ir2XM[31] & ~ir2XM[30] & ir2XM[29] & ~ir2XM[28] & ir2XM[27]) || (~ir2XM[31] & ~ir2XM[30] & ir2XM[29] & ir2XM[28] & ir2XM[27]) || (~ir2XM[31] & ir2XM[30] & ~ir2XM[29] & ~ir2XM[28] & ~ir2XM[27]);

    assign in2ALUB = isImme ? sxImme : bypassB;
    assign aluOP = (~ir2XM[31] & ~ir2XM[30] & ~ir2XM[29] & ~ir2XM[28] & ~ir2XM[31]) ? ir2XM[6:2] : {5'b0};          //here is where I do all ALU stuff
    alu ALU(in2ALUA, in2ALUB, aluOP, ir2XM[11:7], aluOut, ALUoverflow);

    //multdiv
    wire ctrl_MULT, ctrl_DIV, data_exception, data_resultRDY, multdivStatus, pqReadyOut, data_exceptionOut;
    wire[31:0] multdivA, multdivB, data_result, pqout, pqIRin, pqIRout, newMDir;

    assign ctrl_MULT = (~ir2XM[31] & ~ir2XM[30] & ~ir2XM[29] & ~ir2XM[28] & ~ir2XM[27]) & (~ir2XM[6] & ~ir2XM[5] & ir2XM[4] & ir2XM[3] & ~ir2XM[2]);
    assign ctrl_DIV = (~ir2XM[31] & ~ir2XM[30] & ~ir2XM[29] & ~ir2XM[28] & ~ir2XM[27]) & (~ir2XM[6] & ~ir2XM[5] & ir2XM[4] & ir2XM[3] & ir2XM[2]);

    multdivctrl MULTDIV(ir2XM, clock, data_result, data_exception, data_resultRDY, multdivStatus, pqIRin, pqIRout, ctrl_MULT, ctrl_DIV, in2ALUA, in2ALUB);

    PWpipe PW(data_result, pqout, pqIRin, pqIRout, data_resultRDY, pqReadyOut, data_exception, data_exceptionOut, clock, reset);

    assign newMDir = data_exceptionOut ? {pqIRout[31:27], {5'b11110}, pqIRout[21:0]} : pqIRout;       //change output of PW IR if overflowed to write to 30

    //overflow control
    wire isALUop;
    wire [31:0] new2XM;             //new addr to pass if there was overflow
    assign isALUop = (~ir2XM[31] & ~ir2XM[30] & ~ir2XM[29] & ~ir2XM[28] & ~ir2XM[27]) || (~ir2XM[31] & ~ir2XM[30] & ir2XM[29] & ~ir2XM[28] & ir2XM[27]);
    //assign new2XM = (isALUop & ALUoverflow) ? {ir2XM[31:27], {5'b11110}, ir2XM[21:0]} : ir2XM;    //if aluop and overflow, change rd to 30
    mux_4 NEWXMIR(new2XM, {(ctrl_MULT || ctrl_DIV || MWstall), (isALUop & ALUoverflow)}, ir2XM, {ir2XM[31:27], {5'b11110}, ir2XM[21:0]}, 32'b0, 32'bz);

    //X/M to M/W
    wire overOut1;
    wire [31:0] pc2MW; 
    XMpipe XM(aluOut, oOut, bypassB, bOut, new2XM, ir2MW, clock, reset, pc2MUX, pc2MW, MWstall);
    assign data = WMbp ? data_writeReg : bOut;                                                      //what to write to data, bypass or no
    assign address_dmem = oOut;
    assign wren = (~ir2MW[31] & ~ir2MW[30] & ir2MW[29] & ir2MW[28] & ir2MW[27]);

    //M/W to RegFile
    wire[31:0] oOut2, dOut, irFin, new2MW, finalir, toWrite, toWrite2, toWrite3, address, pcFin;
    wire[4:0] writeReg1;
    wire overOut2, isSetx, isJal, isStore;

    MWpipe MW(oOut, q_dmem, oOut2, dOut, ir2MW, irFin, clock, reset, pc2MW, pcFin);               

    assign isSetx = (finalir[31] & ~finalir[30] & finalir[29] & ~finalir[28] & finalir[27]);
    assign isJal = (~finalir[31] & ~finalir[30] & ~finalir[29] & finalir[28] & finalir[27]);
    assign isStore = (~finalir[31] & finalir[30] & ~finalir[29] & ~finalir[28] & ~finalir[27]);

    assign finalir = pqReadyOut ? newMDir : irFin;                         //new ins to use if multdiv is ready
    assign address = {5'b0, finalir[26:0]}; 
    assign toWrite = pqReadyOut ? pqout : oOut2;
    assign toWrite2 = isSetx ? address : toWrite;
    assign toWrite3 = isJal ? pcFin : toWrite2;
    assign data_writeReg = isStore ? q_dmem : toWrite3;  

    assign writeReg1 = isSetx ? 5'b11110 : finalir[26:22];
    assign ctrl_writeReg = isJal ? 5'b11111 : writeReg1;       
     
    assign ctrl_writeEnable = (~finalir[31] & ~finalir[30] & ~finalir[29] & ~finalir[28] & ~finalir[27]) | (~finalir[31] & ~finalir[30] & finalir[29] & ~finalir[28] & finalir[27])
                               | (~finalir[31] & finalir[30] & ~finalir[29] & ~finalir[28] & ~finalir[27]) | (finalir[31] & ~finalir[30] & finalir[29] & ~finalir[28] & finalir[27])
                                | (~finalir[31] & ~finalir[30] & ~finalir[29] & finalir[28] & finalir[27]) ;
    
    //add some write controls for multdiv and branchs

    //extra controls
    
    bypassctrl BYPASS(ir2XM, ir2MW, finalir, ALUinA , ALUinB, WMbp, ctrl_writeEnable);
    branchbypass BRANCHBY(new2DX, new2XM, ir2MW, finalir, selectA ,selectB, ctrl_writeEnable);

    stallctrl STALLING(ir2DX, ir2XM, ir2MW, stall, MWstall, (multdivStatus || (ctrl_MULT || ctrl_DIV)), pqIRin, data_resultRDY);
    nextPC NEXTPC(pcOut, ir2XM, branchImme, isNotEqual, isLessThan, in2ALUB, (stall || MWstall || countstatus), pcNext, flushJ, flushB, ir2MW, finalir, ir2DX, start, clock); 
	
	/* END CODE */

endmodule
