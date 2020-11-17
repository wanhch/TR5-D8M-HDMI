
#include <stdio.h>
#include "system.h"
#include "HDMI_TX.h"
#include "terasic_includes.h"
#include "HDMI_RX.h"
#include "I2C.h"

// Note, Figure 71 in https://www.analog.com/media/cn/technical-documentation/evaluation-documentation/UG-237.pdf?doc=ADV7619.pdf
// I2C Slave Address
// IO MAP: 0x98
// HDMI MAP: 0x68
// REPEATER MAP: 0x64
// EDID MAP: 0x6C
// DLL MAP: 0x4C


alt_32 regData[]={
		0x98FF80, //I2C reset
		0x98F480, //CEC
		0x98F57C, //INFOFRAME
		0x98F84C, //Set DPLL Slave Address 0x4C
		0x98F964, //Set KSV(repeater) Slave Address 0x64
		0x98FA6C, //Set EDID Map Slave Address 0x6C
		0x98FB68, //Set HDMI Map Slave Addres 0x68
		0x98FD44, //Set CP Map Slave Addres 0x44
		0x68C003, //ADI Required Write
		0x980019, //Set VID_STD
		0x980105, //Prim_Mode =101b HDMI-Comp
		0x9802F2, //Auto CSC, RGB out, Set op_656 bit  (Address 0x02[1]=1, RGB output)
		0x980354, //2x24 bit SDR 444 interleaved mode 0
		0x980528, //AV Codes Off
		0x9806A0, //No inversion on VS,HS pins
		0x980C42, //Power up part
		0x981580, //Disable Tristate of Pins
		0x981980, //LLC DLL phase
		0x983340, //LLC DLL MUX enable
		0x98DD00, //ADI Required Write
		0x98E704, //ADI Required Write
		0x4CB501, //Setting MCLK to 256Fs
		0x4CC380, //ADI Required Write
		0x4CCF03, //ADI Required Write
		0x4CDB80, //ADI Required Write
		0x68C003, //ADI Required write
		0x680008, //Set HDMI Input Port A (BG_MEAS_PORT_SEL = 001b)
		0x680203, //ALL BG Ports enabled
		0x680398, //ADI Required Write
		0x6810A5, //ADI Required Write
		0x681B00, //ADI Required Write
		0x684504, //ADI Required Write
		0x6897C0, //ADI Required Write
		0x683E69, //ADI Required Write
		0x683F46, //ADI Required Write
		0x684EFE, //ADI Required Write
		0x684F08, //ADI Required Write
		0x685000, //ADI Required Write
		0x6857A3, //ADI Required Write
		0x685807, //ADI Required Write
		0x686F08, //ADI Required Write
		0x6883FC, //Enable clock terminators for port A & B
		0x688403, //FP MODE
		0x688510, //ADI Required Write
		0x68869B, //ADI Required Write
		0x688903, //HF Gain
		0x689B03, //ADI Required Write
		0x689303, //ADI Required Write
		0x685A80, //ADI Required Write
		0x689C80, //ADI Required Write
		0x689CC0, //ADI Required Write
		0x689C00, //ADI Required Write
};


//#define WRITE_EEPROM 1

typedef enum {
	PORT_A = 0,
	PORT_B,
	PORT_NUM
}PORD_ID;

bool IsPortDetected(PORD_ID PortID){
	bool bDetected = false;
	alt_u8 value8;

	if (PortID == PORT_B){ // CABLE_DET_B_RAW, IO, Address 0x6A[7] (Read Only)
    	I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x98, 0x6a, &value8);
    	if(value8&0x80)
    		bDetected = true;
    }else if (PortID == PORT_A){ //CABLE_DET_A_RAW, IO, Address 0x6F[0] (Read Only)
    	I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x98, 0x6f, &value8);
    	if(value8&0x01)
    		bDetected = true;
	}

	return bDetected;
}

