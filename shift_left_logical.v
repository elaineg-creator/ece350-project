module shift_left_logical( a, shamt, out); 

   input [31:0] a;
   input [4:0] shamt;
   output[31:0] out;

   wire [31:0] w1, w2, w3, w4;

   // Shift by either 0 or 1 bits.
   //
   mux_2 s0( w1, shamt[0], a, {a[30:0], 1'b0} );

   // Shift by either 0 or 2 bits.
   //
   mux_2 s1( w2, shamt[1], w1, {w1[29:0], 2'b00} );

   // Shift by either 0 or 4 bits.
   //
   mux_2 s2( w3, shamt[2], w2, {w2[27:0], 4'b0000} );

   // Shift by either 0 or 8 bits.
   //
   mux_2 s3( w4, shamt[3], w3, {w3[23:0], 8'b00000000} );

    // Shift by either 0 or 16 bits.
   mux_2 s4( out, shamt[4], w4, {w4[15:0], 16'b0000000000000000} );

endmodule