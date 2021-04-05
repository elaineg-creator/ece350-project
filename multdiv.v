module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here

    wire divRdy, multRdy, multException, divException, q, d;
    wire [31:0] divResult, multResult, multReal, divReal;


    multiplier BOOTH(data_operandA, data_operandB, clock, ctrl_MULT, multResult, multRdy, multException);
    assign multReal = multException ? 32'b0100 : multResult;
    
    divider DIVIDE(data_operandA, data_operandB, clock, ctrl_DIV, divResult, divRdy, divException);
    assign divReal = divException ? 32'b0101 : divResult;

    assign data_resultRDY = q ? multRdy : divRdy;

    assign data_exception = q ? multException : divException;

    assign data_result = q ? multReal : divReal;

    assign d = ctrl_MULT || (~ctrl_DIV & (q));

    dffe_ref FF(q, d, clock, 1'b1, 1'b0);

    
    

endmodule