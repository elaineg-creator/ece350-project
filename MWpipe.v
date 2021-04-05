module MWpipe(oIn, dIn, oOut, dOut, irIn, irOut, clock, reset, pcIn, pcOut);
    input [31:0] oIn, dIn, irIn, pcIn;
    input clock, reset;
    output [31:0] oOut, dOut, irOut, pcOut;
   

    reg_32 O(oOut, oIn, clock, 1'b1, reset);
    reg_32 D(dOut, dIn, clock, 1'b1, reset);
    reg_32 IR(irOut, irIn, clock, 1'b1, reset);
    reg_32 PC(pcOut, pcIn, clock, 1'b1, reset);

endmodule
