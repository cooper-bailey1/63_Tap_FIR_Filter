// FIR_63TAP.sv
module FIR_63TAP (
    input  logic        clk,
    input  logic        rst_n,   // active-low reset
    input  logic signed [9:0] x_in, // example 10-bit signed inputi
    output logic signed [9:0] y  // example 10-bit signed output
);


logic signed [9:0] x_prev [0:62]; // previous input samples
logic signed [25:0] acc; // accumulator for the FIR filter (20 bits to prevent overflow)
logic signed[25:0] acc_scaled; // scaled accumulator for saturation
logic signed[25:0] acc_sat; // saturated accumulator for final output

  logic signed [9:0] h [0:62];

  initial begin
      $readmemh("fir_coeffs.hex", h);
  end

  always_comb begin
      acc = '0; // reset accumulator
      for (int i = 0; i < 63; i++) begin
          acc += x_prev[i] * h[i]; // multiply and accumulate
      end
      // Scale down the accumulator to fit into 10 bits (assuming coefficients are small)
      acc_sat = acc + 26'sd512; // add offset for rounding (if needed)
      acc_scaled = acc_sat >>> 9; // example scaling factor (adjust as needed)
      // Saturate the output to fit into 10 bits
      if (acc_scaled >26'sd511) begin
          acc_scaled = 10'sd511; // max positive value for 10-bit signed
        end else if (acc_scaled < -26'sd512) begin
          acc_scaled = -10'sd512; // max negative value for 10-bit signed
      end
  end

  // Sequential logic (runs on clock edge)
  always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
          for(int i = 0; i < 63; i++) begin
              x_prev[i] <= '0; // reset previous input samples to zero
          end
          y <= '0; // reset output to zero
      end else begin
          x_prev[0] <= x_in; // current input sample
          for(int i = 1; i < 63; i++) begin
              x_prev[i] <= x_prev[i-1]; // shift previous samples
          end
          y <= acc_scaled[9:0]; // assign the scaled and saturated output
      end
  end
endmodule
