module mux_2_16(out, select, in0, in1);
    input select;
    input [15:0] in0, in1;
    output [15:0] out;
    assign out = select ? in1 : in0;
endmodule