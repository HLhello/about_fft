`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
module fft_insert128(
	clk,  ///
	rst,  ///
	ce,   ///
	oe,   ///
	din,  ///
	dout  ///
);
input clk;         ///
input rst;         ///
input ce;          ///
input [31:0]din;   ///
output oe;         ///
output[31:0]dout;  ///

wire ce_r,ce_r1;                         ///
wire [31:0]data;                         ///
wire signed[15:0]dina_r,dina_i;          ///
wire signed[15:0]dinb_r,dinb_i;          ///
wire signed[15:0]douta_r_reg,douta_i_reg;///
wire signed[15:0]doutb_r_reg,doutb_i_reg;///
wire [31:0] ram_out;                     ///
wire [6:0]ram_rd_addr,ram_wr_addr;       ///

fft_128_ctr fft_128_ctr(
	.clk(clk),
	.rst(rst),
	.ce(ce),
	.ce_r(ce_r),
	.ce_r1(ce_r1),
	.dina_r(dina_r),
	.dina_i(dina_i),
	.dinb_r(dinb_r),
	.dinb_i(dinb_i),
	.douta_r_reg(douta_r_reg),
	.douta_i_reg(douta_i_reg),
	.doutb_r_reg(doutb_r_reg),
	.doutb_i_reg(doutb_i_reg),
	.data(data),
	.ram_out(ram_out),
	.oe(oe),
	.din(din),
	.dout(dout)
	);


fft_ram_ad fft_ram_ad_1(
    .clk(clk),
    .rst(rst),
    .ce(ce_r),
    .ram_rd_addr(ram_rd_addr),
    .ram_wr_addr(ram_wr_addr)
    );
    
butterfly2 butterfly2_1(  
  .clk(clk),
  .rst(rst),
  .ce(ce_r1),
  .dina_r(dina_r),
  .dina_i(dina_i),
  .dinb_r(dinb_r),
  .dinb_i(dinb_i),
  .douta_r(douta_r_reg),
  .douta_i(douta_i_reg),
  .doutb_r(doutb_r_reg),
  .doutb_i(doutb_i_reg)
);

fft_ram_2ports fft_ram_2ports_1(
  .clka(clk),            // input wire clka
  .wea(1'b1),            // input wire [0 : 0] wea
  .addra(ram_wr_addr),   // input wire [6 : 0] addra
  .dina(data),           // input wire [31 : 0] dina
  .clkb(clk),            // input wire clkb
  .addrb(ram_rd_addr),   // input wire [6 : 0] addrb
  .doutb(ram_out)        // output wire [31 : 0] doutb
);
endmodule
