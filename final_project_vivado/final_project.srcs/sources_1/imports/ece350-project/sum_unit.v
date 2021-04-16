module sum_unit(sum, p, carry, cin);
    input cin;
    input [30:0] carry;
    input [31:0] p;
    output [31:0] sum;

    xor SUM0(sum[0], p[0], cin);
    xor SUM1(sum[1], p[1], carry[0]);
    xor SUM2(sum[2], p[2], carry[1]);
    xor SUM3(sum[3], p[3], carry[2]);
    xor SUM4(sum[4], p[4], carry[3]);
    xor SUM5(sum[5], p[5], carry[4]);
    xor SUM6(sum[6], p[6], carry[5]);
    xor SUM7(sum[7], p[7], carry[6]);
    xor SUM8(sum[8], p[8], carry[7]);
    xor SUM9(sum[9], p[9], carry[8]);
    xor SUM10(sum[10], p[10], carry[9]);
    xor SUM11(sum[11], p[11], carry[10]);
    xor SUM12(sum[12], p[12], carry[11]);
    xor SUM13(sum[13], p[13], carry[12]);
    xor SUM14(sum[14], p[14], carry[13]);
    xor SUM15(sum[15], p[15], carry[14]);
    xor SUM16(sum[16], p[16], carry[15]);
    xor SUM17(sum[17], p[17], carry[16]);
    xor SUM18(sum[18], p[18], carry[17]);
    xor SUM19(sum[19], p[19], carry[18]);
    xor SUM20(sum[20], p[20], carry[19]);
    xor SUM21(sum[21], p[21], carry[20]);
    xor SUM22(sum[22], p[22], carry[21]);
    xor SUM23(sum[23], p[23], carry[22]);
    xor SUM24(sum[24], p[24], carry[23]);
    xor SUM25(sum[25], p[25], carry[24]);
    xor SUM26(sum[26], p[26], carry[25]);
    xor SUM27(sum[27], p[27], carry[26]);
    xor SUM28(sum[28], p[28], carry[27]);
    xor SUM29(sum[29], p[29], carry[28]);
    xor SUM30(sum[30], p[30], carry[29]);
    xor SUM31(sum[31], p[31], carry[30]);

endmodule