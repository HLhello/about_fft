`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:Xidian university 
// Engineer: Chang Xuyang 
// 
// Create Date: 2016/10/30 13:52:15
// Design Name: butterfly2
// Module Name: butterfly2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: complete the calculation of butterfly
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module butterfly2(
clk,
rst,
ce,
dina_r,
dina_i,
dinb_r,
dinb_i,
douta_r,
douta_i,
doutb_r,
doutb_i
    );
//parameter DINA_REG_SIZE=4'd6;

input clk,rst;
input ce;
input signed[15:0] dina_r,dina_i;
input signed[15:0] dinb_r,dinb_i;

output signed[15:0] douta_r,douta_i;
output signed[15:0] doutb_r,doutb_i;

wire [8:0]rom_ad;
wire[31:0]rom_out;

wire ce_oe;
wire signed[15:0] dout_r,dout_i;

rom_w rom_w_1 (
  .clka(clk),    // input wire clka
  .addra(rom_ad),  // input wire [8 : 0] addra
  .douta(rom_out)  // output wire [31 : 0] douta
);
tw_mult2 tw_mult2( 
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .din_r(dinb_r),
    .din_i(dinb_i),
    .oe(ce_oe),
    .dout_r(dout_r),
    .dout_i(dout_i),
    .rom_ad(rom_ad),
    .rom_out(rom_out)
);

radix_2 radix_2(
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .dina_r(dina_r),
    .dina_i(dina_i),
    .dinb_r(dout_r),
    .dinb_i(dout_i),
    .douta_r(douta_r),
    .douta_i(douta_i),
    .doutb_r(doutb_r),
    .doutb_i(doutb_i)
);
endmodule
