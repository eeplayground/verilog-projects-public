// Author: EE playground
// This module generates Hozizontal and Verical
// Synchronization signal essential for VGA

module vga_sync(
  input clk,
  input rstn,
  output reg h_sync,
  output reg v_sync,
  output reg [9:0] h_count,
  output reg [8:0] v_count,
  output reg display_on
);

  // VGA Specification reference
  // http://tinyvga.com/vga-timing/640x480@60Hz

  // Horizontal
  localparam  H_VA = 640; // Visible Area
  localparam  H_FP = 16;  // Front Porch
  localparam  H_SP = 96;  // Sync Pulse
  localparam  H_BP = 48;  // BackPorch
  localparam  H_WL = H_VA + H_FP + H_SP + H_BP; // Whole Line


  // Vertical
  localparam  V_VA = 480; // Visible Area
  localparam  V_FP = 10;  // Front Porch
  localparam  V_SP = 2;   // Sync Pulse
  localparam  V_BP = 33;  // BackPorch
  localparam  V_WL = V_VA + V_FP + V_SP + V_BP;  // Whole Line


  // Horizontal Counter
  always @(posedge clk or negedge rstn) begin
    if (~rstn)
      h_count <= 0;
    else begin
      if (h_count == H_WL) // whole horizontal line is reached, reset count
        h_count <= 0;
      else
        h_count <= h_count + 1;
    end
  end


  // Vertical Counter
  always @(posedge clk or negedge rstn) begin
    if (~rstn)
      v_count <= 0;
    else begin
      if (h_count == H_WL) begin
        // Vertical counter starts every end of horizontal counter
        if(v_count == V_WL) 
          v_count <= 0;
        else
          v_count <= v_count + 1;
      end
    end
  end

  // Generate Horizontal and Vertical Synchronization signals
  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      h_sync <= 0;
      v_sync <= 0;
    end
    else begin
      h_sync <= ~(h_count > (H_VA + H_FP) && (h_count < (H_VA + H_FP + H_SP)));
      v_sync <= ~(v_count > (V_VA + V_FP) && (v_count < (V_VA + V_FP + V_SP)));
    end
  end

  // Generate an optional signal to indicate that counter is in Visible Area
  // Helpful when displaying elements
  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      display_on <= 0;
    end
    else begin
      display_on <= (h_count < H_VA) && (v_count < V_VA);
    end
  end

endmodule
