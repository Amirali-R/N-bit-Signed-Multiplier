`timescale 1ns/1ns
module multiplier5 #(parameter nb = 11, parameter odd = (nb%2==1) ? 1 : 0, parameter NB = nb + odd)
(
//---------------------Port directions and deceleration
   input clk,  
   input start,
   input signed [nb-1:0] A, 
   input signed [nb-1:0] B, 
   output wire signed [2*NB-1:0] Product,
   output ready
    );

//----------------------------------------------------

//--------------------------------- register deceleration
reg signed [NB-1:0] Multiplicand ;
reg signed [NB-1:0]  Multiplier;
reg [7:0]  counter;
reg signed [2*NB:0] adder_output;
//-----------------------------------------------------

//------------------------------------ combinational logic
//assign ready = (odd==1) ? ;
assign Product = adder_output[2*NB-1:0];
//-------------------------------------------------------

//------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 8'h00 ;
      adder_output <= {2*NB+1{1'b0}};
   

      if(nb % 2 == 1) begin
         
         if(A[nb-1]==1'b0)
            Multiplicand <= $signed({1'b0 , A});
         else
            Multiplicand <= $signed({1'b1 , A});

         if(B[nb-1]==1'b0)
            Multiplier <= $signed({1'b0 , B});
         else
            Multiplier <= $signed({1'b1 , B});
      end
      else begin
         Multiplicand <= $signed(A) ;
         Multiplier <= $signed(B) ;
      end
         
   end

   else if(counter != (NB)/2) begin
      counter <= counter + 1;
      
      if(counter==8'h00) begin
         Multiplier <= Multiplier >>> 1 ;
         case (Multiplier[1:0])
            2'b00: adder_output <= $signed(adder_output) >>> 2;
            2'b01: adder_output <= ($signed(adder_output) + $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            2'b10: adder_output <= ($signed(adder_output) - $signed({Multiplicand,1'b0,{NB{1'b0}}})) >>> 2;
            default: adder_output <= ($signed(adder_output) - $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
         endcase
      end
      else if(counter != (NB)/2 -1) begin
         Multiplier <= Multiplier >>> 2 ;
         case (Multiplier[2:0])
            3'b000: adder_output <= $signed(adder_output) >>> 2;
            3'b001: adder_output <= ($signed(adder_output) + $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            3'b010: adder_output <= ($signed(adder_output) + $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            3'b011: adder_output <= ($signed(adder_output) + $signed({Multiplicand,1'b0,{NB{1'b0}}})) >>> 2;
            3'b100: adder_output <= ($signed(adder_output) - $signed({Multiplicand,1'b0,{NB{1'b0}}})) >>> 2;
            3'b101: adder_output <= ($signed(adder_output) - $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            3'b110: adder_output <= ($signed(adder_output) - $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            default: adder_output <= $signed(adder_output) >>> 2;
         endcase
      end
      else begin
         Multiplier <= Multiplier >>> 2 ;
         case (Multiplier[2:0])
            3'b000: adder_output <= $signed(adder_output) >>> 2;
            3'b001: adder_output <= ($signed(adder_output) + $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            3'b010: adder_output <= ($signed(adder_output) + $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            3'b011: adder_output <= ($signed(adder_output) + $signed({Multiplicand,1'b0,{NB{1'b0}}})) >>> 2;
            3'b100: adder_output <= ($signed(adder_output) - $signed({Multiplicand,1'b0,{NB{1'b0}}})) >>> 2;
            3'b101: adder_output <= ($signed(adder_output) - $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            3'b110: adder_output <= ($signed(adder_output) - $signed({Multiplicand,{NB{1'b0}}})) >>> 2;
            default: adder_output <= $signed(adder_output) >>> 2;
         endcase
      end
   

   end   

endmodule
