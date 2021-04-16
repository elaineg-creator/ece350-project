module stallctrl(FDir, DXir, XMir, stall, MWstall, multdivStatus, pqIRin, multdivRDY);
    input [31:0] FDir, DXir, XMir, pqIRin;
    input multdivStatus, multdivRDY;
    output stall, MWstall;
    wire stall1, stall2, stall3, FDwriteen, FDsetx, FDjal, pqIRnotzero, XMwriteen;
    wire[4:0] FDrd1, FDrd2;

    // assign FDwriteen = (~FDir[31] & ~FDir[30] & ~FDir[29] & ~FDir[28] & ~FDir[27]) | (~FDir[31] & ~FDir[30] & FDir[29] & ~FDir[28] & FDir[27])
    //                            | (~FDir[31] & FDir[30] & ~FDir[29] & ~FDir[28] & ~FDir[27]) | (XMir[31] & ~XMir[30] & XMir[29] & ~XMir[28] & XMir[27])
    //                             | (~FDir[31] & ~FDir[30] & ~FDir[29] & FDir[28] & FDir[27]) ;

    assign pqIRnotzero = |pqIRin[26:22];        //don't stall if multdiv is writing to zero

    assign FDsetx = (FDir[31] & ~FDir[30] & FDir[29] & ~FDir[28] & FDir[27]);
    assign FDjal = (~FDir[31] & ~FDir[30] & ~FDir[29] & FDir[28] & FDir[27]);
    assign FDrd1 = FDsetx ? 5'b11110 : FDir[26:22];
    assign FDrd2 = FDjal ? 5'b11111 : FDrd1;

    assign stall1 = (DXir[31:27] == {5'b01000}) &&
                    ((FDir[21:17] == DXir[26:22]) || 
                    ((FDir[16:12] == DXir[26:22]) && (FDir[31:27] != {5'b00111})));
    assign stall2 = multdivStatus & ((~|FDir[31:27]) & ((FDir[6:2] == 5'b00110) || (FDir[6:2] == 5'b00111))); //stall if op is multdiv and there is already another one happening
    assign stall3 = multdivStatus & ((pqIRin[26:22] == FDir[21:17]) || (pqIRin[26:22] == FDir[16:12]) || (pqIRin[26:22] == FDrd2)) & pqIRnotzero;  //stall is op uses the rd of multdiv

    assign stall = stall1 || stall2 || stall3;

    assign XMwriteen = (~XMir[31] & ~XMir[30] & ~XMir[29] & ~XMir[28] & ~XMir[27]) | (~XMir[31] & ~XMir[30] & XMir[29] & ~XMir[28] & XMir[27])
                               | (~XMir[31] & XMir[30] & ~XMir[29] & ~XMir[28] & ~XMir[27]) | (XMir[31] & ~XMir[30] & XMir[29] & ~XMir[28] & XMir[27])
                                | (~XMir[31] & ~XMir[30] & ~XMir[29] & XMir[28] & XMir[27]) ;

    assign MWstall = (multdivRDY & XMwriteen);

endmodule