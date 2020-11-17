
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module D8M_FMC(

	//////////// CLOCK //////////
	input 		          		OSC_50_B3B,
	input 		          		OSC_50_B4A,
	input 		          		OSC_50_B4D,
	input 		          		OSC_50_B7A,
	input 		          		OSC_50_B7D,
	input 		          		OSC_50_B8A,
	input 		          		OSC_50_B8D,

	//////////// KEY //////////
	input 		     [3:0]		BUTTON,
	input 		          		CPU_RESET_n,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// LED //////////
	output		     [3:0]		LED,

	//////////// FAN //////////
	input 		          		FAN_ALERT_n,


	//////////// Share Bus for Flash and SSRAM //////////
	output		    [26:1]		FSM_A,
	inout 		    [15:0]		FSM_D,

	//////////// SD Card //////////
	output		          		SD_CLK,
	inout 		          		SD_CMD,
	inout 		     [3:0]		SD_DATA,

	//////////// Uart to Usb //////////
	input 		          		UART_RX,
	output		          		UART_TX,

	//////////// I2C for Temperature-Sensor or Fan-Control or Power-Monitor //////////
	inout 		          		FPGA_I2C_SCL,
	inout 		          		FPGA_I2C_SDA,

	//////////// Temperature //////////
	input 		          		TEMP_INT_n,
	input 		          		TEMP_OVERT_n,

	//////////// POWER Monitor //////////
	input 		          		POWER_MONITOR_ALERT,

	//////////// SMA //////////
	input 		          		SMA_CLKIN_p,
	output		          		SMA_CLKOUT_p,

	//////////// FMCD, FMCD connect to D8M-FMC //////////
	inout 		          		CAMERA_I2C_SCL,     //T12
	inout 		          		CAMERA_I2C_SDA,     //T11
	output		          		CAMERA_PWDN_n,      //N13
	inout 		          		HDMI_I2C_SCL,       //T9
	inout 		          		HDMI_I2C_SDA,       //U9
	output		     [3:0]		HDMI_I2S,           //3-0 U14 V12 K8 R12
	output		          		HDMI_LRCLK,         //T14
	output		          		HDMI_MCLK,          //J9
	output		          		HDMI_SCLK,          //V11
	output		          		HDMI_SPDIF,         //P12
	output		          		HDMI_TX_CLK,        //M12
	output		          		HDMI_TX_DE,         //U12
	output		    [23:0]		HDMI_TX_D,          //23-0 D11 C10 B10 A10 B7 A7 E12 E11 K13 J13 H12 K12 J12 H11 K10 K9 L12 P8 N11 N8 P13 M11 T10 R10
	output		          		HDMI_TX_HS,         //U11
	input 		          		HDMI_TX_INT,        //K14
	output		          		HDMI_TX_VS,         //V9
	output		          		MIPI_CS_n,          //N14
	inout 		          		MIPI_I2C_SCL,       //J10
	inout 		          		MIPI_I2C_SDA,       //H10
	input 		          		MIPI_PIXEL_CLK,     //V10
	input 		     [9:0]		MIPI_PIXEL_D,       //9-0 H14 H15 G14 H13 C12 D12 G11 A11 B11 F11
	input 		          		MIPI_PIXEL_HS,      //F10
	input 		          		MIPI_PIXEL_VS,      //G10
	output		          		MIPI_REFCLK,        //L15
	output		          		MIPI_RESET_n,       //P14
	inout 		     [7:0]		TMD_D               //7-0 A8 B8 W16 Y16 C21 M9 L11 K11
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire        RESET_N       ; 
wire        RESET_N_DELAY ; 
wire        VGA_HS ;
wire        VGA_VS ;
wire        VGA_CLK;
wire  [7:0] VGA_R;
wire  [7:0] VGA_G;
wire  [7:0] VGA_B;
wire        READ_Request ;
wire 	[7:0] BLUE;
wire 	[7:0] GREEN;
wire 	[7:0] RED;
wire 	[7:0] R_AUTO;
wire 	[7:0] G_AUTO;
wire 	[7:0] B_AUTO;
wire        I2C_RELEASE ;  
wire        CAMERA_I2C_SCL_MIPI ; 
wire        CAMERA_I2C_SCL_AF;
wire        CAMERA_MIPI_RELAESE ;
wire        MIPI_BRIDGE_RELEASE ;  
wire        VCM_RELAESE ;
wire        AUTO_FOC ;
wire [9:0]  RD_DATA ; 
wire [19:0] WR_ADDR ;
wire [19:0] RD_ADDR ; 
wire        WR ; 
wire        AUD_CTRL_CLK;
wire        PLL_TEST_OK;
wire [7:0]  VGA_R_O;
wire [7:0]  VGA_G_O;
wire [7:0]  VGA_B_O;
wire        HZ_50M ;
wire        HZ_125M;
wire        HZ_100M;
wire        HZ_MIPI_VS; 
wire        HZ_D8M_PCK;
wire [3:0]  HDMI_I2S_1;

//=======================================================
// Structural coding
//=======================================================

//------ HDMI_SOUND ON/OFF ------
assign  HDMI_I2S = ( ~BUTTON[3] ) ? HDMI_I2S_1 : 4'h0  ; 

//------ MIPI BRIGE & CAMERA RESET  --
assign RESET_N        =  BUTTON[0];  
assign MIPI_RESET_n   =  RESET_N; 
assign CAMERA_PWDN_n  =  RESET_N; 
assign MIPI_CS_n      =  0;


//---ALL RESET ---- 
RESET_DELAY  dl(
           .RESET_N      ( RESET_N ) ,
           .CLK          ( OSC_50_B3B) , 
           .READY        ( RESET_N_DELAY)  
);  

//------ CAMERA MODULE I2C SWITCH  --
assign I2C_RELEASE    =  CAMERA_MIPI_RELAESE & MIPI_BRIDGE_RELEASE; 
assign CAMERA_I2C_SCL =  (I2C_RELEASE  )?  CAMERA_I2C_SCL_AF  : CAMERA_I2C_SCL_MIPI  ;   

//------ MIPI BRIGE & CAMERA SETTING  --   
MIPI_BRIDGE_CAMERA_Config    cfin(
          .RESET_N           ( RESET_N_DELAY ), 
          .CLK_50            ( OSC_50_B3B ), 
          .MIPI_I2C_SCL      ( MIPI_I2C_SCL ), 
          .MIPI_I2C_SDA      ( MIPI_I2C_SDA ), 
          .MIPI_I2C_RELEASE  ( MIPI_BRIDGE_RELEASE ),  
          .CAMERA_I2C_SCL    ( CAMERA_I2C_SCL_MIPI ),
          .CAMERA_I2C_SDA    ( CAMERA_I2C_SDA ),
          .CAMERA_I2C_RELAESE( CAMERA_MIPI_RELAESE ),
			 .VCM_RELAESE       ( VCM_RELAESE )
 );


//------MIPI / AUDIO REF CLOCK  --
pll_test pll_ref(
	       .refclk       ( OSC_50_B4A   ),
	       .rst          ( ~RESET_N    ),
	       .outclk_0     ( MIPI_REFCLK ),  // 20MHz
          .outclk_1     ( AUD_CTRL_CLK ),	// 1.536MHz
          .locked       ( PLL_TEST_OK  )   			 		 
);

//------VGA REF CLOCK  --
pll_video pll_vg(
	       .refclk       ( OSC_50_B4D   ),
	       .rst          ( ~RESET_N    ),
          .outclk_0     ( VGA_CLK      ),	// 75.25MHz			 
          .locked       ( )   			 		 
);





//--FRAME BUFFER using ON-CHIP SRAM---
ON_CHIP_FRAM  fra( 
         .W_CLK        ( MIPI_PIXEL_CLK ),   
         .W_DE         ( MIPI_PIXEL_HS & MIPI_PIXEL_VS  ),  
         .W_DATA       ( MIPI_PIXEL_D[9:0] ), 
         .W_CLR        ( MIPI_PIXEL_VS     ), 	      
	      .R_CLK        ( VGA_CLK), 
         .R_DATA       ( RD_DATA), 
         .R_CLR        ( VGA_VS ), 
         .R_DE         ( READ_Request)

 );
	
//-- RAW TO RGB ---
RAW2RGB_J				u4	(	
	      .RST          ( VGA_VS ),
         .CCD_PIXCLK   ( VGA_CLK ),
	      .mCCD_DATA    ( RD_DATA[9:0] ),
         .VGA_CLK      ( VGA_CLK ),
         .READ_Request ( READ_Request ),
         .VGA_VS       ( VGA_VS ),	
	      .VGA_HS       ( VGA_HS ) , 	      			
	      .oRed         ( RED  [7:0] ),
	      .oGreen       ( GREEN[7:0] ),
	      .oBlue        ( BLUE [7:0] ),
	      .oDVAL        ( )
			);
//----- VGA Controller ---
VGA_Controller u1(
	       .iCLK        ( VGA_CLK),
			 .iRed        ( RED  [7:0] ), 
	       .iGreen      ( GREEN[7:0] ), 
	       .iBlue       ( BLUE [7:0] ), 	       	   
	       .oVGA_R      ( R_AUTO[7:0]  ),
	       .oVGA_G      ( G_AUTO[7:0]  ),
	       .oVGA_B      ( B_AUTO[7:0]  ),			 				 
	       .oVGA_H_SYNC ( VGA_HS  ),
	       .oVGA_V_SYNC ( VGA_VS  ),	       
	       .oRequest    ( READ_Request),			 
	       .iRST_N      ( 1 ) 
);

//------AOTO FOCUS ENABLE  --
AUTO_FOCUS_ON  u9( 
          .CLK_50      ( OSC_50_B3B), 
          .I2C_RELEASE ( I2C_RELEASE ), 
          .AUTO_FOC    ( AUTO_FOC )
         ) ; 
				
					
//------AOTO FOCUS ADJ  --
FOCUS_ADJ adl(
          .CLK_50        ( OSC_50_B3B ) , 
          .RESET_N       ( I2C_RELEASE ), 
          .RESET_SUB_N   ( I2C_RELEASE ), 
          .AUTO_FOC      ( BUTTON[2] & AUTO_FOC ),
          .SW_Y          ( 0 ),
          .SW_H_FREQ     ( 0 ),   
          .SW_FUC_LINE   ( SW[3] ),    
          .SW_FUC_ALL_CEN( SW[3] ),
          .VIDEO_HS      ( VGA_HS ),
          .VIDEO_VS      ( VGA_VS ),
          .VIDEO_CLK     ( VGA_CLK ),
			 .VIDEO_DE      ( READ_Request) ,
          .iR            ( R_AUTO[7:0]), 
          .iG            ( G_AUTO[7:0]), 
          .iB            ( B_AUTO[7:0]), 
			 
          .oR            ( VGA_R_O), 
          .oG            ( VGA_G_O), 
          .oB            ( VGA_B_O),    
          .READY         ( ), 
          .SCL           ( CAMERA_I2C_SCL_AF ), 
          .SDA           ( CAMERA_I2C_SDA )
  
 );   

//---- Dynamic Gamma (Real time GAMMA correction using BEZIER CURVE) ---- 
GAMMA_CORRECT ui    
 ( 
          .CLK ( VGA_CLK ),  
          .DI_0( VGA_R_O[7:0] ),  
          .DI_1( VGA_G_O[7:0] ),  
          .DI_2( VGA_B_O[7:0] ),  
          .DO_0( VGA_R ),  
          .DO_1( VGA_G ),  
          .DO_2( VGA_B )
 );
   

//---HDMI TX RECONFIG ---- 
 HDMI_TX_AD7513 hdmi (
         .RESET_N         ( RESET_N_DELAY ),
         .CLK_50          ( OSC_50_B3B ),			 
         .AUD_CTRL_CLK    ( AUD_CTRL_CLK ),
         .PLL_TEST_OK     ( PLL_TEST_OK  ) ,    
         .HDMI_I2C_SCL    ( HDMI_I2C_SCL),
         .HDMI_I2C_SDA    ( HDMI_I2C_SDA),		   
         .HDMI_I2S        ( HDMI_I2S_1  ),
         .HDMI_LRCLK      ( HDMI_LRCLK),
         .HDMI_MCLK       ( HDMI_MCLK ),
         .HDMI_SCLK       ( HDMI_SCLK ),			
         .HDMI_TX_INT     ( HDMI_TX_INT)
 );
 
//---VGA TIMG TO HDMI  ----  
assign HDMI_TX_CLK = VGA_CLK                ;  
assign HDMI_TX_D   = { VGA_R ,VGA_G ,VGA_B }; 


assign HDMI_TX_DE  = READ_Request           ; 
assign HDMI_TX_HS  = VGA_HS                 ;
assign HDMI_TX_VS  = VGA_VS                 ;



//---FREQUNCY TEST--
CLOCKMEM  ck1 ( .CLK(MIPI_PIXEL_CLK  ), .CLK_FREQ  (100000000), .CK_1HZ (HZ_D8M_PCK ));
CLOCKMEM  ck2 ( .CLK(MIPI_PIXEL_VS   ), .CLK_FREQ  (60       ), .CK_1HZ (HZ_MIPI_VS ));
CLOCKMEM  ck3 ( .CLK(OSC_50_B4A      ), .CLK_FREQ  (50000000), .CK_1HZ (HZ1_50M )   );
CLOCKMEM  ck4 ( .CLK(OSC_50_B3B      ), .CLK_FREQ  (50000000 ), .CK_1HZ(HZ_50M  )   );



//--RED LED --
assign  LED = 4'hf ^  
                 {HZ_D8M_PCK , HDMI_TX_INT , CAMERA_MIPI_RELAESE  ,MIPI_BRIDGE_RELEASE   } ;  	
					  

	

endmodule
