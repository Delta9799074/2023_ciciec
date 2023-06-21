module sms_sms_ahbs_bk128(
  ahbs_harb_hrdata,
  ahbs_harb_hready,
  ahbs_harb_hresp,
  harb_ahbs_hsel,
  harb_xx_haddr,
  harb_xx_hready,
  harb_xx_hsize,
  harb_xx_htrans,
  harb_xx_hwdata,
  harb_xx_hwrite,
  i_sys_hclk,
  i_sys_rst_b,
  little_endian_trans,
  mem_hprot,
  ram_addr,
  ram_idle,
  ram_rdata,
  ram_sel,
  ram_size,
  ram_wdata,
  ram_write,
  resp_cfg
);
input           harb_ahbs_hsel;         
input   [31:0]  harb_xx_haddr;          
input           harb_xx_hready;         
input   [2 :0]  harb_xx_hsize;          
input   [1 :0]  harb_xx_htrans;         
input   [31:0]  harb_xx_hwdata;         
input           harb_xx_hwrite;         
input           i_sys_hclk;             
input           i_sys_rst_b;            
input           little_endian_trans;    
input   [3 :0]  mem_hprot;              
input   [31:0]  ram_rdata;              
input   [3 :0]  resp_cfg;               
output  [31:0]  ahbs_harb_hrdata;       
output          ahbs_harb_hready;       
output  [1 :0]  ahbs_harb_hresp;        
output  [16:0]  ram_addr;               
output          ram_idle;               
output          ram_sel;                
output  [2 :0]  ram_size;               
output  [31:0]  ram_wdata;              
output          ram_write;              
reg             ahbs_harb_hready_s;     
reg     [1 :0]  ahbs_harb_hresp;        
reg             harb_ahbs_hsel_r;       
reg     [16:0]  harb_xx_haddr_r;        
reg     [2 :0]  harb_xx_hsize_r;        
reg             read_after_write_access; 
reg             rty_first;              
reg             rty_flag;               
reg     [16:0]  w_ram_addr_tmp;         
reg             w_ram_sel_tmp;          
reg     [2 :0]  w_ram_size_tmp;         
reg             w_ram_write_tmp;        
wire            a_act_burst;            
wire            a_byte;                 
wire            a_halfword;             
wire            a_nonseq;               
wire            a_seq;                  
wire            a_word;                 
wire            ahbs_harb_hready;       
wire            harb_ahbs_hsel;         
wire    [31:0]  harb_xx_haddr;          
wire            harb_xx_hready;         
wire    [2 :0]  harb_xx_hsize;          
wire    [1 :0]  harb_xx_htrans;         
wire            harb_xx_hwrite;         
wire            hready_s;               
wire            i_sys_hclk;             
wire            i_sys_rst_b;            
wire    [16:0]  r_ram_addr;             
wire            r_ram_sel;              
wire    [2 :0]  r_ram_size;             
wire            r_ram_write;            
wire    [16:0]  ram_addr;               
wire            ram_idle;               
wire    [31:0]  ram_rdata;              
wire            ram_sel;                
wire    [2 :0]  ram_size;               
wire    [31:0]  ram_wdata;              
wire            ram_write;              
wire    [31:0]  reg_slave_rdata;        
wire    [3 :0]  resp_cfg;               
wire    [31:0]  slave_reg_wdata_t;      
wire    [1 :0]  sms_resp;               
wire    [16:0]  w_ram_addr;             
wire            w_ram_sel;              
wire    [2 :0]  w_ram_size;             
wire            w_ram_write;            
parameter        REG_NUM = 64;
parameter        BIT_WIDTH = 17;
parameter                 NONSEQ  = 2'b10;
parameter                 SEQ     = 2'b11;
parameter[2:0]   BYTE      = 3'b000, 
                 HALFWORD  = 3'b001, 
                 WORD      = 3'b010; 
parameter[1:0]   OKAY  = 2'b00,       
                 ERROR = 2'b01,
                 RETRY = 2'b10;
assign a_nonseq   = harb_xx_htrans[1:0] == NONSEQ;
assign a_seq      = harb_xx_htrans[1:0] == SEQ;
always @( posedge i_sys_hclk or negedge i_sys_rst_b)
begin
  if(!i_sys_rst_b)
    harb_xx_hsize_r[2:0] <= 3'b0;
  else if(harb_xx_hready)
    harb_xx_hsize_r[2:0] <= harb_xx_hsize[2:0];
  else 
    harb_xx_hsize_r[2:0] <= harb_xx_hsize_r[2:0];
