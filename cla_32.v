module cla_32(sum, cout, a, b, cin);
    input [31:0] a, b;
    input cin;
    output [31:0] sum;
    output cout;
    wire [31:0] g, p;
    wire [30:0] carry;
    wire [3:0] G, P;
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;

    cpgenerate CPGEN(g, p, a, b);

    and AND0(w1, P[0], cin);
    or OR0(carry[7], G[0], w1);

    and AND1(w2, P[1], G[0]);
    and AND1_2(w3, P[1], P[0], cin);
    or OR1(carry[15], G[1], w2, w3);

    and AND2(w4, P[2], G[1]);
    and AND2_2(w5, P[2], P[1], G[0]);
    and AND2_3(w6, P[2], P[1], P[0], cin);
    or OR2(carry[23], G[2], w4, w5, w6);

    and AND3(w7, P[3], G[2]);
    and AND3_2(w8, P[3], P[2], G[1]);
    and AND3_3(w9, P[3], P[2], P[1], G[0]);
    and AND3_4(w10, P[3], P[2], P[1], P[0], cin);
    or OR3(cout, G[3], w7, w8, w9, w10);

    eight_bit_cla EB0(P[0], G[0], carry[6:0], p[7:0], g[7:0], cin);
    eight_bit_cla EB1(P[1], G[1], carry[14:8], p[15:8], g[15:8], carry[7]);
    eight_bit_cla EB2(P[2], G[2], carry[22:16], p[23:16], g[23:16], carry[15]);
    eight_bit_cla EB3(P[3], G[3], carry[30:24], p[31:24], g[31:24], carry[23]);

    sum_unit SUM(sum, p, carry[30:0], cin);

endmodule
