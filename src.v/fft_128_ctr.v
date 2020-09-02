`timescale 1ns / 1ps

module fft_128_ctr(
clk,
rst,
ce,
ce_r,
ce_r1,
dina_r,
dina_i,
dinb_r,
dinb_i,
douta_r_reg,
douta_i_reg,
doutb_r_reg,
doutb_i_reg,
oe,
data,
ram_out,
din,
dout
    );
input clk;
input rst;
input ce;
input [31:0]din;
input signed[15:0]douta_r_reg,douta_i_reg;
input signed[15:0]doutb_r_reg,doutb_i_reg;
output reg oe;
output reg[31:0]dout;

reg clk_en;
output reg ce_r,ce_r1;
reg [10:0] count;
reg [31:0]din_r;
reg [31:0]din_reg;
output reg [31:0]data;
output reg signed[15:0]dina_r,dina_i; 
output reg signed[15:0]dinb_r,dinb_i; 
wire signed[15:0]douta_r_reg,douta_i_reg;
wire signed[15:0]doutb_r_reg,doutb_i_reg;
input [31:0] ram_out;
wire [31:0] douta_reg,doutb_reg;
wire oe_r;

assign oe_r=( (count>=11'd1026 && count<11'd1154) );
assign douta_reg={douta_r_reg,douta_i_reg};
assign doutb_reg={doutb_r_reg,doutb_i_reg};
		
always@(posedge clk or negedge rst)
    if(!rst)
        clk_en<=1'b1;
    else if(ce_r)
       clk_en<=~clk_en; 
    else 
       clk_en<=1'b1;

always@(posedge clk or negedge rst)
	if(!rst)
		ce_r<=1'b0;
	else if(ce==1'b1)
		ce_r<=1'b1;
	else if(count==11'd1155)
		ce_r<=1'b0; 

always@(posedge clk or negedge rst)
	if(!rst)
		ce_r1<=1'b0;
	else if(count>11'd130)
		ce_r1<=1'b1;
	else
		ce_r1<=1'b0; 

always@(posedge clk or negedge rst)
	if(!rst)
		oe<=1'b0;
	else if( oe_r )
		oe<=1'b1;
	else
		oe<=1'b0;

always@(posedge clk or negedge rst)
    if(!rst)
        count<=11'd0;
    else if(ce_r)
        count<=count+1'b1;
    else 
		count<=11'd0;

always@(posedge clk or negedge rst)
	if(!rst)begin
		dina_r<=16'd0;
		dina_i<=16'd0;
		dinb_r<=16'd0;
		dinb_i<=16'd0;
	end
	else if(clk_en==1'b1) begin
		dina_r<=ram_out[31:16];
		dina_i<=ram_out[15:0];
	end
	else if(clk_en==1'b0) begin
		dinb_r<=ram_out[31:16];
		dinb_i<=ram_out[15:0];
	end
	else begin
		dina_r<=16'd0;
		dina_i<=16'd0;
		dinb_r<=16'd0;
		dinb_i<=16'd0;
	end

always@(posedge clk or negedge rst)
	if(!rst)
		din_r<=32'd0;
	else
		din_r<=din;

always@(posedge clk or negedge rst)
	if(!rst)
		din_reg<=32'd0;
	else
		din_reg<=din_r;
	
always@(posedge clk or negedge rst)
	if(!rst)
		data<=32'd0;
	else if( count<=11'd64 )
		data<=din_reg;
	else if( count<=11'd128 )
		data<=32'd0;
	else if( clk_en==1'b0) 
		data<=douta_reg;
	else if( clk_en==1'b1) 
		data<=doutb_reg;

always@(posedge clk or negedge rst)
  if(!rst)
      dout <= 32'd0;
  else if( oe_r ) 
      dout <= ram_out;
  else 
	  dout <= 32'd0;
endmodule
