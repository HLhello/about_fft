`timescale 1ns / 1ps 

module tw_mult2(
clk,
rst,
ce,                 //input data enable
oe,                 //output data enable                
din_r,              //input data real part
din_i,               //input data imag part             
dout_r,             //output data real part 
dout_i,             //output data imag part         
rom_ad,             // rom address
rom_out             // rom output
);

parameter ROM_AD_WIDTH=9;
parameter MAX_16SD = 18'sd32767;
parameter MIN_16SD = -18'sd32768;

input clk;
input rst;
input ce;
input [15:0] din_r,din_i;
output reg oe;
input [31:0] rom_out;
output reg signed [15:0] dout_r,dout_i;
output reg [ROM_AD_WIDTH-1:0] rom_ad;
reg clk_en;
reg [7:0]ce_r;

wire signed[31:0]multa,multb;
wire signed[79:0]mult_out;
wire signed [16:0] mult_out_r,mult_out_i;
//reg signed [16:0] mult_out_r1,mult_out_i1;
reg signed [15:0] din_r_reg,din_i_reg;

assign multa={din_i_reg,din_r_reg};
assign multb={rom_out[15:0],rom_out[31:16]};
assign mult_out_r = mult_out[31:15];
assign mult_out_i = mult_out[71:55];
		
mult16x16_cpx mult16x16_cpx_1 (
      .aclk(clk),                                // input wire aclk
      .s_axis_a_tvalid(1'b1),                    // input wire s_axis_a_tvalid
      .s_axis_a_tdata(multa),           // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid(1'b1),                    // input wire s_axis_b_tvalid
      .s_axis_b_tdata(multb),          // input wire [31 : 0] s_axis_b_tdata
      .m_axis_dout_tvalid(),  			// output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(mult_out)     // output wire [79 : 0] m_axis_dout_tdata
    );	
always@(posedge clk or negedge rst)
    if(!rst)
        clk_en<=1'b1;
    else if(ce)
		clk_en<=~clk_en; 
    else 
		clk_en<=1'b1;
    		
always @(posedge clk or negedge rst)
    if(!rst)
    	ce_r<=8'd0;
    else
    	ce_r<={ce_r[6:0],ce}; 

always @(posedge clk or negedge rst)
    if(!rst)
    	oe<=1'b0;
    else
    	oe<=ce_r[7]; 	

always @(posedge clk or negedge rst)
    if(!rst)begin
    	din_r_reg<=16'd0;
    	din_i_reg<=16'd0;
    end
    else if(clk_en==1'b0)begin
    	din_r_reg<=din_r;
    	din_i_reg<=din_i;
    end

always @(posedge clk or negedge rst)
    if(!rst)
    	dout_r<=16'd0;
    else if(mult_out_r>MAX_16SD)
    	dout_r<=MAX_16SD;
    else if(mult_out_r<MIN_16SD)
    	dout_r<=MIN_16SD;
    else 
    	dout_r<=mult_out_r[15:0];

always @(posedge clk or negedge rst)
    if(!rst)
    	dout_i<=16'd0;
    else if(mult_out_i>MAX_16SD)
    	dout_i<=MAX_16SD;
    else if(mult_out_i<MIN_16SD)
    	dout_i<=MIN_16SD;
    else 
    	dout_i<=mult_out_i[15:0];   
 
always @(posedge clk or negedge rst)
    if(!rst)
    	rom_ad<=9'd0;
	else if( ce==1'b0 )
        rom_ad<=9'd0;		
    else if(clk_en==1'b0)
    	rom_ad<=rom_ad+1'b1;	
endmodule	
