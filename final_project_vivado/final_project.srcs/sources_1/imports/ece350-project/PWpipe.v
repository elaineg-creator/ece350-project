module PWpipe(pqin, pqout, irin, irout, pqReadyIn, pqReadyOut, data_exceptionIn, data_exceptionOut, clock, reset);
    input [31:0] pqin, irin;
    input clock, reset, pqReadyIn, data_exceptionIn;
    output [31:0] pqout, irout;
    output pqReadyOut, data_exceptionOut;

    reg_32 PQ(pqout, pqin, clock, 1'b1, reset);
    reg_32 IR(irout, irin, clock, 1'b1, reset);
    dffe_ref RDY(pqReadyOut, pqReadyIn, clock, 1'b1, reset);
    dffe_ref OVERFLOW(data_exceptionOut, data_exceptionIn, clock, 1'b1, reset);

endmodule