/*
 * HDMI_RX.h
 *
 *  Created on: 2016Äê1ÔÂ19ÈÕ
 *      Author: matthew
 */

#ifndef HDMI_RX_H_
#define HDMI_RX_H_

#include "terasic_includes.h"

bool HDMIRX_VerifyEeprom( alt_u32   SCL_BASE, alt_u32 SDA_BASE );
bool HDMIRX_WriteEeprom(alt_u32   SCL_BASE, alt_u32 SDA_BASE  );
void hdmi_interrupt_init();
void hdmi_rx_regwrite(alt_32 data);

#endif /* HDMI_RX_H_ */
