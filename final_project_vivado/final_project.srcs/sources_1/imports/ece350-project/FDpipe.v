module FDpipe(pcIn, pcOut, irIn, irOut, clock, reset, stall, MWstall);
    input [31:0] pcIn, irIn;
    input clock, reset, stall, MWstall;
    output [31:0] pcOut, irOut;
    wire [31:0] irIfStall;

    assign irIfStall = (stall | MWstall) ? irOut : irIn;

    reg_32 PC(pcOut, pcIn, clock, 1'b1, reset);
    reg_32 IR(irOut, irIfStall, clock, 1'b1, reset);

endmodule

