/*
Copyright (c) 2019 Alibaba Group Holding Limited

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
module smu_top(
  hmain0_ismc_s0_haddr,
  hmain0_ismc_s0_hprot,
  hmain0_ismc_s0_hsel,
  hmain0_ismc_s0_hsize,
  hmain0_ismc_s0_htrans,
  hmain0_ismc_s0_hwdata,
  hmain0_ismc_s0_hwrite,


  hmain0_smc_s2_haddr,
  hmain0_smc_s2_hprot,
  hmain0_smc_s2_hsel,
  hmain0_smc_s2_hsize,
  hmain0_smc_s2_htrans,
  hmain0_smc_s2_hwdata,
  hmain0_smc_s2_hwrite,
  hmain0_smc_s3_haddr,
  hmain0_smc_s3_hprot,
  hmain0_smc_s3_hsel,
  hmain0_smc_s3_hsize,
  hmain0_smc_s3_htrans,
  hmain0_smc_s3_hwdata,
  hmain0_smc_s3_hwrite,
  hmain0_smc_s4_haddr,
  hmain0_smc_s4_hprot,
  hmain0_smc_s4_hsel,
  hmain0_smc_s4_hsize,
  hmain0_smc_s4_htrans,
  hmain0_smc_s4_hwdata,
  hmain0_smc_s4_hwrite,

  //TODO：将信号引出去
  hmain0_dummy3_s11_haddr,    
  hmain0_dummy3_s11_hprot,    
  hmain0_dummy3_s11_hsel,     
  hmain0_dummy3_s11_hsize,    
  hmain0_dummy3_s11_htrans,   
  hmain0_dummy3_s11_hwdata,   
  hmain0_dummy3_s11_hwrite, 
  hmain0_dummy0_s7_haddr,     
  hmain0_dummy0_s7_hprot,     
  hmain0_dummy0_s7_hsel,      
  hmain0_dummy0_s7_hsize,     
  hmain0_dummy0_s7_htrans,    
  hmain0_dummy0_s7_hwdata,    
  hmain0_dummy0_s7_hwrite,    
  hmain0_dummy1_s8_haddr,       
  hmain0_dummy1_s8_hprot,     
  hmain0_dummy1_s8_hsel,      
  hmain0_dummy1_s8_hsize,     
  hmain0_dummy1_s8_htrans,    
  hmain0_dummy1_s8_hwdata,    
  hmain0_dummy1_s8_hwrite,    
  hmain0_dummy2_s9_haddr,       
  hmain0_dummy2_s9_hprot,     
  hmain0_dummy2_s9_hsel,      
  hmain0_dummy2_s9_hsize,     
  hmain0_dummy2_s9_htrans,    
  hmain0_dummy2_s9_hwdata,    
  hmain0_dummy2_s9_hwrite,  

  ismc_hmain0_s0_hrdata,
  ismc_hmain0_s0_hready,
  ismc_hmain0_s0_hresp,
  pmu_smc_hclk,
  pmu_smc_hrst_b,
  smc_hmain0_s2_hrdata,
  smc_hmain0_s2_hready,
  smc_hmain0_s2_hresp,
  smc_hmain0_s3_hrdata,
  smc_hmain0_s3_hready,
  smc_hmain0_s3_hresp,
  smc_hmain0_s4_hrdata,
  smc_hmain0_s4_hready,
  smc_hmain0_s4_hresp,

  dummy0_hmain0_s7_hrdata,    
  dummy0_hmain0_s7_hready,    
  dummy0_hmain0_s7_hresp,     
  dummy1_hmain0_s8_hrdata,    
  dummy1_hmain0_s8_hready,    
  dummy1_hmain0_s8_hresp,     
  dummy2_hmain0_s9_hrdata,    
  dummy2_hmain0_s9_hready,    
  dummy2_hmain0_s9_hresp,     
  dummy3_hmain0_s11_hrdata,   
  dummy3_hmain0_s11_hready,   
  dummy3_hmain0_s11_hresp,

//TODO:将信号引入
  hmain0_imemdummy0_s1_haddr, 
  hmain0_imemdummy0_s1_hprot, 
  hmain0_imemdummy0_s1_hsel,  
  hmain0_imemdummy0_s1_hsize, 
  hmain0_imemdummy0_s1_htrans,
  hmain0_imemdummy0_s1_hwdata,
  hmain0_imemdummy0_s1_hwrite,
  imemdummy0_hmain0_s1_hrdata,
  imemdummy0_hmain0_s1_hready,
  imemdummy0_hmain0_s1_hresp

);
input   [31:0]  hmain0_ismc_s0_haddr; 
input   [3 :0]  hmain0_ismc_s0_hprot; 
input           hmain0_ismc_s0_hsel;  
input   [2 :0]  hmain0_ismc_s0_hsize; 
input   [1 :0]  hmain0_ismc_s0_htrans; 
input   [31:0]  hmain0_ismc_s0_hwdata; 
input           hmain0_ismc_s0_hwrite; 
input   [31:0]  hmain0_smc_s2_haddr;  
input   [3 :0]  hmain0_smc_s2_hprot;  
input           hmain0_smc_s2_hsel;   
input   [2 :0]  hmain0_smc_s2_hsize;  
input   [1 :0]  hmain0_smc_s2_htrans; 
input   [31:0]  hmain0_smc_s2_hwdata; 
input           hmain0_smc_s2_hwrite; 
input   [31:0]  hmain0_smc_s3_haddr;  
input   [3 :0]  hmain0_smc_s3_hprot;  
input           hmain0_smc_s3_hsel;   
input   [2 :0]  hmain0_smc_s3_hsize;  
input   [1 :0]  hmain0_smc_s3_htrans; 
input   [31:0]  hmain0_smc_s3_hwdata; 
input           hmain0_smc_s3_hwrite; 
input   [31:0]  hmain0_smc_s4_haddr;  
input   [3 :0]  hmain0_smc_s4_hprot;  
input           hmain0_smc_s4_hsel;   
input   [2 :0]  hmain0_smc_s4_hsize;  
input   [1 :0]  hmain0_smc_s4_htrans; 
input   [31:0]  hmain0_smc_s4_hwdata; 
input           hmain0_smc_s4_hwrite;

input    [31:0]  hmain0_imemdummy0_s1_haddr; 
input    [3 :0]  hmain0_imemdummy0_s1_hprot; 
input            hmain0_imemdummy0_s1_hsel;  
input    [2 :0]  hmain0_imemdummy0_s1_hsize; 
input    [1 :0]  hmain0_imemdummy0_s1_htrans; 
input    [31:0]  hmain0_imemdummy0_s1_hwdata; 
input            hmain0_imemdummy0_s1_hwrite;

//TODO：input output
input  [31:0]  hmain0_dummy3_s11_haddr;      
input  [3 :0]  hmain0_dummy3_s11_hprot;    
input          hmain0_dummy3_s11_hsel;     
input  [2 :0]  hmain0_dummy3_s11_hsize;    
input  [1 :0]  hmain0_dummy3_s11_htrans;   
input  [31:0]  hmain0_dummy3_s11_hwdata;   
input          hmain0_dummy3_s11_hwrite; 
input    [31:0]  hmain0_dummy0_s7_haddr;         
input    [3 :0]  hmain0_dummy0_s7_hprot;     
input            hmain0_dummy0_s7_hsel;      
input    [2 :0]  hmain0_dummy0_s7_hsize;     
input    [1 :0]  hmain0_dummy0_s7_htrans;    
input    [31:0]  hmain0_dummy0_s7_hwdata;    
input            hmain0_dummy0_s7_hwrite;    
input    [31:0]  hmain0_dummy1_s8_haddr;         
input    [3 :0]  hmain0_dummy1_s8_hprot;     
input            hmain0_dummy1_s8_hsel;      
input    [2 :0]  hmain0_dummy1_s8_hsize;     
input    [1 :0]  hmain0_dummy1_s8_htrans;    
input    [31:0]  hmain0_dummy1_s8_hwdata;    
input            hmain0_dummy1_s8_hwrite;    
input    [31:0]  hmain0_dummy2_s9_haddr;       
input    [3 :0]  hmain0_dummy2_s9_hprot;     
input            hmain0_dummy2_s9_hsel;      
input    [2 :0]  hmain0_dummy2_s9_hsize;     
input    [1 :0]  hmain0_dummy2_s9_htrans;    
input    [31:0]  hmain0_dummy2_s9_hwdata;    
input            hmain0_dummy2_s9_hwrite;

input           pmu_smc_hclk;         
input           pmu_smc_hrst_b;       

output  [31:0]  ismc_hmain0_s0_hrdata; 
output          ismc_hmain0_s0_hready; 
output  [1 :0]  ismc_hmain0_s0_hresp; 
output  [31:0]  smc_hmain0_s2_hrdata; 
output          smc_hmain0_s2_hready; 
output  [1 :0]  smc_hmain0_s2_hresp;  
output  [31:0]  smc_hmain0_s3_hrdata; 
output          smc_hmain0_s3_hready; 
output  [1 :0]  smc_hmain0_s3_hresp;  
output  [31:0]  smc_hmain0_s4_hrdata; 
output          smc_hmain0_s4_hready; 
output  [1 :0]  smc_hmain0_s4_hresp;  

output    [31:0]  dummy3_hmain0_s11_hrdata;   
output            dummy3_hmain0_s11_hready;   
output    [1 :0]  dummy3_hmain0_s11_hresp; 
output    [31:0]  dummy0_hmain0_s7_hrdata;    
output            dummy0_hmain0_s7_hready;    
output    [1 :0]  dummy0_hmain0_s7_hresp;     
output    [31:0]  dummy1_hmain0_s8_hrdata;    
output            dummy1_hmain0_s8_hready;    
output    [1 :0]  dummy1_hmain0_s8_hresp;     
output    [31:0]  dummy2_hmain0_s9_hrdata;    
output            dummy2_hmain0_s9_hready;    
output    [1 :0]  dummy2_hmain0_s9_hresp;

output    [31:0]  imemdummy0_hmain0_s1_hrdata; 
output            imemdummy0_hmain0_s1_hready; 
output    [1 :0]  imemdummy0_hmain0_s1_hresp;

wire    [31:0]  hmain0_ismc_s0_haddr; 
wire    [3 :0]  hmain0_ismc_s0_hprot; 
wire            hmain0_ismc_s0_hsel;  
wire    [2 :0]  hmain0_ismc_s0_hsize; 
wire    [1 :0]  hmain0_ismc_s0_htrans; 
wire    [31:0]  hmain0_ismc_s0_hwdata; 
wire            hmain0_ismc_s0_hwrite; 
wire    [31:0]  hmain0_smc_s2_haddr;  
wire    [3 :0]  hmain0_smc_s2_hprot;  
wire            hmain0_smc_s2_hsel;   
wire    [2 :0]  hmain0_smc_s2_hsize;  
wire    [1 :0]  hmain0_smc_s2_htrans; 
wire    [31:0]  hmain0_smc_s2_hwdata; 
wire            hmain0_smc_s2_hwrite; 
wire    [31:0]  hmain0_smc_s3_haddr;  
wire    [3 :0]  hmain0_smc_s3_hprot;  
wire            hmain0_smc_s3_hsel;   
wire    [2 :0]  hmain0_smc_s3_hsize;  
wire    [1 :0]  hmain0_smc_s3_htrans; 
wire    [31:0]  hmain0_smc_s3_hwdata; 
wire            hmain0_smc_s3_hwrite; 
wire    [31:0]  hmain0_smc_s4_haddr;  
wire    [3 :0]  hmain0_smc_s4_hprot;  
wire            hmain0_smc_s4_hsel;   
wire    [2 :0]  hmain0_smc_s4_hsize;  
wire    [1 :0]  hmain0_smc_s4_htrans; 
wire    [31:0]  hmain0_smc_s4_hwdata; 
wire            hmain0_smc_s4_hwrite; 
wire    [31:0]  ismc_hmain0_s0_hrdata; 
wire            ismc_hmain0_s0_hready; 
wire    [1 :0]  ismc_hmain0_s0_hresp; 
wire            pmu_smc_hclk;         
wire            pmu_smc_hrst_b;       
wire    [31:0]  smc_hmain0_s2_hrdata; 
wire            smc_hmain0_s2_hready; 
wire    [1 :0]  smc_hmain0_s2_hresp;  
wire    [31:0]  smc_hmain0_s3_hrdata; 
wire            smc_hmain0_s3_hready; 
wire    [1 :0]  smc_hmain0_s3_hresp;  
wire    [31:0]  smc_hmain0_s4_hrdata; 
wire            smc_hmain0_s4_hready; 
wire    [1 :0]  smc_hmain0_s4_hresp;  

//1111:
wire    [31:0]  hmain0_imemdummy0_s1_haddr; 
wire    [3 :0]  hmain0_imemdummy0_s1_hprot; 
wire            hmain0_imemdummy0_s1_hsel;  
wire    [2 :0]  hmain0_imemdummy0_s1_hsize; 
wire    [1 :0]  hmain0_imemdummy0_s1_htrans; 
wire    [31:0]  hmain0_imemdummy0_s1_hwdata; 
wire            hmain0_imemdummy0_s1_hwrite;
wire    [31:0]  imemdummy0_hmain0_s1_hrdata; 
wire            imemdummy0_hmain0_s1_hready; 
wire    [1 :0]  imemdummy0_hmain0_s1_hresp;

wire            sms0_idle;            
wire            sms1_idle;            
wire            sms2_idle;            
wire            sms3_idle;      
wire            sms4_idle;  
wire            sms7_idle;            
wire            sms8_idle;            
wire            sms9_idle;            
wire            sms11_idle;  

wire            sms_big_endian_b;     

wire    [31:0]  hmain0_dummy3_s11_haddr;    
wire    [3 :0]  hmain0_dummy3_s11_hprot;    
wire            hmain0_dummy3_s11_hsel;     
wire    [2 :0]  hmain0_dummy3_s11_hsize;    
wire    [1 :0]  hmain0_dummy3_s11_htrans;   
wire    [31:0]  hmain0_dummy3_s11_hwdata;   
wire            hmain0_dummy3_s11_hwrite; 
wire    [31:0]  hmain0_dummy0_s7_haddr;     
wire    [3 :0]  hmain0_dummy0_s7_hprot;     
wire            hmain0_dummy0_s7_hsel;      
wire    [2 :0]  hmain0_dummy0_s7_hsize;     
wire    [1 :0]  hmain0_dummy0_s7_htrans;    
wire    [31:0]  hmain0_dummy0_s7_hwdata;    
wire            hmain0_dummy0_s7_hwrite;    
wire    [31:0]  hmain0_dummy1_s8_haddr;       
wire    [3 :0]  hmain0_dummy1_s8_hprot;     
wire            hmain0_dummy1_s8_hsel;      
wire    [2 :0]  hmain0_dummy1_s8_hsize;     
wire    [1 :0]  hmain0_dummy1_s8_htrans;    
wire    [31:0]  hmain0_dummy1_s8_hwdata;    
wire            hmain0_dummy1_s8_hwrite;    
wire    [31:0]  hmain0_dummy2_s9_haddr;       
wire    [3 :0]  hmain0_dummy2_s9_hprot;     
wire            hmain0_dummy2_s9_hsel;      
wire    [2 :0]  hmain0_dummy2_s9_hsize;     
wire    [1 :0]  hmain0_dummy2_s9_htrans;    
wire    [31:0]  hmain0_dummy2_s9_hwdata;    
wire            hmain0_dummy2_s9_hwrite; 

wire    [31:0]  dummy0_hmain0_s7_hrdata;    
wire            dummy0_hmain0_s7_hready;    
wire    [1 :0]  dummy0_hmain0_s7_hresp;     
wire    [31:0]  dummy1_hmain0_s8_hrdata;    
wire            dummy1_hmain0_s8_hready;    
wire    [1 :0]  dummy1_hmain0_s8_hresp;     
wire    [31:0]  dummy2_hmain0_s9_hrdata;    
wire            dummy2_hmain0_s9_hready;    
wire    [1 :0]  dummy2_hmain0_s9_hresp;     
wire    [31:0]  dummy3_hmain0_s11_hrdata;   
wire            dummy3_hmain0_s11_hready;   
wire    [1 :0]  dummy3_hmain0_s11_hresp; 

sms_top  x_sms_top (
  .ahb_sms0_haddr        (hmain0_smc_s2_haddr  ),
  .ahb_sms0_hprot        (hmain0_smc_s2_hprot  ),
  .ahb_sms0_hsel         (hmain0_smc_s2_hsel   ),
  .ahb_sms0_hsize        (hmain0_smc_s2_hsize  ),
  .ahb_sms0_htrans       (hmain0_smc_s2_htrans ),
  .ahb_sms0_hwdata       (hmain0_smc_s2_hwdata ),
  .ahb_sms0_hwrite       (hmain0_smc_s2_hwrite ),
  .ahb_sms1_haddr        (hmain0_smc_s3_haddr  ),
  .ahb_sms1_hprot        (hmain0_smc_s3_hprot  ),
  .ahb_sms1_hsel         (hmain0_smc_s3_hsel   ),
  .ahb_sms1_hsize        (hmain0_smc_s3_hsize  ),
  .ahb_sms1_htrans       (hmain0_smc_s3_htrans ),
  .ahb_sms1_hwdata       (hmain0_smc_s3_hwdata ),
  .ahb_sms1_hwrite       (hmain0_smc_s3_hwrite ),
  .ahb_sms2_haddr        (hmain0_smc_s4_haddr  ),
  .ahb_sms2_hprot        (hmain0_smc_s4_hprot  ),
  .ahb_sms2_hsel         (hmain0_smc_s4_hsel   ),
  .ahb_sms2_hsize        (hmain0_smc_s4_hsize  ),
  .ahb_sms2_htrans       (hmain0_smc_s4_htrans ),
  .ahb_sms2_hwdata       (hmain0_smc_s4_hwdata ),
  .ahb_sms2_hwrite       (hmain0_smc_s4_hwrite ),
  .ahb_sms3_haddr        (hmain0_ismc_s0_haddr ),
  .ahb_sms3_hprot        (hmain0_ismc_s0_hprot ),
  .ahb_sms3_hsel         (hmain0_ismc_s0_hsel  ),
  .ahb_sms3_hsize        (hmain0_ismc_s0_hsize ),
  .ahb_sms3_htrans       (hmain0_ismc_s0_htrans),
  .ahb_sms3_hwdata       (hmain0_ismc_s0_hwdata),
  .ahb_sms3_hwrite       (hmain0_ismc_s0_hwrite),

  //TODO4:sms模块引出去
  .ahb_sms7_haddr        (hmain0_dummy0_s7_haddr  ),
  .ahb_sms7_hprot        (hmain0_dummy0_s7_hprot  ),
  .ahb_sms7_hsel         (hmain0_dummy0_s7_hsel   ),
  .ahb_sms7_hsize        (hmain0_dummy0_s7_hsize  ),
  .ahb_sms7_htrans       (hmain0_dummy0_s7_htrans ),
  .ahb_sms7_hwdata       (hmain0_dummy0_s7_hwdata ),
  .ahb_sms7_hwrite       (hmain0_dummy0_s7_hwrite ),
  .ahb_sms8_haddr        (/*hmain0_dummy1_s8_haddr  */),
  .ahb_sms8_hprot        (/*hmain0_dummy1_s8_hprot  */),
  .ahb_sms8_hsel         (/*hmain0_dummy1_s8_hsel   */),
  .ahb_sms8_hsize        (/*hmain0_dummy1_s8_hsize  */),
  .ahb_sms8_htrans       (/*hmain0_dummy1_s8_htrans */),
  .ahb_sms8_hwdata       (/*hmain0_dummy1_s8_hwdata */),
  .ahb_sms8_hwrite       (/*hmain0_dummy1_s8_hwrite */),
  .ahb_sms9_haddr        (/*hmain0_dummy2_s9_haddr  */),
  .ahb_sms9_hprot        (/*hmain0_dummy2_s9_hprot  */),
  .ahb_sms9_hsel         (/*hmain0_dummy2_s9_hsel   */),
  .ahb_sms9_hsize        (/*hmain0_dummy2_s9_hsize  */),
  .ahb_sms9_htrans       (/*hmain0_dummy2_s9_htrans */),
  .ahb_sms9_hwdata       (/*hmain0_dummy2_s9_hwdata */),
  .ahb_sms9_hwrite       (/*hmain0_dummy2_s9_hwrite */),
  .ahb_sms11_haddr       (hmain0_dummy3_s11_haddr ),
  .ahb_sms11_hprot       (hmain0_dummy3_s11_hprot ),
  .ahb_sms11_hsel        (hmain0_dummy3_s11_hsel  ),
  .ahb_sms11_hsize       (hmain0_dummy3_s11_hsize ),
  .ahb_sms11_htrans      (hmain0_dummy3_s11_htrans),
  .ahb_sms11_hwdata      (hmain0_dummy3_s11_hwdata),
  .ahb_sms11_hwrite      (hmain0_dummy3_s11_hwrite),

  .pmu_sms_hclk          (pmu_smc_hclk         ),
  .pmu_sms_hrst_b        (pmu_smc_hrst_b       ),

  .sms0_ahb_hrdata       (smc_hmain0_s2_hrdata ),
  .sms0_ahb_hready       (smc_hmain0_s2_hready ),
  .sms0_ahb_hresp        (smc_hmain0_s2_hresp  ),
  .sms0_idle             (sms0_idle            ),
  .sms1_ahb_hrdata       (smc_hmain0_s3_hrdata ),
  .sms1_ahb_hready       (smc_hmain0_s3_hready ),
  .sms1_ahb_hresp        (smc_hmain0_s3_hresp  ),
  .sms1_idle             (sms1_idle            ),
  .sms2_ahb_hrdata       (smc_hmain0_s4_hrdata ),
  .sms2_ahb_hready       (smc_hmain0_s4_hready ),
  .sms2_ahb_hresp        (smc_hmain0_s4_hresp  ),
  .sms2_idle             (sms2_idle            ),
  .sms3_ahb_hrdata       (ismc_hmain0_s0_hrdata),
  .sms3_ahb_hready       (ismc_hmain0_s0_hready),
  .sms3_ahb_hresp        (ismc_hmain0_s0_hresp ),
  .sms3_idle             (sms3_idle            ),

