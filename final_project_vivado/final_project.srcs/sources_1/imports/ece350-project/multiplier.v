module multiplier(multiplicand, multiplier, clk, rst, out, ready, overflow);
    input [31:0] multiplicand, multiplier;
    input clk, rst;
    wire [5:0] counter;
    wire [2:0] segment;
    wire [31:0] prodOut, multiplierOut, multiplierIn, multiplicandToAdd, shiftedMultiplier, shiftedProduct, claOut, prodIn;
    wire cout, overflow1, overflow2, overflow3, overflow4, overflow5, testrst, on, ctrlsig;
    output [31:0] out;
    output ready, overflow;

    reg_32 PRODUCT(prodOut, prodIn, clk, 1'b1, rst);
    reg_32 MULTIPLIER(multiplierOut, multiplierIn, clk, 1'b1, rst);
    dffe_ref extra(.d(lastBit), .q(seg0), .clr(rst), .clk(clk), .en(1'b1));

    counter COUNTER(clk, rst, counter);

    assign lastBit = (~counter[0] & ~counter[1] & ~counter[2] & ~counter[3] & ~counter[4] & ~counter[5]) ? 1'b0 : multiplierOut[1];
    
    assign multiplierIn = (~counter[0] & ~counter[1] & ~counter[2] & ~counter[3] & ~counter[4] & ~counter[5]) ? multiplier : shiftedMultiplier;    //load multiplier in
    
    assign segment = {multiplierOut[1:0], seg0};   //change multiplier segment

    partialProd MULTIP(multiplicand, segment, multiplicandToAdd);  //get changed multiplicand

    assign shiftedMultiplier = {prodOut[1:0], multiplierOut[31:2]};   //shift the multiplier
    assign shiftedProduct = {{2{prodOut[31]}}, prodOut[31:2]};  //shift the product

    cla_32 ADD(claOut, cout, shiftedProduct, multiplicandToAdd, 1'b0);  //add the shifted product and put into product register
    assign prodIn = (counter[4] & ~counter[3] & ~counter[2] & ~counter[1] & counter[0]) ? shiftedProduct : claOut; 

    assign last = seg0;
    assign ready = (~counter[5]  & counter[4] & ~counter[3] & ~counter[2] & counter[1] & ~counter[0]) & on; //ready once 18+clock cycles passed

    nor OVERFLOW1(overflow1, prodOut[0], prodOut[1], prodOut[2], prodOut[3], prodOut[4], prodOut[5], prodOut[6], prodOut[7], prodOut[8], prodOut[9], 
                prodOut[10], prodOut[11], prodOut[12], prodOut[13], prodOut[14], prodOut[15], prodOut[16], prodOut[17], prodOut[18], prodOut[19],
                prodOut[20], prodOut[21], prodOut[22], prodOut[23], prodOut[24], prodOut[25], prodOut[26], prodOut[27], prodOut[28], prodOut[29],
                prodOut[30], prodOut[31], multiplierOut[31]);   //checks if all bits are 0's
    and OVERFLOW2(overflow2, prodOut[0], prodOut[1], prodOut[2], prodOut[3], prodOut[4], prodOut[5], prodOut[6], prodOut[7], prodOut[8], prodOut[9], 
                prodOut[10], prodOut[11], prodOut[12], prodOut[13], prodOut[14], prodOut[15], prodOut[16], prodOut[17], prodOut[18], prodOut[19],
                prodOut[20], prodOut[21], prodOut[22], prodOut[23], prodOut[24], prodOut[25], prodOut[26], prodOut[27], prodOut[28], prodOut[29],
                prodOut[30], prodOut[31], multiplierOut[31]);   //checks if all bits are 1's
    nor OVERFLOW3(overflow3, overflow1, overflow2);  //if bits are neither all 0 or all 1, then overflow
    
    xnor CHECKOVERFLOW1(sameSign, multiplicand[31], multiplier[31]);  //checks if a and b are the same sign
    xnor CHECKOVERFLOW2(overflow4, sameSign, multiplierOut[31]);  //if a and b are same sign, prod should be positive
    //nor CHECKOVERFLOW3(overflow3, sameSign, multiplierOut[31]);  //if a and b are diff sign, prod should be negative
    or OVERFLOW(overflow5, overflow3, overflow4);

    assign overflow = ((!(|multiplicand[31:0])) || (!(|multiplier[31:0]))) ? 1'b0 : overflow5;
    



    assign out = multiplierOut;

    
    assign testrst = (~counter[5]  & counter[4] & ~counter[3] & ~counter[2] & counter[1] & counter[0]);

    assign ctrlsig = rst || (~(~counter[5]  & counter[4] & ~counter[3] & ~counter[2] & counter[1] & ~counter[0]) & (on));


    dffe_ref test(on, ctrlsig, clk, 1'b1, testrst);

   
endmodule

    