
module TR5_QSYS (
	adv7619_int_external_connection_export,
	adv7619_rst_external_connection_export,
	in_port_to_the_button,
	clk_50,
	reset_n,
	hdmi_tx_fmc_i2c_scl_external_connection_export,
	hdmi_tx_fmc_i2c_sda_external_connection_export,
	i2c_scl_external_connection_export,
	i2c_sda_external_connection_export,
	out_port_from_the_led,
	sii9136_int_external_connection_export,
	sii9136_rst_n_external_connection_export,
	sii9678_int_external_connection_export,
	sw_external_connection_export,
	rx0_edid_i2c_scl_external_connection_export,
	rx0_edid_i2c_sda_external_connection_export,
	rx1_edid_i2c_scl_external_connection_export,
	rx1_edid_i2c_sda_external_connection_export);	

	input		adv7619_int_external_connection_export;
	output		adv7619_rst_external_connection_export;
	input	[3:0]	in_port_to_the_button;
	input		clk_50;
	input		reset_n;
	output		hdmi_tx_fmc_i2c_scl_external_connection_export;
	inout		hdmi_tx_fmc_i2c_sda_external_connection_export;
	output		i2c_scl_external_connection_export;
	inout		i2c_sda_external_connection_export;
	output	[3:0]	out_port_from_the_led;
	input		sii9136_int_external_connection_export;
	output		sii9136_rst_n_external_connection_export;
	input		sii9678_int_external_connection_export;
	input	[3:0]	sw_external_connection_export;
	output		rx0_edid_i2c_scl_external_connection_export;
	inout		rx0_edid_i2c_sda_external_connection_export;
	output		rx1_edid_i2c_scl_external_connection_export;
	inout		rx1_edid_i2c_sda_external_connection_export;
endmodule
