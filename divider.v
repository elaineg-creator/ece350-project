module divider(dividend0, divisor0, clk, rst, quotient, ready, overflow);
    input [31:0] dividend0, divisor0;
    input clk, rst;
    wire [5:0] counter;
    wire [31:0] remainderOut, remainderIn, quotientOut, quotientIn, divisorToAdd, newQuotient, 
                newRemainder, addedQuotient, finalRemainder, finalQuotient, A, Q, 
                adjustedQ, notDivisor, notDividend, divisor2, dividend2, quotient2, notQuotient,
                dividend, divisor;
    wire cout, cout2, signA, q0, testrst, on, ctrlsig;
    output [31:0] quotient;
    output ready, overflow;
    //output [5:0] count;

    bitwise_not NOTDIVISOR(divisor0, notDivisor);
    cla_32 DIVISOR2(divisor2, cout, notDivisor, 32'b0, 1'b1);
    bitwise_not NOTDIVIDEND(dividend0, notDividend);
    cla_32 DIVIDEND2(dividend2, cout2, notDividend, 32'b0, 1'b1);

    assign divisor = divisor0[31] ? divisor2 : divisor0;
    assign dividend = dividend0[31] ? dividend2 : dividend0;
    xor FLIPQUOTIENT(flipQ, divisor0[31], dividend0[31]);

    reg_32 REMAINDER(remainderOut, remainderIn, clk, 1'b1, rst);
    reg_32 QUOTIENT(quotientOut, quotientIn, clk, 1'b1, rst);
    //dffe_ref sign(.d(remainderOut[3]), .q(signA), .clr(rst), .clk(clk), .en(1'b1));

    counter COUNTER(clk, rst, counter);

    assign quotientIn = (counter[0] & counter[1] & counter[2] & counter[3] & counter[4] & counter[5]) ? newQuotient : finalQuotient;    //load dividend in
    assign remainderIn = (counter[0] & counter[1] & counter[2] & counter[3] & counter[4] & ~counter[5]) ? finalRemainder : newRemainder;

    assign A = (counter[0] & counter[1] & counter[2] & counter[3] & counter[4] & counter[5]) ? 4'b0 : remainderOut ;

    assign Q = (counter[0] & counter[1] & counter[2] & counter[3] & counter[4] & counter[5]) ? dividend : adjustedQ;

    assign adjustedQ = {quotientOut[31:1], ~remainderOut[31]};
  
    partialQuotient partQ(A, Q, divisor, newRemainder, newQuotient);
    
    assign finalRemainder = remainderOut[31] ? (remainderOut + divisor) : remainderOut;

    assign finalQuotient = (counter[0] & counter[1] & counter[2] & counter[3] & counter[4] & ~counter[5]) ? {quotientOut[31:1], ~remainderOut[31]} : newQuotient;

    assign ready = (~counter[0] & ~counter[1] & ~counter[2] & ~counter[3] & ~counter[4] & counter[5]) & on;

    assign signBit = remainderOut[31];
    
    assign overflow = |divisor[31:0] ? 1'b0 : 1'b1;

    bitwise_not NOTQUOTIENT(quotientOut, notQuotient);
    cla_32 QUOTIENT2(quotient2, cout, notQuotient, 32'b0, 1'b1);

    assign quotient = flipQ ? quotient2 : quotientOut;
    
    assign testrst = (counter[0] & ~counter[1] & ~counter[2] & ~counter[3] & ~counter[4] & counter[5]);

    assign ctrlsig = rst || (~(~counter[0] & ~counter[1] & ~counter[2] & ~counter[3] & ~counter[4] & counter[5]) & (on));


    dffe_ref test(on, ctrlsig, clk, 1'b1, testrst);
    

endmodule

    





