/*
  This SystemVerilog testbench (tb.sv) is designed to verify the functionality of a FIR filter module named FIR_63TAP. 
  The testbench generates a clock signal and applies a reset signal to initialize the FIR filter. 
  It then feeds a repeating pattern of 20 signed 10-bit input samples (x_in) into the FIR filter for a total of 256 samples. 
  The output of the FIR filter (y) is captured and written to an output file named "fir_output.txt" for further analysis. 
  Additionally, the testbench prints the current sample index, input value, and output value to the console for real-time monitoring.
*/

`timescale 1ns/1ps

module tb;
  reg clk;
  reg rst_n;
  reg signed [9:0] x_in;
  wire signed [9:0] y;


  FIR_63TAP dut (.clk(clk), .rst_n(rst_n), .x_in(x_in), .y(y));

  integer out_file;

  initial clk = 0;
  always #5 clk = ~clk;

  // 20-sample pattern (repeat to 256)
  reg signed [9:0] x20 [0:19];
  integer n;

  initial begin
       
    x20[0] = 10'sd0;     x20[1] = 10'sd498;  x20[2] = 10'sd150;  x20[3] = -10'sd406; x20[4] = -10'sd243;
    x20[5] = 10'sd255;   x20[6] = 10'sd243;  x20[7] = -10'sd105; x20[8] = -10'sd150; x20[9] = 10'sd13;
    x20[10]= 10'sd0;     x20[11]= -10'sd13;  x20[12]= 10'sd150;  x20[13]= 10'sd105;  x20[14]= -10'sd243;
    x20[15]= -10'sd256;  x20[16]= 10'sd243;  x20[17]= 10'sd406;  x20[18]= -10'sd150; x20[19]= -10'sd498;

    out_file = $fopen("fir_output.txt", "w");
    if (out_file == 0) begin
        $display("Error: Could not open output file.");
        $finish;
    end

    rst_n = 0;
    x_in  = 0;

    repeat (3) @(posedge clk);
      rst_n = 1;

    for (n = 0; n < 256; n = n + 1) begin
      x_in <= x20[n % 20];
      @(posedge clk);
      //write y to file
      $fwrite(out_file, "%0d\n", $signed(y));
      //$display("n=%0d x_in=%0d y=%0d", n, x_in, $signed(y));
    end

    $fclose(out_file);

    $finish;
  end
endmodule
