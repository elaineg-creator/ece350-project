module eight_bit_cla(P,G,carry,p,g,cin);
    input [7:0] p,g;
    input cin;
    output [6:0] carry;
    output P, G;
    wire w1,w2,w3, w4, w5, w6, w7, w8, w9, w10, w11,w12,w13, w14, w15, w16, w17, w18, w19, w20, w21,w22,w23, w24, w25, w26, w27, w28, w29, w30, w31, w32, w33, w34, w35;
    
    //assign c[0] = cin;

    and CARRYAND1(w1, cin, p[0]);
    or CARRYOR1(carry[0], g[0], w1);   

    and CARRYAND2(w2, p[1], g[0]);
    and CARRYAND2_1(w3, p[1], p[0], cin);
    or CARRYOR2(carry[1], g[1], w2, w3);  

    and CARRYAND3(w4, p[2], g[1]);
    and CARRYAND3_1(w5, p[2], p[1], g[0]);
    and CARRYAND3_2(w6, p[2], p[1], p[0], cin);
    or CARRYOR3(carry[2], g[2], w4, w5, w6);

    and CARRYAND4(w7, p[3], g[2]);
    and CARRYAND4_1(w8, p[3], p[2], g[1]);
    and CARRYAND4_2(w9, p[3], p[2], p[1], g[0]);
    and CARRYAND4_3(w35, p[3], p[2], p[1], p[0], cin);
    or CARRYOR4(carry[3], g[3], w7, w8, w9, w35);

    and CARRYAND5(w10, p[4], g[3]);
    and CARRYAND5_1(w11, p[4], p[3], g[2]);
    and CARRYAND5_2(w12, p[4], p[3], p[2], g[1]);
    and CARRYAND5_3(w13, p[4], p[3], p[2], p[1], g[0]);
    and CARRYAND5_4(w34, p[4], p[3], p[2], p[1], p[0], cin);
    or CARRYOR5(carry[4], g[4], w10, w11, w12, w13, w34); 

    and CARRYAND6(w14, p[5], g[4]);
    and CARRYAND6_1(w15, p[5], p[4], g[3]);
    and CARRYAND6_2(w16, p[5], p[4], p[3], g[2]);
    and CARRYAND6_3(w17, p[5], p[4], p[3], p[2], g[1]);
    and CARRYAND6_4(w18, p[5], p[4], p[3], p[2], p[1], g[0]);
    and CARRYAND6_5(w19, p[5], p[4], p[3], p[2], p[1], p[0], cin);
    or CARRYOR6(carry[5], g[5], w14, w15, w16, w17, w18, w19); 

    and CARRYAND7(w20, p[6], g[5]);
    and CARRYAND7_1(w21, p[6], p[5], g[4]);
    and CARRYAND7_2(w22, p[6], p[5], p[4], g[3]);
    and CARRYAND7_3(w23, p[6], p[5], p[4], p[3], g[2]);
    and CARRYAND7_4(w24, p[6], p[5], p[4], p[3], p[2], g[1]);
    and CARRYAND7_5(w25, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and CARRYAND7_6(w26, p[6], p[5], p[4], p[3], p[2], p[1], p[0], cin);
    or CARRYOR7(carry[6], g[6], w20, w21, w22, w23, w24, w25, w26); 

    and CARRYAND8(w27, p[7], g[6]);
    and CARRYAND8_1(w28, p[7], p[6], g[5]);
    and CARRYAND8_2(w29, p[7], p[6], p[5], g[4]);
    and CARRYAND8_3(w30, p[7], p[6], p[5], p[4], g[3]);
    and CARRYAND8_4(w31, p[7], p[6], p[5], p[4], p[3], g[2]);
    and CARRYAND8_5(w32, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and CARRYAND8_6(w33, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
   // and CARRYAND8_7(w34, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0], cin);
    //or CARRYOR8(carry[8], g[7], w27, w28, w29, w30, w31, w32, w33, w34); 

    and bigP(P, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    or bigG(G, g[7], w27, w28, w29, w30, w31, w32, w33);

endmodule