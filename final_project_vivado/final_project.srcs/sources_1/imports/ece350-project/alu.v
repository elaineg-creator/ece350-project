module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output overflow;

    
    // add your code here:
    wire [31:0] add, sub, bit_and, bit_or, shift_right, shift_left, notB, data_result_nooverflow, data_result_overflow;
    wire absigns, overflowadd1, overflowsub1 ,overflowadd2, overflowsub2, cin, cout, lt1, lt2, lt3, NotEqual;
    assign cin = 1;

    bitwise_not NOTB(data_operandB, notB);  //for subtraction
    
    cla_32 ADD(add, cout, data_operandA, data_operandB, 1'b0);
    cla_32 SUB(sub, cout, data_operandA, notB, 1'd1);
    bitwise_and AND(data_operandA, data_operandB, bit_and);
    bitwise_or OR(data_operandA, data_operandB, bit_or);
    shift_right_arithmic SRA(data_operandA, ctrl_shiftamt, shift_right); 
    shift_left_logical SLA(data_operandA, ctrl_shiftamt, shift_left); 

    xnor CHECKOVERFLOW1(absignsADD, data_operandA[31], data_operandB[31]);
    xnor CHECKOVERFLOW2(absignsSUB, data_operandA[31], notB[31]);
    xor CHECKOVERFLOWADD(overflowadd1, data_operandA[31], add[31]);
    xor CHECKOVERFLOWSUB(overflowsub1, data_operandA[31], sub[31]);
    and CHECKOVERFLOWADD2(overflowadd2, overflowadd1, absignsADD);
    and CHECKOVERFLOWSUB2(overflowsub2, overflowsub1, absignsSUB);
    assign overflow0 = ctrl_ALUopcode[0] ? overflowsub2 : overflowadd2;   //overflow
    assign overflow = overflow0;
    
    // or NOTEQUAL(NotEqual, sub[0], sub[1], sub[2], sub[3], sub[4], sub[5], sub[6], sub[7], sub[8], sub[9],
    //             sub[10], sub[11], sub[12], sub[13], sub[14], sub[15], sub[16], sub[17], sub[18], sub[19],
    //             sub[20], sub[21], sub[22], sub[23], sub[24], sub[25], sub[26], sub[27], sub[28], sub[29],
    //             sub[30], sub[31]);
    // assign isNotEqual = NotEqual;
    // //2 cases for LT: neg result but no overflow, overflowed and a is neg

    // xor LESSTHAN1(lt1, sub[31], overflowsub2);
    // and LESSTHAN2(lt2, overflowsub2, data_operandA[31]);
    // or LESSTHAN3(lt3, lt1, lt2);
    // assign isLessThan = NotEqual ? ~lt3 : 1'b0;

    mux_8 MUX(data_result_nooverflow, ctrl_ALUopcode[2:0], add, sub, bit_and, bit_or, shift_left, shift_right, 32'b0, 32'b0);

    assign data_result_overflow = (|ctrl_ALUopcode[2:0]) ? {32'b011} : {32'b01};

    assign data_result = overflow0 ? data_result_overflow : data_result_nooverflow;
    
endmodule