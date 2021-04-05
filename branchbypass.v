module branchbypass(FDir, DXir, XMir, MWir, selectA ,selectB, MWwriteen);
    input [31:0] FDir, DXir, XMir, MWir;
    input MWwriteen;
    output [1:0] selectA, selectB;

    wire A0, A1, XMwriteen, DXforA, XMforA, MWforA, AnotZero, BnotZero, DXwriteen;
    wire [1:0] A2;

    comparator forA0(FDir[21:17], DXir[26:22], DXforA);
    comparator forA1(FDir[21:17], XMir[26:22], XMforA);
    comparator forA2(FDir[21:17], MWir[26:22], MWforA);

    assign XMwriteen = (~XMir[31] & ~XMir[30] & ~XMir[29] & ~XMir[28] & ~XMir[27]) | (~XMir[31] & ~XMir[30] & XMir[29] & ~XMir[28] & XMir[27])
                               | (~XMir[31] & XMir[30] & ~XMir[29] & ~XMir[28] & ~XMir[27]) | (XMir[31] & ~XMir[30] & XMir[29] & ~XMir[28] & XMir[27])
                                | (~XMir[31] & ~XMir[30] & ~XMir[29] & XMir[28] & XMir[27]) ;

    assign DXwriteen = (~DXir[31] & ~DXir[30] & ~DXir[29] & ~DXir[28] & ~DXir[27]) | (~DXir[31] & ~DXir[30] & DXir[29] & ~DXir[28] & DXir[27])
                               | (~DXir[31] & DXir[30] & ~DXir[29] & ~DXir[28] & ~DXir[27]) | (DXir[31] & ~DXir[30] & DXir[29] & ~DXir[28] & DXir[27])
                                | (~DXir[31] & ~DXir[30] & ~DXir[29] & DXir[28] & DXir[27]) ;
    
    assign AnotZero = |FDir[21:17];

    assign A0 = (XMforA) & (XMwriteen) & (AnotZero);
    
    assign A1 = (MWforA) & (MWwriteen) & (AnotZero);
    
    mux_4_2 A(A2, {A0, A1}, 2'b10, 2'b01, 2'b00, 2'b00);

    assign selectA = ((DXforA) & (DXwriteen) & (AnotZero)) ? 2'b11 : A2;
  


    wire B0, B1, XMforB, MWforB, WMequal, DXforB;
    wire [1:0] B2;
    wire [4:0] regB;

    comparator forB0(regB, DXir[26:22], DXforB);
    comparator forB1(regB, XMir[26:22], XMforB);
    comparator forB2(regB, MWir[26:22], MWforB);

    assign regB = (~FDir[31] & ~FDir[30] & ~FDir[29] & ~FDir[28] & ~FDir[31]) ? FDir[16:12] : FDir[26:22];

    assign BnotZero = |regB;

    assign B0 = (XMforB) & (XMwriteen) & (BnotZero);

    assign B1 = (MWforB) & (MWwriteen) & (BnotZero);
    
    mux_4_2 B(B2, {B0, B1}, 2'b10, 2'b01, 2'b00, 2'b00);

    assign selectB = ((DXforB) & (DXwriteen) & (BnotZero)) ? 2'b11 : B2;

    

endmodule