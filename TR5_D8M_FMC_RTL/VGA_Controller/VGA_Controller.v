
module	VGA_Controller (	
    input		   [7:0]	iRed,
    input		   [7:0]	iGreen,
    input		   [7:0]	iBlue,
    output	reg	      oRequest,
    output	reg	[7:0]	oVGA_R,
    output	reg	[7:0]	oVGA_G,
    output	reg	[7:0]	oVGA_B,
    output	reg			oVGA_H_SYNC,
    output	reg			oVGA_V_SYNC,
    output	reg			oVGA_SYNC,
    output	reg			oVGA_BLANK,
    input				   iCLK,
    input				   iRST_N

	);
//=======================================================
//  REG/WIRE declarations
//=======================================================

`include "VGA_Param.h"  // 720p@60

wire     [9:0] V_SYNC_CYC	;
wire     [9:0] V_SYNC_BACK	;
wire     [9:0] V_SYNC_FRONT;
wire     [9:0] V_SYNC_ACT	;
wire     [9:0] V_SYNC_TOTAL;
wire     [9:0] Y_START		;
wire		[7:0]	mVGA_R;
wire		[7:0]	mVGA_G;
wire		[7:0]	mVGA_B;
reg				mVGA_H_SYNC;
reg			   mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;
reg		[12:0]H_Cont;
reg		[12:0]V_Cont;
wire	   [12:0]v_mask;

//=======================================================
// Structural coding
//=======================================================


//Mode	                  MHz   HVisible	HFront HSync  HBack	H Whole		VVisable	VFront VSync  VBack	V Whole
//1280x720x60 (aka 720p)	74.25 1280	   72	    80	  216	   1648		   720	   3      5	     22	   750	


assign V_SYNC_CYC	  = 5 ;
assign V_SYNC_BACK  = 22;//13  ;
assign V_SYNC_FRONT = 3; //21;
assign V_SYNC_ACT	  = 720 ;
assign V_SYNC_TOTAL = V_SYNC_CYC	 + V_SYNC_BACK + V_SYNC_FRONT+V_SYNC_ACT;	
assign Y_START		  = V_SYNC_CYC+ V_SYNC_BACK ;



/////////////////////////////////////////////////
assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;

assign	mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START  	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iRed	:	0;
assign	mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START  	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iGreen	:	0;
assign	mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START  	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iBlue	:	0;

						
//------------------- H-V COUNTER ----
always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N)
			begin
				    oVGA_R  <= 0;
				    oVGA_G  <= 0;
                oVGA_B  <= 0;
				oVGA_BLANK  <= 0;
				oVGA_SYNC   <= 0;
				oVGA_H_SYNC <= 0;
				oVGA_V_SYNC <= 0; 
			end
		else
			begin
				oVGA_R <= mVGA_R;
				oVGA_G <= mVGA_G;
            oVGA_B <= mVGA_B;
			   oVGA_BLANK  <= mVGA_BLANK;
				oVGA_SYNC   <= mVGA_SYNC;
				oVGA_H_SYNC <= mVGA_H_SYNC;
				oVGA_V_SYNC <= mVGA_V_SYNC;				
			end               
	end

//	Pixel LUT Address Generator
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	  oRequest	<=	0;
	else
	begin
		if(  H_Cont>= X_START  &&  H_Cont< X_START+H_SYNC_ACT  &&
		                            
			  V_Cont>=Y_START && V_Cont< Y_START+V_SYNC_ACT         )
			                             
			  
		 oRequest	<=	1;
		else
		 oRequest	<=	0;
	end
end

//	H_Sync Generator, Ref. 74.25 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		mVGA_H_SYNC	<=	0;
	end
	else
	begin
	if( H_Cont < H_SYNC_TOTAL )
		 H_Cont	<=	H_Cont+1;
		else
		 H_Cont	<=	0;
		//	H_Sync Generator
		if( H_Cont < H_SYNC_CYC )
		 mVGA_H_SYNC	<=	0;
		else
		 mVGA_H_SYNC	<=	1;
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge iCLK or negedge iRST_N )
begin
	if(!iRST_N )
	begin
		V_Cont		  <=	0;
		mVGA_V_SYNC	  <=	0;
	end
	else
	begin

		if(H_Cont==0)
		 begin
			if( V_Cont  < V_SYNC_TOTAL )
			   V_Cont	<=	V_Cont+1;
			else
			   V_Cont	<=	0;
			//	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC )
			mVGA_V_SYNC	<=	0;
			else
			mVGA_V_SYNC	<=	1;
		end
	end
end

endmodule

