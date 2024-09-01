`timescale 1ns/1ns
module multiplier4 #(parameter nb = 32)
(
//---------------------Port directions and deceleration
   input clk,  
   input start,
   input signed [nb-1:0] A, 
   input signed [nb-1:0] B, 
   output wire signed [2*nb-1:0] Product,
   output ready
    );
//----------------------------------------------------

//--------------------------------- register deceleration
reg signed [nb-1:0] Multiplicand ;
reg [5:0]  counter;
reg signed [2*nb-1:0] adder_output;
//-----------------------------------------------------

//----------------------------------- wire deceleration
wire product_write_enable;
//-------------------------------------------------------

//------------------------------------ combinational logic
assign product_write_enable = adder_output[0];
assign ready = (counter==nb) ? 1 : 0;
assign Product = adder_output[2*nb-1:0];
//-------------------------------------------------------

//------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 6'h00 ;
      adder_output <= { {nb{1'b0}} , B};
      Multiplicand <= A ;
   end

   else if(! ready) begin
      counter <= counter + 1;
      
      
      if(product_write_enable && counter == nb-1)
         adder_output <= (adder_output >>> 1) + (2**(nb-1))*(~Multiplicand+1);
      else if(product_write_enable && counter != nb-1)
         adder_output <= (adder_output >>> 1) + (2**(nb-1))*Multiplicand;
      else
         adder_output <= adder_output >>> 1;
   end   

endmodule