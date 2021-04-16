module partialProd(multiplicand, multiplier, out);
    input [31:0] multiplicand;
    input [2:0] multiplier;
    output [31:0] out;
    wire cout;
    wire [31:0] subMultiplicand, subMultiplicandShifted, notMultiplicand, notMultiplicandShifted, multipShift, nop;


    

    assign multipShift = multiplicand <<< 1;

    bitwise_not NOTMULTIP(multipShift, notMultiplicandShifted);
    cla_32 ADD(subMultiplicandShifted, cout, notMultiplicandShifted, {32'b0}, 1'b1);

    bitwise_not NOTMULTIP1(multiplicand, notMultiplicand);
    cla_32 ADD1(subMultiplicand, cout, notMultiplicand, {32'b0}, 1'b1);


    assign nop = 32'b0;

    //assigned the output

    mux_8 mux(out, multiplier, nop, multiplicand, multiplicand, multipShift, subMultiplicandShifted, subMultiplicand, subMultiplicand, nop);

endmodule