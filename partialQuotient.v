module partialQuotient(remainder, quotient, divisor, newRemainder, newQuotient);
    input [31:0] remainder, quotient, divisor;
    output [31:0] newRemainder, newQuotient;
    wire [31:0] shiftedRemainder, shiftedQuotient, notDivisor, subRemainder, addRemainder;
    wire signBit1, cout1, cout2;

    assign signBit1 = remainder[31];         //step 1: check sign bit of A

    assign shiftedQuotient = quotient <<< 1;   //shift the quotient 
    assign shiftedRemainder = {remainder[30:0], quotient[31]};  //shift the remainder 
    

    bitwise_not NOTDIVISOR(divisor, notDivisor);
    cla_32 SUB(subRemainder, cout1, shiftedRemainder, notDivisor, 1'b1);  //if signBit1 = 0, A=(A<<<1)-M
    cla_32 ADD(addRemainder, cout2, shiftedRemainder, divisor, 1'b0);     //if signBit1 = 1, A=(A<<<1)+M

    assign newRemainder = signBit1 ? addRemainder : subRemainder;
    assign newQuotient = shiftedQuotient;
    

endmodule