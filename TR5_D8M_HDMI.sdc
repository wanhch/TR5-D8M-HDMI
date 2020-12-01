#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.000000 MHz" [get_ports OSC_50_B3B]
create_clock -period "50.000000 MHz" [get_ports OSC_50_B4A]
create_clock -period "50.000000 MHz" [get_ports OSC_50_B4D]
create_clock -period "50.000000 MHz" [get_ports OSC_50_B7A]
create_clock -period "50.000000 MHz" [get_ports OSC_50_B7D]
create_clock -period "50.000000 MHz" [get_ports OSC_50_B8A]
create_clock -period "50.000000 MHz" [get_ports OSC_50_B8D]
#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.000000 MHz" [get_ports CLK_50 ]
create_clock -period "100.000000 MHz" [get_ports  CLK_100]
create_clock -period "100.000000 MHz" [get_ports  CLKUSR ]

create_clock -period "100.0 MHz" -name MIPI_PIXEL_CLK [get_ports MIPI_PIXEL_CLK]
create_clock -period "100.0 MHz" -name MIPI_PIXEL_CLK_ext

# HDMI_TX_CLK
create_generated_clock -source [get_pins {pll_vg|pll_vga_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] \
                      -name HDMI_TX_CLK_ext [get_ports {HDMI_TX_CLK}]

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
# tpd  min 1ns ,max 6ns
set_input_delay -max 6.0 -clock  MIPI_PIXEL_CLK_ext  [get_ports {MIPI_PIXEL_VS MIPI_PIXEL_HS MIPI_PIXEL_D[*]}]
set_input_delay -min 1.0 -clock  MIPI_PIXEL_CLK_ext  [get_ports {MIPI_PIXEL_VS MIPI_PIXEL_HS MIPI_PIXEL_D[*]}]



#**************************************************************
# Set Output Delay
#**************************************************************

# tsu 1ns , th 0.7ns
# tsu(tVSU in datasheet)   th(tVHLD in datasheet)
set_output_delay -max  1.0 -clock  HDMI_TX_CLK_ext  [get_ports {HDMI_TX_DE HDMI_TX_VS HDMI_TX_HS HDMI_TX_D[*]}]
set_output_delay -min -0.7 -clock  HDMI_TX_CLK_ext  [get_ports {HDMI_TX_DE HDMI_TX_VS HDMI_TX_HS HDMI_TX_D[*]}]



#**************************************************************
# Set Clock Groups
#**************************************************************


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



