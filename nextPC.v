module nextPC(pc, ir, im, bne, blt, regD, stall, PCnext, flushJ, flushB, ir2, ir3, ir4, clock, on);
    input [31:0] pc, ir, im, regD, ir2, ir3, ir4;
    input bne, blt ,stall, clock, on;
    output[31:0] PCnext;
    output flushJ, flushB;
    wire isB, isBNE, isBLT, isBEX, rstatus, isJ1, isJ2, ctrl1, ctrl2, cout1, cout2, XMsetx, MWsetx;
    wire [31:0] pcPlus1, PCandIm, address, muxI, muxJ1, PCnoStall, sx, BEXreg, PC0;

    assign XMsetx = (ir2[31] & ~ir2[30] & ir2[29] & ~ir2[28] & ir2[27]);
    assign MWsetx = (ir3[31] & ~ir3[30] & ir3[29] & ~ir3[28] & ir3[27]);

    cla_32 PCADD1(pcPlus1, cout1, pc, 32'b0, 1'b1);
    
    cla_32 SUMPCIMME(PCandIm, cout, pc, im, 1'b0);

    assign address = {5'b0, ir[26:0]}; 
    mux_4 BEX(BEXreg, {XMsetx, MWsetx}, regD, {5'b0, ir3[26:0]}, {5'b0, ir2[26:0]}, {5'b0, ir2[26:0]});
    assign rstatus = |BEXreg[31:0];            //bex bypassing
   

    assign isBNE = (~ir4[31] & ~ir4[30] & ~ir4[29] & ir4[28] & ~ir4[27]) & bne;
    assign isBLT = (~ir4[31] & ~ir4[30] & ir4[29] & ir4[28] & ~ir4[27]) & blt;
    assign isB = isBNE | isBLT;
    assign muxI = isB ? PCandIm : pcPlus1;       //is instruction an immediate type?

    assign isBEX = (ir[31] & ~ir[30] & ir[29] & ir[28] & ~ir[27]) & rstatus; 
    assign isJ1 = (~ir[31] & ~ir[30] & ~ir[29] & ~ir[28] & ir[27]) | (~ir[31] & ~ir[30] & ~ir[29] & ir[28] & ir[27]) | isBEX;
    assign muxJ1 = isJ1 ? address : muxI;       //is instruction a J1 type?

    assign isJ2 = (~ir[31] & ~ir[30] & ir[29] & ~ir[28] & ~ir[27]);
    assign PCnoStall = isJ2 ? regD : muxJ1;        //is the instruction JR?

    //reg on = 0;
    //reg [31:0] PCnext = 0;
    // always @(posedge clock) begin
    //     if(start) begin
    //         on <= 1;
    //     end
    // end


    assign PCnext = (stall || ~on) ? pc : PCnoStall;

    // always @(posedge clock) begin               //if start hasn't been pressed yet, keep pc at 0
    //     if(on == 1) begin
    //         PCnext <= stall ? pc : PCnoStall;
    //     end else begin
    //         PCnext <= 0;
    //     end
        
    // end
    

    assign flushJ = isJ1 | isJ2;
    assign flushB = isB;

endmodule