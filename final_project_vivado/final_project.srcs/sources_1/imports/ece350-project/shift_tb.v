`timescale 1 ns / 100 ps

module shift_tb;

    
    wire [31:0] a, out;
    wire [4:0] shamt;


    shift_left_logical SHIFT(.a(a), .shamt(shamt), .out(out));


    // assign {in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20,
    //                 in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31} = i[31:0];
    assign a = 32'b11111111111111111111111111111111;
    assign shamt = 5'b10001;

    initial begin

        
            #20
            $display("a:%b , shamt:%b", a, shamt);
            $display("out:%b", out);
        

        $finish;

    end

    
    initial begin
        $dumpfile("Wave_File_Name.vcd");
        $dumpvars(0, shift_tb);
    end
    
endmodule






    