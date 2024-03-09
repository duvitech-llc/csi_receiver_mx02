module histogram_top (
	input 			reset_n,
	
	// Sensor configuration
	inout  wire		scl,
	inout  wire		sda,
	
	output  wire 	reset_sensor,
	output  wire  	reset_fpga,

	output  wire osc_clk, 
	output  wire led0, 
	output  wire led1, 
	output  wire led2, 
	output  wire led3, 
	output  wire led4, 
	output  wire led5, 
	output  wire led6, 
	output  wire led7 

);

defparam OSCH_inst.NOM_FREQ = "12.09";		//  This is the default frequency
OSCH OSCH_inst( .STDBY(stdby1 ), 		// 0=Enabled, 1=Disabled also Disabled with Bandgap=OFF
                .OSC(osc_clk),
                .SEDSTDBY());		//  this signal is not required if not using SED - see TN1199 for more details.



i2c_top i2c_inst (
	.clk_i 			(osc_clk),
	.rst_n 			(reset_n),

	.scl			(scl),
	.sda			(sda),
	.reset_sensor	(reset_sensor),
	.reset_crosslink(reset_fpga),
	.q				(led7),
	.config_done	()
);

endmodule