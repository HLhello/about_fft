`timescale 1ns / 1ps 

module fft_ram_ad(
clk,
rst,
ce,
ram_rd_addr,
ram_wr_addr
    );
input clk,rst;
input ce;
output reg [6:0] ram_rd_addr;
output reg [6:0] ram_wr_addr;
reg[1:0]i;
reg[1:0]j;
reg [10:0] count;
reg[6:0]ram_wr_ad_temp;
wire[6:0]ram_wr_ad_temp_rev;
 
wire w_ad_4_1,w_ad_8_3,w_ad_16_7,w_ad_32_15,w_ad_64_31,w_ad_128_63;
wire r_ad_4_1,r_ad_8_3,r_ad_16_7,r_ad_32_15,r_ad_64_31,r_ad_128_63;

//ram_wr_addr%7'd4==7'd1
assign w_ad_4_1   = (ram_wr_addr[1:0]=={1'b0,1'b1}); 
//ram_wr_addr%7'd8==7'd3                     
assign w_ad_8_3   = (ram_wr_addr[2:0]=={1'b0,1'b1,1'b1});
//ram_wr_addr%7'd16==7'd7
assign w_ad_16_7  = (ram_wr_addr[3:0]=={1'b0,1'b1,1'b1,1'b1});
//ram_wr_addr%7'd32==7'd15
assign w_ad_32_15 = (ram_wr_addr[4:0]=={1'b0,1'b1,1'b1,1'b1,1'b1});
//ram_wr_addr%7'd64==7'd31
assign w_ad_64_31 = (ram_wr_addr[5:0]=={1'b0,1'b1,1'b1,1'b1,1'b1,1'b1});
//ram_wr_addr%7'd128==7'd63
assign w_ad_128_63 = (ram_wr_addr[6:0]=={1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1});

//ram_rd_addr%7'd4==7'd1
assign r_ad_4_1   = (ram_rd_addr[1:0]=={1'b0,1'b1}); 
//ram_rd_addr%7'd8==7'd3                     
assign r_ad_8_3   = (ram_rd_addr[2:0]=={1'b0,1'b1,1'b1});
//ram_rd_addr%7'd16==7'd7
assign r_ad_16_7  = (ram_rd_addr[3:0]=={1'b0,1'b1,1'b1,1'b1});
//ram_rd_addr%7'd32==7'd15
assign r_ad_32_15 = (ram_rd_addr[4:0]=={1'b0,1'b1,1'b1,1'b1,1'b1});
//ram_rd_addr%7'd64==7'd31
assign r_ad_64_31 = (ram_rd_addr[5:0]=={1'b0,1'b1,1'b1,1'b1,1'b1,1'b1});
//ram_rd_addr%7'd128==7'd63
assign r_ad_128_63 = (ram_rd_addr[6:0]=={1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1});
 
always@(posedge clk or negedge rst)
    if(!rst)
        count<=11'd0;
    else if(ce)
        count<=count+1'b1;
    else 
		count<=11'd0;

assign ram_wr_ad_temp_rev={ram_wr_ad_temp[0],ram_wr_ad_temp[1],ram_wr_ad_temp[2],ram_wr_ad_temp[3],ram_wr_ad_temp[4],ram_wr_ad_temp[5],ram_wr_ad_temp[6]};

always@(posedge clk or negedge rst)
  if(!rst)
    ram_wr_ad_temp <= 7'd0;
  else if( count >= 11'd1 && count < 11'd129 )
    ram_wr_ad_temp <= ram_wr_ad_temp + 1'b1;    
  else 
	ram_wr_ad_temp <= 7'd0; 		
		
always@(posedge clk or negedge rst)
  if(!rst)begin
    j<=2'd1;
    ram_wr_addr<=7'd0;
  end
  else if(count<=11'd1 )begin 
    j<=2'd1;
    ram_wr_addr<=7'd0;
  end
  else if( count<=11'd143 )
	ram_wr_addr<=ram_wr_ad_temp_rev;
  else if( count<=11'd271 )
    ram_wr_addr<=ram_wr_addr+7'd1;
  else if( count<=11'd399)
     case(j)
      2'd1: begin ram_wr_addr<=ram_wr_addr+7'd2;
            if( w_ad_4_1 )j<=j+2'd2;
            else j<=j+2'd1;end
      2'd2: begin ram_wr_addr<=ram_wr_addr-7'd1;j<=j-2'd1;end      
      2'd3: begin ram_wr_addr<=ram_wr_addr+7'd1;j<=2'd1;end
	  default: begin j<=2'd1;ram_wr_addr<=7'd0;end
     endcase    
  else if( count<=11'd527 )
     case(j)
      2'd1: begin ram_wr_addr<=ram_wr_addr+7'd4;
            if( w_ad_8_3 )j<=j+2'd2;
            else j<=j+2'd1;end
      2'd2: begin ram_wr_addr<=ram_wr_addr-7'd3;j<=j-2'd1;end      
      2'd3: begin ram_wr_addr<=ram_wr_addr+7'd1;j<=2'd1;end
	  default: begin j<=2'd1;ram_wr_addr<=7'd0;end
     endcase    
  else if( count<=11'd655 )
     case(j)
      2'd1: begin ram_wr_addr<=ram_wr_addr+7'd8;
            if( w_ad_16_7 )j<=j+2'd2;
            else j<=j+2'd1;end
      2'd2: begin ram_wr_addr<=ram_wr_addr-7'd7;j<=j-2'd1;end      
      2'd3: begin ram_wr_addr<=ram_wr_addr+7'd1;j<=2'd1;end
	  default: begin j<=2'd1;ram_wr_addr<=7'd0;end
     endcase    
  else if( count<=11'd783)
     case(j)
      2'd1: begin ram_wr_addr<=ram_wr_addr+7'd16;
            if( w_ad_32_15 )j<=j+2'd2;
            else j<=j+2'd1;end
      2'd2: begin ram_wr_addr<=ram_wr_addr-7'd15;j<=j-2'd1;end      
      2'd3: begin ram_wr_addr<=ram_wr_addr+7'd1;j<=2'd1;end
	  default: begin j<=2'd1;ram_wr_addr<=7'd0;end
     endcase 
  else if( count<=11'd911)
     case(j)
      2'd1: begin ram_wr_addr<=ram_wr_addr+7'd32;
            if( w_ad_64_31 )j<=j+2'd2;
            else j<=j+2'd1;end
      2'd2: begin ram_wr_addr<=ram_wr_addr-7'd31;j<=j-2'd1;end      
      2'd3: begin ram_wr_addr<=ram_wr_addr+7'd1;j<=2'd1;end
	  default: begin j<=2'd1;ram_wr_addr<=7'd0;end
     endcase 
  else if( count<=11'd1039)
     case(j)
      2'd1: begin ram_wr_addr<=ram_wr_addr+7'd64;
            if( w_ad_128_63 )j<=j+2'd2;
            else j<=j+2'd1;end
      2'd2: begin ram_wr_addr<=ram_wr_addr-7'd63;j<=j-2'd1;end      
      2'd3: begin ram_wr_addr<=ram_wr_addr+7'd1;j<=2'd1;end
	  default: begin j<=2'd1;ram_wr_addr<=7'd0;end
     endcase 
  
always@(posedge clk or negedge rst)
  if(!rst)begin
    i<=2'd1;
    ram_rd_addr<=7'd0;
  end 
  else if(count<=11'd127)begin  
    i<=2'd1;
    ram_rd_addr<=7'd0;
  end
  else if( count<=11'd255 )
       ram_rd_addr<=ram_rd_addr+7'd1;
  else if( count<=11'd383 )
    case(i)
      2'd1: begin ram_rd_addr<=ram_rd_addr+7'd2;
            if( r_ad_4_1 )i<=i+2'd2;
            else i<=i+2'd1;end
      2'd2: begin ram_rd_addr<=ram_rd_addr-7'd1;i<=i-2'd1;end      
      2'd3: begin ram_rd_addr<=ram_rd_addr+7'd1;i<=2'd1;end
	  default: begin i<=2'd1;ram_rd_addr<=7'd0;end
     endcase      
  else if( count<=11'd511 )
    case(i)
      2'd1: begin ram_rd_addr<=ram_rd_addr+7'd4;
            if( r_ad_8_3 )i<=i+2'd2;
            else i<=i+2'd1;end
      2'd2: begin ram_rd_addr<=ram_rd_addr-7'd3;i<=i-2'd1;end      
      2'd3: begin ram_rd_addr<=ram_rd_addr+7'd1;i<=2'd1;end
	  default: begin i<=2'd1;ram_rd_addr<=7'd0;end
     endcase      
  else if( count<=11'd639)
    case(i)
      2'd1: begin ram_rd_addr<=ram_rd_addr+7'd8;
            if( r_ad_16_7 )i<=i+2'd2;
            else i<=i+2'd1;end
      2'd2: begin ram_rd_addr<=ram_rd_addr-7'd7;i<=i-2'd1;end      
      2'd3: begin ram_rd_addr<=ram_rd_addr+7'd1;i<=2'd1;end
	  default: begin i<=2'd1;ram_rd_addr<=7'd0;end
     endcase      
  else if( count<=11'd767)
    case(i)
      2'd1: begin ram_rd_addr<=ram_rd_addr+7'd16;
            if( r_ad_32_15 )i<=i+2'd2;
            else i<=i+2'd1;end
      2'd2: begin ram_rd_addr<=ram_rd_addr-7'd15;i<=i-2'd1;end      
      2'd3: begin ram_rd_addr<=ram_rd_addr+7'd1;i<=2'd1;end
	  default: begin i<=2'd1;ram_rd_addr<=7'd0;end
     endcase 
  else if( count<=11'd895)
    case(i)
      2'd1: begin ram_rd_addr<=ram_rd_addr+7'd32;
            if( r_ad_64_31 )i<=i+2'd2;
            else i<=i+2'd1;end
      2'd2: begin ram_rd_addr<=ram_rd_addr-7'd31;i<=i-2'd1;end      
      2'd3: begin ram_rd_addr<=ram_rd_addr+7'd1;i<=2'd1;end
	  default: begin i<=2'd1;ram_rd_addr<=7'd0;end
     endcase 
  else if( count<=11'd1023)
    case(i)
      2'd1: begin ram_rd_addr<=ram_rd_addr+7'd64;
            if( r_ad_128_63 )i<=i+2'd2;
            else i<=i+2'd1;end
      2'd2: begin ram_rd_addr<=ram_rd_addr-7'd63;i<=i-2'd1;end      
      2'd3: begin ram_rd_addr<=ram_rd_addr+7'd1;i<=2'd1;end
	  default: begin i<=2'd1;ram_rd_addr<=7'd0;end
     endcase 	 
  else if( count<=11'd1151 )
       ram_rd_addr<=ram_rd_addr+7'd1;
endmodule
