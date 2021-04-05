module multdivctrl(ir2XM, clock, data_result, data_exception, data_resultRDY, multdivStatus, pqIRin, pqIRout, ctrl_MULT, ctrl_DIV, regA, regB);
    input[31:0] ir2XM, pqIRout, regA, regB;
    input clock, ctrl_MULT, ctrl_DIV;
    output[31:0] data_result, pqIRin;
    output data_exception, data_resultRDY, multdivStatus;

    wire ctrl_MULT, ctrl_DIV, multdivOn;
    wire[31:0] multdivA, multdivB, regAOut, regBOut;
    
    
    reg_32 A(multdivA, regA, clock, (ctrl_MULT || ctrl_DIV), reset);
    reg_32 B(multdivB, regB, clock, (ctrl_MULT || ctrl_DIV), reset);

    assign multdivOn = (ctrl_MULT || ctrl_DIV) || (~data_resultRDY & (multdivStatus));          //multdiv is on or not
    dffe_ref FF(multdivStatus, multdivOn, clock, 1'b1, reset);

    multdiv MULTDIV(multdivA, multdivB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);


    assign pqIRin = (ctrl_MULT || ctrl_DIV) ? ir2XM : pqIRout;


endmodule