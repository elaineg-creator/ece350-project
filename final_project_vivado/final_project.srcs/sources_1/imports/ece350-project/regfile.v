module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here

	wire [31:0] regOut[31:0];
	wire [31:0] writeRegEn, readRegA, readRegB, triA, triB;
	wire  notzeroA, notzeroB;
	wire clk;

	assign clk = ~clock;

	decoder dec32(ctrl_writeReg, writeRegEn, ctrl_writeEnable);

    decoder regA(ctrl_readRegA, readRegA, 1'b1);
    decoder regB(ctrl_readRegB, readRegB, 1'b1);

	or A0(notzeroA, ctrl_readRegA[0], ctrl_readRegA[1], ctrl_readRegA[2], ctrl_readRegA[3], ctrl_readRegA[4]);
	or B0(notzeroB, ctrl_readRegB[0], ctrl_readRegB[1], ctrl_readRegB[2], ctrl_readRegB[3], ctrl_readRegB[4]);

	genvar i;
    generate
        for (i=0; i<32; i=i+1) begin:loop1
            reg_32 regs(.d(data_writeReg), .q(regOut[i]), .clr(ctrl_reset), .clk(clk), .en(writeRegEn[i]));
        end

    endgenerate

	// mux_32 regA(data_readRegA, ctrl_readRegA, regOut[0], regOut[1],regOut[2],regOut[3],regOut[4],regOut[5],regOut[6], regOut[7],
	// 			regOut[8],regOut[9],regOut[10],regOut[11], regOut[12],regOut[13],regOut[14],regOut[15],regOut[16], regOut[17],
	// 			regOut[18],regOut[19],regOut[20],regOut[21],regOut[22],regOut[23],regOut[24],regOut[25],regOut[26], regOut[27],
	// 			regOut[28],regOut[29],regOut[30],regOut[31]);
	// mux_32 regB(data_readRegB, ctrl_readRegB, regOut[0], regOut[1],regOut[2],regOut[3],regOut[4],regOut[5],regOut[6], regOut[7],
	// 			regOut[8],regOut[9],regOut[10],regOut[11], regOut[12],regOut[13],regOut[14],regOut[15],regOut[16], regOut[17],
	// 			regOut[18],regOut[19],regOut[20],regOut[21],regOut[22],regOut[23],regOut[24],regOut[25],regOut[26], regOut[27],
	// 			regOut[28],regOut[29],regOut[30],regOut[31]);

    //read register A
    genvar k;
    generate
        for (k=0; k<32; k=k+1) begin:loop2
            tristatebuf tribuf(.in(regOut[k]), .oe(readRegA[k]), .out(triA));
        end

    endgenerate
    genvar j;
    generate
        for (j=0; j<32; j=j+1) begin:loop3
            tristatebuf tribuf(.in(regOut[j]), .oe(readRegB[j]), .out(triB));
        end

    endgenerate

	assign data_readRegA = notzeroA ? triA : 32'b0;
	assign data_readRegB = notzeroB ? triB : 32'b0;


endmodule