bool IsTmdsClockDetected(PORD_ID PortID){
	bool bDetected = false;
	alt_u8 value8;
	alt_u8 Mask=0;

	if (PortID == PORT_A) // TMDS_CLK_A_RAW, IO, Address 0x6A[4] (Read Only)
		Mask = 0x10;
    else if (PortID == PORT_B) //TMDS_CLK_B_RAW, IO, Address 0x6A[3] (Read Only)
		Mask = 0x08;

   	I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x98, 0x6a, &value8);
    	if(Mask&value8)
    		bDetected = true;

	return bDetected;
}

// https://www.analog.com/media/cn/technical-documentation/evaluation-documentation/UG-237.pdf?doc=ADV7619.pdf
// The ADV7619 can also perform HDMI parameter measurements on one background port. The following information can then be read from the background measurement and parameter registers.
// https://zh.scribd.com/document/261437848/Adv7619-Regs
/*
• BG_TMDSFREQ[8:0]
• BG_TMDSFREQ_FRAC[6:0]
• BG_DEEP_COLOR_MODE[1:0]
• BG_PIX_REP[3:0]
• BG_PARAM_LOCK
• BG_TOTAL_LINE_WIDTH[13:0]
UG-237 ADV7619 Reference Manual
Rev. C | Page 40 of 204
• BG_LINE_WIDTH[12:0]
• BG_TOTAL_FIELD_HEIGHT[12:0]
• BG_FIELD_HEIGHT[12:0]
• BG_HDMI_INTERLACED
*/


void Meaurement(PORD_ID PortID){
	alt_u8 value8, value8_L, value8_H;
	alt_u16 value16;
	float fValue;
	int i;

	printf("===== Port%d Measurement =====\r\n", PortID);


	// set as background port for measurement
	// BG_MEAS_PORT_SEL[2:0], Addr 68 (HDMI), Address 0x00[5:3]
	printf("Set Port%d as background port for measurement\r\n", PortID);
	I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0x00, &value8);
	value8 &= 0xC7;
	if (PortID == PORT_B)
		value8 |= 0x08;
	I2C_Write(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0x00, value8);

	usleep(200*1000); //!!!!!!!!!!!! it is necessary to add delay here


	//BG_MEAS_REQ, Addr 68 (HDMI), Address 0x5A[5] (Self-Clearing)
	I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0x5A, &value8);
	value8 |= 0x20; //Requests an update of the selected background port synchronization parameter measurements
	I2C_Write(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0x5A, value8);
	printf("BG_MEAS_REQ<--%0xh\r\n", value8);
	

	//check measure done by monitor BG_MEAS_DONE_RAW, IO, Address 0x8D[1] (Read Only)
	i=0;
	while(i++ < 100){
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x98, 0x8D, &value8); // Note: it is IO Port
		//printf("%d...BG_MEAS_DONE_RAW(0x8D[1])=%xh\r\n", i, value8);
		if (value8 & 0x02)
			break;
		else
			usleep(100);
	}
	if ((value8 & 0x02) != 0x02){
		printf("measure failed0....BG_MEAS_DONE_RAW(0x8D[1])=%xh\r\n", value8);
		return;
	}else{
		printf("BG_MEAS_DONE_RAW=%xh(wait %d)\r\n", value8, i);
	}

	//BG_PARAM_LOCK, Addr 68 (HDMI), Address 0xEA[1] (Read Only)
	//BG_PARAM_LOCK (wait go high)
	i=0;
	while(i++ < 100){
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xEA, &value8);
		//printf("%d...BG_PARAM_LOCK(0xEA[1])=%xh\r\n", i, value8);
		if (value8 & 0x02)
			break;
		else
			usleep(100);

	}
	if ((value8 & 0x02) != 0x02){
		printf("measure failed1....BG_PARAM_LOCK(0xEA[1])=%xh\r\n", value8);
		return;
	}else{
		printf("BG_PARAM_LOCK=%xh(wait %d)\r\n", value8, i);
	}


		// BG_TMDSFREQ[8:0]
		// BG_TMDSFREQ_FRAC[6:0],
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE0, &value8_L);
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE1, &value8_H);
		//printf("TMDS frequency L=%xh, H=%xh\r\n", value8_L, value8_H);
		value16 = value8_L;
		if (value8_H & 0x80)
			value16 += 256;
		fValue = (float)value16 + (float)(value8_H & 0x7F)/128.0;
		printf("TMDS frequency: %f Mhz\r\n", fValue);

		//BG_DEEP_COLOR_MODE[1:0]
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xEA, &value8);
		printf("BG_DEEP_COLOR_MODE ");
		switch((value8 >> 2) & 0x03){
			case 0: printf("8-bit color\r\n"); break;
			case 1: printf("10-bit color\r\n"); break;
			case 2: printf("12-bit color\r\n"); break;
			case 3: printf("16-bit color\r\n"); break;

		}

		//BG_TOTAL_LINE_WIDTH[13:0], Addr 68 (HDMI), Address 0xE4[5:0]; Address 0xE5[7:0] (Read Only)
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE4, &value8_H);
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE5, &value8_L);
		value16 = ((value8_H & 0x1F) << 8) | value8_L;
		printf("BG_TOTAL_LINE_WIDTH %d\r\n", value16);

		//BG_LINE_WIDTH[12:0], Addr 68 (HDMI), Address 0xE2[4:0]; Address 0xE3[7:0] (Read Only)
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE2, &value8_H);
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE3, &value8_L);
		value16 = ((value8_H & 0x1F) << 8) | value8_L;
		printf("BG_LINE_WIDTH %d\r\n", value16);

		//BG_TOTAL_FIELD_HEIGHT[12:0], Addr 68 (HDMI), Address 0xE8[4:0]; Address 0xE9[7:0] (Read Only)
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE8, &value8_H);
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE9, &value8_L);
		value16 = ((value8_H & 0x1F) << 8) | value8_L;
		printf("BG_TOTAL_FIELD_HEIGHT %d\r\n", value16);


		//BG_FIELD_HEIGHT[12:0], Addr 68 (HDMI), Address 0xE6[4:0]; Address 0xE7[7:0] (Read Only)
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE6, &value8_H);
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xE7, &value8_L);
		value16 = ((value8_H & 0x1F) << 8) | value8_L;
		printf("BG_FIELD_HEIGHT %d\r\n", value16);

		//BG_HDMI_INTERLACED, Addr 68 (HDMI), Address 0xEA[0] (Read Only)
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68, 0xEA, &value8);
		printf("BG_HDMI_INTERLACED %s\r\n", (value8 & 0x01)?"interlaced input":"progressive input");

		printf("====\r\n");




}


