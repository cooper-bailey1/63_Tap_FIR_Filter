// FIR_63TAP.sp
module FIR_63TAP #(
    parameter int NUM_TAPS = 63,
    parameter int WIDTH = 10,
    parameter coeff_file = "fir_coeffs.hex"
) (
    input  logic              clk,
    input  logic              rst_n,  // active-low reset
    input  logic signed [9:0] x_in,   // example 10-bit signed inputi
    output logic signed [9:0] y       // example 10-bit signed output
);


  logic signed [9:0] x_prev[0:62];  // previous input samples
  logic signed [19:0] products[0:62];
  logic signed [20:0] stage1[0:31];
  logic signed [21:0] stage2[0:15];  //32 -> 16
  logic signed [22:0] stage3[0:7];  //16 -> 8
  logic signed [23:0] stage4[0:3];  //8 -> 4
  logic signed [25:0] acc;  // accumulator for the FIR filter (26 bits to prevent overflow)
  logic signed [25:0] acc_scaled;  // scaled accumulator for saturation
  logic signed [25:0] acc_sat;  // saturated accumulator for final output

  //  logic signed [9:0] h [0:62];
  localparam int max_sat = 2 << WIDTH;

  logic signed [WIDTH-1:0] h[0:NUM_TAPS-1];


  initial begin
    $readmemh(coeff_file, h);
  end

  //stage 1, multiplication
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < NUM_TAPS; i++) products[i] <= '0;
    end else begin
      for (int i = 0; i < NUM_TAPS; i++) begin
        products[i] <= x_prev[i] * h[i];  // multiply into 64 registers
      end
    end
  end


  //stage 2, 32 adds
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < NUM_TAPS / 2 + 1; i++) stage1[i] <= '0;
    end else begin
      for (int j = 0; j < NUM_TAPS / 2 + 1; j++) begin
        stage1[j] <= {products[j*2][19], products[j*2]} + {products[j*2+1][19], products[j*2+1]};
      end
      stage1[31] <= {{1{products[62][19]}}, products[62]};  //last product
    end
  end



  always_ff @(posedge clk or negedge rst_n) begin  //32 -> 16
    if (!rst_n) begin
      for (int i = 0; i < NUM_TAPS / 4 + 1; i++) stage2[i] <= '0;
    end else begin
      for (int j = 0; j < NUM_TAPS / 4 + 1; j++) begin
        stage2[j] <= {stage1[j*2][20], stage1[j*2]} + {stage1[j*2+1][20], stage1[j*2+1]};
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin  //16 -> 8
    if (!rst_n) begin
      for (int i = 0; i < NUM_TAPS / 8 + 1; i++) stage3[i] <= '0;
    end else begin
      for (int j = 0; j < NUM_TAPS / 8 + 1; j++) begin
        stage3[j] <= {stage2[j*2][21], stage2[j*2]} + {stage2[j*2+1][21], stage2[j*2+1]};
      end
    end
  end


  always_ff @(posedge clk or negedge rst_n) begin  // 8 -> 4
    if (!rst_n) begin
      for (int i = 0; i < NUM_TAPS / 16 + 1; i++) stage4[i] <= '0;
    end else begin
      for (int j = 0; j < NUM_TAPS / 16 + 1; j++) begin
        stage4[j] <= {stage3[j*2][22], stage3[j*2]} + {stage3[j*2+1][22], stage3[j*2+1]};
      end
    end
  end


  always_ff @(posedge clk or negedge rst_n) begin  //final 4 adds
    if (!rst_n) begin
      acc <= '0;
    end else begin
      acc <=  {{2{stage4[0][23]}}, stage4[0]} + {{2{stage4[1][23]}}, stage4[1]} +
               {{2{stage4[2][23]}}, stage4[2]} + {{2{stage4[3][23]}}, stage4[3]};
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      acc_sat <= '0;
      acc_scaled <= '0;
    end else begin
      acc_sat <= acc + 26'sd256;
      acc_scaled <= acc_sat >>> 9;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      y <= '0;
    end else begin
      if (acc_scaled > 26'sd511) y <= 10'sd511;
      else if (acc_scaled < -26'sd512) y <= -10'sd512;
      else y <= acc_scaled[9:0];
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < 63; i++) begin
        x_prev[i] <= '0;
      end
    end else begin
      x_prev[0] <= x_in;
      for (int i = 1; i < NUM_TAPS; i++) begin
        x_prev[i] <= x_prev[i-1];
      end
    end
  end

endmodule
