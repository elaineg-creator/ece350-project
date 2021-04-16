module encoder(out, in0,in1,in2,in3);

input in3, in2, in1, in0;
output [1:0] out;

assign out[1] = in3 + in2;
assign out[0] = in3 + ((~in2)&in1);

endmodule