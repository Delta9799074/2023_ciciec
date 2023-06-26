/**
* @ version 1.0
* create: 2023-06-22 14:56
* follow RISC-V IOPMP Specification Document, Version 1.0.0-draft2, 05/2023 */
`ifndef IOPMP_DEFINE_SVH
`define IOPMP_DEFINE_SVH
localparam IOPMP_EXP_ADDR = 32'h4010_0020;
localparam IOPMP_WRITE_ADDR = 32'h4010_0024;
localparam ADDR_BUS     = 32;
localparam MD_NUM       = 7;
localparam SID_NUM      = 1;
localparam ENTRY_NUM    = 16;
localparam MDCFG_OFFSET = 'h0800;
localparam SRCMD_OFFSET = 'h1000;
localparam RULE_OFFSET  = 'h2000;
localparam MD_PROT      = 7'b1101010;
localparam MD_READ_ONLY = 7'b1101000;

typedef struct {
    logic [15:0] entry_num = 0;  //16 bits
    logic [8:0]  sid_num   = 0;  //9 bits
    logic [6:0]  md_num    = 0;  //7 bits
} hwcfg_reg;  

typedef struct {
    logic [MD_NUM:0] srcmd_en [SID_NUM-1:0] = {0};  //source command enable
    logic [MD_NUM:0] srcmd_r  [SID_NUM-1:0] = {0};  //source command read
    logic [MD_NUM:0] srcmd_w  [SID_NUM-1:0] = {0};  //source command write 
} srcmd_table_regs;

typedef struct {
    logic [26:0] reserved = 0;  //27bits
    logic [1:0] a = 0;          //2 bits
    logic x = 0;                //1 bits
    logic w = 0;                //1 bit
    logic r = 0;                //1 bit
} entry_cfg_reg;        

typedef struct {
    logic         [31:0] entry_addr = 0;  //iopmp entry address
    entry_cfg_reg entry_cfg;              //entry config
} entry_array_regs;

typedef struct {
    logic [15:0] reserved = 0;  //reserved
    logic [15:0] t        = 0;  //threshold
} mdcfg_reg;

typedef struct  {
    entry_array_regs entry_array [ENTRY_NUM-1:0];
} entry_array_table;

typedef struct {
    mdcfg_reg         mdcfg [MD_NUM-1:0];             //memory domain config
    entry_array_table md_entry_array [MD_NUM-1:0];  //entry array
} mdcfg_table_regs;



typedef enum logic [31:0] { 
    P0_TIMER0 = 32'h5000_0000, //APB timer0
    P1_TIMER2 = 32'h5000_0400, //APB timer2
    P2_TIMER4 = 32'h5000_0800, //APB timer4
    P3_TIMER6 = 32'h5000_0C00, //APB timer6
    P4_USI0 = 32'h5002_8000, //APB usi0
    P5_USI2 = 32'h5002_9000, //APB usi2
    P6_APB0_DUMMY1 = 32'h5000_4000,  //APB dummy
    P7_WDT = 32'h5000_8000, //APB WDT
    P8_APB0_DUMMY2 = 32'h5000_C000, //APB dummy
    P9_APB0_DUMMY3 = 32'h5001_0000, //APB dummy
    P10_APB0_DUMMY4 = 32'h5001_4000, //APB dummy
    P11_APB0_DUMMY5 = 32'h5001_8000, //APB dummy
    P12_PWM = 32'h5001_C000, //APB PWM
    P13_APB0_DUMMY7 = 32'h5002_0000,//APB dummy
    P14_APB0_DUMMY8 = 32'h5002_4000,//APB dummy
    P15_APB0_DUMMY9 = 32'h5003_0000//APB dummy
} s2_apb0_tmap_e;

typedef enum logic [31:0] { 
    P0_TIMER1 = 32'h6000_0000,
    P1_TIMER3 = 32'h6000_0400,
    P2_TIMER5 = 32'h6000_0800,
    P3_TIMER7 = 32'h6000_0C00,
    P4_USI1 = 32'h6002_8000,
    P5_GPIO = 32'h6001_8000,
    P6_RTC = 32'h6000_4000,
    P7_APB1_DUMMY1 = 32'h6000_8000,
    P8_APB1_DUMMY2 = 32'h6000_C000,
    P9_APB1_DUMMY3 = 32'h6001_0000,
    P10_APB1_DUMMY4 = 32'h6001_4000,
    P11_APB1_DUMMY5 = 32'h6001_C000,
    P12_APB1_DUMMY6 = 32'h6002_0000,
    P13_APB1_DUMMY7 = 32'h6002_4000,
    P14_APB1_DUMMY8 = 32'h6002_C000,
    P15_PMU = 32'h6003_0000
} s3_apb1_tmap_e;

s2_apb0_tmap_e s2_apb0_tmap;
s3_apb1_tmap_e s3_apb1_tmap;

typedef enum logic[31:0] { 
    S8_MBX_GB = 32'h4003_0000, //mailbox global register
    S8_MBX_CH0 = 32'h4003_0008, //mailbox Channel0 registers (w: sid 0,1,2 ; r: sid 0,1,2,4,5,6)
    S8_DUMMY = 32'h4003_000F //other dummy
} s8_tmap_e;

typedef enum logic[31:0] { 
    S9_MDUMMY2_0 = 32'h4010_0000, //s9_dummy0
    S9_MBX_CH1 = 32'h4010_0014, //mailbox Channel1 registers(w: sid 4,5,6 ; r: sid 0,1,2,4,5,6)
    S9_IOPMP = IOPMP_EXP_ADDR,
    S9_MDUMMY2_1 = 32'h4010_0028 //s9_dummy1 
} s9_tmap_e;

typedef enum logic[31:0] { 
    S0_LS_DUMMY0 = 32'h4020_0000,
    S1_LS_DUMMY1 = 32'h4030_0000,
    S2_apb0_TADDR = s2_apb0_tmap.first,
    S3_apb1_TADDR = s3_apb1_tmap.first,
    S4_LS_DUMMY2 = 32'h7000_0000,
    S5_LS_DUMMY3 = 32'h7800_0000
} s10_ahb_ls_bus_tmap_e;

s8_tmap_e s8_tmap;
s9_tmap_e s9_tmap;
s10_ahb_ls_bus_tmap_e s10_ahb_ls_bus_tmap;

typedef enum logic[31:0] { 
    S0_BOOTINST = 32'h0000_0000,
    S1_BOOTDATA = 32'h1000_0000,
    S2_DSRAM = 32'h1002_0000,
    S3_DSRAM = 32'h2000_0000,
    S4_DSRAM = 32'h2003_0000,
    S5_DMEM_DUMMY1 = 32'h3000_0000,
    S6_DMA = 32'h4000_0000,
    S7_MDUMMY0 = 32'h4001_0000,
    S8_TADDR = s8_tmap.first,
    S9_TADDR = s9_tmap.first,
    S10_AHB_TADDR = s10_ahb_ls_bus_tmap.first,
    S11_MDUMMY3 = 32'h8000_0000
} address_tmap_e; //address top map enum

typedef enum logic[31:0] { 
    MD0 = 32'h0000_0000,  //denied
    MD1 = 32'h1002_0000,
    MD2 = 32'h2000_0000, //denied
    MD3 = 32'h2003_0000,
    MD4 = 32'h5000_0000, //denied
    MD5 = 32'h6000_0000,
    MD6 = 32'h7000_0000
} md_map_e;

`endif