void WriteRxEDID(void){
	bool bPass;
	 // RX0 EDID
	  bPass=HDMIRX_VerifyEeprom( RX0_EDID_I2C_SCL_BASE,RX0_EDID_I2C_SDA_BASE    );
	  if (!bPass){
		  // need to write EDID
		  HDMIRX_WriteEeprom(  RX0_EDID_I2C_SCL_BASE,RX0_EDID_I2C_SDA_BASE    );
		  printf("Write RX0 EEPROM EDID\r\n");
		  bPass=HDMIRX_VerifyEeprom( RX0_EDID_I2C_SCL_BASE,RX0_EDID_I2C_SDA_BASE    );
		  printf("RX0 EEPROM EDID Verify %s \r\n", bPass?"OK":"NG");
	  }else{
		  printf("RX0 EEPROM EDID ready\r\n");
	  }
	  // RX1 EDID
	  bPass=HDMIRX_VerifyEeprom( RX1_EDID_I2C_SCL_BASE,RX1_EDID_I2C_SDA_BASE    );
	  if (!bPass){
		  // need to write EDID
		  HDMIRX_WriteEeprom(  RX1_EDID_I2C_SCL_BASE,RX1_EDID_I2C_SDA_BASE    );
		  printf("Write RX1 EEPROM EDID\r\n");
		  bPass=HDMIRX_VerifyEeprom( RX1_EDID_I2C_SCL_BASE,RX1_EDID_I2C_SDA_BASE    );
		  printf("RX1 EEPROM EDID Verify %s \r\n", bPass?"OK":"NG");
	  }else{
		  printf("RX1 EEPROM EDID ready\r\n");
	  }
}

