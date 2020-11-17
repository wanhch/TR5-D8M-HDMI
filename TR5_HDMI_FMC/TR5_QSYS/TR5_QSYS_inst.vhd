	component TR5_QSYS is
		port (
			adv7619_int_external_connection_export         : in    std_logic                    := 'X';             -- export
			adv7619_rst_external_connection_export         : out   std_logic;                                       -- export
			in_port_to_the_button                          : in    std_logic_vector(3 downto 0) := (others => 'X'); -- export
			clk_50                                         : in    std_logic                    := 'X';             -- clk
			reset_n                                        : in    std_logic                    := 'X';             -- reset_n
			hdmi_tx_fmc_i2c_scl_external_connection_export : out   std_logic;                                       -- export
			hdmi_tx_fmc_i2c_sda_external_connection_export : inout std_logic                    := 'X';             -- export
			i2c_scl_external_connection_export             : out   std_logic;                                       -- export
			i2c_sda_external_connection_export             : inout std_logic                    := 'X';             -- export
			out_port_from_the_led                          : out   std_logic_vector(3 downto 0);                    -- export
			sii9136_int_external_connection_export         : in    std_logic                    := 'X';             -- export
			sii9136_rst_n_external_connection_export       : out   std_logic;                                       -- export
			sii9678_int_external_connection_export         : in    std_logic                    := 'X';             -- export
			sw_external_connection_export                  : in    std_logic_vector(3 downto 0) := (others => 'X'); -- export
			rx0_edid_i2c_scl_external_connection_export    : out   std_logic;                                       -- export
			rx0_edid_i2c_sda_external_connection_export    : inout std_logic                    := 'X';             -- export
			rx1_edid_i2c_scl_external_connection_export    : out   std_logic;                                       -- export
			rx1_edid_i2c_sda_external_connection_export    : inout std_logic                    := 'X'              -- export
		);
	end component TR5_QSYS;

	u0 : component TR5_QSYS
		port map (
			adv7619_int_external_connection_export         => CONNECTED_TO_adv7619_int_external_connection_export,         --         adv7619_int_external_connection.export
			adv7619_rst_external_connection_export         => CONNECTED_TO_adv7619_rst_external_connection_export,         --         adv7619_rst_external_connection.export
			in_port_to_the_button                          => CONNECTED_TO_in_port_to_the_button,                          --              button_external_connection.export
			clk_50                                         => CONNECTED_TO_clk_50,                                         --                           clk_50_clk_in.clk
			reset_n                                        => CONNECTED_TO_reset_n,                                        --                     clk_50_clk_in_reset.reset_n
			hdmi_tx_fmc_i2c_scl_external_connection_export => CONNECTED_TO_hdmi_tx_fmc_i2c_scl_external_connection_export, -- hdmi_tx_fmc_i2c_scl_external_connection.export
			hdmi_tx_fmc_i2c_sda_external_connection_export => CONNECTED_TO_hdmi_tx_fmc_i2c_sda_external_connection_export, -- hdmi_tx_fmc_i2c_sda_external_connection.export
			i2c_scl_external_connection_export             => CONNECTED_TO_i2c_scl_external_connection_export,             --             i2c_scl_external_connection.export
			i2c_sda_external_connection_export             => CONNECTED_TO_i2c_sda_external_connection_export,             --             i2c_sda_external_connection.export
			out_port_from_the_led                          => CONNECTED_TO_out_port_from_the_led,                          --                 led_external_connection.export
			sii9136_int_external_connection_export         => CONNECTED_TO_sii9136_int_external_connection_export,         --         sii9136_int_external_connection.export
			sii9136_rst_n_external_connection_export       => CONNECTED_TO_sii9136_rst_n_external_connection_export,       --       sii9136_rst_n_external_connection.export
			sii9678_int_external_connection_export         => CONNECTED_TO_sii9678_int_external_connection_export,         --         sii9678_int_external_connection.export
			sw_external_connection_export                  => CONNECTED_TO_sw_external_connection_export,                  --                  sw_external_connection.export
			rx0_edid_i2c_scl_external_connection_export    => CONNECTED_TO_rx0_edid_i2c_scl_external_connection_export,    --    rx0_edid_i2c_scl_external_connection.export
			rx0_edid_i2c_sda_external_connection_export    => CONNECTED_TO_rx0_edid_i2c_sda_external_connection_export,    --    rx0_edid_i2c_sda_external_connection.export
			rx1_edid_i2c_scl_external_connection_export    => CONNECTED_TO_rx1_edid_i2c_scl_external_connection_export,    --    rx1_edid_i2c_scl_external_connection.export
			rx1_edid_i2c_sda_external_connection_export    => CONNECTED_TO_rx1_edid_i2c_sda_external_connection_export     --    rx1_edid_i2c_sda_external_connection.export
		);

