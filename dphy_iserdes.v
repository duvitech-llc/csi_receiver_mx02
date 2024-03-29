/**
 * MIPI D-PHY input SERDES
 * This is designed to take 2 inputs per clock from an architecture specific
 * DDR primitive
 */

module dphy_iserdes(
	input dphy_clk, // Fast D-PHY DDR clock (4x sys_clk)
	input [1:0] din, // Input from arch DDR primitive, D1 should be the bit after D0
	input sys_clk, // System byte clock
	input areset, // Active high async reset
	output [7:0] dout // Output data
);

	parameter REG_INPUT = 1'b0;
	parameter NUM_OUT_SYNCFFS = 2;
	wire [1:0] iserdes_din;

	generate
	if (REG_INPUT) begin
	  reg [1:0] din_reg;
		always @(posedge dphy_clk, posedge areset)
		  if (areset)
				din_reg <= 2'b00;
			else
				din_reg <= din;
		assign iserdes_din = din_reg;
	end else begin
	  assign iserdes_din = din;
	end
	endgenerate

	reg [7:0] reg_word;

	always @(posedge dphy_clk, posedge areset)
		if (areset)
			reg_word <= 0;
		else
			reg_word <= {iserdes_din, reg_word[7:2]}; // MIPI interface uses LSB first

	reg [7:0] out_sync_regs[0:NUM_OUT_SYNCFFS-1];
	integer i;
	always @(posedge sys_clk, posedge areset)
		if (areset)
			for (i = 0; i < NUM_OUT_SYNCFFS; i = i + 1)
				out_sync_regs[i] <= 0;
		else begin
			for (i = 1; i < NUM_OUT_SYNCFFS; i = i + 1)
				out_sync_regs[i] <= out_sync_regs[i-1];
			out_sync_regs[0] <= reg_word;
		end

	assign dout = out_sync_regs[NUM_OUT_SYNCFFS-1];
endmodule
