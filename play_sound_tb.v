`timescale 1ns / 1ps

module play_sound_tb();

  reg [3:0] switches;
  reg signal = 1;
  output audioOut, audioEn, chSel;
  reg clock = 0;
  always
    #5 clock = ~clock;
  always
    #10000000 signal = ~signal;

  play_sound dut(clock, signal, audioOut, audioEn);

  initial begin
      $dumpfile("play_sound_wave.vcd");
      $dumpvars(0, play_sound_tb);
  end


endmodule
