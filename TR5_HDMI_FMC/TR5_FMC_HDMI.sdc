#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.000000 MHz" [get_ports OSC_50_B3B]
create_clock -period "50.000 MHz" [get_ports OSC_50_B8D]

create_generated_clock -source [get_pins tx_pll_inst|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk] \
                       -name HDMI_TX_PCLK [get_ports TX_PCLK]

create_clock -period "148.500 MHz" -name HDMI_RX_PCLK [get_ports RX_PCLK]
create_clock -period "148.500 MHz" -name HDMI_RX_PCLK_ext

set_clock_groups -logically_exclusive -group HDMI_TX_PCLK -group HDMI_RX_PCLK

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -min -1.0 -clock HDMI_RX_PCLK_ext [get_ports {RX_DE RX_HS RX_VS RX_RD[*] RX_GD[*] RX_BD[*]}] -clock_fall
set_input_delay -max 0.1  -clock HDMI_RX_PCLK_ext [get_ports {RX_DE RX_HS RX_VS RX_RD[*] RX_GD[*] RX_BD[*]}] -clock_fall


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -min -0.45 -clock HDMI_TX_PCLK [get_ports {TX_DE TX_HS TX_VS TX_RD[*] TX_GD[*] TX_BD[*]}] -clock_fall
set_output_delay -max 1.36  -clock HDMI_TX_PCLK [get_ports {TX_DE TX_HS TX_VS TX_RD[*] TX_GD[*] TX_BD[*]}] -clock_fall


#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -asynchronous \
    -group [get_clocks {OSC_50_B3B}] \
    -group [get_clocks {HDMI_RX_PCLK}] \
    -group [get_clocks {tx_pll_inst|pll_inst|altera_pll_i|general[*].gpll~PLL_OUTPUT_COUNTER|divclk}]




#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



