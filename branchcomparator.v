module branchcomparator(A, B, isLessThan, isNotEqual);
    input [31:0] A, B;
    output isLessThan, isNotEqual;
    wire[31:0] sub, notB;
    wire cout, absignsSUB, overflowsub1, overflowsub2 ,lt1, lt2, lt3, NotEqual;

    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin:loop1
            assign notB[i] = ~B[i];
        end

    endgenerate

    cla_32 SUB(sub, cout, A, notB, 1'b1);

    or NOTEQUAL(NotEqual, sub[0], sub[1], sub[2], sub[3], sub[4], sub[5], sub[6], sub[7], sub[8], sub[9],
                sub[10], sub[11], sub[12], sub[13], sub[14], sub[15], sub[16], sub[17], sub[18], sub[19],
                sub[20], sub[21], sub[22], sub[23], sub[24], sub[25], sub[26], sub[27], sub[28], sub[29],
                sub[30], sub[31]);
    assign isNotEqual = NotEqual;

    xnor CHECKOVERFLOW2(absignsSUB, A[31], notB[31]);
    xor CHECKOVERFLOWSUB(overflowsub1, A[31], sub[31]);
    and CHECKOVERFLOWSUB2(overflowsub2, overflowsub1, absignsSUB);

    xor LESSTHAN1(lt1, sub[31], overflowsub2);
    and LESSTHAN2(lt2, overflowsub2, A[31]);
    or LESSTHAN3(lt3, lt1, lt2);
    assign isLessThan = NotEqual ? ~lt3 : 1'b0;

endmodule