int main()
{
	// bool bPass=true;
	 bool bCableDetected[2],bPreCabletDetected[2]={false,false};
	 bool bClkDetected[2],bPreClkDetected[2]={false,false};
	 bool bStateChagned;
	 alt_u8 value,PrePortSelValue=0xFF,PortSelValue;
	 int i, port;

	// printf("FMC D Port for HDMI Daughter Card \r\n");
//#ifdef WRITE_EEPROM
	 WriteRxEDID();
//#endif
		HDMI_TX_Init();

		usleep(2000);

	    IOWR(ADV7619_RST_BASE, 0, 1);
	     usleep(20*1000);
	     IOWR(ADV7619_RST_BASE, 0, 0);
	     usleep(20*1000);
	     IOWR(ADV7619_RST_BASE, 0, 1);
	     usleep(20*1000);
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x98, 0xEA, &value);
		printf("version ID0 %x\r\n",value);
		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x98, 0xEB, &value);
		printf("version ID1 %x\r\n",value);
		printf("hdmi rx config starting...\r\n");
	    for(i=0;i<sizeof(regData)/sizeof(regData[0]);i++)
	    {
	    	hdmi_rx_regwrite(regData[i] );
	    	//if(bPass==FALSE){
	    	//	printf("write reg %d error\r\n",i);
	    	//	return 1;
	    	//}
	    }
	    printf("hdmi rx config done\r\n");

		I2C_Read(I2C_SCL_BASE ,I2C_SDA_BASE , 0x98, 0xFB, &value);
		printf("HDMI_SLAVE_ADDR[6:0]=%xh\r\n", value);

	    hdmi_interrupt_init();

	  //  for(port=0;port<PORT_NUM;port++){
	    //	bPrePortDetected[port] = IsPortDetected(port);
    	//	if (bPrePortDetected[port])
	    	//	printf("RX port%d detected\r\n", port);
	   // }
	    while(1)
	    {
	    	// monitor two RX port status
	    	bStateChagned = false;
		    for(port=0;port<PORT_NUM;port++){
		    	bCableDetected[port] = IsPortDetected(port);
		    	bClkDetected[port] = IsTmdsClockDetected(port);

		    	//
	    		if (bPreCabletDetected[port] ^ bCableDetected[port]){
	    			bPreCabletDetected[port] = bCableDetected[port];
		    		printf("RX port%d cable %s\r\n", port, bCableDetected[port]?"detected":"removed");
		    		//bStateChagned = true;
	    		}

		    	//
	    		if (bPreClkDetected[port] ^ bClkDetected[port]){
	    			bPreClkDetected[port] = bClkDetected[port];
		    		printf("RX port%d TMDS clock %s\r\n", port, bClkDetected[port]?"detected":"undetected");
		    		bStateChagned = true;
	    		}
	        }

		    if (bStateChagned){
		    	// Set active RX port
		    	PortSelValue = 0xFF;
		    	if (bClkDetected[PORT_A] ){
		    		PortSelValue = 0x00; // set port A as active
		    		port = PORT_A;
		    	}else if (bClkDetected[PORT_B]){
		    		PortSelValue = 0x01; // set port B as active
		    		port = PORT_B;
		    	}

		    	if ((PrePortSelValue != PortSelValue) && (PortSelValue != 0xFF)){
		    		// port(s) active
		    		I2C_Write(I2C_SCL_BASE ,I2C_SDA_BASE , 0x68 ,0x00 ,PortSelValue); // set active port by HDMI_PORT_SELECT[2:0]
		    		printf("Set RX port%d as active port\r\n", (PortSelValue == 0x00)?0:1);

		    		//bTmdsClockDetected = IsTmdsClockDetected(port);
		    		//printf("Port%d TMDS Clock detected:%s\r\n", port, bTmdsClockDetected?"yes":"no");
		    		Meaurement(port);
		    	}
	    		PrePortSelValue = PortSelValue;
		    }

	        //
	    	usleep(10*1000);
//	    	usleep(1000*1000);

	    }
		return 0;
}
