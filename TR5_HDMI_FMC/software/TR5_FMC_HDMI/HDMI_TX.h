#ifndef HDMI_TX_H_
#define HDMI_TX_H_
#include "terasic_includes.h"


bool HDMI_TX_ReadI2C_ByteN_0(alt_u8 RegAddr, alt_u8 *pData,int N);
bool HDMI_TX_WriteI2C_ByteN_0(alt_u8 RegAddr, alt_u8 *pData,int N);
int  HDMI_TX_ReadI2C_Byte_0(alt_u8 RegAddr);
int  HDMI_TX_WriteI2C_Byte_0(alt_u8 RegAddr,alt_u8 Data);
void HDMI_TX_Reset(void);
bool HDMI_TX_Init(void);
bool HDMI_TX_ChipVerify(void);
bool HDMI_TX_TPI_Mode_Enable(void);

#define HDMI_TX_I2C_SLAVE_ADDR_0 0x72   //Page 0 i2c slave addr
#define HDMI_TX_I2C_SLAVE_ADDR_1 0x7A   //Page 1 i2c slave addr

#endif /*HDMI_TX_H_*/
