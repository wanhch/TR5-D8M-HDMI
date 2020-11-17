
#include "terasic_includes.h"
#include "HDMI_TX.h"
#include "I2C.h"


bool HDMI_TX_ReadI2C_ByteN_0(alt_u8 RegAddr, alt_u8 *pData,int N)
{
	bool bSuccess = true;
	int i;
    for(i=0;i<N && bSuccess;i++){
        bSuccess = I2C_Read(HDMI_TX_FMC_I2C_SCL_BASE, HDMI_TX_FMC_I2C_SDA_BASE, HDMI_TX_I2C_SLAVE_ADDR_0, RegAddr+i,(alt_u8 *)(pData+i));
        //printf("==========> Read HDMI-TX Reg[%02Xh]=%02Xh\n", RegAddr+i, *(alt_u8 *)(pData+i));
        //usleep(50); // wait
    }
    return bSuccess;
}


bool HDMI_TX_WriteI2C_ByteN_0(alt_u8 RegAddr, alt_u8 *pData,int N)
{
	bool bSuccess = true;
	int i;
    for(i=0;i<N && bSuccess;i++){
        //printf("==========> Write HDMI-TX Reg[%02Xh]=%02Xh\n", RegAddr+i, *(pData+i));
        bSuccess = I2C_Write(HDMI_TX_FMC_I2C_SCL_BASE, HDMI_TX_FMC_I2C_SDA_BASE, HDMI_TX_I2C_SLAVE_ADDR_0, RegAddr+i, *(pData+i));
    }
    return bSuccess;
}


int HDMI_TX_ReadI2C_Byte_0(alt_u8 RegAddr)
{
	//return I2C_Read_Byte(HDMI_TX_I2C_SLAVE_ADDR,RegAddr) ;
	alt_u8 Value;
    HDMI_TX_ReadI2C_ByteN_0(RegAddr, &Value, 1);
    return Value;
}
int HDMI_TX_WriteI2C_Byte_0(alt_u8 RegAddr,alt_u8 Data)
{

    return HDMI_TX_WriteI2C_ByteN_0(RegAddr, &Data, 1);
}


bool HDMI_TX_TPI_Mode_Enable(void){
    bool bSuccess = false;
    bSuccess=HDMI_TX_WriteI2C_Byte_0(0xC7, 0x00);
    usleep(30*1000);
   // bSuccess=HDMI_TX_WriteI2C_Byte_0(0xC7, 0x80);
    if (bSuccess){
        printf("HDMI TX TPI Mode Enable success\r\n");
    }else{
        printf("HDMI TX TPI Mode Enable failed\r\n");
    }
    return bSuccess;
}


void HDMI_TX_Reset(void){
	printf("TX hardware Reset\n");
    IOWR(SII9136_RST_N_BASE, 0, 1);
    usleep(20*1000);
    IOWR(SII9136_RST_N_BASE, 0, 0);
    usleep(20*1000);
    IOWR(SII9136_RST_N_BASE, 0, 1);
    usleep(200*1000);
    //I2C_Write(HDMI_FMC_I2C_SCL_BASE, HDMI_FMC_I2C_SDA_BASE, HDMI_TX_I2C_SLAVE_ADDR_0, 0xc7, 0x00);
    HDMI_TX_TPI_Mode_Enable();
    usleep(500*1000);
}

bool HDMI_TX_ChipVerify(void){
    bool bPass = false;
    alt_u8 szID[3];
    int i;
    for(i=0;i<3;i++){
    	//I2C_Read(HDMI_FMC_I2C_SCL_BASE, HDMI_FMC_I2C_SDA_BASE, HDMI_TX_I2C_SLAVE_ADDR_0, 0x1b+i,&szID[i]);
    	szID[i]=HDMI_TX_ReadI2C_Byte_0(i+0x1b);
        printf("szID[%d]= %x\n",i, szID[i]);}
       // szID[i] = HDMITX_ReadI2C_Byte(i+0x1b);

    if ((szID[0]==0xB4 && szID[1] == 0x20 && szID[2] == 0x30)){
        bPass = true;
        printf("TX Chip Device ID: %02X%02X%02Xh\n", szID[0], szID[1], szID[2]);
    }else{
        printf("NG, Read TX Chip ID:%02X%02X%02Xh (expected:B4C2030)\n", szID[0], szID[1], szID[2]);
    }

    return bPass;
}





void InitSII9136(void){

	alt_u8 STATUE;




		HDMI_TX_WriteI2C_Byte_0(0x1A, 0x11);	// disable TMDS output


		HDMI_TX_WriteI2C_Byte_0(0x09, 0x00);  //input 8-bit  RGB mode
		HDMI_TX_WriteI2C_Byte_0(0x1E, 0x00);    // Power up transmitter----Enter full-operation D0 state


		HDMI_TX_WriteI2C_Byte_0(0x09, 0x04);  //input 12-bit  RGB mode
		HDMI_TX_WriteI2C_Byte_0(0x0A, 0x04);    //output 12-bit RGB

		HDMI_TX_WriteI2C_Byte_0(0xBC, 0x01);    //Set source termination
	    HDMI_TX_WriteI2C_Byte_0(0xBD, 0x80);
	    HDMI_TX_WriteI2C_Byte_0(0xBE, 0x24);

	    HDMI_TX_WriteI2C_Byte_0(0x19, 0x01);
	    HDMI_TX_WriteI2C_Byte_0(0x3C, 0x00);     // disable Interrupt
	    HDMI_TX_WriteI2C_Byte_0(0x3D, 0xF3);     // clear Interrupt Status



	    //audio config
	    HDMI_TX_WriteI2C_Byte_0(0x26, 0x91);
	    HDMI_TX_WriteI2C_Byte_0(0x25, 0x03);
	    HDMI_TX_WriteI2C_Byte_0(0x27, 0x00);  //
		HDMI_TX_WriteI2C_Byte_0(0x1f, 0x80);  //
		HDMI_TX_WriteI2C_Byte_0(0x1f, 0x91);  //
	    HDMI_TX_WriteI2C_Byte_0(0x1f, 0xa2);  //
		HDMI_TX_WriteI2C_Byte_0(0x1f, 0xb3);  //
		HDMI_TX_WriteI2C_Byte_0(0x20, 0xF0);  //
		HDMI_TX_WriteI2C_Byte_0(0x26, 0x81);	// I2S
		//audio config end

		HDMI_TX_WriteI2C_Byte_0(0xBC, 0x02);  //
		HDMI_TX_WriteI2C_Byte_0(0xBD, 0x1D);  //
		STATUE=HDMI_TX_ReadI2C_Byte_0(0xBE);
		STATUE=STATUE^0x10;
		HDMI_TX_WriteI2C_Byte_0(0xBE, STATUE);  //

		HDMI_TX_WriteI2C_Byte_0(0x1A, 0x01);	// enable TMDS output
	//
	//
		HDMI_TX_WriteI2C_Byte_0(0x3C, 0xFB);     // Interrupt Enable

		//while(1){
		STATUE=HDMI_TX_ReadI2C_Byte_0(0x3D);
		printf("STATUE= %x\n", STATUE);
		usleep(1000*1000);
		//}


}

bool HDMI_TX_Init(void){
    bool bSuccess = true;
    HDMI_TX_Reset();
    usleep(500*1000);
    if (!HDMI_TX_ChipVerify()){
    	printf("Failed to find SIL9136-3 HDMI-TX Chip.\n");
        bSuccess = false;
        //return 0;
    }

    //HDMITX_InitInstance(&InitInstanceData) ;
    InitSII9136() ;


    return bSuccess;
}











