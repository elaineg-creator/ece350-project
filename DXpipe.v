module DXpipe(pcIn, pcOut, regAIn, regBIn, regAOut, regBOut, irIn, irOut, clock, reset, MWstall);
    input [31:0] pcIn, regAIn, regBIn, irIn;
    input clock, reset, MWstall;
    output [31:0] pcOut, regAOut, regBOut, irOut;
    wire [31:0] irIfStall;

    assign irIfStall = MWstall ? irOut : irIn;

    reg_32 PC(pcOut, pcIn, clock, 1'b1, reset);
    reg_32 regA(regAOut, regAIn, clock, 1'b1, reset);
    reg_32 regB(regBOut, regBIn, clock, 1'b1, reset);
    reg_32 IR(irOut, irIfStall, clock, 1'b1, reset);

endmodule