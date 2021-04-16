module decoder(select, out, enable); 

   input [4:0] select;
   input enable;
   output [31:0] out;

   wire [31:0] w1, w2, w3, w4;

   wire [31:0] enable32;

   wire notzero, selectReg;

   or reg0(notzero, select[0], select[1], select[2], select[3], select[4]);

   assign selectReg = notzero ? enable : 1'b0;

   assign enable32 = {31'b0000000000000000000000000000000, selectReg};

   // Shift by either 0 or 1 bits.
   //
   mux_2 s0( w1, select[0], enable32, {enable32[30:0], 1'b0} );

   // Shift by either 0 or 2 bits.
   //
   mux_2 s1( w2, select[1], w1, {w1[29:0], 2'b00} );

   // Shift by either 0 or 4 bits.
   //
   mux_2 s2( w3, select[2], w2, {w2[27:0], 4'b0000} );

   // Shift by either 0 or 8 bits.
   //
   mux_2 s3( w4, select[3], w3, {w3[23:0], 8'b00000000} );

    // Shift by either 0 or 16 bits.
   mux_2 s4( out, select[4], w4, {w4[15:0], 16'b0000000000000000} );

endmodule