//TODO1:修改连接信号
  .sms4_ahb_hrdata       (imemdummy0_hmain0_s1_hrdata),
  .sms4_ahb_hready       (imemdummy0_hmain0_s1_hready),
  .sms4_ahb_hresp        (imemdummy0_hmain0_s1_hresp ),
  .sms4_idle             (sms4_idle            ),
  .ahb_sms4_haddr       (hmain0_imemdummy0_s1_haddr ),
  .ahb_sms4_hprot       (hmain0_imemdummy0_s1_hprot ),
  .ahb_sms4_hsel        (hmain0_imemdummy0_s1_hsel  ),
  .ahb_sms4_hsize       (hmain0_imemdummy0_s1_hsize ),
  .ahb_sms4_htrans      (hmain0_imemdummy0_s1_htrans),
  .ahb_sms4_hwdata      (hmain0_imemdummy0_s1_hwdata),
  .ahb_sms4_hwrite      (hmain0_imemdummy0_s1_hwrite),


  .sms7_ahb_hrdata       (dummy0_hmain0_s7_hrdata ),
  .sms7_ahb_hready       (dummy0_hmain0_s7_hready ),
  .sms7_ahb_hresp        (dummy0_hmain0_s7_hresp  ),
  .sms7_idle             (sms7_idle            ),
  .sms8_ahb_hrdata       (dummy1_hmain0_s8_hrdata ),
  .sms8_ahb_hready       (dummy1_hmain0_s8_hready ),
  .sms8_ahb_hresp        (dummy1_hmain0_s8_hresp  ),
  .sms8_idle             (sms8_idle            ),
  .sms9_ahb_hrdata       (dummy2_hmain0_s9_hrdata ),
  .sms9_ahb_hready       (dummy2_hmain0_s9_hready ),
  .sms9_ahb_hresp        (dummy2_hmain0_s9_hresp  ),
  .sms9_idle             (sms9_idle            ),
  .sms11_ahb_hrdata       (dummy3_hmain0_s11_hrdata),
  .sms11_ahb_hready       (dummy3_hmain0_s11_hready),
  .sms11_ahb_hresp        (dummy3_hmain0_s11_hresp ),
  .sms11_idle             (sms11_idle            ),

  .sms_big_endian_b      (sms_big_endian_b     )

);
assign sms_big_endian_b = 1'b1;
endmodule
