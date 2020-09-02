`timescale 1ns / 1ps 
module radix_2(
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
 
input clk,rst;
input ce;
input [15:0] dina_r,dina_i;
input signed[15:0] dinb_r,dinb_i;
output reg signed[15:0]douta_r,douta_i;
output reg signed[15:0]doutb_r,doutb_i;

reg signed[15:0]dina_r_reg[0:8],dina_i_reg[0:8];
reg signed[15:0]dina_r_reg1,dina_i_reg1;
reg signed[16:0]douta_r_reg,douta_i_reg;
reg signed[16:0]doutb_r_reg,doutb_i_reg;

always@(posedge clk or negedge rst) 
  if(!rst)begin
    dina_r_reg[0]<=16'd0;
    dina_i_reg[0]<=16'd0;
  end
  else begin
    dina_r_reg[0]<=dina_r;
    dina_i_reg[0]<=dina_i;   
  end

generate
    genvar i;
    for(i=1;i<=8;i=i+1)
        begin:din_r
            always@(posedge clk or negedge rst) 
              if(!rst)
                dina_r_reg[i]<=16'd0;
              else begin
                dina_r_reg[i]<=dina_r_reg[i-1];
                dina_i_reg[i]<=dina_i_reg[i-1];
              end
       end
endgenerate

always@(posedge clk or negedge rst) 
  if(!rst)begin
     dina_r_reg1<=16'd0;
     dina_i_reg1<=16'd0;
  end
  else begin
     dina_r_reg1<=dina_r_reg[8]; 
     dina_i_reg1<=dina_i_reg[8]; 
  end

always@(posedge clk or negedge rst) 
  if(!rst)begin
     douta_r_reg<=17'd0;
     douta_r_reg<=17'd0;
  end
  else begin
     douta_r_reg<=dina_r_reg1+dinb_r;
     douta_i_reg<=dina_i_reg1+dinb_i;    
  end 

always@(posedge clk or negedge rst) 
  if(!rst)begin
     doutb_r_reg<=17'd0;
     doutb_i_reg<=17'd0;
  end
  else begin
     doutb_r_reg<=dina_r_reg1-dinb_r;
     doutb_i_reg<=dina_i_reg1-dinb_i;    
  end 

always@(posedge clk or negedge rst) 
  if(!rst)begin
     douta_r<=16'd0;
	 douta_i<=16'd0;
	 doutb_r<=16'd0;
	 doutb_i<=16'd0;
  end
  else begin
     douta_r<=douta_r_reg[16:1];
	 douta_i<=douta_i_reg[16:1];
	 doutb_r<=doutb_r_reg[16:1];
	 doutb_i<=doutb_i_reg[16:1];
  end
endmodule