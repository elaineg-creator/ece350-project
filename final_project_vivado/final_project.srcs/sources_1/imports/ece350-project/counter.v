module counter(clk, rst, out);
    input clk, rst;
    output [5:0] out;
    wire [5:0] q;

    dffe_ref dff0(.d(~q[0]), .q(q[0]), .clr(rst), .clk(clk), .en(1'b1));

    dffe_ref dff1(.d(~q[1]), .q(q[1]), .clr(rst), .clk(q[0]), .en(1'b1));

    dffe_ref dff2(.d(~q[2]), .q(q[2]), .clr(rst), .clk(q[1]), .en(1'b1));

    dffe_ref dff3(.d(~q[3]), .q(q[3]), .clr(rst), .clk(q[2]), .en(1'b1));

    dffe_ref dff4(.d(~q[4]), .q(q[4]), .clr(rst), .clk(q[3]), .en(1'b1));

    dffe_ref dff5(.d(~q[5]), .q(q[5]), .clr(rst), .clk(q[4]), .en(1'b1));

    assign out = {~q[5], ~q[4], ~q[3], ~q[2], ~q[1], ~q[0]};

endmodule

    