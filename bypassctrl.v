module bypassctrl(DXir, XMir, MWir, ALUinA ,ALUinB, WMbp, MWwriteen);
    input [31:0] DXir, XMir, MWir;
    input MWwriteen;
    output [1:0] ALUinA, ALUinB;
    output WMbp;

    wire A0, A1, XMwriteen, XMforA, MWforA, AnotZero, BnotZero, WnotZero;

    comparator forA(DXir[21:17], XMir[26:22], XMforA);
    comparator forA2(DXir[21:17], MWir[26:22], MWforA);

    assign XMwriteen = (~XMir[31] & ~XMir[30] & ~XMir[29] & ~XMir[28] & ~XMir[27]) | (~XMir[31] & ~XMir[30] & XMir[29] & ~XMir[28] & XMir[27])
                               | (~XMir[31] & XMir[30] & ~XMir[29] & ~XMir[28] & ~XMir[27]) | (XMir[31] & ~XMir[30] & XMir[29] & ~XMir[28] & XMir[27])
                                | (~XMir[31] & ~XMir[30] & ~XMir[29] & XMir[28] & XMir[27]) ;
    
    assign AnotZero = |DXir[21:17];

    assign A0 = (XMforA) & (XMwriteen) & (AnotZero);
    
    assign A1 = (MWforA) & (MWwriteen) & (AnotZero);
    
    mux_4_2 A(ALUinA, {A0, A1}, 2'b10, 2'b01, 2'b00, 2'b00);
  


    wire B0, B1, XMforB, MWforB, WMequal;
    wire [4:0] regB;

    comparator forB(regB, XMir[26:22], XMforB);
    comparator forB2(regB, MWir[26:22], MWforB);

    assign regB = (~DXir[31] & ~DXir[30] & ~DXir[29] & ~DXir[28] & ~DXir[31]) ? DXir[16:12] : DXir[26:22];

    assign BnotZero = |regB;

    assign B0 = (XMforB) & (XMwriteen) & (BnotZero);

    assign B1 = (MWforB) & (MWwriteen) & (BnotZero);
    
    mux_4_2 B(ALUinB, {B0, B1}, 2'b10, 2'b01, 2'b00, 2'b00);

    comparator forWM(XMir[26:22], MWir[26:22], WMequal);

    assign WnotZero = |XMir[26:22];

    assign WMbp = ((WMequal) & MWwriteen & WnotZero) ? 1'b1 : 1'b0;

endmodule