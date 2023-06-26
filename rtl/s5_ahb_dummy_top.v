`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/17 21:37:16
// Design Name: 
// Module Name: s5_ahb_dummy_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// slave 5 range for REE rst_b and rst_addr
// slave 5 range for REE rst_b and rst_addr
module s5_ahb_dummy_top(
  haddr,
  hclk,
  hprot,
  hrdata,
  hready,
  hresp,
  hrst_b,
  hsel,
  hsize,
  htrans,
  hwdata,
  hwrite,
  intr,

  //new 0517
  REE_rst_b,
  REE_rst_addr
);
//new 0517
output reg REE_rst_b;
output reg [31:0] REE_rst_addr;
 
input   [31:0]  haddr;        
input           hclk;         
input   [3 :0]  hprot;        
input           hrst_b;       
input           hsel;         
input   [2 :0]  hsize;        
input   [1 :0]  htrans;       
input   [31:0]  hwdata;       
input           hwrite;       
output  [31:0]  hrdata;       
output          hready;  
output  [1 :0]  hresp;    
output		intr;    
wire  [31:0]  hrdata;       
wire          hready;  
wire  [1 :0]  hresp;    
wire          intr;
assign hrdata[31:0] = 32'b0;       
assign hready = 1'b1;  
assign hresp[1:0] = 2'b0;    
assign intr = 1'b0;     

reg [31:0] haddr_ff;
reg hwrite_ff;
reg hsel_ff;

always @(posedge hclk or negedge hrst_b) begin
    if (!hrst_b) begin
        haddr_ff <= 32'd0;
        hwrite_ff <= 1'b0;
        hsel_ff <= 1'b0;
    end
    else begin
        haddr_ff  <= haddr;
        hwrite_ff <= hwrite;
        hsel_ff   <= hsel;
    end
end


always @(posedge hclk or negedge hrst_b) begin
    if (!hrst_b) begin
        REE_rst_b <= 1'b0;
    end
    else if ((haddr_ff == 32'h3000_0000) && hwrite_ff && hsel_ff) begin
        REE_rst_b <= hwdata[0];
    end
    else begin
        REE_rst_b <= REE_rst_b;
    end
end

always @(posedge hclk or negedge hrst_b) begin
    if (!hrst_b) begin
        REE_rst_addr <= 32'd0;
    end
    else if (~REE_rst_b && (haddr_ff == 32'h3000_0004) && hwrite_ff && hsel_ff) begin
        REE_rst_addr <= hwdata;
    end
    else begin
        REE_rst_addr <= REE_rst_addr;
    end
end

endmodule
