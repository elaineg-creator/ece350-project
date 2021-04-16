module XMpipe(oIn, oOut, bIn, bOut, irIn, irOut, clock, reset, pcIn, pcOut, MWstall);
    input [31:0] oIn, bIn, irIn, pcIn;
    input clock, reset, MWstall;
    output [31:0] oOut, bOut, irOut, pcOut;

    wire [31:0] irIfStall;

    assign irIfStall = MWstall ? irOut : irIn;

    reg_32 O(oOut, oIn, clock, 1'b1, reset);
    reg_32 B(bOut, bIn, clock, 1'b1, reset);
    reg_32 IR(irOut, irIfStall, clock, 1'b1, reset);
    reg_32 PC(pcOut, pcIn, clock, 1'b1, reset);

endmodule