`timescale 1 ns / 100 ps

module cla_tb;

    
    wire [31:0] A, B;
    wire[31:0] Res;
	wire NE, LT;
	wire OVF;

    //wire cout;
    wire [4:0] ALU_OP;

    sub cla_sub(.data_operandA(A), .data_operandB(B), 
		.ctrl_ALUopcode(ALU_OP), .ctrl_shiftamt(Shift_Amt),
        .data_result(Res), 
        .isNotEqual(NE), .isLessThan(LT), 
        .overflow(OVF));

    integer i;

    // assign {in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20,
    //                 in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31} = i[31:0];
    assign A = 1111111111;
    assign B = 1111111;
    
    assign ALU_OP = 5'b00001;
    initial begin

        
            #20
            $display("a:%b + b:%b", A, B);
            $display("out:%b", Res);
            $display("INE:%b, ILT:%b, OVFLW: %b", NE, LT, OVF);
        

        $finish;

    end

    
    initial begin
        $dumpfile("Wave_File_Name.vcd");
        $dumpvars(0, cla_tb);
    end
    
endmodule






    