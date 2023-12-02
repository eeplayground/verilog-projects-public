// Author: EE Playground
// Description: VGA red square with x & y axis movement

module red_square(
  input wire clk,
  input wire rstn,
  input wire left,
  input wire right,
  input wire up,
  input wire down,
  input [9:0] h_count,
  input [8:0] v_count,
  output wire square_on,
  output wire [15:0] rgb
);

  // Color is RGB 565
  localparam  RED   = 16'h001F;
  localparam  GREEN = 16'h07E0;
  localparam  BLUE  = 16'hF800;
  localparam  WHITE = RED | GREEN | BLUE ;
  localparam  BLACK = 16'h0000;
  localparam  SQUARE_SIZE = 32; // SQUARE_SIZE pixels

  reg  [9:0] square_x1;
  wire [9:0] square_x2;
  reg  [8:0] square_y1;
  wire [8:0] square_y2;

  // Square's movement
  always @(posedge clk or negedge rstn)begin
    if(~rstn) begin
      // initial position is at the middle
      square_x1 <= 304; // (640-32)/2
	    square_y1 <= 224; // (480-32)/2 
    end
    else begin
      // X-axis movement
	    if((square_x1 >= 0) && (square_x1 <= 640-SQUARE_SIZE))begin
	      case ({left,right})
		      2'b01: begin 
            if(square_x1 < 640-SQUARE_SIZE) square_x1 <= square_x1 + 1'b1;
            else  square_x1 <= square_x1;
          end
		      2'b10: begin
            if(square_x1 > 0) square_x1 <= square_x1 - 1'b1;
            else square_x1 <= square_x1;
          end
          default: square_x1 <= square_x1;
		    endcase
	    end
	    else begin
	      square_x1 <= 0;
	    end
	  
      // Y-axis movement
	    if((square_y1 >= 0) && (square_y1 <= 480-SQUARE_SIZE))begin
	      case ({up,down})
		      2'b01:begin
            if(square_y1 < 480-SQUARE_SIZE) square_y1 <= square_y1 + 1'b1;
            else square_y1 <= square_y1;
          end
		      2'b10:begin
            if(square_y1 > 0) square_y1 <= square_y1 - 1'b1;
            else square_y1 <= square_y1;
          end
          default: square_y1 <= square_y1;
		    endcase  
      end
	    else begin
	      square_y1 <= 0;
	    end
	  end
  end 

  //square color
  assign rgb = RED;
  
  // Squares dimension
  assign square_x2 = square_x1 + SQUARE_SIZE;
  assign square_y2 = square_y1 + SQUARE_SIZE;

  // logic to determine is square is ON
  assign square_on = (h_count >= square_x1) && (h_count <= square_x2) && (v_count >= square_y1) && (v_count <= square_y2);



endmodule