end
assign a_byte     = (harb_xx_hsize_r[2:0]  == BYTE);
assign a_halfword = (harb_xx_hsize_r[2:0]  == HALFWORD);
assign a_word     = (harb_xx_hsize_r[2:0]  == WORD);
assign a_act_burst = ( a_nonseq || a_seq ) & harb_ahbs_hsel & harb_xx_hready;
always @(posedge i_sys_hclk  or negedge i_sys_rst_b)
begin
  if(!i_sys_rst_b)
     harb_ahbs_hsel_r <= 1'b0;
  else if(harb_ahbs_hsel)
     harb_ahbs_hsel_r <= 1'b1;
  else if(ahbs_harb_hready)
     harb_ahbs_hsel_r <= 1'b0;
end
always @( posedge i_sys_hclk or negedge i_sys_rst_b)
begin
  if(!i_sys_rst_b)
    harb_xx_haddr_r[BIT_WIDTH-1:0] <= {BIT_WIDTH{1'b0}};
  else if(ahbs_harb_hready)
    harb_xx_haddr_r[BIT_WIDTH-1:0] <= harb_xx_haddr[BIT_WIDTH-1:0];
  else
    harb_xx_haddr_r[BIT_WIDTH-1:0] <= harb_xx_haddr_r[BIT_WIDTH-1:0];
end
reg     [31:0]  ahbs_harb_hrdata;
reg     [31:0]  slave_reg_wdata;
always @(little_endian_trans 
      or harb_ahbs_hsel_r
      or a_byte
      or a_halfword
      or a_word
      or reg_slave_rdata[31:0]
      or harb_xx_haddr_r[1:0]
      or harb_xx_hwdata[31:0])
begin
  if(little_endian_trans & harb_ahbs_hsel_r)
    begin
      ahbs_harb_hrdata[31:0] = reg_slave_rdata[31:0];
      slave_reg_wdata[31:0] = harb_xx_hwdata[31:0];
    end
  else if (~little_endian_trans & harb_ahbs_hsel_r)
    begin
      ahbs_harb_hrdata[31:0] = 32'h0;
      slave_reg_wdata[31:0] = 32'h0;
      case(1'b1)
        a_byte :
        begin
          if(~|harb_xx_haddr_r[1:0])
            begin
              ahbs_harb_hrdata[31:0] = {reg_slave_rdata[7:0], 24'h0};
              slave_reg_wdata[31:0] = {24'h0, harb_xx_hwdata[31:24]};
            end
          else if(harb_xx_haddr_r[1:0] == 2'b01)
            begin
              ahbs_harb_hrdata[31:0] = {8'h0, reg_slave_rdata[15:8], 16'h0};
              slave_reg_wdata[31:0] = {16'h0, harb_xx_hwdata[23:16],8'h0};
            end
          else if(harb_xx_haddr_r[1:0] == 2'b10)
            begin
              ahbs_harb_hrdata[31:0] = {16'h0, reg_slave_rdata[23:16], 8'h0};
              slave_reg_wdata[31:0] = {8'h0, harb_xx_hwdata[15:8],16'h0};
            end
          else
            begin
              ahbs_harb_hrdata[31:0] = {24'h0,reg_slave_rdata[31:24]};
              slave_reg_wdata[31:0] = {harb_xx_hwdata[7:0],24'h0};
            end
        end
        a_halfword :
        begin
          if(~|harb_xx_haddr_r[1:0])
            begin
              ahbs_harb_hrdata[31:0] = {reg_slave_rdata[15:0], 16'h0};
              slave_reg_wdata[31:0] = {16'h0, harb_xx_hwdata[31:16]};
            end
          else if(harb_xx_haddr_r[1:0] == 2'b10)
            begin
              ahbs_harb_hrdata[31:0] = {16'h0, reg_slave_rdata[31:16]};
              slave_reg_wdata[31:0] = {harb_xx_hwdata[15:0],16'h0};
            end
          end
        a_word :
          begin
            ahbs_harb_hrdata[31:0] = reg_slave_rdata[31:0];
            slave_reg_wdata[31:0] = harb_xx_hwdata[31:0];
          end
      endcase
    end
  else
    begin
      ahbs_harb_hrdata[31:0] = reg_slave_rdata[31:0];
      slave_reg_wdata[31:0] = harb_xx_hwdata[31:0];
    end
end
`ifdef RAM_USAGE
assign slave_reg_wdata_t[31:0] = slave_reg_wdata[31:0];
`endif
always @ (posedge i_sys_hclk or negedge i_sys_rst_b)
begin
  if(!i_sys_rst_b)
    begin
      w_ram_sel_tmp <= 1'b0;
      w_ram_size_tmp[2:0] <= 3'b0;
      w_ram_addr_tmp[BIT_WIDTH-1:0] <= {BIT_WIDTH{1'b0}};
      w_ram_write_tmp <= 1'b0;
      read_after_write_access <= 1'b0;
    end
  else if(harb_xx_hwrite) 
    begin
      w_ram_sel_tmp <= a_act_burst;
      w_ram_size_tmp[2:0] <= harb_xx_hsize[2:0];
      w_ram_addr_tmp[BIT_WIDTH-1:0] <= harb_xx_haddr[BIT_WIDTH-1:0];
      w_ram_write_tmp <= 1'b1;
      if(read_after_write_access)
        read_after_write_access <= 1'b0;
      else
        read_after_write_access <= read_after_write_access;
    end
  else if(w_ram_sel & w_ram_write & r_ram_sel) 
    begin
      w_ram_sel_tmp <= a_act_burst;
      w_ram_size_tmp[2:0] <= harb_xx_hsize[2:0];
      w_ram_addr_tmp[BIT_WIDTH-1:0] <= harb_xx_haddr[BIT_WIDTH-1:0];
      w_ram_write_tmp <= 1'b0;
      read_after_write_access <= 1'b1;
    end
  else
    begin
      w_ram_sel_tmp <= 1'b0;
      w_ram_size_tmp[2:0] <= 3'b0;
      w_ram_addr_tmp[BIT_WIDTH-1:0] <= {BIT_WIDTH{1'b0}};
      w_ram_write_tmp <= 1'b0;
      read_after_write_access <= 1'b0;
    end
end
assign w_ram_size[2:0] = w_ram_size_tmp[2:0];
assign w_ram_addr[BIT_WIDTH-1:0] = w_ram_addr_tmp[BIT_WIDTH-1:0];
assign w_ram_sel = w_ram_sel_tmp;
assign w_ram_write = w_ram_write_tmp;
assign ram_wdata[31:0] = slave_reg_wdata_t[31:0];
assign r_ram_sel = a_act_burst & ~r_ram_write;
assign r_ram_write = harb_xx_hwrite;
assign r_ram_size[2:0] = harb_xx_hsize[2:0];
assign r_ram_addr[BIT_WIDTH-1:0] = harb_xx_haddr[BIT_WIDTH-1:0];
assign reg_slave_rdata[31:0] = ram_rdata[31:0];
assign ram_sel = w_ram_sel | r_ram_sel;
assign ram_write = w_ram_sel ? w_ram_write : r_ram_write;
assign ram_size[2:0] = w_ram_sel ? w_ram_size[2:0] : r_ram_size[2:0];
assign ram_addr[BIT_WIDTH-1:0] = w_ram_sel ? w_ram_addr[BIT_WIDTH-1:0] : r_ram_addr[BIT_WIDTH-1:0];


assign ram_idle = (~a_act_burst) & (~w_ram_sel);
always @ (posedge i_sys_hclk or negedge i_sys_rst_b)
begin
  if(~i_sys_rst_b)
    rty_first <= 1'b0;
  else
    rty_first <= rty_flag;
end
assign ahbs_harb_hready = (~read_after_write_access) & ahbs_harb_hready_s;
assign sms_resp[1:0] = OKAY;
assign hready_s = 1'b1;	
always @( hready_s
       or sms_resp[1:0]
       or resp_cfg[3:0]
       or rty_first)
begin
casex ({resp_cfg[3:2], rty_first, resp_cfg[1:0]})  // synopsys parallel_case
  5'b1x_x0_x,                     
  5'b1x_x1_0:                     
    begin
      rty_flag = 1'b0;
      ahbs_harb_hready_s = hready_s;
      ahbs_harb_hresp[1:0] = sms_resp[1:0];
    end
  5'b00_x1_0,
  5'b00_x0_x:                     
    begin
      rty_flag = 1'b0;
      ahbs_harb_hready_s = 1'b0;
      ahbs_harb_hresp[1:0] = OKAY;
    end
  5'b01_00_x,                     
  5'b01_01_0:              
    begin
      rty_flag = 1'b1;
      ahbs_harb_hready_s = 1'b0;
      ahbs_harb_hresp[1:0] = RETRY;
    end
  5'b01_10_x,
  5'b01_11_0:                    
    begin
      rty_flag = 1'b0;
      ahbs_harb_hready_s = 1'b1;
      ahbs_harb_hresp[1:0] = RETRY;
    end
  5'bxx_01_1:                    
    begin
      rty_flag = 1'b1;
      ahbs_harb_hready_s = 1'b0;
      ahbs_harb_hresp[1:0] = ERROR;
    end
  5'bxx_11_1:                    
    begin
      rty_flag = 1'b0;
      ahbs_harb_hready_s = 1'b1;
      ahbs_harb_hresp[1:0] = ERROR;
    end
  default:                      
    begin
      rty_flag = 1'b0;
      ahbs_harb_hready_s = 1'b1;
      ahbs_harb_hresp[1:0] = OKAY;
    end
endcase
end
endmodule