/*
Copyright (c) 2019 Alibaba Group Holding Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
`define FPGA
module wujian100_open_top(
  PAD_GPIO_0,
  PAD_GPIO_1,
  PAD_GPIO_10,
  PAD_GPIO_11,
  PAD_GPIO_12,
  PAD_GPIO_13,
  PAD_GPIO_14,
  PAD_GPIO_15,
  PAD_GPIO_16,
  PAD_GPIO_17,
  PAD_GPIO_18,
  PAD_GPIO_19,
  PAD_GPIO_2,
  PAD_GPIO_20,
  PAD_GPIO_21,
  PAD_GPIO_22,
  PAD_GPIO_23,
  PAD_GPIO_24,
  PAD_GPIO_25,
  PAD_GPIO_26,
  PAD_GPIO_27,
  PAD_GPIO_28,
  PAD_GPIO_29,
  PAD_GPIO_3,
  PAD_GPIO_30,
  PAD_GPIO_31,  
  PAD_GPIO_4,
  PAD_GPIO_5,
  PAD_GPIO_6,
  PAD_GPIO_7,
  PAD_GPIO_8,
  PAD_GPIO_9,
  PAD_JTAG_TCLK,
  PAD_JTAG_TMS,
  PAD_MCURST,
  PAD_PWM_CH0,
  PAD_PWM_CH1,
  PAD_PWM_CH10,
  PAD_PWM_CH11,
  PAD_PWM_CH2,
  PAD_PWM_CH3,
  PAD_PWM_CH4,
  PAD_PWM_CH5,
  PAD_PWM_CH6,
  PAD_PWM_CH7,
  PAD_PWM_CH8,
  PAD_PWM_CH9,
  PAD_PWM_FAULT,
  PAD_USI0_NSS,
  PAD_USI0_SCLK,
  PAD_USI0_SD0,
  PAD_USI0_SD1,
  PAD_USI1_NSS,
  PAD_USI1_SCLK,
  PAD_USI1_SD0,
  PAD_USI1_SD1,
  PAD_USI2_NSS,
  PAD_USI2_SCLK,
  PAD_USI2_SD0,
  PAD_USI2_SD1,
//  PIN_EHS,
  clk,
  POUT_EHS,
  vadj_en,
  set_vadj,
  qspi_dq
);
//new0517
wire REE_rst_b;
wire [31:0] REE_rst_addr;
output    [1:0] qspi_dq;
// wire          spi_mi;
// wire          qspi_cs;    
wire    [1:0] qspi_dq;
assign qspi_dq[0] = 1'b1;  //为0表示开启写保护，不开启写保护
assign qspi_dq[1] = 1'b1;  //hold引脚信号，连接到 spi_nss 上？todo
// input   [31:0]  pad_cpu_rst_addr;    
// wire    [31:0]  pad_cpu_rst_addr;  
input           clk;            //100Mhz
clk_wiz_0 u_clk_wiz_0
 (
  // Clock out ports
  .clk_out1(PIN_EHS),  //20Mhz  
  // Status and control signals
  .resetn(PAD_MCURST),  
 // Clock in ports
  .clk_in1(clk)  //100Mhz
 );
output reg vadj_en;
output reg[1:0] set_vadj;
reg[31:0] counter;
reg flag;
parameter time1 = 32'd400000;         //the bigger one 
parameter time2 = 32'd200000;
always@(posedge PIN_EHS or negedge PAD_MCURST)begin
    if(!PAD_MCURST)
        counter <= 32'd0;
    else 
        counter <= counter +1'b1;
end
always@(posedge PIN_EHS or negedge PAD_MCURST)begin
    if(!PAD_MCURST)
        flag <= 1'b1;
    else if(counter == 32'd600000)
        flag <= 1'b0;
    else
        flag <= flag;
end
always@(posedge PIN_EHS or negedge PAD_MCURST)begin
    if(!PAD_MCURST)
        set_vadj <= 2'd0;
    else if(counter == time2 && flag)
        set_vadj <= 2'd3;
    else 
        set_vadj <= set_vadj;
end
always@(posedge PIN_EHS or negedge PAD_MCURST)begin
    if(!PAD_MCURST)
        vadj_en <= 1'b0;
    else if(counter == time1 && flag)
        vadj_en <= 1'b1;
    else 
        vadj_en <= vadj_en;
end
    
//wire           PIN_EHS;               
output          POUT_EHS;              
inout           PAD_GPIO_0;            
inout           PAD_GPIO_1;            
inout           PAD_GPIO_10;           
inout           PAD_GPIO_11;           
inout           PAD_GPIO_12;           
inout           PAD_GPIO_13;           
inout           PAD_GPIO_14;           
inout           PAD_GPIO_15;           
inout           PAD_GPIO_16;           
inout           PAD_GPIO_17;           
inout           PAD_GPIO_18;           
inout           PAD_GPIO_19;           
inout           PAD_GPIO_2;            
inout           PAD_GPIO_20;           
inout           PAD_GPIO_21;           
inout           PAD_GPIO_22;           
inout           PAD_GPIO_23;           
inout           PAD_GPIO_24;           
inout           PAD_GPIO_25;           
inout           PAD_GPIO_26;           
inout           PAD_GPIO_27;           
inout           PAD_GPIO_28;           
inout           PAD_GPIO_29;           
inout           PAD_GPIO_3;            
inout           PAD_GPIO_30;           
inout           PAD_GPIO_31;           
inout           PAD_GPIO_4;            
inout           PAD_GPIO_5;            
inout           PAD_GPIO_6;            
inout           PAD_GPIO_7;            
inout           PAD_GPIO_8;            
inout           PAD_GPIO_9;            
inout           PAD_JTAG_TCLK;        //input 
inout           PAD_JTAG_TMS;          
inout           PAD_MCURST;            
inout           PAD_PWM_CH0;           
inout           PAD_PWM_CH1;           
inout           PAD_PWM_CH10;          
inout           PAD_PWM_CH11;          
inout           PAD_PWM_CH2;           
inout           PAD_PWM_CH3;           
inout           PAD_PWM_CH4;           
inout           PAD_PWM_CH5;           
inout           PAD_PWM_CH6;           
inout           PAD_PWM_CH7;           
inout           PAD_PWM_CH8;           
inout           PAD_PWM_CH9;           
inout           PAD_PWM_FAULT;         
inout           PAD_USI0_NSS;          
inout           PAD_USI0_SCLK;         
inout           PAD_USI0_SD0;          
inout           PAD_USI0_SD1;          
inout           PAD_USI1_NSS;          
inout           PAD_USI1_SCLK;         
inout           PAD_USI1_SD0;      //当作usi1的txd使用    
inout           PAD_USI1_SD1;          
inout           PAD_USI2_NSS;          
inout           PAD_USI2_SCLK;         
inout           PAD_USI2_SD0;          
inout           PAD_USI2_SD1;          
wire  [1:0]   core_pad_jdb_pm;
wire  [1:0]   core_pad_jdb_pm2;
wire            PAD_GPIO_0;            
wire            PAD_GPIO_1;            
wire            PAD_GPIO_10;           
wire            PAD_GPIO_11;           
wire            PAD_GPIO_12;           
wire            PAD_GPIO_13;           
wire            PAD_GPIO_14;           
wire            PAD_GPIO_15;           
wire            PAD_GPIO_16;           
wire            PAD_GPIO_17;           
wire            PAD_GPIO_18;           
wire            PAD_GPIO_19;           
wire            PAD_GPIO_2;            
wire            PAD_GPIO_20;           
wire            PAD_GPIO_21;           
wire            PAD_GPIO_22;           
wire            PAD_GPIO_23;           
wire            PAD_GPIO_24;           
wire            PAD_GPIO_25;           
wire            PAD_GPIO_26;           
wire            PAD_GPIO_27;           
wire            PAD_GPIO_28;           
wire            PAD_GPIO_29;           
wire            PAD_GPIO_3;            
wire            PAD_GPIO_30;           
wire            PAD_GPIO_31;           
wire            PAD_GPIO_4;            
wire            PAD_GPIO_5;            
wire            PAD_GPIO_6;            
wire            PAD_GPIO_7;            
wire            PAD_GPIO_8;            
wire            PAD_GPIO_9;            
wire            PAD_JTAG_TCLK;         
wire            PAD_JTAG_TMS;          
wire            PAD_MCURST;            
wire            PAD_PWM_CH0;           
wire            PAD_PWM_CH1;           
wire            PAD_PWM_CH10;          
wire            PAD_PWM_CH11;          
wire            PAD_PWM_CH2;           
wire            PAD_PWM_CH3;           
wire            PAD_PWM_CH4;           
wire            PAD_PWM_CH5;           
wire            PAD_PWM_CH6;           
wire            PAD_PWM_CH7;           
wire            PAD_PWM_CH8;           
wire            PAD_PWM_CH9;           
wire            PAD_PWM_FAULT;         
wire            PAD_USI0_NSS;          
wire            PAD_USI0_SCLK;         
wire            PAD_USI0_SD0;          
wire            PAD_USI0_SD1;          
wire            PAD_USI1_NSS;          
wire            PAD_USI1_SCLK;         
wire            PAD_USI1_SD0;          
wire            PAD_USI1_SD1;          
wire            PAD_USI2_NSS;          
wire            PAD_USI2_SCLK;         
wire            PAD_USI2_SD0;          
wire            PAD_USI2_SD1;          
wire            PIN_EHS;               
wire            POUT_EHS;              
wire            apb0_dummy1_intr;      
wire            apb0_dummy2_intr;      
wire            apb0_dummy3_intr;      
wire            apb0_dummy4_intr;      
wire            apb0_dummy5_intr;      
wire            apb0_dummy7_intr;      
wire            apb0_dummy8_intr;      
wire            apb0_dummy9_intr;      
wire            apb1_dummy1_intr;      
wire            apb1_dummy2_intr;      
wire            apb1_dummy3_intr;      
wire            apb1_dummy4_intr;      
wire            apb1_dummy5_intr;      
wire            apb1_dummy6_intr;      
wire            apb1_dummy7_intr;      
wire            apb1_dummy8_intr;      
wire            apb1_gpio_psel_s5;     
wire            apb1_pmu_psel_s15;     
wire            apb1_rtc_psel_s6;      
wire    [31:0]  apb1_xx_paddr;         
wire            apb1_xx_penable;       
wire    [2 :0]  apb1_xx_pprot;         
wire    [31:0]  apb1_xx_pwdata;        
wire            apb1_xx_pwrite;        
wire            bist0_mode;            
wire    [31:0]  cpu_hmain0_m0_haddr;   
wire    [2 :0]  cpu_hmain0_m0_hburst;  
wire    [3 :0]  cpu_hmain0_m0_hprot;   
wire    [2 :0]  cpu_hmain0_m0_hsize;   
wire    [1 :0]  cpu_hmain0_m0_htrans;  
wire    [31:0]  cpu_hmain0_m0_hwdata;  
wire            cpu_hmain0_m0_hwrite;  
wire    [31:0]  cpu_hmain0_m1_haddr;   
wire    [2 :0]  cpu_hmain0_m1_hburst;  
wire    [3 :0]  cpu_hmain0_m1_hprot;   
wire    [2 :0]  cpu_hmain0_m1_hsize;   
wire    [1 :0]  cpu_hmain0_m1_htrans;  
wire    [31:0]  cpu_hmain0_m1_hwdata;  
wire            cpu_hmain0_m1_hwrite;  
wire    [31:0]  cpu_hmain0_m2_haddr;   
wire    [2 :0]  cpu_hmain0_m2_hburst;  
wire    [3 :0]  cpu_hmain0_m2_hprot;   
wire    [2 :0]  cpu_hmain0_m2_hsize;   
wire    [1 :0]  cpu_hmain0_m2_htrans;  
wire    [31:0]  cpu_hmain0_m2_hwdata;  
wire            cpu_hmain0_m2_hwrite;  
wire    [31:0]  mdummy0_hmain0_m4_haddr;    
wire    [2 :0]  mdummy0_hmain0_m4_hburst;   
wire    [3 :0]  mdummy0_hmain0_m4_hprot;    
wire    [2 :0]  mdummy0_hmain0_m4_hsize;    
wire    [1 :0]  mdummy0_hmain0_m4_htrans;   
wire    [31:0]  mdummy0_hmain0_m4_hwdata;   
wire            mdummy0_hmain0_m4_hwrite;   
wire    [31:0]  mdummy1_hmain0_m5_haddr;    
wire    [2 :0]  mdummy1_hmain0_m5_hburst;   
wire    [3 :0]  mdummy1_hmain0_m5_hprot;    
wire    [2 :0]  mdummy1_hmain0_m5_hsize;    
wire    [1 :0]  mdummy1_hmain0_m5_htrans;   
wire    [31:0]  mdummy1_hmain0_m5_hwdata;   
wire            mdummy1_hmain0_m5_hwrite;   
wire    [31:0]  mdummy2_hmain0_m6_haddr;    
wire    [2 :0]  mdummy2_hmain0_m6_hburst;   
wire    [3 :0]  mdummy2_hmain0_m6_hprot;    
wire    [2 :0]  mdummy2_hmain0_m6_hsize;    
wire    [1 :0]  mdummy2_hmain0_m6_htrans;   
wire    [31:0]  mdummy2_hmain0_m6_hwdata;   
wire            mdummy2_hmain0_m6_hwrite;
wire            cpu_padmux_jtg_tms_ien; 
wire            cpu_padmux_jtg_tms_o;  
wire            cpu_padmux_jtg2_tms_o;   //将cpu的两个output信号连出去，避免重复赋值造成冲突
wire            cpu_padmux_jtg_tms_oe; 
wire            cpu_padmux_jtg2_tms_oe; 
wire            cpu_padmux_jtg_tms_oen; 
wire            cpu_pmu_dfs_ack;       
wire            cpu_pmu_sleep_b;       
wire            cpu_pmu2_dfs_ack;       
wire            cpu_pmu2_sleep_b;  
wire            dft_clk;               
wire            dmac0_wic_intr;        
wire            ehs_pmu_clk;           
wire            els_pmu_clk;           
wire    [31:0]  gpio_apb1_prdata;      
wire    [31:0]  gpio_ioctl_porta_dr;   
wire            gpio_wic_intr;         
wire    [31:0]  hmain0_cpu_m0_hrdata;  
wire            hmain0_cpu_m0_hready;  
wire    [1 :0]  hmain0_cpu_m0_hresp;   
wire    [31:0]  hmain0_cpu_m1_hrdata;  
wire            hmain0_cpu_m1_hready;  
wire    [1 :0]  hmain0_cpu_m1_hresp;   
wire    [31:0]  hmain0_cpu_m2_hrdata;  
wire            hmain0_cpu_m2_hready;  
wire    [1 :0]  hmain0_cpu_m2_hresp;   
 
wire    [31:0]  hmain0_mdummy0_m4_hrdata;   
wire            hmain0_mdummy0_m4_hready;   
wire    [1 :0]  hmain0_mdummy0_m4_hresp;    
wire    [31:0]  hmain0_mdummy1_m5_hrdata;   
wire            hmain0_mdummy1_m5_hready;   
wire    [1 :0]  hmain0_mdummy1_m5_hresp;     
wire    [31:0]  hmain0_mdummy2_m6_hrdata;   
wire            hmain0_mdummy2_m6_hready;   
wire    [1 :0]  hmain0_mdummy2_m6_hresp;  
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
wire    [31:0]  ioctl_gpio_ext_porta;  
wire            ioctl_pwm_cap0;        
wire            ioctl_pwm_cap10;       
wire            ioctl_pwm_cap2;        
wire            ioctl_pwm_cap4;        
wire            ioctl_pwm_cap6;        
wire            ioctl_pwm_cap8;        
wire            ioctl_pwm_fault;       
wire            ioctl_usi0_nss_in;     
wire            ioctl_usi0_sclk_in;    
wire            ioctl_usi0_sd0_in;     
wire            ioctl_usi0_sd1_in;     
wire            ioctl_usi1_nss_in;     
wire            ioctl_usi1_sclk_in;    
wire            ioctl_usi1_sd0_in;     
wire            ioctl_usi1_sd1_in;     
wire            ioctl_usi2_nss_in;     
wire            ioctl_usi2_sclk_in;    
wire            ioctl_usi2_sd0_in;     
wire            ioctl_usi2_sd1_in;     
wire    [31:0]  ismc_hmain0_s0_hrdata; 
wire            ismc_hmain0_s0_hready; 
wire    [1 :0]  ismc_hmain0_s0_hresp;  
wire            lsbus_dummy0_intr;     
wire            lsbus_dummy1_intr;     
wire            lsbus_dummy2_intr;     
wire            lsbus_dummy3_intr;     
wire            main_dmemdummy0_intr;  
wire            main_dummy0_intr;      
wire            main_dummy1_intr;      
wire            main_dummy2_intr;      
wire            main_dummy3_intr;      
wire            main_imemdummy0_intr;  
wire            pad_core_clk;          
wire            pad_core_ctim_refclk;  
wire            pad_core_rst_b;        
wire    [31:0]  pad_gpio_ien;          
wire    [31:0]  pad_gpio_oen;          
wire            pad_mcurst_b;          
wire            padmux_cpu_jtg_tclk;   
wire            padmux_cpu_jtg_tms_i;  
wire            pmu_apb0_pclk_en;      
wire            pmu_apb0_s3clk;        
wire            pmu_apb0_s3rst_b;      
wire            pmu_apb1_pclk_en;      
wire    [31:0]  pmu_apb1_prdata;       
wire            pmu_apb1_s3clk;        
wire            pmu_apb1_s3rst_b;      
wire            pmu_cpu_dfs_req;       
wire            pmu_dmac0_hclk;        
wire            pmu_dmac0_hrst_b;      
wire            pmu_dmemdummy0_hclk;   
wire            pmu_dmemdummy0_hrst_b; 
wire            pmu_dummy0_hclk;       
wire            pmu_dummy0_hrst_b;     
wire            pmu_dummy0_s3clk;      
wire            pmu_dummy0_s3rst_b;    
wire            pmu_dummy1_hclk;       
wire            pmu_dummy1_hrst_b;     
wire            pmu_dummy1_p0clk;      
wire            pmu_dummy1_p0rst_b;    
wire            pmu_dummy1_p1clk;      
wire            pmu_dummy1_p1rst_b;    
wire            pmu_dummy1_s3clk;      
wire            pmu_dummy1_s3rst_b;    
wire            pmu_dummy2_hclk;       
wire            pmu_dummy2_hrst_b;     
wire            pmu_dummy2_p0clk;      
wire            pmu_dummy2_p0rst_b;    
wire            pmu_dummy2_p1clk;      
wire            pmu_dummy2_p1rst_b;    
wire            pmu_dummy2_s3clk;      
wire            pmu_dummy2_s3rst_b;    
wire            pmu_dummy3_hclk;       
wire            pmu_dummy3_hrst_b;     
wire            pmu_dummy3_p0clk;      
wire            pmu_dummy3_p0rst_b;    
wire            pmu_dummy3_p1clk;      
wire            pmu_dummy3_p1rst_b;    
wire            pmu_dummy3_s3clk;      
wire            pmu_dummy3_s3rst_b;    
wire            pmu_dummy4_p0clk;      
wire            pmu_dummy4_p0rst_b;    
wire            pmu_dummy4_p1clk;      
wire            pmu_dummy4_p1rst_b;    
wire            pmu_dummy5_p0clk;      
wire            pmu_dummy5_p0rst_b;    
wire            pmu_dummy5_p1clk;      
wire            pmu_dummy5_p1rst_b;    
wire            pmu_dummy6_p1clk;      
wire            pmu_dummy6_p1rst_b;    
wire            pmu_dummy7_p0clk;      
wire            pmu_dummy7_p0rst_b;    
wire            pmu_dummy7_p1clk;      
wire            pmu_dummy7_p1rst_b;    
wire            pmu_dummy8_p0clk;      
wire            pmu_dummy8_p0rst_b;    
wire            pmu_dummy8_p1clk;      
wire            pmu_dummy8_p1rst_b;    
wire            pmu_dummy9_p0clk;      
wire            pmu_dummy9_p0rst_b;    
wire            pmu_hmain0_hclk;       
wire            pmu_hmain0_hrst_b;     
wire            pmu_imemdummy0_hclk;   
wire            pmu_imemdummy0_hrst_b; 
wire            pmu_lsbus_hclk;        
wire            pmu_lsbus_hrst_b;      
wire            pmu_mdummy0_hclk;      
wire            pmu_mdummy0_hrst_b;    
wire            pmu_mdummy1_hclk;      
wire            pmu_mdummy1_hrst_b;    
wire            pmu_mdummy2_hclk;      
wire            pmu_mdummy2_hrst_b;    
wire            pmu_pwm_p0clk;         
wire            pmu_pwm_p0rst_b;       
wire            pmu_smc_hclk;          
wire            pmu_smc_hrst_b;        
wire            pmu_sub3_s3clk;        
wire            pmu_sub3_s3rst_b;      
wire            pmu_tim0_p0clk;        
wire            pmu_tim0_p0rst_b;      
wire            pmu_tim1_p1clk;        
wire            pmu_tim1_p1rst_b;      
wire            pmu_tim2_p0clk;        
wire            pmu_tim2_p0rst_b;      
wire            pmu_tim3_p1clk;        
wire            pmu_tim3_p1rst_b;      
wire            pmu_tim4_p0clk;        
wire            pmu_tim4_p0rst_b;      
wire            pmu_tim5_p1clk;        
wire            pmu_tim5_p1rst_b;      
wire            pmu_tim6_p0clk;        
wire            pmu_tim6_p0rst_b;      
wire            pmu_tim7_p1clk;        
wire            pmu_tim7_p1rst_b;      
wire            pmu_usi0_p0clk;        
wire            pmu_usi0_p0rst_b;      
wire            pmu_usi1_p1clk;        
wire            pmu_usi1_p1rst_b;      
wire            pmu_usi2_p0clk;        
wire            pmu_usi2_p0rst_b;      
wire            pmu_wdt_p0clk;         
wire            pmu_wdt_p0rst_b;       
wire            pmu_wic_intr;          
wire            pwm_indata1;           
wire            pwm_indata11;          
wire            pwm_indata3;           
wire            pwm_indata5;           
wire            pwm_indata7;           
wire            pwm_indata9;           
wire            pwm_ioctl_ch0;         
wire            pwm_ioctl_ch0_ie_n;    
wire            pwm_ioctl_ch0_oe_n;    
wire            pwm_ioctl_ch1;         
wire            pwm_ioctl_ch10;        
wire            pwm_ioctl_ch10_ie_n;   
wire            pwm_ioctl_ch10_oe_n;   
wire            pwm_ioctl_ch11;        
wire            pwm_ioctl_ch11_ie_n;   
wire            pwm_ioctl_ch11_oe_n;   
wire            pwm_ioctl_ch1_ie_n;    
wire            pwm_ioctl_ch1_oe_n;    
wire            pwm_ioctl_ch2;         
wire            pwm_ioctl_ch2_ie_n;    
wire            pwm_ioctl_ch2_oe_n;    
wire            pwm_ioctl_ch3;         
wire            pwm_ioctl_ch3_ie_n;    
wire            pwm_ioctl_ch3_oe_n;    
wire            pwm_ioctl_ch4;         
wire            pwm_ioctl_ch4_ie_n;    
wire            pwm_ioctl_ch4_oe_n;    
wire            pwm_ioctl_ch5;         
wire            pwm_ioctl_ch5_ie_n;    
wire            pwm_ioctl_ch5_oe_n;    
wire            pwm_ioctl_ch6;         
wire            pwm_ioctl_ch6_ie_n;    
wire            pwm_ioctl_ch6_oe_n;    
wire            pwm_ioctl_ch7;         
wire            pwm_ioctl_ch7_ie_n;    
wire            pwm_ioctl_ch7_oe_n;    
wire            pwm_ioctl_ch8;         
wire            pwm_ioctl_ch8_ie_n;    
wire            pwm_ioctl_ch8_oe_n;    
wire            pwm_ioctl_ch9;         
wire            pwm_ioctl_ch9_ie_n;    
wire            pwm_ioctl_ch9_oe_n;    
wire            pwm_wic_intr;          
wire    [31:0]  rtc_apb1_prdata;       
wire            rtc_wic_intr;          
wire            scan_en;               
wire            scan_mode;             
wire    [31:0]  smc_hmain0_s2_hrdata;  
wire            smc_hmain0_s2_hready;  
wire    [1 :0]  smc_hmain0_s2_hresp;   
wire    [31:0]  smc_hmain0_s3_hrdata;  
wire            smc_hmain0_s3_hready;  
wire    [1 :0]  smc_hmain0_s3_hresp;   
wire    [31:0]  smc_hmain0_s4_hrdata;  
wire            smc_hmain0_s4_hready;  
wire    [1 :0]  smc_hmain0_s4_hresp;   
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
wire    [31:0]  imemdummy0_hmain0_s1_hrdata; 
wire            imemdummy0_hmain0_s1_hready; 
wire    [1 :0]  imemdummy0_hmain0_s1_hresp; 
wire    [31:0]  hmain0_imemdummy0_s1_haddr; 
wire    [3 :0]  hmain0_imemdummy0_s1_hprot; 
wire            hmain0_imemdummy0_s1_hsel;  
wire    [2 :0]  hmain0_imemdummy0_s1_hsize; 
wire    [1 :0]  hmain0_imemdummy0_s1_htrans; 
wire    [31:0]  hmain0_imemdummy0_s1_hwdata; 
wire            hmain0_imemdummy0_s1_hwrite; 
wire            test_mode;             
wire    [1 :0]  tim0_wic_intr;         
wire    [1 :0]  tim1_wic_intr;         
wire    [1 :0]  tim2_wic_intr;         
wire    [1 :0]  tim3_wic_intr;         
wire    [1 :0]  tim4_wic_intr;         
wire    [1 :0]  tim5_wic_intr;         
wire    [1 :0]  tim6_wic_intr;         
wire    [1 :0]  tim7_wic_intr;         
wire            usi0_ioctl_nss_ie_n;   
wire            usi0_ioctl_nss_oe_n;   
wire            usi0_ioctl_nss_out;    
wire            usi0_ioctl_sclk_ie_n;  
wire            usi0_ioctl_sclk_oe_n;  
wire            usi0_ioctl_sclk_out;   
wire            usi0_ioctl_sd0_ie_n;   
wire            usi0_ioctl_sd0_oe_n;   
wire            usi0_ioctl_sd0_out;    
wire            usi0_ioctl_sd1_ie_n;   
wire            usi0_ioctl_sd1_oe_n;   
wire            usi0_ioctl_sd1_out;    
wire            usi0_wic_intr;         
wire            usi1_ioctl_nss_ie_n;   
wire            usi1_ioctl_nss_oe_n;   
wire            usi1_ioctl_nss_out;    
wire            usi1_ioctl_sclk_ie_n;  
wire            usi1_ioctl_sclk_oe_n;  
wire            usi1_ioctl_sclk_out;   
wire            usi1_ioctl_sd0_ie_n;   
wire            usi1_ioctl_sd0_oe_n;   
wire            usi1_ioctl_sd0_out;    
wire            usi1_ioctl_sd1_ie_n;   
wire            usi1_ioctl_sd1_oe_n;   
wire            usi1_ioctl_sd1_out;    
wire            usi1_wic_intr;         
wire            usi2_ioctl_nss_ie_n;   
wire            usi2_ioctl_nss_oe_n;   
wire            usi2_ioctl_nss_out;    
wire            usi2_ioctl_sclk_ie_n;  
wire            usi2_ioctl_sclk_oe_n;  
wire            usi2_ioctl_sclk_out;   
wire            usi2_ioctl_sd0_ie_n;   
wire            usi2_ioctl_sd0_oe_n;   
wire            usi2_ioctl_sd0_out;    
wire            usi2_ioctl_sd1_ie_n;   
wire            usi2_ioctl_sd1_oe_n;   
wire            usi2_ioctl_sd1_out;    
wire            usi2_wic_intr;         
wire            wdt_pmu_rst_b;         
wire            wdt_wic_intr;          
wire            cpu0_mbx_intr;
wire            cpu1_mbx_intr;
aou_top  x_aou_top (
  .apb1_gpio_psel_s5     (apb1_gpio_psel_s5    ),
  .apb1_pmu_psel_s15     (apb1_pmu_psel_s15    ),
  .apb1_rtc_psel_s6      (apb1_rtc_psel_s6     ),
  .apb1_xx_paddr         (apb1_xx_paddr        ),
  .apb1_xx_penable       (apb1_xx_penable      ),
  .apb1_xx_pprot         (apb1_xx_pprot        ),
  .apb1_xx_pwdata        (apb1_xx_pwdata       ),
  .apb1_xx_pwrite        (apb1_xx_pwrite       ),
  .cpu_pmu_dfs_ack       (cpu_pmu_dfs_ack      ),  //input
  .cpu_pmu_sleep_b       (cpu_pmu_sleep_b      ),
  .cpu_pmu2_dfs_ack       (cpu_pmu2_dfs_ack      ),  //input
  .cpu_pmu2_sleep_b       (cpu_pmu2_sleep_b      ),
  .dft_clk               (dft_clk              ),  //clk100MHz-->PAD_OSC_IO(CLK)-->aou_top(pmu_dummy_top[output])
  .ehs_pmu_clk           (ehs_pmu_clk          ),
  .els_pmu_clk           (els_pmu_clk          ),
  .gpio_apb1_prdata      (gpio_apb1_prdata     ),
  .gpio_ioctl_porta_dr   (gpio_ioctl_porta_dr  ),
  .gpio_wic_intr         (gpio_wic_intr        ),
  .ioctl_gpio_ext_porta  (ioctl_gpio_ext_porta ),
  .pad_core_clk          (pad_core_clk         ),
  .pad_core_ctim_refclk  (pad_core_ctim_refclk ),  //=ehs_pmu_clk
  .pad_core_rst_b        (pad_core_rst_b       ),
  .pad_gpio_ien          (pad_gpio_ien         ),
  .pad_gpio_oen          (pad_gpio_oen         ),
  .pad_mcurst_b          (pad_mcurst_b         ),
  .pmu_apb0_pclk_en      (pmu_apb0_pclk_en     ),
  .pmu_apb0_s3clk        (pmu_apb0_s3clk       ),
  .pmu_apb0_s3rst_b      (pmu_apb0_s3rst_b     ),
  .pmu_apb1_pclk_en      (pmu_apb1_pclk_en     ),
  .pmu_apb1_prdata       (pmu_apb1_prdata      ),
  .pmu_apb1_s3clk        (pmu_apb1_s3clk       ),
  .pmu_apb1_s3rst_b      (pmu_apb1_s3rst_b     ),
  .pmu_cpu_dfs_req       (pmu_cpu_dfs_req      ),  
  .pmu_dmac0_hclk        (pmu_dmac0_hclk       ),
  .pmu_dmac0_hrst_b      (pmu_dmac0_hrst_b     ),
  .pmu_dmemdummy0_hclk   (pmu_dmemdummy0_hclk  ),
  .pmu_dmemdummy0_hrst_b (pmu_dmemdummy0_hrst_b),
  .pmu_dummy0_hclk       (pmu_dummy0_hclk      ),
  .pmu_dummy0_hrst_b     (pmu_dummy0_hrst_b    ),
  .pmu_dummy0_s3clk      (pmu_dummy0_s3clk     ),
  .pmu_dummy0_s3rst_b    (pmu_dummy0_s3rst_b   ),
  .pmu_dummy1_hclk       (pmu_dummy1_hclk      ),
  .pmu_dummy1_hrst_b     (pmu_dummy1_hrst_b    ),
  .pmu_dummy1_p0clk      (pmu_dummy1_p0clk     ),
  .pmu_dummy1_p0rst_b    (pmu_dummy1_p0rst_b   ),
  .pmu_dummy1_p1clk      (pmu_dummy1_p1clk     ),
  .pmu_dummy1_p1rst_b    (pmu_dummy1_p1rst_b   ),
  .pmu_dummy1_s3clk      (pmu_dummy1_s3clk     ),
  .pmu_dummy1_s3rst_b    (pmu_dummy1_s3rst_b   ),
  .pmu_dummy2_hclk       (pmu_dummy2_hclk      ),
  .pmu_dummy2_hrst_b     (pmu_dummy2_hrst_b    ),
  .pmu_dummy2_p0clk      (pmu_dummy2_p0clk     ),
  .pmu_dummy2_p0rst_b    (pmu_dummy2_p0rst_b   ),
  .pmu_dummy2_p1clk      (pmu_dummy2_p1clk     ),
  .pmu_dummy2_p1rst_b    (pmu_dummy2_p1rst_b   ),
  .pmu_dummy2_s3clk      (pmu_dummy2_s3clk     ),
  .pmu_dummy2_s3rst_b    (pmu_dummy2_s3rst_b   ),
  .pmu_dummy3_hclk       (pmu_dummy3_hclk      ),
  .pmu_dummy3_hrst_b     (pmu_dummy3_hrst_b    ),
  .pmu_dummy3_p0clk      (pmu_dummy3_p0clk     ),
  .pmu_dummy3_p0rst_b    (pmu_dummy3_p0rst_b   ),
  .pmu_dummy3_p1clk      (pmu_dummy3_p1clk     ),
  .pmu_dummy3_p1rst_b    (pmu_dummy3_p1rst_b   ),
  .pmu_dummy3_s3clk      (pmu_dummy3_s3clk     ),
  .pmu_dummy3_s3rst_b    (pmu_dummy3_s3rst_b   ),
  .pmu_dummy4_p0clk      (pmu_dummy4_p0clk     ),
  .pmu_dummy4_p0rst_b    (pmu_dummy4_p0rst_b   ),
  .pmu_dummy4_p1clk      (pmu_dummy4_p1clk     ),
  .pmu_dummy4_p1rst_b    (pmu_dummy4_p1rst_b   ),
  .pmu_dummy5_p0clk      (pmu_dummy5_p0clk     ),
  .pmu_dummy5_p0rst_b    (pmu_dummy5_p0rst_b   ),
  .pmu_dummy5_p1clk      (pmu_dummy5_p1clk     ),
  .pmu_dummy5_p1rst_b    (pmu_dummy5_p1rst_b   ),
  .pmu_dummy6_p1clk      (pmu_dummy6_p1clk     ),
  .pmu_dummy6_p1rst_b    (pmu_dummy6_p1rst_b   ),
  .pmu_dummy7_p0clk      (pmu_dummy7_p0clk     ),
  .pmu_dummy7_p0rst_b    (pmu_dummy7_p0rst_b   ),
  .pmu_dummy7_p1clk      (pmu_dummy7_p1clk     ),
  .pmu_dummy7_p1rst_b    (pmu_dummy7_p1rst_b   ),
  .pmu_dummy8_p0clk      (pmu_dummy8_p0clk     ),
  .pmu_dummy8_p0rst_b    (pmu_dummy8_p0rst_b   ),
  .pmu_dummy8_p1clk      (pmu_dummy8_p1clk     ),
  .pmu_dummy8_p1rst_b    (pmu_dummy8_p1rst_b   ),
  .pmu_dummy9_p0clk      (pmu_dummy9_p0clk     ),
  .pmu_dummy9_p0rst_b    (pmu_dummy9_p0rst_b   ),
  .pmu_hmain0_hclk       (pmu_hmain0_hclk      ),
  .pmu_hmain0_hrst_b     (pmu_hmain0_hrst_b    ),
  .pmu_imemdummy0_hclk   (pmu_imemdummy0_hclk  ),
  .pmu_imemdummy0_hrst_b (pmu_imemdummy0_hrst_b),
  .pmu_lsbus_hclk        (pmu_lsbus_hclk       ),
  .pmu_lsbus_hrst_b      (pmu_lsbus_hrst_b     ),
  .pmu_mdummy0_hclk      (pmu_mdummy0_hclk     ),
  .pmu_mdummy0_hrst_b    (pmu_mdummy0_hrst_b   ),
  .pmu_mdummy1_hclk      (pmu_mdummy1_hclk     ),
  .pmu_mdummy1_hrst_b    (pmu_mdummy1_hrst_b   ),
  .pmu_mdummy2_hclk      (pmu_mdummy2_hclk     ),
  .pmu_mdummy2_hrst_b    (pmu_mdummy2_hrst_b   ),
  .pmu_pwm_p0clk         (pmu_pwm_p0clk        ),
  .pmu_pwm_p0rst_b       (pmu_pwm_p0rst_b      ),
  .pmu_smc_hclk          (pmu_smc_hclk         ),
  .pmu_smc_hrst_b        (pmu_smc_hrst_b       ),
  .pmu_sub3_s3clk        (pmu_sub3_s3clk       ),
  .pmu_sub3_s3rst_b      (pmu_sub3_s3rst_b     ),
  .pmu_tim0_p0clk        (pmu_tim0_p0clk       ),
  .pmu_tim0_p0rst_b      (pmu_tim0_p0rst_b     ),
  .pmu_tim1_p1clk        (pmu_tim1_p1clk       ),
  .pmu_tim1_p1rst_b      (pmu_tim1_p1rst_b     ),
  .pmu_tim2_p0clk        (pmu_tim2_p0clk       ),
  .pmu_tim2_p0rst_b      (pmu_tim2_p0rst_b     ),
  .pmu_tim3_p1clk        (pmu_tim3_p1clk       ),
  .pmu_tim3_p1rst_b      (pmu_tim3_p1rst_b     ),
  .pmu_tim4_p0clk        (pmu_tim4_p0clk       ),
  .pmu_tim4_p0rst_b      (pmu_tim4_p0rst_b     ),
  .pmu_tim5_p1clk        (pmu_tim5_p1clk       ),
  .pmu_tim5_p1rst_b      (pmu_tim5_p1rst_b     ),
  .pmu_tim6_p0clk        (pmu_tim6_p0clk       ),
  .pmu_tim6_p0rst_b      (pmu_tim6_p0rst_b     ),
  .pmu_tim7_p1clk        (pmu_tim7_p1clk       ),
  .pmu_tim7_p1rst_b      (pmu_tim7_p1rst_b     ),
  .pmu_usi0_p0clk        (pmu_usi0_p0clk       ),
  .pmu_usi0_p0rst_b      (pmu_usi0_p0rst_b     ),
  .pmu_usi1_p1clk        (pmu_usi1_p1clk       ),
  .pmu_usi1_p1rst_b      (pmu_usi1_p1rst_b     ),
  .pmu_usi2_p0clk        (pmu_usi2_p0clk       ),
  .pmu_usi2_p0rst_b      (pmu_usi2_p0rst_b     ),
  .pmu_wdt_p0clk         (pmu_wdt_p0clk        ),
  .pmu_wdt_p0rst_b       (pmu_wdt_p0rst_b      ),
  .pmu_wic_intr          (pmu_wic_intr         ),
  .rtc_apb1_prdata       (rtc_apb1_prdata      ),
  .rtc_wic_intr          (rtc_wic_intr         ),
  .test_mode             (test_mode            ),
  .wdt_pmu_rst_b         (wdt_pmu_rst_b        )
);
pdu_top  x_pdu_top (
  .REE_rst_b(REE_rst_b),
  .REE_rst_addr(REE_rst_addr),
  .apb0_dummy1_intr      (apb0_dummy1_intr     ),
  .apb0_dummy2_intr      (apb0_dummy2_intr     ),
  .apb0_dummy3_intr      (apb0_dummy3_intr     ),
  .apb0_dummy4_intr      (apb0_dummy4_intr     ),
  .apb0_dummy5_intr      (apb0_dummy5_intr     ),
  .apb0_dummy7_intr      (apb0_dummy7_intr     ),
  .apb0_dummy8_intr      (apb0_dummy8_intr     ),
  .apb0_dummy9_intr      (apb0_dummy9_intr     ),
  .apb1_dummy1_intr      (apb1_dummy1_intr     ),
  .apb1_dummy2_intr      (apb1_dummy2_intr     ),
  .apb1_dummy3_intr      (apb1_dummy3_intr     ),
  .apb1_dummy4_intr      (apb1_dummy4_intr     ),
  .apb1_dummy5_intr      (apb1_dummy5_intr     ),
  .apb1_dummy6_intr      (apb1_dummy6_intr     ),
  .apb1_dummy7_intr      (apb1_dummy7_intr     ),
  .apb1_dummy8_intr      (apb1_dummy8_intr     ),  
  .apb1_gpio_psel_s5     (apb1_gpio_psel_s5    ),
  .apb1_pmu_psel_s15     (apb1_pmu_psel_s15    ),
  .apb1_rtc_psel_s6      (apb1_rtc_psel_s6     ),
  .apb1_xx_paddr         (apb1_xx_paddr        ),
  .apb1_xx_penable       (apb1_xx_penable      ),
  .apb1_xx_pprot         (apb1_xx_pprot        ),
  .apb1_xx_pwdata        (apb1_xx_pwdata       ),
  .apb1_xx_pwrite        (apb1_xx_pwrite       ),
  .cpu_hmain0_m0_haddr   (cpu_hmain0_m0_haddr  ),
  .cpu_hmain0_m0_hburst  (cpu_hmain0_m0_hburst ),
  .cpu_hmain0_m0_hprot   (cpu_hmain0_m0_hprot  ),
  .cpu_hmain0_m0_hsize   (cpu_hmain0_m0_hsize  ),
  .cpu_hmain0_m0_htrans  (cpu_hmain0_m0_htrans ),
  .cpu_hmain0_m0_hwdata  (cpu_hmain0_m0_hwdata ),
  .cpu_hmain0_m0_hwrite  (cpu_hmain0_m0_hwrite ),
  .cpu_hmain0_m1_haddr   (cpu_hmain0_m1_haddr  ),
  .cpu_hmain0_m1_hburst  (cpu_hmain0_m1_hburst ),
  .cpu_hmain0_m1_hprot   (cpu_hmain0_m1_hprot  ),
  .cpu_hmain0_m1_hsize   (cpu_hmain0_m1_hsize  ),
  .cpu_hmain0_m1_htrans  (cpu_hmain0_m1_htrans ),
  .cpu_hmain0_m1_hwdata  (cpu_hmain0_m1_hwdata ),
  .cpu_hmain0_m1_hwrite  (cpu_hmain0_m1_hwrite ),
  .cpu_hmain0_m2_haddr   (cpu_hmain0_m2_haddr  ),
  .cpu_hmain0_m2_hburst  (cpu_hmain0_m2_hburst ),
  .cpu_hmain0_m2_hprot   (cpu_hmain0_m2_hprot  ),
  .cpu_hmain0_m2_hsize   (cpu_hmain0_m2_hsize  ),
  .cpu_hmain0_m2_htrans  (cpu_hmain0_m2_htrans ),
  .cpu_hmain0_m2_hwdata  (cpu_hmain0_m2_hwdata ),
  .cpu_hmain0_m2_hwrite  (cpu_hmain0_m2_hwrite ),
  .mdummy0_hmain0_m4_haddr (mdummy0_hmain0_m4_haddr ),  
  .mdummy0_hmain0_m4_hburst(mdummy0_hmain0_m4_hburst), 
  .mdummy0_hmain0_m4_hprot (mdummy0_hmain0_m4_hprot ),    
  .mdummy0_hmain0_m4_hsize (mdummy0_hmain0_m4_hsize ),    
  .mdummy0_hmain0_m4_htrans(mdummy0_hmain0_m4_htrans),   
  .mdummy0_hmain0_m4_hwdata(mdummy0_hmain0_m4_hwdata),   
  .mdummy0_hmain0_m4_hwrite(mdummy0_hmain0_m4_hwrite),   
  .mdummy1_hmain0_m5_haddr (mdummy1_hmain0_m5_haddr ),    
  .mdummy1_hmain0_m5_hburst(mdummy1_hmain0_m5_hburst),   
  .mdummy1_hmain0_m5_hprot (mdummy1_hmain0_m5_hprot ),     
  .mdummy1_hmain0_m5_hsize (mdummy1_hmain0_m5_hsize ),    
  .mdummy1_hmain0_m5_htrans(mdummy1_hmain0_m5_htrans),   
  .mdummy1_hmain0_m5_hwdata(mdummy1_hmain0_m5_hwdata),   
  .mdummy1_hmain0_m5_hwrite(mdummy1_hmain0_m5_hwrite),   
  .mdummy2_hmain0_m6_haddr (mdummy2_hmain0_m6_haddr ),    
  .mdummy2_hmain0_m6_hburst(mdummy2_hmain0_m6_hburst),   
  .mdummy2_hmain0_m6_hprot (mdummy2_hmain0_m6_hprot ),    
  .mdummy2_hmain0_m6_hsize (mdummy2_hmain0_m6_hsize ),    
  .mdummy2_hmain0_m6_htrans(mdummy2_hmain0_m6_htrans),   
  .mdummy2_hmain0_m6_hwdata(mdummy2_hmain0_m6_hwdata),   
  .mdummy2_hmain0_m6_hwrite(mdummy2_hmain0_m6_hwrite),
  .dmac0_wic_intr        (dmac0_wic_intr       ),
  .gpio_apb1_prdata      (gpio_apb1_prdata     ),
  .hmain0_cpu_m0_hrdata  (hmain0_cpu_m0_hrdata ),
  .hmain0_cpu_m0_hready  (hmain0_cpu_m0_hready ),
  .hmain0_cpu_m0_hresp   (hmain0_cpu_m0_hresp  ),
  .hmain0_cpu_m1_hrdata  (hmain0_cpu_m1_hrdata ),
  .hmain0_cpu_m1_hready  (hmain0_cpu_m1_hready ),
  .hmain0_cpu_m1_hresp   (hmain0_cpu_m1_hresp  ),
  .hmain0_cpu_m2_hrdata  (hmain0_cpu_m2_hrdata ),
  .hmain0_cpu_m2_hready  (hmain0_cpu_m2_hready ),
  .hmain0_cpu_m2_hresp   (hmain0_cpu_m2_hresp  ),
  .hmain0_mdummy0_m4_hrdata(hmain0_mdummy0_m4_hrdata),   
  .hmain0_mdummy0_m4_hready(hmain0_mdummy0_m4_hready),   
  .hmain0_mdummy0_m4_hresp (hmain0_mdummy0_m4_hresp ),    
  .hmain0_mdummy1_m5_hrdata(hmain0_mdummy1_m5_hrdata),   
  .hmain0_mdummy1_m5_hready(hmain0_mdummy1_m5_hready),   
  .hmain0_mdummy1_m5_hresp (hmain0_mdummy1_m5_hresp ),    
  .hmain0_mdummy2_m6_hrdata(hmain0_mdummy2_m6_hrdata),   
  .hmain0_mdummy2_m6_hready(hmain0_mdummy2_m6_hready),   
  .hmain0_mdummy2_m6_hresp (hmain0_mdummy2_m6_hresp ),  
  .hmain0_ismc_s0_haddr  (hmain0_ismc_s0_haddr ),
  .hmain0_ismc_s0_hprot  (hmain0_ismc_s0_hprot ),
  .hmain0_ismc_s0_hsel   (hmain0_ismc_s0_hsel  ),
  .hmain0_ismc_s0_hsize  (hmain0_ismc_s0_hsize ),
  .hmain0_ismc_s0_htrans (hmain0_ismc_s0_htrans),
  .hmain0_ismc_s0_hwdata (hmain0_ismc_s0_hwdata),
  .hmain0_ismc_s0_hwrite (hmain0_ismc_s0_hwrite),
  .hmain0_dummy3_s11_haddr  (hmain0_dummy3_s11_haddr ),    
  .hmain0_dummy3_s11_hprot  (hmain0_dummy3_s11_hprot ),    
  .hmain0_dummy3_s11_hsel   (hmain0_dummy3_s11_hsel  ),     
  .hmain0_dummy3_s11_hsize  (hmain0_dummy3_s11_hsize ),    
  .hmain0_dummy3_s11_htrans (hmain0_dummy3_s11_htrans),   
  .hmain0_dummy3_s11_hwdata (hmain0_dummy3_s11_hwdata),   
  .hmain0_dummy3_s11_hwrite (hmain0_dummy3_s11_hwrite),
  .hmain0_smc_s2_haddr   (hmain0_smc_s2_haddr  ),
  .hmain0_smc_s2_hprot   (hmain0_smc_s2_hprot  ),
  .hmain0_smc_s2_hsel    (hmain0_smc_s2_hsel   ),
  .hmain0_smc_s2_hsize   (hmain0_smc_s2_hsize  ),
  .hmain0_smc_s2_htrans  (hmain0_smc_s2_htrans ),
  .hmain0_smc_s2_hwdata  (hmain0_smc_s2_hwdata ),
  .hmain0_smc_s2_hwrite  (hmain0_smc_s2_hwrite ),
  .hmain0_smc_s3_haddr   (hmain0_smc_s3_haddr  ),
  .hmain0_smc_s3_hprot   (hmain0_smc_s3_hprot  ),
  .hmain0_smc_s3_hsel    (hmain0_smc_s3_hsel   ),
  .hmain0_smc_s3_hsize   (hmain0_smc_s3_hsize  ),
  .hmain0_smc_s3_htrans  (hmain0_smc_s3_htrans ),
  .hmain0_smc_s3_hwdata  (hmain0_smc_s3_hwdata ),
  .hmain0_smc_s3_hwrite  (hmain0_smc_s3_hwrite ),
  .hmain0_smc_s4_haddr   (hmain0_smc_s4_haddr  ),
  .hmain0_smc_s4_hprot   (hmain0_smc_s4_hprot  ),
  .hmain0_smc_s4_hsel    (hmain0_smc_s4_hsel   ),
  .hmain0_smc_s4_hsize   (hmain0_smc_s4_hsize  ),
  .hmain0_smc_s4_htrans  (hmain0_smc_s4_htrans ),
  .hmain0_smc_s4_hwdata  (hmain0_smc_s4_hwdata ),
  .hmain0_smc_s4_hwrite  (hmain0_smc_s4_hwrite ),
  .hmain0_dummy0_s7_haddr (hmain0_dummy0_s7_haddr ),       
  .hmain0_dummy0_s7_hprot (hmain0_dummy0_s7_hprot ),     
  .hmain0_dummy0_s7_hsel  (hmain0_dummy0_s7_hsel  ),      
  .hmain0_dummy0_s7_hsize (hmain0_dummy0_s7_hsize ),     
  .hmain0_dummy0_s7_htrans(hmain0_dummy0_s7_htrans),    
  .hmain0_dummy0_s7_hwdata(hmain0_dummy0_s7_hwdata),    
  .hmain0_dummy0_s7_hwrite(hmain0_dummy0_s7_hwrite),    
  .hmain0_dummy1_s8_haddr (hmain0_dummy1_s8_haddr ),      
  .hmain0_dummy1_s8_hprot (hmain0_dummy1_s8_hprot ),     
  .hmain0_dummy1_s8_hsel  (hmain0_dummy1_s8_hsel  ),      
  .hmain0_dummy1_s8_hsize (hmain0_dummy1_s8_hsize ),     
  .hmain0_dummy1_s8_htrans(hmain0_dummy1_s8_htrans),    
  .hmain0_dummy1_s8_hwdata(hmain0_dummy1_s8_hwdata),    
  .hmain0_dummy1_s8_hwrite(hmain0_dummy1_s8_hwrite),    
  .hmain0_dummy2_s9_haddr (hmain0_dummy2_s9_haddr ),        
  .hmain0_dummy2_s9_hprot (hmain0_dummy2_s9_hprot ),     
  .hmain0_dummy2_s9_hsel  (hmain0_dummy2_s9_hsel  ),      
  .hmain0_dummy2_s9_hsize (hmain0_dummy2_s9_hsize ),     
  .hmain0_dummy2_s9_htrans(hmain0_dummy2_s9_htrans),    
  .hmain0_dummy2_s9_hwdata(hmain0_dummy2_s9_hwdata),    
  .hmain0_dummy2_s9_hwrite(hmain0_dummy2_s9_hwrite), 
  .ioctl_pwm_cap0        (ioctl_pwm_cap0       ),
  .ioctl_pwm_cap10       (ioctl_pwm_cap10      ),
  .ioctl_pwm_cap2        (ioctl_pwm_cap2       ),
  .ioctl_pwm_cap4        (ioctl_pwm_cap4       ),
  .ioctl_pwm_cap6        (ioctl_pwm_cap6       ),
  .ioctl_pwm_cap8        (ioctl_pwm_cap8       ),
  .ioctl_pwm_fault       (ioctl_pwm_fault      ),
  .ioctl_usi0_nss_in     (ioctl_usi0_nss_in    ), //input  uart
  .ioctl_usi0_sclk_in    (ioctl_usi0_sclk_in   ), //input
  .ioctl_usi0_sd0_in     (ioctl_usi0_sd0_in    ), //input
  .ioctl_usi0_sd1_in     (ioctl_usi0_sd1_in    ), //input
  .ioctl_usi1_nss_in     (ioctl_usi1_nss_in    ), //i2c 
  .ioctl_usi1_sclk_in    (ioctl_usi1_sclk_in   ),
  .ioctl_usi1_sd0_in     (ioctl_usi1_sd0_in    ),
  .ioctl_usi1_sd1_in     (ioctl_usi1_sd1_in    ),
  .ioctl_usi2_nss_in     (ioctl_usi2_nss_in    ), //spi
  .ioctl_usi2_sclk_in    (ioctl_usi2_sclk_in   ),
  .ioctl_usi2_sd0_in     (ioctl_usi2_sd0_in    ),
  .ioctl_usi2_sd1_in     (ioctl_usi2_sd1_in    ),
  .ismc_hmain0_s0_hrdata (ismc_hmain0_s0_hrdata),
  .ismc_hmain0_s0_hready (ismc_hmain0_s0_hready),
  .ismc_hmain0_s0_hresp  (ismc_hmain0_s0_hresp ),
  .dummy3_hmain0_s11_hrdata(dummy3_hmain0_s11_hrdata),   
  .dummy3_hmain0_s11_hready(dummy3_hmain0_s11_hready),   
  .dummy3_hmain0_s11_hresp (dummy3_hmain0_s11_hresp ),
  .lsbus_dummy0_intr     (lsbus_dummy0_intr    ),
  .lsbus_dummy1_intr     (lsbus_dummy1_intr    ),
  .lsbus_dummy2_intr     (lsbus_dummy2_intr    ),
  .lsbus_dummy3_intr     (lsbus_dummy3_intr    ),
  .main_dmemdummy0_intr  (main_dmemdummy0_intr ),
  .main_dummy0_intr      (main_dummy0_intr     ),
  .main_dummy1_intr      (main_dummy1_intr     ),
  .main_dummy2_intr      (main_dummy2_intr     ),
  .main_dummy3_intr      (main_dummy3_intr     ),
  .main_imemdummy0_intr  (main_imemdummy0_intr ),
  .pmu_apb0_pclk_en      (pmu_apb0_pclk_en     ),
  .pmu_apb0_s3clk        (pmu_apb0_s3clk       ),
  .pmu_apb0_s3rst_b      (pmu_apb0_s3rst_b     ),
  .pmu_apb1_pclk_en      (pmu_apb1_pclk_en     ),
  .pmu_apb1_prdata       (pmu_apb1_prdata      ),
  .pmu_apb1_s3clk        (pmu_apb1_s3clk       ),
  .pmu_apb1_s3rst_b      (pmu_apb1_s3rst_b     ),
  .pmu_dmac0_hclk        (pmu_dmac0_hclk       ),
  .pmu_dmac0_hrst_b      (pmu_dmac0_hrst_b     ),
  .pmu_dmemdummy0_hclk   (pmu_dmemdummy0_hclk  ),
  .pmu_dmemdummy0_hrst_b (pmu_dmemdummy0_hrst_b),
  .pmu_dummy0_hclk       (pmu_dummy0_hclk      ),
  .pmu_dummy0_hrst_b     (pmu_dummy0_hrst_b    ),
  .pmu_dummy0_s3clk      (pmu_dummy0_s3clk     ),
  .pmu_dummy0_s3rst_b    (pmu_dummy0_s3rst_b   ),
  .pmu_dummy1_hclk       (pmu_dummy1_hclk      ),
  .pmu_dummy1_hrst_b     (pmu_dummy1_hrst_b    ),
  .pmu_dummy1_p0clk      (pmu_dummy1_p0clk     ),
  .pmu_dummy1_p0rst_b    (pmu_dummy1_p0rst_b   ),
  .pmu_dummy1_p1clk      (pmu_dummy1_p1clk     ),
  .pmu_dummy1_p1rst_b    (pmu_dummy1_p1rst_b   ),
  .pmu_dummy1_s3clk      (pmu_dummy1_s3clk     ),
  .pmu_dummy1_s3rst_b    (pmu_dummy1_s3rst_b   ),
  .pmu_dummy2_hclk       (pmu_dummy2_hclk      ),
  .pmu_dummy2_hrst_b     (pmu_dummy2_hrst_b    ),
  .pmu_dummy2_p0clk      (pmu_dummy2_p0clk     ),
  .pmu_dummy2_p0rst_b    (pmu_dummy2_p0rst_b   ),
  .pmu_dummy2_p1clk      (pmu_dummy2_p1clk     ),
  .pmu_dummy2_p1rst_b    (pmu_dummy2_p1rst_b   ),
  .pmu_dummy2_s3clk      (pmu_dummy2_s3clk     ),
  .pmu_dummy2_s3rst_b    (pmu_dummy2_s3rst_b   ),
  .pmu_dummy3_hclk       (pmu_dummy3_hclk      ),
  .pmu_dummy3_hrst_b     (pmu_dummy3_hrst_b    ),
  .pmu_dummy3_p0clk      (pmu_dummy3_p0clk     ),
  .pmu_dummy3_p0rst_b    (pmu_dummy3_p0rst_b   ),
  .pmu_dummy3_p1clk      (pmu_dummy3_p1clk     ),
  .pmu_dummy3_p1rst_b    (pmu_dummy3_p1rst_b   ),
  .pmu_dummy3_s3clk      (pmu_dummy3_s3clk     ),
  .pmu_dummy3_s3rst_b    (pmu_dummy3_s3rst_b   ),
  .pmu_dummy4_p0clk      (pmu_dummy4_p0clk     ),
  .pmu_dummy4_p0rst_b    (pmu_dummy4_p0rst_b   ),
  .pmu_dummy4_p1clk      (pmu_dummy4_p1clk     ),
  .pmu_dummy4_p1rst_b    (pmu_dummy4_p1rst_b   ),
  .pmu_dummy5_p0clk      (pmu_dummy5_p0clk     ),
  .pmu_dummy5_p0rst_b    (pmu_dummy5_p0rst_b   ),
  .pmu_dummy5_p1clk      (pmu_dummy5_p1clk     ),
  .pmu_dummy5_p1rst_b    (pmu_dummy5_p1rst_b   ),
  .pmu_dummy6_p1clk      (pmu_dummy6_p1clk     ),
  .pmu_dummy6_p1rst_b    (pmu_dummy6_p1rst_b   ),
  .pmu_dummy7_p0clk      (pmu_dummy7_p0clk     ),
  .pmu_dummy7_p0rst_b    (pmu_dummy7_p0rst_b   ),
  .pmu_dummy7_p1clk      (pmu_dummy7_p1clk     ),
  .pmu_dummy7_p1rst_b    (pmu_dummy7_p1rst_b   ),
  .pmu_dummy8_p0clk      (pmu_dummy8_p0clk     ),
  .pmu_dummy8_p0rst_b    (pmu_dummy8_p0rst_b   ),
  .pmu_dummy8_p1clk      (pmu_dummy8_p1clk     ),
  .pmu_dummy8_p1rst_b    (pmu_dummy8_p1rst_b   ),
  .pmu_dummy9_p0clk      (pmu_dummy9_p0clk     ),
  .pmu_dummy9_p0rst_b    (pmu_dummy9_p0rst_b   ),
  .pmu_hmain0_hclk       (pmu_hmain0_hclk      ),
  .pmu_hmain0_hrst_b     (pmu_hmain0_hrst_b    ),
  .pmu_imemdummy0_hclk   (pmu_imemdummy0_hclk  ),
  .pmu_imemdummy0_hrst_b (pmu_imemdummy0_hrst_b),
  .pmu_lsbus_hclk        (pmu_lsbus_hclk       ),
  .pmu_lsbus_hrst_b      (pmu_lsbus_hrst_b     ),
  .pmu_mdummy0_hclk      (pmu_mdummy0_hclk     ),
  .pmu_mdummy0_hrst_b    (pmu_mdummy0_hrst_b   ),
  .pmu_mdummy1_hclk      (pmu_mdummy1_hclk     ),
  .pmu_mdummy1_hrst_b    (pmu_mdummy1_hrst_b   ),
  .pmu_mdummy2_hclk      (pmu_mdummy2_hclk     ),
  .pmu_mdummy2_hrst_b    (pmu_mdummy2_hrst_b   ),
  .pmu_pwm_p0clk         (pmu_pwm_p0clk        ),
  .pmu_pwm_p0rst_b       (pmu_pwm_p0rst_b      ),
  .pmu_sub3_s3clk        (pmu_sub3_s3clk       ),
  .pmu_sub3_s3rst_b      (pmu_sub3_s3rst_b     ),
  .pmu_tim0_p0clk        (pmu_tim0_p0clk       ),
  .pmu_tim0_p0rst_b      (pmu_tim0_p0rst_b     ),
  .pmu_tim1_p1clk        (pmu_tim1_p1clk       ),
  .pmu_tim1_p1rst_b      (pmu_tim1_p1rst_b     ),
  .pmu_tim2_p0clk        (pmu_tim2_p0clk       ),
  .pmu_tim2_p0rst_b      (pmu_tim2_p0rst_b     ),
  .pmu_tim3_p1clk        (pmu_tim3_p1clk       ),
  .pmu_tim3_p1rst_b      (pmu_tim3_p1rst_b     ),
  .pmu_tim4_p0clk        (pmu_tim4_p0clk       ),
  .pmu_tim4_p0rst_b      (pmu_tim4_p0rst_b     ),
  .pmu_tim5_p1clk        (pmu_tim5_p1clk       ),
  .pmu_tim5_p1rst_b      (pmu_tim5_p1rst_b     ),
  .pmu_tim6_p0clk        (pmu_tim6_p0clk       ),
  .pmu_tim6_p0rst_b      (pmu_tim6_p0rst_b     ),
  .pmu_tim7_p1clk        (pmu_tim7_p1clk       ),
  .pmu_tim7_p1rst_b      (pmu_tim7_p1rst_b     ),
  .pmu_usi0_p0clk        (pmu_usi0_p0clk       ),
  .pmu_usi0_p0rst_b      (pmu_usi0_p0rst_b     ),
  .pmu_usi1_p1clk        (pmu_usi1_p1clk       ),
  .pmu_usi1_p1rst_b      (pmu_usi1_p1rst_b     ),
  .pmu_usi2_p0clk        (pmu_usi2_p0clk       ),
  .pmu_usi2_p0rst_b      (pmu_usi2_p0rst_b     ),
  .pmu_wdt_p0clk         (pmu_wdt_p0clk        ),
  .pmu_wdt_p0rst_b       (pmu_wdt_p0rst_b      ),
  .pwm_ioctl_ch0         (pwm_ioctl_ch0        ),
  .pwm_ioctl_ch0_oe_n    (pwm_ioctl_ch0_oe_n   ),
  .pwm_ioctl_ch1         (pwm_ioctl_ch1        ),
  .pwm_ioctl_ch10        (pwm_ioctl_ch10       ),
  .pwm_ioctl_ch10_oe_n   (pwm_ioctl_ch10_oe_n  ),
  .pwm_ioctl_ch11        (pwm_ioctl_ch11       ),
  .pwm_ioctl_ch11_oe_n   (pwm_ioctl_ch11_oe_n  ),
  .pwm_ioctl_ch1_oe_n    (pwm_ioctl_ch1_oe_n   ),
  .pwm_ioctl_ch2         (pwm_ioctl_ch2        ),
  .pwm_ioctl_ch2_oe_n    (pwm_ioctl_ch2_oe_n   ),
  .pwm_ioctl_ch3         (pwm_ioctl_ch3        ),
  .pwm_ioctl_ch3_oe_n    (pwm_ioctl_ch3_oe_n   ),
  .pwm_ioctl_ch4         (pwm_ioctl_ch4        ),
  .pwm_ioctl_ch4_oe_n    (pwm_ioctl_ch4_oe_n   ),
  .pwm_ioctl_ch5         (pwm_ioctl_ch5        ),
  .pwm_ioctl_ch5_oe_n    (pwm_ioctl_ch5_oe_n   ),
  .pwm_ioctl_ch6         (pwm_ioctl_ch6        ),
  .pwm_ioctl_ch6_oe_n    (pwm_ioctl_ch6_oe_n   ),
  .pwm_ioctl_ch7         (pwm_ioctl_ch7        ),
  .pwm_ioctl_ch7_oe_n    (pwm_ioctl_ch7_oe_n   ),
  .pwm_ioctl_ch8         (pwm_ioctl_ch8        ),
  .pwm_ioctl_ch8_oe_n    (pwm_ioctl_ch8_oe_n   ),
  .pwm_ioctl_ch9         (pwm_ioctl_ch9        ),
  .pwm_ioctl_ch9_oe_n    (pwm_ioctl_ch9_oe_n   ),
  .pwm_wic_intr          (pwm_wic_intr         ),
  .rtc_apb1_prdata       (rtc_apb1_prdata      ),
  .scan_mode             (scan_mode            ),
  .smc_hmain0_s2_hrdata  (smc_hmain0_s2_hrdata ),
  .smc_hmain0_s2_hready  (smc_hmain0_s2_hready ),
  .smc_hmain0_s2_hresp   (smc_hmain0_s2_hresp  ),
  .smc_hmain0_s3_hrdata  (smc_hmain0_s3_hrdata ),
  .smc_hmain0_s3_hready  (smc_hmain0_s3_hready ),
  .smc_hmain0_s3_hresp   (smc_hmain0_s3_hresp  ),
  .smc_hmain0_s4_hrdata  (smc_hmain0_s4_hrdata ),
  .smc_hmain0_s4_hready  (smc_hmain0_s4_hready ),
  .smc_hmain0_s4_hresp   (smc_hmain0_s4_hresp  ),
  
  .dummy0_hmain0_s7_hrdata(dummy0_hmain0_s7_hrdata),    
  .dummy0_hmain0_s7_hready(dummy0_hmain0_s7_hready),    
  .dummy0_hmain0_s7_hresp (dummy0_hmain0_s7_hresp ),     
  .dummy1_hmain0_s8_hrdata(dummy1_hmain0_s8_hrdata),    
  .dummy1_hmain0_s8_hready(dummy1_hmain0_s8_hready),    
  .dummy1_hmain0_s8_hresp (dummy1_hmain0_s8_hresp ),     
  .dummy2_hmain0_s9_hrdata(dummy2_hmain0_s9_hrdata),    
  .dummy2_hmain0_s9_hready(dummy2_hmain0_s9_hready),    
  .dummy2_hmain0_s9_hresp (dummy2_hmain0_s9_hresp ),
  .test_mode             (test_mode            ),
  .tim0_wic_intr         (tim0_wic_intr        ),
  .tim1_wic_intr         (tim1_wic_intr        ),
  .tim2_wic_intr         (tim2_wic_intr        ),
  .tim3_wic_intr         (tim3_wic_intr        ),
  .tim4_wic_intr         (tim4_wic_intr        ),
  .tim5_wic_intr         (tim5_wic_intr        ),
  .tim6_wic_intr         (tim6_wic_intr        ),
  .tim7_wic_intr         (tim7_wic_intr        ),
  .usi0_ioctl_nss_ie_n   (usi0_ioctl_nss_ie_n  ),
  .usi0_ioctl_nss_oe_n   (usi0_ioctl_nss_oe_n  ),
  .usi0_ioctl_nss_out    (usi0_ioctl_nss_out   ),
  .usi0_ioctl_sclk_ie_n  (usi0_ioctl_sclk_ie_n ),
  .usi0_ioctl_sclk_oe_n  (usi0_ioctl_sclk_oe_n ),
  .usi0_ioctl_sclk_out   (usi0_ioctl_sclk_out  ),
  .usi0_ioctl_sd0_ie_n   (usi0_ioctl_sd0_ie_n  ),
  .usi0_ioctl_sd0_oe_n   (usi0_ioctl_sd0_oe_n  ),
  .usi0_ioctl_sd0_out    (usi0_ioctl_sd0_out   ),
  .usi0_ioctl_sd1_ie_n   (usi0_ioctl_sd1_ie_n  ),
  .usi0_ioctl_sd1_oe_n   (usi0_ioctl_sd1_oe_n  ),
  .usi0_ioctl_sd1_out    (usi0_ioctl_sd1_out   ),
  .usi0_wic_intr         (usi0_wic_intr        ),
  .usi1_ioctl_nss_ie_n   (usi1_ioctl_nss_ie_n  ),
  .usi1_ioctl_nss_oe_n   (usi1_ioctl_nss_oe_n  ),
  .usi1_ioctl_nss_out    (usi1_ioctl_nss_out   ),
  .usi1_ioctl_sclk_ie_n  (usi1_ioctl_sclk_ie_n ),
  .usi1_ioctl_sclk_oe_n  (usi1_ioctl_sclk_oe_n ),
  .usi1_ioctl_sclk_out   (usi1_ioctl_sclk_out  ),
  .usi1_ioctl_sd0_ie_n   (usi1_ioctl_sd0_ie_n  ),
  .usi1_ioctl_sd0_oe_n   (usi1_ioctl_sd0_oe_n  ),
  .usi1_ioctl_sd0_out    (usi1_ioctl_sd0_out   ),
  .usi1_ioctl_sd1_ie_n   (usi1_ioctl_sd1_ie_n  ),
  .usi1_ioctl_sd1_oe_n   (usi1_ioctl_sd1_oe_n  ),
  .usi1_ioctl_sd1_out    (usi1_ioctl_sd1_out   ),
  .usi1_wic_intr         (usi1_wic_intr        ),
  .usi2_ioctl_nss_ie_n   (usi2_ioctl_nss_ie_n  ),
  .usi2_ioctl_nss_oe_n   (usi2_ioctl_nss_oe_n  ),
  .usi2_ioctl_nss_out    (usi2_ioctl_nss_out   ),
  .usi2_ioctl_sclk_ie_n  (usi2_ioctl_sclk_ie_n ),
  .usi2_ioctl_sclk_oe_n  (usi2_ioctl_sclk_oe_n ),
  .usi2_ioctl_sclk_out   (usi2_ioctl_sclk_out  ),
  .usi2_ioctl_sd0_ie_n   (usi2_ioctl_sd0_ie_n  ),
  .usi2_ioctl_sd0_oe_n   (usi2_ioctl_sd0_oe_n  ),
  .usi2_ioctl_sd0_out    (usi2_ioctl_sd0_out   ),
  .usi2_ioctl_sd1_ie_n   (usi2_ioctl_sd1_ie_n  ),
  .usi2_ioctl_sd1_oe_n   (usi2_ioctl_sd1_oe_n  ),
  .usi2_ioctl_sd1_out    (usi2_ioctl_sd1_out   ),
  .usi2_wic_intr         (usi2_wic_intr        ),
  .wdt_pmu_rst_b         (wdt_pmu_rst_b        ), //pdu_top输出给aou_top，产生pad_core_rst_b，输入给cpu
  .wdt_wic_intr          (wdt_wic_intr         ),
  .hmain0_imemdummy0_s1_haddr  (hmain0_imemdummy0_s1_haddr ), 
  .hmain0_imemdummy0_s1_hprot  (hmain0_imemdummy0_s1_hprot ), 
  .hmain0_imemdummy0_s1_hsel   (hmain0_imemdummy0_s1_hsel  ),  
  .hmain0_imemdummy0_s1_hsize  (hmain0_imemdummy0_s1_hsize ), 
  .hmain0_imemdummy0_s1_htrans (hmain0_imemdummy0_s1_htrans), 
  .hmain0_imemdummy0_s1_hwdata (hmain0_imemdummy0_s1_hwdata), 
  .hmain0_imemdummy0_s1_hwrite (hmain0_imemdummy0_s1_hwrite),
  .imemdummy0_hmain0_s1_hrdata (imemdummy0_hmain0_s1_hrdata), 
  .imemdummy0_hmain0_s1_hready (imemdummy0_hmain0_s1_hready), 
  .imemdummy0_hmain0_s1_hresp  (imemdummy0_hmain0_s1_hresp )
);
core_top  x_cpu1_top (
  .apb0_dummy1_intr      (apb0_dummy1_intr     ),
  .apb0_dummy2_intr      (apb0_dummy2_intr     ),
  .apb0_dummy3_intr      (apb0_dummy3_intr     ),
  .apb0_dummy4_intr      (apb0_dummy4_intr     ),
  .apb0_dummy5_intr      (apb0_dummy5_intr     ),
  .apb0_dummy7_intr      (apb0_dummy7_intr     ),
  .apb0_dummy8_intr      (apb0_dummy8_intr     ),
  .apb0_dummy9_intr      (apb0_dummy9_intr     ),
  .apb1_dummy1_intr      (apb1_dummy1_intr     ),
  .apb1_dummy2_intr      (apb1_dummy2_intr     ),
  .apb1_dummy3_intr      (apb1_dummy3_intr     ),
  .apb1_dummy4_intr      (apb1_dummy4_intr     ),
  .apb1_dummy5_intr      (apb1_dummy5_intr     ),
  .apb1_dummy6_intr      (apb1_dummy6_intr     ),
  .apb1_dummy7_intr      (apb1_dummy7_intr     ),
  .apb1_dummy8_intr      (apb1_dummy8_intr     ),  // connect into pdu_top
  .bist0_mode            (bist0_mode           ),  //=1'b1
  .cpu_hmain0_m0_haddr   (cpu_hmain0_m0_haddr  ),
  .cpu_hmain0_m0_hburst  (cpu_hmain0_m0_hburst ),
  .cpu_hmain0_m0_hprot   (cpu_hmain0_m0_hprot  ),
  .cpu_hmain0_m0_hsize   (cpu_hmain0_m0_hsize  ),
  .cpu_hmain0_m0_htrans  (cpu_hmain0_m0_htrans ),
  .cpu_hmain0_m0_hwdata  (cpu_hmain0_m0_hwdata ),
  .cpu_hmain0_m0_hwrite  (cpu_hmain0_m0_hwrite ),
  .cpu_hmain0_m1_haddr   (cpu_hmain0_m1_haddr  ),
  .cpu_hmain0_m1_hburst  (cpu_hmain0_m1_hburst ),
  .cpu_hmain0_m1_hprot   (cpu_hmain0_m1_hprot  ),
  .cpu_hmain0_m1_hsize   (cpu_hmain0_m1_hsize  ),
  .cpu_hmain0_m1_htrans  (cpu_hmain0_m1_htrans ),
  .cpu_hmain0_m1_hwdata  (cpu_hmain0_m1_hwdata ),
  .cpu_hmain0_m1_hwrite  (cpu_hmain0_m1_hwrite ),
  .cpu_hmain0_m2_haddr   (cpu_hmain0_m2_haddr  ),
  .cpu_hmain0_m2_hburst  (cpu_hmain0_m2_hburst ),
  .cpu_hmain0_m2_hprot   (cpu_hmain0_m2_hprot  ),
  .cpu_hmain0_m2_hsize   (cpu_hmain0_m2_hsize  ),
  .cpu_hmain0_m2_htrans  (cpu_hmain0_m2_htrans ),
  .cpu_hmain0_m2_hwdata  (cpu_hmain0_m2_hwdata ),
  .cpu_hmain0_m2_hwrite  (cpu_hmain0_m2_hwrite ),  //connect into pdu_top
  .cpu_padmux_jtg_tms_o  (cpu_padmux_jtg_tms_o ),   //在tclk下降沿设置该信号，输出给外部调试器，cpu通过该接口告知用户cpu寄存器以及存储器内容（也就是软件可以获取并读取到cpu寄存器的值）
  .cpu_padmux_jtg_tms_oe (cpu_padmux_jtg_tms_oe),  //jtag_tms_oen ，是cpu_padmux_jtg_tms_o信号的有效指示信号
  .padmux_cpu_jtg_tms_i  (padmux_cpu_jtg_tms_i ), //jtag_tms_i，为2线制串行数据输入信号，空闲时为高电平，经过设置可用于同步复位调试模式   
                                                  //connect outside  can inst a PAD module
  .cpu_pmu_dfs_ack       (cpu_pmu_dfs_ack      ),  //output never mind  just pullout
  .cpu_pmu_sleep_b       (cpu_pmu_sleep_b      ),  //output never mind  just pullout
  .dft_clk               (dft_clk              ),  //  clk100MHz-->PAD_OSC_IO(CLK)20MHZ ----> aou_top  [pmu_dummy_top ouput: assign dft_clk = ehs_pmu_clk]---> cpu[input],
  .dmac0_wic_intr        (dmac0_wic_intr       ),  //  --->dmac_top[output]--->cpu[input]  来自DMAC的一个中断信号
  .gpio_wic_intr         (1'b0                  ),  //  gpio_top[output] ---> aou_top[output] ----> cpu[input]  来自gpio apb外设的一个信号
  .hmain0_cpu_m0_hrdata  (hmain0_cpu_m0_hrdata ),
  .hmain0_cpu_m0_hready  (hmain0_cpu_m0_hready ),
  .hmain0_cpu_m0_hresp   (hmain0_cpu_m0_hresp  ),
  .hmain0_cpu_m1_hrdata  (hmain0_cpu_m1_hrdata ),
  .hmain0_cpu_m1_hready  (hmain0_cpu_m1_hready ),
  .hmain0_cpu_m1_hresp   (hmain0_cpu_m1_hresp  ),
  .hmain0_cpu_m2_hrdata  (hmain0_cpu_m2_hrdata ),
  .hmain0_cpu_m2_hready  (hmain0_cpu_m2_hready ),
  .hmain0_cpu_m2_hresp   (hmain0_cpu_m2_hresp  ),
  .lsbus_dummy0_intr     (lsbus_dummy0_intr    ),   //input assign intr=1'b0;
  .lsbus_dummy1_intr     (lsbus_dummy1_intr    ),
  .lsbus_dummy2_intr     (lsbus_dummy2_intr    ),
  .lsbus_dummy3_intr     (lsbus_dummy3_intr    ),   //来自外设的中断信号
  .main_dmemdummy0_intr  (main_dmemdummy0_intr ),  //input assign intr=1'b0;
  .main_dummy0_intr      (main_dummy0_intr     ),  // input assign intr=1'b0;
  .main_dummy1_intr      (/*main_dummy1_intr*/cpu0_mbx_intr ), //43
  .main_dummy2_intr      (/* main_dummy2_intr */  1'b0 ), //44
  .main_dummy3_intr      (/* main_dummy3_intr */  1'b0),
  .main_imemdummy0_intr  (main_imemdummy0_intr ),  //input assign intr=1'b0
  .pad_core_clk          (pad_core_clk         ), //  CLK20MHZ[input]---> aou_top[ehs_pmu_clk]--->cpu[input]
  .pad_core_ctim_refclk  (pad_core_ctim_refclk ), //input assign = PAD module's CLK
  .pad_core_rst_b        (pad_core_rst_b       ), // --->cpu[input]  assign sys_rst_b = pad_mcurst_b & wdt_pmu_rst_b;
  .padmux_cpu_jtg_tclk   (padmux_cpu_jtg_tclk  ), // inout，是调试器产生的时钟信号
 
  .pmu_cpu_dfs_req       (pmu_cpu_dfs_req      ), // assign = 1'b0
  .pmu_wic_intr          (pmu_wic_intr         ), //assign = 1'b0
  .pwm_wic_intr          (pwm_wic_intr         ), //assign assign pwmint= pwm0_int | pwm1_int | pwm2_int | pwm3_int | pwm4_int | pwm5_int | int_fault;
  .rtc_wic_intr          (rtc_wic_intr         ), //assign rtc0_vic_intr = intr_mask ? 1'b0 : (int_flag && ~pdu_aou_int_clr);
  .scan_en               (scan_en              ), //assign scan_en = 1'b0;
  .scan_mode             (scan_mode            ), //assign scan_mode = 1'b0;
  .test_mode             (test_mode            ), //assign test_mode = 1'b0;
  .tim0_wic_intr         (tim0_wic_intr        ),   //tim.v模块的一个中断输入
  .tim1_wic_intr         (2'b0                 ),
  .tim2_wic_intr         (tim2_wic_intr        ), //1'b0
  .tim3_wic_intr         (2'b0        ),
  .tim4_wic_intr         (tim4_wic_intr        ),
  .tim5_wic_intr         (2'b0       ),
  .tim6_wic_intr         (tim6_wic_intr        ),
  .tim7_wic_intr         (2'b0        ), //time模块中断
  .usi0_wic_intr         (usi0_wic_intr        ), //挂载在usi0下各种外设可能产生的中断
  .usi1_wic_intr         (1'b0                 ), //连到REE CPU  1'b0
  .usi2_wic_intr         (usi2_wic_intr        ), //外设的中断
  .wdt_wic_intr          (wdt_wic_intr         ), 
  
  .core_pad_jdb_pm       (core_pad_jdb_pm      ),
    .pad_cpu_rst_addr     (32'h00000000               )  //全部为正常工作模式
);
core_top  x_cpu2_top (
 .apb0_dummy1_intr      (apb0_dummy1_intr     ),
 .apb0_dummy2_intr      (apb0_dummy2_intr     ),
 .apb0_dummy3_intr      (apb0_dummy3_intr     ),
 .apb0_dummy4_intr      (apb0_dummy4_intr     ),
 .apb0_dummy5_intr      (apb0_dummy5_intr     ),
 .apb0_dummy7_intr      (apb0_dummy7_intr     ),
 .apb0_dummy8_intr      (apb0_dummy8_intr     ),
 .apb0_dummy9_intr      (apb0_dummy9_intr     ),
 .apb1_dummy1_intr      (apb1_dummy1_intr     ),
 .apb1_dummy2_intr      (apb1_dummy2_intr     ),
 .apb1_dummy3_intr      (apb1_dummy3_intr     ),
 .apb1_dummy4_intr      (apb1_dummy4_intr     ),
 .apb1_dummy5_intr      (apb1_dummy5_intr     ),
 .apb1_dummy6_intr      (apb1_dummy6_intr     ),
 .apb1_dummy7_intr      (apb1_dummy7_intr     ),
 .apb1_dummy8_intr      (apb1_dummy8_intr     ),  // connect into pdu_top
 .bist0_mode            (bist0_mode           ),  //=1'b1
 .cpu_hmain0_m0_haddr   (mdummy0_hmain0_m4_haddr  ), //此处pc需要修改
 .cpu_hmain0_m0_hburst  (mdummy0_hmain0_m4_hburst ),
 .cpu_hmain0_m0_hprot   (mdummy0_hmain0_m4_hprot  ),
 .cpu_hmain0_m0_hsize   (mdummy0_hmain0_m4_hsize  ),
 .cpu_hmain0_m0_htrans  (mdummy0_hmain0_m4_htrans ),
 .cpu_hmain0_m0_hwdata  (mdummy0_hmain0_m4_hwdata ),
 .cpu_hmain0_m0_hwrite  (mdummy0_hmain0_m4_hwrite ),
 .cpu_hmain0_m1_haddr   (mdummy1_hmain0_m5_haddr  ),
 .cpu_hmain0_m1_hburst  (mdummy1_hmain0_m5_hburst ),
 .cpu_hmain0_m1_hprot   (mdummy1_hmain0_m5_hprot  ),
 .cpu_hmain0_m1_hsize   (mdummy1_hmain0_m5_hsize  ),
 .cpu_hmain0_m1_htrans  (mdummy1_hmain0_m5_htrans ),
 .cpu_hmain0_m1_hwdata  (mdummy1_hmain0_m5_hwdata ),
 .cpu_hmain0_m1_hwrite  (mdummy1_hmain0_m5_hwrite ),
 .cpu_hmain0_m2_haddr   (mdummy2_hmain0_m6_haddr  ),
 .cpu_hmain0_m2_hburst  (mdummy2_hmain0_m6_hburst ),
 .cpu_hmain0_m2_hprot   (mdummy2_hmain0_m6_hprot  ),
 .cpu_hmain0_m2_hsize   (mdummy2_hmain0_m6_hsize  ),
 .cpu_hmain0_m2_htrans  (mdummy2_hmain0_m6_htrans ),
 .cpu_hmain0_m2_hwdata  (mdummy2_hmain0_m6_hwdata ),
 .cpu_hmain0_m2_hwrite  (mdummy2_hmain0_m6_hwrite ),  //connect into pdu_top
 .cpu_padmux_jtg_tms_o  (cpu_padmux_jtg2_tms_o ),   //在tclk下降沿设置该信号，输出给外部调试器，cpu通过该接口告知用户cpu寄存器以及存储器内容（也就是软件可以获取并读取到cpu寄存器的值）
 .cpu_padmux_jtg_tms_oe (cpu_padmux_jtg2_tms_oe),  //jtag_tms_oen ，是cpu_padmux_jtg_tms_o信号的有效指示信号
 .padmux_cpu_jtg_tms_i  (padmux_cpu_jtg_tms_i ), //jtag_tms_i，为2线制串行数据输入信号，空闲时为高电平，经过设置可用于同步复位调试模式  
                                                 //connect outside  can inst a PAD module
 .cpu_pmu_dfs_ack       (cpu_pmu2_dfs_ack      ),  //output never mind  just pullout
 .cpu_pmu_sleep_b       (cpu_pmu2_sleep_b      ),  //output never mind  just pullout
 .dft_clk               (dft_clk              ),  //  clk100MHz-->PAD_OSC_IO(CLK)20MHZ ----> aou_top  [pmu_dummy_top ouput: assign dft_clk = ehs_pmu_clk]---> cpu[input],
 .dmac0_wic_intr        (dmac0_wic_intr       ),  //  --->dmac_top[output]--->cpu[input]  来自DMAC的一个中断信号
 .gpio_wic_intr         (gpio_wic_intr        ),  //  gpio_top[output] ---> aou_top[output] ----> cpu[input]  来自gpio apb外设的一个信号
 .hmain0_cpu_m0_hrdata  (hmain0_mdummy0_m4_hrdata), 
 .hmain0_cpu_m0_hready  (hmain0_mdummy0_m4_hready),
 .hmain0_cpu_m0_hresp   (hmain0_mdummy0_m4_hresp ),
 .hmain0_cpu_m1_hrdata  (hmain0_mdummy1_m5_hrdata),
 .hmain0_cpu_m1_hready  (hmain0_mdummy1_m5_hready),
 .hmain0_cpu_m1_hresp   (hmain0_mdummy1_m5_hresp ),
 .hmain0_cpu_m2_hrdata  (hmain0_mdummy2_m6_hrdata),
 .hmain0_cpu_m2_hready  (hmain0_mdummy2_m6_hready),
 .hmain0_cpu_m2_hresp   (hmain0_mdummy2_m6_hresp ),
 .lsbus_dummy0_intr     (  lsbus_dummy0_intr  ),   //input assign intr=1'b0;
 .lsbus_dummy1_intr     (lsbus_dummy1_intr    ),
 .lsbus_dummy2_intr     (lsbus_dummy2_intr    ),
 .lsbus_dummy3_intr     (lsbus_dummy3_intr    ),   //来自外设的中断信号
 .main_dmemdummy0_intr  (main_dmemdummy0_intr ),  //input assign intr=1'b0;
 .main_dummy0_intr      (main_dummy0_intr     ),  // input assign intr=1'b0;
 .main_dummy1_intr      (/* main_dummy1_intr */   1'b0  ),
 .main_dummy2_intr      (/* main_dummy2_intr */  cpu1_mbx_intr /* 1'b0 */  ),
 .main_dummy3_intr      (/*main_dummy3_intr*/  1'b0  ),
 .main_imemdummy0_intr  (main_imemdummy0_intr ),  //input assign intr=1'b0
 .pad_core_clk          (pad_core_clk         ), //  CLK20MHZ[input]---> aou_top[ehs_pmu_clk]--->cpu[input]
 .pad_core_ctim_refclk  (pad_core_ctim_refclk ), //input assign = PAD module's CLK
 .pad_core_rst_b        (REE_rst_b), // --->cpu[input]  assign sys_rst_b = pad_mcurst_b & wdt_pmu_rst_b;
 .padmux_cpu_jtg_tclk   (padmux_cpu_jtg_tclk  ), // inout，是调试器产生的时钟信号
 
 .pmu_cpu_dfs_req       (pmu_cpu_dfs_req      ), // assign = 1'b0
 .pmu_wic_intr          (pmu_wic_intr         ), //assign = 1'b0
 .pwm_wic_intr          (pwm_wic_intr         ), //assign assign pwmint= pwm0_int | pwm1_int | pwm2_int | pwm3_int | pwm4_int | pwm5_int | int_fault;
 .rtc_wic_intr          (rtc_wic_intr         ), //assign rtc0_vic_intr = intr_mask ? 1'b0 : (int_flag && ~pdu_aou_int_clr);
 .scan_en               (scan_en              ), //assign scan_en = 1'b0;
 .scan_mode             (scan_mode            ), //assign scan_mode = 1'b0;
 .test_mode             (test_mode            ), //assign test_mode = 1'b0;
 .tim0_wic_intr         (2'b0                 ),   //tim.v模块的一个中断输入
 .tim1_wic_intr         (tim1_wic_intr        ),
 .tim2_wic_intr         (2'b0        ),  //其余中断不会响应
 .tim3_wic_intr         (tim3_wic_intr        ),
 .tim4_wic_intr         (2'b0        ),
 .tim5_wic_intr         (tim5_wic_intr        ),
 .tim6_wic_intr         (2'b0        ),
 .tim7_wic_intr         (tim7_wic_intr        ), //time模块中断
 .usi0_wic_intr         (1'b0                 ), //挂载在usi0下各种外设可能产生的中断
 .usi1_wic_intr         (usi1_wic_intr        ), //连到REE CPU
 .usi2_wic_intr         (1'b0        ), //外设的中断
 .wdt_wic_intr          (1'b0                 ),        
  
 .core_pad_jdb_pm       (core_pad_jdb_pm2      ),  //全部为正常工作模式
 .pad_cpu_rst_addr      (REE_rst_addr)
);
my_mailbox mbx(
    .hrst_b     (pmu_dummy2_hrst_b),  
    .hclk       (pmu_dummy2_hclk),
    .hsel       (hmain0_dummy1_s8_hsel | hmain0_dummy2_s9_hsel),
    .c0_hprot   (hmain0_dummy1_s8_hprot),
    .c0_hsize   (hmain0_dummy1_s8_hsize),
    .c0_htrans  (hmain0_dummy1_s8_htrans),
    .c0_hwdata  (hmain0_dummy1_s8_hwdata),
    .c0_hwrite  (hmain0_dummy1_s8_hwrite),
    .c0_haddr   (hmain0_dummy1_s8_haddr),
    .c0_hrdata  (dummy1_hmain0_s8_hrdata),
    .c0_hready  (dummy1_hmain0_s8_hready),
    .c0_hresp   (dummy1_hmain0_s8_hresp),
    .c0_tx_intr (cpu0_mbx_intr),
    .c1_hprot   (hmain0_dummy2_s9_hprot),
    .c1_hsize   (hmain0_dummy2_s9_hsize),
    .c1_htrans  (hmain0_dummy2_s9_htrans),
    .c1_hwdata  (hmain0_dummy2_s9_hwdata),
    .c1_hwrite  (hmain0_dummy2_s9_hwrite),
    .c1_haddr   (hmain0_dummy2_s9_haddr),
    .c1_hrdata  (dummy2_hmain0_s9_hrdata),
    .c1_hready  (dummy2_hmain0_s9_hready),
    .c1_hresp   (dummy2_hmain0_s9_hresp),
    .c1_tx_intr (cpu1_mbx_intr)
);
retu_top  x_retu_top (
  .hmain0_ismc_s0_haddr  (hmain0_ismc_s0_haddr ),
  .hmain0_ismc_s0_hprot  (hmain0_ismc_s0_hprot ),
  .hmain0_ismc_s0_hsel   (hmain0_ismc_s0_hsel  ),
  .hmain0_ismc_s0_hsize  (hmain0_ismc_s0_hsize ),
  .hmain0_ismc_s0_htrans (hmain0_ismc_s0_htrans),
  .hmain0_ismc_s0_hwdata (hmain0_ismc_s0_hwdata),
  .hmain0_ismc_s0_hwrite (hmain0_ismc_s0_hwrite),
  .hmain0_smc_s2_haddr   (hmain0_smc_s2_haddr  ),
  .hmain0_smc_s2_hprot   (hmain0_smc_s2_hprot  ),
  .hmain0_smc_s2_hsel    (hmain0_smc_s2_hsel   ),
  .hmain0_smc_s2_hsize   (hmain0_smc_s2_hsize  ),
  .hmain0_smc_s2_htrans  (hmain0_smc_s2_htrans ),
  .hmain0_smc_s2_hwdata  (hmain0_smc_s2_hwdata ),
  .hmain0_smc_s2_hwrite  (hmain0_smc_s2_hwrite ),
  .hmain0_smc_s3_haddr   (hmain0_smc_s3_haddr  ),
  .hmain0_smc_s3_hprot   (hmain0_smc_s3_hprot  ),
  .hmain0_smc_s3_hsel    (hmain0_smc_s3_hsel   ),
  .hmain0_smc_s3_hsize   (hmain0_smc_s3_hsize  ),
  .hmain0_smc_s3_htrans  (hmain0_smc_s3_htrans ),
  .hmain0_smc_s3_hwdata  (hmain0_smc_s3_hwdata ),
  .hmain0_smc_s3_hwrite  (hmain0_smc_s3_hwrite ),
  .hmain0_smc_s4_haddr   (hmain0_smc_s4_haddr  ),
  .hmain0_smc_s4_hprot   (hmain0_smc_s4_hprot  ),
  .hmain0_smc_s4_hsel    (hmain0_smc_s4_hsel   ),
  .hmain0_smc_s4_hsize   (hmain0_smc_s4_hsize  ),
  .hmain0_smc_s4_htrans  (hmain0_smc_s4_htrans ),
  .hmain0_smc_s4_hwdata  (hmain0_smc_s4_hwdata ),
  .hmain0_smc_s4_hwrite  (hmain0_smc_s4_hwrite ),
  .ismc_hmain0_s0_hrdata (ismc_hmain0_s0_hrdata),
  .ismc_hmain0_s0_hready (ismc_hmain0_s0_hready),
  .ismc_hmain0_s0_hresp  (ismc_hmain0_s0_hresp ),
  .pmu_smc_hclk          (pmu_smc_hclk         ),
  .pmu_smc_hrst_b        (pmu_smc_hrst_b       ),
  .smc_hmain0_s2_hrdata  (smc_hmain0_s2_hrdata ),
  .smc_hmain0_s2_hready  (smc_hmain0_s2_hready ),
  .smc_hmain0_s2_hresp   (smc_hmain0_s2_hresp  ),
  .smc_hmain0_s3_hrdata  (smc_hmain0_s3_hrdata ),
  .smc_hmain0_s3_hready  (smc_hmain0_s3_hready ),
  .smc_hmain0_s3_hresp   (smc_hmain0_s3_hresp  ),
  .smc_hmain0_s4_hrdata  (smc_hmain0_s4_hrdata ),
  .smc_hmain0_s4_hready  (smc_hmain0_s4_hready ),
  .smc_hmain0_s4_hresp   (smc_hmain0_s4_hresp  ),
    //40个信号
  .hmain0_dummy3_s11_haddr  (hmain0_dummy3_s11_haddr ),     
  .hmain0_dummy3_s11_hprot  (hmain0_dummy3_s11_hprot ),    
  .hmain0_dummy3_s11_hsel   (hmain0_dummy3_s11_hsel  ),     
  .hmain0_dummy3_s11_hsize  (hmain0_dummy3_s11_hsize ),    
  .hmain0_dummy3_s11_htrans (hmain0_dummy3_s11_htrans),   
  .hmain0_dummy3_s11_hwdata (hmain0_dummy3_s11_hwdata),   
  .hmain0_dummy3_s11_hwrite (hmain0_dummy3_s11_hwrite), 
  .hmain0_dummy0_s7_haddr   (hmain0_dummy0_s7_haddr  ),     
  .hmain0_dummy0_s7_hprot   (hmain0_dummy0_s7_hprot  ),     
  .hmain0_dummy0_s7_hsel    (hmain0_dummy0_s7_hsel   ),      
  .hmain0_dummy0_s7_hsize   (hmain0_dummy0_s7_hsize  ),     
  .hmain0_dummy0_s7_htrans  (hmain0_dummy0_s7_htrans ),    
  .hmain0_dummy0_s7_hwdata  (hmain0_dummy0_s7_hwdata ),    
  .hmain0_dummy0_s7_hwrite  (hmain0_dummy0_s7_hwrite ),    
  .hmain0_dummy1_s8_haddr   (/*hmain0_dummy1_s8_haddr  */),       
  .hmain0_dummy1_s8_hprot   (/*hmain0_dummy1_s8_hprot  */),     
  .hmain0_dummy1_s8_hsel    (/*hmain0_dummy1_s8_hsel   */),      
  .hmain0_dummy1_s8_hsize   (/*hmain0_dummy1_s8_hsize  */),     
  .hmain0_dummy1_s8_htrans  (/*hmain0_dummy1_s8_htrans */),    
  .hmain0_dummy1_s8_hwdata  (/*hmain0_dummy1_s8_hwdata */),    
  .hmain0_dummy1_s8_hwrite  (/*hmain0_dummy1_s8_hwrite */),    
  .hmain0_dummy2_s9_haddr   (/*hmain0_dummy2_s9_haddr  */),       
  .hmain0_dummy2_s9_hprot   (/*hmain0_dummy2_s9_hprot  */),     
  .hmain0_dummy2_s9_hsel    (/*hmain0_dummy2_s9_hsel   */),      
  .hmain0_dummy2_s9_hsize   (/*hmain0_dummy2_s9_hsize  */),     
  .hmain0_dummy2_s9_htrans  (/*hmain0_dummy2_s9_htrans */),    
  .hmain0_dummy2_s9_hwdata  (/*hmain0_dummy2_s9_hwdata */),    
  .hmain0_dummy2_s9_hwrite  (/*hmain0_dummy2_s9_hwrite */), 
  .dummy0_hmain0_s7_hrdata  (dummy0_hmain0_s7_hrdata ),    
  .dummy0_hmain0_s7_hready  (dummy0_hmain0_s7_hready ),    
  .dummy0_hmain0_s7_hresp   (dummy0_hmain0_s7_hresp  ),     
  .dummy1_hmain0_s8_hrdata  (/*dummy1_hmain0_s8_hrdata */),    
  .dummy1_hmain0_s8_hready  (/*dummy1_hmain0_s8_hready */),    
  .dummy1_hmain0_s8_hresp   (/*dummy1_hmain0_s8_hresp  */),     
  .dummy2_hmain0_s9_hrdata  (/*dummy2_hmain0_s9_hrdata */),    
  .dummy2_hmain0_s9_hready  (/*dummy2_hmain0_s9_hready */),    
  .dummy2_hmain0_s9_hresp   (/*dummy2_hmain0_s9_hresp  */),     
  .dummy3_hmain0_s11_hrdata (dummy3_hmain0_s11_hrdata),   
  .dummy3_hmain0_s11_hready (dummy3_hmain0_s11_hready),   
  .dummy3_hmain0_s11_hresp  (dummy3_hmain0_s11_hresp ),
  .hmain0_imemdummy0_s1_haddr  (hmain0_imemdummy0_s1_haddr ), 
  .hmain0_imemdummy0_s1_hprot  (hmain0_imemdummy0_s1_hprot ), 
  .hmain0_imemdummy0_s1_hsel   (hmain0_imemdummy0_s1_hsel  ),  
  .hmain0_imemdummy0_s1_hsize  (hmain0_imemdummy0_s1_hsize ), 
  .hmain0_imemdummy0_s1_htrans (hmain0_imemdummy0_s1_htrans), 
  .hmain0_imemdummy0_s1_hwdata (hmain0_imemdummy0_s1_hwdata), 
  .hmain0_imemdummy0_s1_hwrite (hmain0_imemdummy0_s1_hwrite),
  .imemdummy0_hmain0_s1_hrdata (imemdummy0_hmain0_s1_hrdata), 
  .imemdummy0_hmain0_s1_hready (imemdummy0_hmain0_s1_hready), 
  .imemdummy0_hmain0_s1_hresp  (imemdummy0_hmain0_s1_hresp )
);
PAD_OSC_IO  x_PAD_EHS (
  .CLK         (ehs_pmu_clk),  //output --> dft_clk
  .EN          (1'b1       ),
  .XOSC_IN     (PIN_EHS    ),  //assign CLK = EN ? XOSC_IN : 1'b0;
  .XOSC_OUT    (POUT_EHS   )
);
assign els_pmu_clk = ehs_pmu_clk;
PAD_DIG_IO  x_PAD_MCURST (
  .ID           (pad_mcurst_b),  //output  assign pad_mcurst_b = PAD_MCURST
  .IEN          (1'b0        ),
  .OD           (1'b0        ),
  .OEN          (1'b1        ),
  .PAD          (PAD_MCURST  )
);
assign cpu_padmux_jtg_tms_oen = ~cpu_padmux_jtg_tms_oe; 
assign cpu_padmux_jtg_tms_ien = cpu_padmux_jtg_tms_oe;  //cpu_padmux_jtg_tms_oe是cpu指示cpu_padmux_jtg_tms_o信号有效的使能信�??
//理解为外部调试接口模块，与CPU之间交互调试信号
PAD_DIG_IO  x_PAD_JTAG_TMS (  
  .ID                     (padmux_cpu_jtg_tms_i  ),
  .IEN                    (cpu_padmux_jtg_tms_ien), 
  .OD                     (cpu_padmux_jtg_tms_o  ),
  .OEN                    (cpu_padmux_jtg_tms_oen),
  .PAD                    (PAD_JTAG_TMS          )  //是将padmux_cpu_jtg_tms_i和cpu_padmux_jtg_tms_o信号整合成了该PAD_JTAG_TMS(inout)信号
);
//TODO：可以重新例化一个PAD模块
PAD_DIG_IO  x_PAD_JTAG_TCLK (
  .ID                  (padmux_cpu_jtg_tclk), //assign ID = IEN ? 1'bz : PAD; == PAD
  .IEN                 (1'b0               ), 
  .OD                  (1'b0               ),
  .OEN                 (1'b1               ),
  .PAD                 (PAD_JTAG_TCLK      ) //assign PAD = OEN ? 1'bz : OD; == 1'bz，作为input，由调试器输�??
);
PAD_DIG_IO  x_PAD_GPIO_0 (
  .ID                      (ioctl_gpio_ext_porta[0]),
  .IEN                     (pad_gpio_ien[0]        ),
  .OD                      (gpio_ioctl_porta_dr[0] ), //在 pad 信号是输出的情况下，其是 pad的信号来源
  .OEN                     (pad_gpio_oen[0]        ),
  .PAD                     (PAD_GPIO_0             )  //这是片选信号？ 将其连接到外部 flash上去？
);
PAD_DIG_IO  x_PAD_GPIO_1 (
  .ID                      (ioctl_gpio_ext_porta[1]),
  .IEN                     (pad_gpio_ien[1]        ),
  .OD                      (gpio_ioctl_porta_dr[1] ),
  .OEN                     (pad_gpio_oen[1]        ),
  .PAD                     (PAD_GPIO_1             )
);
PAD_DIG_IO  x_PAD_GPIO_2 (
  .ID                      (ioctl_gpio_ext_porta[2]),
  .IEN                     (pad_gpio_ien[2]        ),
  .OD                      (gpio_ioctl_porta_dr[2] ),
  .OEN                     (pad_gpio_oen[2]        ),
  .PAD                     (PAD_GPIO_2             )
);
PAD_DIG_IO  x_PAD_GPIO_3 (
  .ID                      (ioctl_gpio_ext_porta[3]),
  .IEN                     (pad_gpio_ien[3]        ),
  .OD                      (gpio_ioctl_porta_dr[3] ),
  .OEN                     (pad_gpio_oen[3]        ),
  .PAD                     (PAD_GPIO_3             )
);
PAD_DIG_IO  x_PAD_GPIO_4 (
  .ID                      (ioctl_gpio_ext_porta[4]),
  .IEN                     (pad_gpio_ien[4]        ),
  .OD                      (gpio_ioctl_porta_dr[4] ),
  .OEN                     (pad_gpio_oen[4]        ),
  .PAD                     (PAD_GPIO_4             )
);
PAD_DIG_IO  x_PAD_GPIO_5 (
  .ID                      (ioctl_gpio_ext_porta[5]),
  .IEN                     (pad_gpio_ien[5]        ),
  .OD                      (gpio_ioctl_porta_dr[5] ),
  .OEN                     (pad_gpio_oen[5]        ),
  .PAD                     (PAD_GPIO_5             )
);
PAD_DIG_IO  x_PAD_GPIO_6 (
  .ID                      (ioctl_gpio_ext_porta[6]),
  .IEN                     (pad_gpio_ien[6]        ),
  .OD                      (gpio_ioctl_porta_dr[6] ),
  .OEN                     (pad_gpio_oen[6]        ),
  .PAD                     (PAD_GPIO_6             )
);
PAD_DIG_IO  x_PAD_GPIO_7 (
  .ID                      (ioctl_gpio_ext_porta[7]),
  .IEN                     (pad_gpio_ien[7]        ),
  .OD                      (gpio_ioctl_porta_dr[7] ),
  .OEN                     (pad_gpio_oen[7]        ),
  .PAD                     (PAD_GPIO_7             )
);
PAD_DIG_IO  x_PAD_GPIO_8 (
  .ID                      (ioctl_gpio_ext_porta[8]),
  .IEN                     (pad_gpio_ien[8]        ),
  .OD                      (gpio_ioctl_porta_dr[8] ),
  .OEN                     (pad_gpio_oen[8]        ),
  .PAD                     (PAD_GPIO_8             )
);
PAD_DIG_IO  x_PAD_GPIO_9 (
  .ID                      (ioctl_gpio_ext_porta[9]),
  .IEN                     (pad_gpio_ien[9]        ),
  .OD                      (gpio_ioctl_porta_dr[9] ),
  .OEN                     (pad_gpio_oen[9]        ),
  .PAD                     (PAD_GPIO_9             )
);
PAD_DIG_IO  x_PAD_GPIO_10 (
  .ID                       (ioctl_gpio_ext_porta[10]),
  .IEN                      (pad_gpio_ien[10]        ),
  .OD                       (gpio_ioctl_porta_dr[10] ),
  .OEN                      (pad_gpio_oen[10]        ),
  .PAD                      (PAD_GPIO_10             )
);
PAD_DIG_IO  x_PAD_GPIO_11 (
  .ID                       (ioctl_gpio_ext_porta[11]),
  .IEN                      (pad_gpio_ien[11]        ),
  .OD                       (gpio_ioctl_porta_dr[11] ),
  .OEN                      (pad_gpio_oen[11]        ),
  .PAD                      (PAD_GPIO_11             )
);
PAD_DIG_IO  x_PAD_GPIO_12 (
  .ID                       (ioctl_gpio_ext_porta[12]),
  .IEN                      (pad_gpio_ien[12]        ),
  .OD                       (gpio_ioctl_porta_dr[12] ),
  .OEN                      (pad_gpio_oen[12]        ),
  .PAD                      (PAD_GPIO_12             )
);
PAD_DIG_IO  x_PAD_GPIO_13 (
  .ID                       (ioctl_gpio_ext_porta[13]),
  .IEN                      (pad_gpio_ien[13]        ),
  .OD                       (gpio_ioctl_porta_dr[13] ),
  .OEN                      (pad_gpio_oen[13]        ),
  .PAD                      (PAD_GPIO_13             )
);
PAD_DIG_IO  x_PAD_GPIO_14 (
  .ID                       (ioctl_gpio_ext_porta[14]),
  .IEN                      (pad_gpio_ien[14]        ),
  .OD                       (gpio_ioctl_porta_dr[14] ),
  .OEN                      (pad_gpio_oen[14]        ),
  .PAD                      (PAD_GPIO_14             )
);
PAD_DIG_IO  x_PAD_GPIO_15 (
  .ID                       (ioctl_gpio_ext_porta[15]),
  .IEN                      (pad_gpio_ien[15]        ),
  .OD                       (gpio_ioctl_porta_dr[15] ),
  .OEN                      (pad_gpio_oen[15]        ),
  .PAD                      (PAD_GPIO_15             )
);
PAD_DIG_IO  x_PAD_GPIO_16 (
  .ID                       (ioctl_gpio_ext_porta[16]),
  .IEN                      (pad_gpio_ien[16]        ),
  .OD                       (gpio_ioctl_porta_dr[16] ),
  .OEN                      (pad_gpio_oen[16]        ),
  .PAD                      (PAD_GPIO_16             )
);
PAD_DIG_IO  x_PAD_GPIO_17 (
  .ID                       (ioctl_gpio_ext_porta[17]),
  .IEN                      (pad_gpio_ien[17]        ),
  .OD                       (gpio_ioctl_porta_dr[17] ),
  .OEN                      (pad_gpio_oen[17]        ),
  .PAD                      (PAD_GPIO_17             )
);
PAD_DIG_IO  x_PAD_GPIO_18 (
  .ID                       (ioctl_gpio_ext_porta[18]),
  .IEN                      (pad_gpio_ien[18]        ),
  .OD                       (gpio_ioctl_porta_dr[18] ),
  .OEN                      (pad_gpio_oen[18]        ),
  .PAD                      (PAD_GPIO_18             )
);
PAD_DIG_IO  x_PAD_GPIO_19 (
  .ID                       (ioctl_gpio_ext_porta[19]),
  .IEN                      (pad_gpio_ien[19]        ),
  .OD                       (gpio_ioctl_porta_dr[19] ),
  .OEN                      (pad_gpio_oen[19]        ),
  .PAD                      (PAD_GPIO_19             )
);
PAD_DIG_IO  x_PAD_GPIO_20 (
  .ID                       (ioctl_gpio_ext_porta[20]),
  .IEN                      (pad_gpio_ien[20]        ),
  .OD                       (gpio_ioctl_porta_dr[20] ),
  .OEN                      (pad_gpio_oen[20]        ),
  .PAD                      (PAD_GPIO_20             )
);
PAD_DIG_IO  x_PAD_GPIO_21 (
  .ID                       (ioctl_gpio_ext_porta[21]),
  .IEN                      (pad_gpio_ien[21]        ),
  .OD                       (gpio_ioctl_porta_dr[21] ),
  .OEN                      (pad_gpio_oen[21]        ),
  .PAD                      (PAD_GPIO_21             )
);
PAD_DIG_IO  x_PAD_GPIO_22 (
  .ID                       (ioctl_gpio_ext_porta[22]),
  .IEN                      (pad_gpio_ien[22]        ),
  .OD                       (gpio_ioctl_porta_dr[22] ),
  .OEN                      (pad_gpio_oen[22]        ),
  .PAD                      (PAD_GPIO_22             )
);
PAD_DIG_IO  x_PAD_GPIO_23 (
  .ID                       (ioctl_gpio_ext_porta[23]),
  .IEN                      (pad_gpio_ien[23]        ),
  .OD                       (gpio_ioctl_porta_dr[23] ),
  .OEN                      (pad_gpio_oen[23]        ),
  .PAD                      (PAD_GPIO_23             )
);
PAD_DIG_IO  x_PAD_GPIO_24 (
  .ID                       (ioctl_gpio_ext_porta[24]),
  .IEN                      (pad_gpio_ien[24]        ),
  .OD                       (gpio_ioctl_porta_dr[24] ),
  .OEN                      (pad_gpio_oen[24]        ),
  .PAD                      (PAD_GPIO_24             )
);
PAD_DIG_IO  x_PAD_GPIO_25 (
  .ID                       (ioctl_gpio_ext_porta[25]),
  .IEN                      (pad_gpio_ien[25]        ),
  .OD                       (gpio_ioctl_porta_dr[25] ),
  .OEN                      (pad_gpio_oen[25]        ),
  .PAD                      (PAD_GPIO_25             )
);
PAD_DIG_IO  x_PAD_GPIO_26 (
  .ID                       (ioctl_gpio_ext_porta[26]),
  .IEN                      (pad_gpio_ien[26]        ),
  .OD                       (gpio_ioctl_porta_dr[26] ),
  .OEN                      (pad_gpio_oen[26]        ),
  .PAD                      (PAD_GPIO_26             )
);
PAD_DIG_IO  x_PAD_GPIO_27 (
  .ID                       (ioctl_gpio_ext_porta[27]),
  .IEN                      (pad_gpio_ien[27]        ),
  .OD                       (gpio_ioctl_porta_dr[27] ),
  .OEN                      (pad_gpio_oen[27]        ),
  .PAD                      (PAD_GPIO_27             )
);
PAD_DIG_IO  x_PAD_GPIO_28 (
  .ID                       (ioctl_gpio_ext_porta[28]),
  .IEN                      (pad_gpio_ien[28]        ),
  .OD                       (gpio_ioctl_porta_dr[28] ),
  .OEN                      (pad_gpio_oen[28]        ),
  .PAD                      (PAD_GPIO_28             )
);
PAD_DIG_IO  x_PAD_GPIO_29 (
  .ID                       (ioctl_gpio_ext_porta[29]),
  .IEN                      (pad_gpio_ien[29]        ),
  .OD                       (gpio_ioctl_porta_dr[29] ),
  .OEN                      (pad_gpio_oen[29]        ),
  .PAD                      (PAD_GPIO_29             )
);
PAD_DIG_IO  x_PAD_GPIO_30 (
  .ID                       (ioctl_gpio_ext_porta[30]),
  .IEN                      (pad_gpio_ien[30]        ),
  .OD                       (gpio_ioctl_porta_dr[30] ),
  .OEN                      (pad_gpio_oen[30]        ),
  .PAD                      (PAD_GPIO_30             )
);
PAD_DIG_IO  x_PAD_GPIO_31 (
  .ID                       (ioctl_gpio_ext_porta[31]),
  .IEN                      (pad_gpio_ien[31]        ),
  .OD                       (gpio_ioctl_porta_dr[31] ),
  .OEN                      (pad_gpio_oen[31]        ),
  .PAD                      (PAD_GPIO_31             )
);
assign pwm_ioctl_ch0_ie_n = ~pwm_ioctl_ch0_oe_n;
assign pwm_ioctl_ch1_ie_n = ~pwm_ioctl_ch1_oe_n;
assign pwm_ioctl_ch2_ie_n = ~pwm_ioctl_ch2_oe_n;
assign pwm_ioctl_ch3_ie_n = ~pwm_ioctl_ch3_oe_n;
assign pwm_ioctl_ch4_ie_n = ~pwm_ioctl_ch4_oe_n;
assign pwm_ioctl_ch5_ie_n = ~pwm_ioctl_ch5_oe_n;
assign pwm_ioctl_ch6_ie_n = ~pwm_ioctl_ch6_oe_n;
assign pwm_ioctl_ch7_ie_n = ~pwm_ioctl_ch7_oe_n;
assign pwm_ioctl_ch8_ie_n = ~pwm_ioctl_ch8_oe_n;
assign pwm_ioctl_ch9_ie_n = ~pwm_ioctl_ch9_oe_n;
assign pwm_ioctl_ch10_ie_n = ~pwm_ioctl_ch10_oe_n;
assign pwm_ioctl_ch11_ie_n = ~pwm_ioctl_ch11_oe_n;
PAD_DIG_IO  x_PAD_PWM_FAULT (
  .ID              (ioctl_pwm_fault),
  .IEN             (1'b0           ),
  .OD              (1'b0           ),
  .OEN             (1'b1           ),
  .PAD             (PAD_PWM_FAULT  )
);
PAD_DIG_IO  x_PAD_PWM_CH0 (
  .ID                 (ioctl_pwm_cap0    ),
  .IEN                (pwm_ioctl_ch0_ie_n),
  .OD                 (pwm_ioctl_ch0     ),
  .OEN                (pwm_ioctl_ch0_oe_n),
  .PAD                (PAD_PWM_CH0       )
);
PAD_DIG_IO  x_PAD_PWM_CH1 (
  .ID                 (pwm_indata1       ),
  .IEN                (pwm_ioctl_ch1_ie_n),
  .OD                 (pwm_ioctl_ch1     ),
  .OEN                (pwm_ioctl_ch1_oe_n),
  .PAD                (PAD_PWM_CH1       )
);
PAD_DIG_IO  x_PAD_PWM_CH2 (
  .ID                 (ioctl_pwm_cap2    ),
  .IEN                (pwm_ioctl_ch2_ie_n),
  .OD                 (pwm_ioctl_ch2     ),
  .OEN                (pwm_ioctl_ch2_oe_n),
  .PAD                (PAD_PWM_CH2       )
);
PAD_DIG_IO  x_PAD_PWM_CH3 (
  .ID                 (pwm_indata3       ),
  .IEN                (pwm_ioctl_ch3_ie_n),
  .OD                 (pwm_ioctl_ch3     ),
  .OEN                (pwm_ioctl_ch3_oe_n),
  .PAD                (PAD_PWM_CH3       )
);
PAD_DIG_IO  x_PAD_PWM_CH4 (
  .ID                 (ioctl_pwm_cap4    ),
  .IEN                (pwm_ioctl_ch4_ie_n),
  .OD                 (pwm_ioctl_ch4     ),
  .OEN                (pwm_ioctl_ch4_oe_n),
  .PAD                (PAD_PWM_CH4       )
);
PAD_DIG_IO  x_PAD_PWM_CH5 (
  .ID                 (pwm_indata5       ),
  .IEN                (pwm_ioctl_ch5_ie_n),
  .OD                 (pwm_ioctl_ch5     ),
  .OEN                (pwm_ioctl_ch5_oe_n),
  .PAD                (PAD_PWM_CH5       )
);
PAD_DIG_IO  x_PAD_PWM_CH6 (
  .ID                 (ioctl_pwm_cap6    ),
  .IEN                (pwm_ioctl_ch6_ie_n),
  .OD                 (pwm_ioctl_ch6     ),
  .OEN                (pwm_ioctl_ch6_oe_n),
  .PAD                (PAD_PWM_CH6       )
);
PAD_DIG_IO  x_PAD_PWM_CH7 (
  .ID                 (pwm_indata7       ),
  .IEN                (pwm_ioctl_ch7_ie_n),
  .OD                 (pwm_ioctl_ch7     ),
  .OEN                (pwm_ioctl_ch7_oe_n),
  .PAD                (PAD_PWM_CH7       )
);
PAD_DIG_IO  x_PAD_PWM_CH8 (
  .ID                 (ioctl_pwm_cap8    ),
  .IEN                (pwm_ioctl_ch8_ie_n),
  .OD                 (pwm_ioctl_ch8     ),
  .OEN                (pwm_ioctl_ch8_oe_n),
  .PAD                (PAD_PWM_CH8       )
);
PAD_DIG_IO  x_PAD_PWM_CH9 (
  .ID                 (pwm_indata9       ),
  .IEN                (pwm_ioctl_ch9_ie_n),
  .OD                 (pwm_ioctl_ch9     ),
  .OEN                (pwm_ioctl_ch9_oe_n),
  .PAD                (PAD_PWM_CH9       )
);
PAD_DIG_IO  x_PAD_PWM_CH10 (
  .ID                  (ioctl_pwm_cap10    ),
  .IEN                 (pwm_ioctl_ch10_ie_n),
  .OD                  (pwm_ioctl_ch10     ),
  .OEN                 (pwm_ioctl_ch10_oe_n),
  .PAD                 (PAD_PWM_CH10       )
);
PAD_DIG_IO  x_PAD_PWM_CH11 (
  .ID                  (pwm_indata11       ),
  .IEN                 (pwm_ioctl_ch11_ie_n),
  .OD                  (pwm_ioctl_ch11     ),
  .OEN                 (pwm_ioctl_ch11_oe_n),
  .PAD                 (PAD_PWM_CH11       )
);
PAD_DIG_IO  x_PAD_USI0_SCLK (
  .ID                   (ioctl_usi0_sclk_in  ),
  .IEN                  (usi0_ioctl_sclk_ie_n),
  .OD                   (usi0_ioctl_sclk_out ),
  .OEN                  (usi0_ioctl_sclk_oe_n),
  .PAD                  (PAD_USI0_SCLK       )  // include spi_clk or i2c_scl or uart_tx
);
PAD_DIG_IO  x_PAD_USI0_SD0 (
  .ID                  (ioctl_usi0_sd0_in  ),
  .IEN                 (usi0_ioctl_sd0_ie_n),
  .OD                  (usi0_ioctl_sd0_out ),
  .OEN                 (usi0_ioctl_sd0_oe_n),
  .PAD                 (PAD_USI0_SD0       )
);
PAD_DIG_IO  x_PAD_USI0_SD1 (
  .ID                  (ioctl_usi0_sd1_in  ),  //经过该模块后 spi_mi 变为该信号向控制模块传输
  .IEN                 (usi0_ioctl_sd1_ie_n),
  .OD                  (usi0_ioctl_sd1_out ),
  .OEN                 (usi0_ioctl_sd1_oe_n),
  .PAD                 (PAD_USI0_SD1       )  //include spi_mi，最 top 的input，
);
PAD_DIG_IO  x_PAD_USI0_NSS (
  .ID                  (ioctl_usi0_nss_in  ),
  .IEN                 (usi0_ioctl_nss_ie_n),
  .OD                  (usi0_ioctl_nss_out ),
  .OEN                 (usi0_ioctl_nss_oe_n),
  .PAD                 (PAD_USI0_NSS       ) //由此赋值给 usi0输出
);
PAD_DIG_IO  x_PAD_USI1_SCLK (
  .ID                   (ioctl_usi1_sclk_in  ),
  .IEN                  (usi1_ioctl_sclk_ie_n),
  .OD                   (usi1_ioctl_sclk_out ),
  .OEN                  (usi1_ioctl_sclk_oe_n),
  .PAD                  (PAD_USI1_SCLK       )
);
PAD_DIG_IO  x_PAD_USI1_SD0 (
  .ID                  (ioctl_usi1_sd0_in  ),
  .IEN                 (usi1_ioctl_sd0_ie_n),
  .OD                  (usi1_ioctl_sd0_out ),  //uart spi i2c usi1_txd
  .OEN                 (usi1_ioctl_sd0_oe_n),  //信号拉低
  .PAD                 (PAD_USI1_SD0       )   
);
PAD_DIG_IO  x_PAD_USI1_SD1 (
  .ID                  (ioctl_usi1_sd1_in  ),
  .IEN                 (usi1_ioctl_sd1_ie_n),
  .OD                  (usi1_ioctl_sd1_out ),
  .OEN                 (usi1_ioctl_sd1_oe_n),
  .PAD                 (PAD_USI1_SD1       )
);
PAD_DIG_IO  x_PAD_USI1_NSS (
  .ID                  (ioctl_usi1_nss_in  ),
  .IEN                 (usi1_ioctl_nss_ie_n),
  .OD                  (usi1_ioctl_nss_out ),
  .OEN                 (usi1_ioctl_nss_oe_n),
  .PAD                 (PAD_USI1_NSS       )
);
PAD_DIG_IO  x_PAD_USI2_SCLK (
  .ID                   (ioctl_usi2_sclk_in  ),
  .IEN                  (usi2_ioctl_sclk_ie_n),
  .OD                   (usi2_ioctl_sclk_out ),
  .OEN                  (usi2_ioctl_sclk_oe_n),
  .PAD                  (PAD_USI2_SCLK       )
);
//增加原语，并且将该信号不要引到xdc文件中
  STARTUPE2 #(
      .PROG_USR("FALSE"),  // Activate program event security feature. Requires encrypted bitstreams.
      .SIM_CCLK_FREQ(0.0)  // Set the Configuration Clock Frequency(ns) for simulation.
   )
   STARTUPE2_inst (
      .CFGCLK(),       // 1-bit output: Configuration main clock output
      .CFGMCLK(),     // 1-bit output: Configuration internal oscillator clock output
      .EOS(),             // 1-bit output: Active high output signal indicating the End Of Startup.
      .PREQ(),           // 1-bit output: PROGRAM request to fabric output
      .CLK(1'b0),             // 1-bit input: User start-up clock input
      .GSR(1'b0),             // 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
      .GTS(1'b0),             // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
      .KEYCLEARB(1'b0), // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      .PACK(1'b0),           // 1-bit input: PROGRAM acknowledge input
      .USRCCLKO(PAD_USI2_SCLK),   // 1-bit input: User CCLK input
                             // For Zynq-7000 devices, this input must be tied to GND
      .USRCCLKTS(1'b0), // 1-bit input: User CCLK 3-state enable input
                             // For Zynq-7000 devices, this input must be tied to VCC
      .USRDONEO(1'b1),   // 1-bit input: User DONE pin output control
      .USRDONETS(1'b0)  // 1-bit input: User DONE 3-state enable output
   );
PAD_DIG_IO  x_PAD_USI2_SD0 (
  .ID                  (ioctl_usi2_sd0_in  ),
  .IEN                 (usi2_ioctl_sd0_ie_n),
  .OD                  (usi2_ioctl_sd0_out ),
  .OEN                 (usi2_ioctl_sd0_oe_n),
  .PAD                 (PAD_USI2_SD0       )  //spi_mo
);
PAD_DIG_IO  x_PAD_USI2_SD1 (
  .ID                  (ioctl_usi2_sd1_in  ),
  .IEN                 (usi2_ioctl_sd1_ie_n),
  .OD                  (usi2_ioctl_sd1_out ),
  .OEN                 (usi2_ioctl_sd1_oe_n),
  .PAD                 (PAD_USI2_SD1       )  //spi_mi
);
PAD_DIG_IO  x_PAD_USI2_NSS (
  .ID                  (ioctl_usi2_nss_in  ),
  .IEN                 (usi2_ioctl_nss_ie_n),
  .OD                  (usi2_ioctl_nss_out ),
  .OEN                 (usi2_ioctl_nss_oe_n),
  .PAD                 (PAD_USI2_NSS       ) //not spi_nss
);
assign bist0_mode = 1'b0;
assign scan_en = 1'b0;
assign scan_mode = 1'b0;
assign test_mode = 1'b0;
endmodule
