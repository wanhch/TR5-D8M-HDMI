
module BEZIER_CURVE   ( 
  input  [9:0 ] P1, 
  input  [9:0 ] P2,
  input  [15:0] T,
  input  CLK , 
  output reg [7:0] TT ,
  output reg [41:0] B 
  ) ;  
 
 //assign B  = 0 +  P1 * ( T )  *  (16'hffff - T) +  P2 *T * T ; 
 //assign B  = 0 +  P1 * ( T )  *  (16'hffff - T) +  P2 *T * T ; 
 
 
 always @(posedge  CLK ) begin 
  TT [7:0] <=  ( B[41:33] > 255 )?255 : B[40:33] ;
  B        <= 0 +  P1 * ( T )  *  (16'hffff - T) +  P2 *T * T ; 
 end 
 //assign TT [7:0] =  B[39:32] ;
 
endmodule  