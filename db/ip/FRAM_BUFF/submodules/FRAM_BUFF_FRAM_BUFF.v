// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module  FRAM_BUFF_FRAM_BUFF  (

`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif


    altsyncram  altsyncram_component (
                .aclr0 (1'b0),
                .aclr1 (1'b0),
                .address2_a (1'b1),
                .address2_b (1'b1),
                .addressstall_a (1'b0),
                .addressstall_b (1'b0),
                .byteena_a (1'b1),
                .byteena_b (1'b1),
                .clock0 (1'b0),
                .clock1 (1'b1),
                .clocken0 (1'b1),
                .clocken1 (1'b1),
                .clocken2 (1'b1),
                .clocken3 (1'b1),
                .data_b ({8{1'b1}}),
                .eccencbypass (1'b0),
                .eccencparity (8'b0),
                .eccstatus (),
                .q_a (),
                .q_b (),
                .rden_a (1'b1),
                .rden_b (1'b1),
                .sclr (1'b0),
                .wren_b (1'b0));
    defparam
        altsyncram_component.address_reg_b  = "CLOCK1",
        altsyncram_component.clock_enable_input_a  = "BYPASS",
        altsyncram_component.clock_enable_input_b  = "BYPASS",
        altsyncram_component.clock_enable_output_a  = "BYPASS",
        altsyncram_component.clock_enable_output_b  = "BYPASS",
        altsyncram_component.indata_reg_b  = "CLOCK1",
        altsyncram_component.intended_device_family  = "Stratix V",
        altsyncram_component.lpm_type  = "altsyncram",
        altsyncram_component.numwords_a  = 32,
        altsyncram_component.numwords_b  = 32,
        altsyncram_component.operation_mode  = "BIDIR_DUAL_PORT",
        altsyncram_component.outdata_aclr_a  = "NONE",
        altsyncram_component.outdata_sclr_a  = "NONE",
        altsyncram_component.outdata_aclr_b  = "NONE",
        altsyncram_component.outdata_sclr_b  = "NONE",
        altsyncram_component.outdata_reg_a  = "UNREGISTERED",
        altsyncram_component.outdata_reg_b  = "UNREGISTERED",
        altsyncram_component.power_up_uninitialized  = "FALSE",
        altsyncram_component.read_during_write_mode_port_a  = "NEW_DATA_NO_NBE_READ",
        altsyncram_component.read_during_write_mode_port_b  = "NEW_DATA_NO_NBE_READ",
        altsyncram_component.widthad_a  = 5,
        altsyncram_component.widthad_b  = 5,
        altsyncram_component.width_a  = 8,
        altsyncram_component.width_b  = 8,
        altsyncram_component.width_byteena_a  = 1,
        altsyncram_component.width_byteena_b  = 1,
        altsyncram_component.wrcontrol_wraddress_reg_b  = "CLOCK1";


endmodule


