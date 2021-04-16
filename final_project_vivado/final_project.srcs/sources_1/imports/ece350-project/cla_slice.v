module cla_slice(g,p,a,b);
    input a, b;

    output g;
    output p;

    and AND(g, a, b);
    xor XOR(p, a, b);

endmodule