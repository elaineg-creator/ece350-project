module comparator(A, B, isEqual);
    input [4:0] A, B;
    output isEqual;

    wire[31:0] sub, extendedA, extendedB;
    wire [4:0] notB;
    wire cout;

    genvar i;
    generate
        for (i=0; i<5; i=i+1) begin:loop1
            assign notB[i] = ~B[i];
        end

    endgenerate

    assign extendedA = {{28{A[4]}}, A[4:0]};
    assign extendedB = {{28{notB[4]}}, notB[4:0]};

    cla_32 SUB(sub, cout, extendedA, extendedB, 1'b1);

    nor EQUAL(isEqual, sub[0], sub[1], sub[2], sub[3], sub[4], sub[5], sub[6], sub[7], sub[8], sub[9],
                sub[10], sub[11], sub[12], sub[13], sub[14], sub[15], sub[16], sub[17], sub[18], sub[19],
                sub[20], sub[21], sub[22], sub[23], sub[24], sub[25], sub[26], sub[27], sub[28], sub[29],
                sub[30], sub[31]);


endmodule