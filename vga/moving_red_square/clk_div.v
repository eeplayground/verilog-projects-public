// Author: EE Playground
// A simple clk divider based on counter
// Limitation: Only accepts even DIV values > 4

module clk_div(
  input wire fastClk,
  input wire rstn,
  output reg slowClk
);
  parameter DIV = 25000000;
  parameter COUNTER_WIDTH = $clog2(DIV);
  reg [COUNTER_WIDTH-1:0] count;

  always @ (posedge fastClk) begin
    if(~rstn)begin
      count <= 0;
      slowClk <= 0;
    end
    else begin
      if (count < DIV) begin
        count <= count + 1;
        slowClk <= slowClk;
      end
      else begin
        count <= 0;
        slowClk <= ~slowClk;
      end
    end
  end

endmodule
