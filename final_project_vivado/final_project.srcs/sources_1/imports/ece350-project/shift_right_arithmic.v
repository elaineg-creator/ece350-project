module shift_right_arithmic( a, shamt, out); 

   input [31:0] a;
   input [4:0] shamt;
   output[31:0] out;

   wire [31:0] w1, w2, w3, w4;

   // Shift by either 0 or 1 bits.
   //
   mux_2 s0( w1, shamt[0], a, {{1{a[31]}}, a[31:1]} );

   // Shift by either 0 or 2 bits.
   //
   mux_2 s1( w2, shamt[1], w1, {{2{a[31]}}, w1[31:2]} );

   // Shift by either 0 or 4 bits.
   //
   mux_2 s2( w3, shamt[2], w2, {{4{a[31]}}, w2[31:4]} );

   // Shift by either 0 or 8 bits.
   //
   mux_2 s3( w4, shamt[3], w3, {{8{a[31]}}, w3[31:8]} );

    // Shift by either 0 or 16 bits.
   mux_2 s4( out, shamt[4], w4, {{16{a[31]}}, w4[31:16]} );

endmodule