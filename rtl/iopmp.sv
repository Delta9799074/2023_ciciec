//@ version 1.0
//create: 2023-06-22 14:56
//follow RISC-V IOPMP Specification Document, Version 1.0.0-draft2, 05/2023
`include "iopmp_define.svh"
module my_iopmp(
    /* Global */
    input  logic         clk,
    input  logic         resetn,
    //!2023/06/25
    input  logic [31:0]  iopmp_haddr,
    input  logic [3 :0]  iopmp_hprot, 
    input  logic [2 :0]  iopmp_hsize, 
    input  logic [1 :0]  iopmp_htrans,
    input  logic [31:0]  iopmp_hwdata,
    input  logic         iopmp_hwrite,
    output logic [31:0]  iopmp_hrdata,
    output logic         iopmp_hready,  
    output logic [1 :0]  iopmp_hresp,    

    (*mark_debug = "true"*)output logic         access_deny_intr,
    /* m0 */ /* 主要限制m0的访问*/
    input  logic [31:0]  cpu_hmain0_m0_haddr, 
    input  logic [2 :0]  cpu_hmain0_m0_hburst,
    input  logic [3 :0]  cpu_hmain0_m0_hprot, 
    input  logic [2 :0]  cpu_hmain0_m0_hsize, 
    input  logic [1 :0]  cpu_hmain0_m0_htrans,
    input  logic [31:0]  cpu_hmain0_m0_hwdata,
    input  logic         cpu_hmain0_m0_hwrite,
    /* m1  */
    input  logic [31:0]  cpu_hmain0_m1_haddr, 
    input  logic [2 :0]  cpu_hmain0_m1_hburst,
    input  logic [3 :0]  cpu_hmain0_m1_hprot, 
    input  logic [2 :0]  cpu_hmain0_m1_hsize, 
    input  logic [1 :0]  cpu_hmain0_m1_htrans,
    input  logic [31:0]  cpu_hmain0_m1_hwdata,
    input  logic         cpu_hmain0_m1_hwrite,
    /* m2  */
    input  logic [31:0]  cpu_hmain0_m2_haddr, 
    input  logic [2 :0]  cpu_hmain0_m2_hburst,
    input  logic [3 :0]  cpu_hmain0_m2_hprot, 
    input  logic [2 :0]  cpu_hmain0_m2_hsize, 
    input  logic [1 :0]  cpu_hmain0_m2_htrans,
    input  logic [31:0]  cpu_hmain0_m2_hwdata,
    input  logic         cpu_hmain0_m2_hwrite,

    /* m0 */
    output logic [31:0]  iopmp_cpu_hmain0_m0_haddr, 
    output logic [2 :0]  iopmp_cpu_hmain0_m0_hburst,
    output logic [3 :0]  iopmp_cpu_hmain0_m0_hprot, 
    output logic [2 :0]  iopmp_cpu_hmain0_m0_hsize, 
    output logic [1 :0]  iopmp_cpu_hmain0_m0_htrans,
    output logic [31:0]  iopmp_cpu_hmain0_m0_hwdata,
    output logic         iopmp_cpu_hmain0_m0_hwrite,
    /* m1 */
    output logic [31:0]  iopmp_cpu_hmain0_m1_haddr, 
    output logic [2 :0]  iopmp_cpu_hmain0_m1_hburst,
    output logic [3 :0]  iopmp_cpu_hmain0_m1_hprot, 
    output logic [2 :0]  iopmp_cpu_hmain0_m1_hsize, 
    output logic [1 :0]  iopmp_cpu_hmain0_m1_htrans,
    output logic [31:0]  iopmp_cpu_hmain0_m1_hwdata,
    output logic         iopmp_cpu_hmain0_m1_hwrite,
    /* m2 */
    output logic [31:0]  iopmp_cpu_hmain0_m2_haddr, 
    output logic [2 :0]  iopmp_cpu_hmain0_m2_hburst,
    output logic [3 :0]  iopmp_cpu_hmain0_m2_hprot, 
    output logic [2 :0]  iopmp_cpu_hmain0_m2_hsize, 
    output logic [1 :0]  iopmp_cpu_hmain0_m2_htrans,
    output logic [31:0]  iopmp_cpu_hmain0_m2_hwdata,
    output logic         iopmp_cpu_hmain0_m2_hwrite
);
hwcfg_reg hwcfg;
logic [31:0] rule_offset_reg;
//!2023/06/25 : exception reg
(*mark_debug = "true"*)logic [31:0] ahb_exp_addr;
(*mark_debug = "true"*)logic        ahb_exp_write;
srcmd_table_regs srcmd_table;
mdcfg_table_regs mdcfg_table;
//!2023/06/25: Duplicate Match Logic
logic [2:0] ahb_transit;
logic [MD_NUM-1:0] m0_md_sel;
logic [MD_NUM-1:0] m1_md_sel;
logic [MD_NUM-1:0] m2_md_sel;
logic [ENTRY_NUM-1:0] m0_entry_match;
logic [ENTRY_NUM-1:0] m1_entry_match;
logic [ENTRY_NUM-1:0] m2_entry_match;
logic [4:0] m0_md_idx;
logic [4:0] m1_md_idx;
logic [4:0] m2_md_idx;
logic [5:0] m0_entry_idx;
logic [5:0] m1_entry_idx;
logic [5:0] m2_entry_idx;
logic [6:0] m0_md_access_ok;
logic [6:0] m1_md_access_ok;
logic [6:0] m2_md_access_ok;
logic [2:0] read_enable;
logic [2:0] write_enable;

logic [2:0] table_read_enable;
logic [2:0] table_write_enable;
logic [2:0] iopmp_deny;
/* Configuration */
    always_ff @( posedge clk ) begin : Initialization
        if(~resetn)begin
            hwcfg.md_num    <= MD_NUM;    //Memory domain num
            hwcfg.sid_num   <= SID_NUM;   //Source ID num
            hwcfg.entry_num <= ENTRY_NUM; //IOPMP entry num

            rule_offset_reg <= RULE_OFFSET;
            for (int i=0; i<SID_NUM; i = i+1) begin
                srcmd_table.srcmd_r[i]  <= 7'b1111_111 & MD_PROT;
                srcmd_table.srcmd_w[i]  <= MD_PROT & MD_READ_ONLY;
                srcmd_table.srcmd_en[i] <= MD_PROT;
            end
            for (int m = 0; m < MD_NUM; m = m+1) begin
                mdcfg_table.mdcfg[m].t <= /*(m+1)**/ENTRY_NUM;
            end
            /* Memory Domain 0: BootROM */
            mdcfg_table.md_entry_array[0].entry_array[0].entry_addr <= S0_BOOTINST;
            mdcfg_table.md_entry_array[0].entry_array[0].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[0].entry_array[0].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[0].entry_array[0].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[0].entry_array[1].entry_addr <= S1_BOOTDATA;
            mdcfg_table.md_entry_array[0].entry_array[1].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[0].entry_array[1].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[0].entry_array[1].entry_cfg.x <= 1'b0;
            /* Memory Domain 1: REE Inst */
            mdcfg_table.md_entry_array[1].entry_array[0].entry_addr <= S2_DSRAM;
            mdcfg_table.md_entry_array[1].entry_array[0].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[1].entry_array[0].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[1].entry_array[0].entry_cfg.x <= 1'b1;
            /* Memory Domain 2: TEE Data*/ 
            mdcfg_table.md_entry_array[2].entry_array[0].entry_addr <= S3_DSRAM;
            mdcfg_table.md_entry_array[2].entry_array[0].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[2].entry_array[0].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[2].entry_array[0].entry_cfg.x <= 1'b0;
            /* Mmoery Domain 3: Dsram & DMA & dummies*/
            mdcfg_table.md_entry_array[3].entry_array[0].entry_addr <= S4_DSRAM;
            mdcfg_table.md_entry_array[3].entry_array[0].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[0].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[0].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[1].entry_addr <= S5_DMEM_DUMMY1;
            mdcfg_table.md_entry_array[3].entry_array[1].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[1].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[1].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[2].entry_addr <= S6_DMA;
            mdcfg_table.md_entry_array[3].entry_array[2].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[2].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[2].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[3].entry_addr <= S7_MDUMMY0;
            mdcfg_table.md_entry_array[3].entry_array[3].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[3].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[3].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[4].entry_addr <= S8_MBX_GB;
            mdcfg_table.md_entry_array[3].entry_array[4].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[4].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[3].entry_array[4].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[5].entry_addr <= S8_MBX_CH0;
            mdcfg_table.md_entry_array[3].entry_array[5].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[5].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[3].entry_array[5].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[6].entry_addr <= S8_DUMMY;
            mdcfg_table.md_entry_array[3].entry_array[6].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[6].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[6].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[7].entry_addr <= S9_MDUMMY2_0;
            mdcfg_table.md_entry_array[3].entry_array[7].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[7].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[7].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[8].entry_addr <= S9_MBX_CH1;
            mdcfg_table.md_entry_array[3].entry_array[8].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[8].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[8].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[9].entry_addr <= S9_IOPMP; //read iopmp
            mdcfg_table.md_entry_array[3].entry_array[9].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[9].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[3].entry_array[9].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[10].entry_addr <= S9_MDUMMY2_1;
            mdcfg_table.md_entry_array[3].entry_array[10].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[10].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[10].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[11].entry_addr <= S0_LS_DUMMY0;
            mdcfg_table.md_entry_array[3].entry_array[11].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[11].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[11].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[12].entry_addr <= S1_LS_DUMMY1;
            mdcfg_table.md_entry_array[3].entry_array[12].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[12].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[3].entry_array[12].entry_cfg.x <= 1'b1;
            /*Memory Domain 4: Safety Periphrals*/
            mdcfg_table.md_entry_array[4].entry_array[0].entry_addr <= P0_TIMER0;
            mdcfg_table.md_entry_array[4].entry_array[0].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[0].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[0].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[1].entry_addr <= P1_TIMER2;
            mdcfg_table.md_entry_array[4].entry_array[1].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[1].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[1].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[2].entry_addr <= P2_TIMER4;
            mdcfg_table.md_entry_array[4].entry_array[2].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[2].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[2].entry_cfg.x <= 1'b0;    
            mdcfg_table.md_entry_array[4].entry_array[3].entry_addr <= P3_TIMER6;
            mdcfg_table.md_entry_array[4].entry_array[3].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[3].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[3].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[4].entry_addr <= P4_USI0;
            mdcfg_table.md_entry_array[4].entry_array[4].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[4].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[4].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[5].entry_addr <= P5_USI2;
            mdcfg_table.md_entry_array[4].entry_array[5].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[5].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[5].entry_cfg.x <= 1'b0; 
            mdcfg_table.md_entry_array[4].entry_array[6].entry_addr <= P6_APB0_DUMMY1;
            mdcfg_table.md_entry_array[4].entry_array[6].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[6].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[6].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[7].entry_addr <= P7_WDT;
            mdcfg_table.md_entry_array[4].entry_array[7].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[7].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[7].entry_cfg.x <= 1'b0;  
            mdcfg_table.md_entry_array[4].entry_array[8].entry_addr <= P8_APB0_DUMMY2;
            mdcfg_table.md_entry_array[4].entry_array[8].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[8].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[8].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[9].entry_addr <= P9_APB0_DUMMY3;
            mdcfg_table.md_entry_array[4].entry_array[9].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[9].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[9].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[10].entry_addr <= P10_APB0_DUMMY4;
            mdcfg_table.md_entry_array[4].entry_array[10].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[10].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[10].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[11].entry_addr <= P11_APB0_DUMMY5;
            mdcfg_table.md_entry_array[4].entry_array[11].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[11].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[11].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[12].entry_addr <= P12_PWM;
            mdcfg_table.md_entry_array[4].entry_array[12].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[12].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[12].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[13].entry_addr <= P13_APB0_DUMMY7;
            mdcfg_table.md_entry_array[4].entry_array[13].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[4].entry_array[13].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[4].entry_array[13].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[4].entry_array[14].entry_addr <= P14_APB0_DUMMY8;
            mdcfg_table.md_entry_array[4].entry_array[14].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[14].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[14].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[15].entry_addr <= P15_APB0_DUMMY9;
            mdcfg_table.md_entry_array[4].entry_array[15].entry_cfg.r <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[15].entry_cfg.w <= 1'b0;
            mdcfg_table.md_entry_array[4].entry_array[15].entry_cfg.x <= 1'b0;
            /* Memory Domain 5: Unsafety Peripherals*/
            mdcfg_table.md_entry_array[5].entry_array[0].entry_addr <= P0_TIMER1;
            mdcfg_table.md_entry_array[5].entry_array[0].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[0].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[0].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[1].entry_addr <= P1_TIMER3;
            mdcfg_table.md_entry_array[5].entry_array[1].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[1].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[1].entry_cfg.x <= 1'b0;  
            mdcfg_table.md_entry_array[5].entry_array[2].entry_addr <= P2_TIMER5;
            mdcfg_table.md_entry_array[5].entry_array[2].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[2].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[2].entry_cfg.x <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[3].entry_addr <= P3_TIMER7;
            mdcfg_table.md_entry_array[5].entry_array[3].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[3].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[3].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[4].entry_addr <= P4_USI1;
            mdcfg_table.md_entry_array[5].entry_array[4].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[4].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[4].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[5].entry_addr <= P5_GPIO;
            mdcfg_table.md_entry_array[5].entry_array[5].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[5].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[5].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[6].entry_addr <= P6_RTC;
            mdcfg_table.md_entry_array[5].entry_array[6].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[6].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[6].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[7].entry_addr <= P7_APB1_DUMMY1;
            mdcfg_table.md_entry_array[5].entry_array[7].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[7].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[7].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[8].entry_addr <= P8_APB1_DUMMY2;
            mdcfg_table.md_entry_array[5].entry_array[8].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[8].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[8].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[9].entry_addr <= P9_APB1_DUMMY3;
            mdcfg_table.md_entry_array[5].entry_array[9].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[9].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[9].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[10].entry_addr <= P10_APB1_DUMMY4;
            mdcfg_table.md_entry_array[5].entry_array[10].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[10].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[10].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[11].entry_addr <= P11_APB1_DUMMY5;
            mdcfg_table.md_entry_array[5].entry_array[11].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[11].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[11].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[12].entry_addr <= P12_APB1_DUMMY6;
            mdcfg_table.md_entry_array[5].entry_array[12].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[12].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[12].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[13].entry_addr <= P13_APB1_DUMMY7;
            mdcfg_table.md_entry_array[5].entry_array[13].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[13].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[13].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[14].entry_addr <= P14_APB1_DUMMY8;
            mdcfg_table.md_entry_array[5].entry_array[14].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[14].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[14].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[5].entry_array[15].entry_addr <= P15_PMU;
            mdcfg_table.md_entry_array[5].entry_array[15].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[15].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[5].entry_array[15].entry_cfg.x <= 1'b0;
            /* Memory Domain 6: Dummies */
            mdcfg_table.md_entry_array[6].entry_array[0].entry_addr <= S4_LS_DUMMY2;
            mdcfg_table.md_entry_array[6].entry_array[0].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[6].entry_array[0].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[6].entry_array[0].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[6].entry_array[1].entry_addr <= S5_LS_DUMMY3;
            mdcfg_table.md_entry_array[6].entry_array[1].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[6].entry_array[1].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[6].entry_array[1].entry_cfg.x <= 1'b0;
            mdcfg_table.md_entry_array[6].entry_array[2].entry_addr <= S11_MDUMMY3;
            mdcfg_table.md_entry_array[6].entry_array[2].entry_cfg.r <= 1'b1;
            mdcfg_table.md_entry_array[6].entry_array[2].entry_cfg.w <= 1'b1;
            mdcfg_table.md_entry_array[6].entry_array[2].entry_cfg.x <= 1'b0;
        end
        else; //Don't allow to modify during executing
    end : Initialization
/* Match */
    always_comb begin : AHB_Transit
        ahb_transit[0] = (|cpu_hmain0_m0_htrans) & resetn;
        ahb_transit[1] = (|cpu_hmain0_m1_htrans) & resetn;
        ahb_transit[2] = (|cpu_hmain0_m2_htrans) & resetn;
    end
    always_comb begin : MemoyDomainSelect
        if(ahb_transit[0])begin
            m0_md_sel[0] = (cpu_hmain0_m0_haddr >= MD0) & (cpu_hmain0_m0_haddr < MD1);
            m0_md_sel[1] = (cpu_hmain0_m0_haddr >= MD1) & (cpu_hmain0_m0_haddr < MD2);
            m0_md_sel[2] = (cpu_hmain0_m0_haddr >= MD2) & (cpu_hmain0_m0_haddr < MD3);
            m0_md_sel[3] = (cpu_hmain0_m0_haddr >= MD3) & (cpu_hmain0_m0_haddr < MD4);
            m0_md_sel[4] = (cpu_hmain0_m0_haddr >= MD4) & (cpu_hmain0_m0_haddr < MD5);
            m0_md_sel[5] = (cpu_hmain0_m0_haddr >= MD5) & (cpu_hmain0_m0_haddr < MD6);
            m0_md_sel[6] = (cpu_hmain0_m0_haddr >= MD6) ;
        end
        else begin
            m0_md_sel = 7'b0;
        end
        if(ahb_transit[1])begin
            m1_md_sel[0] = (cpu_hmain0_m1_haddr >= MD0) & (cpu_hmain0_m1_haddr < MD1);
            m1_md_sel[1] = (cpu_hmain0_m1_haddr >= MD1) & (cpu_hmain0_m1_haddr < MD2);
            m1_md_sel[2] = (cpu_hmain0_m1_haddr >= MD2) & (cpu_hmain0_m1_haddr < MD3);
            m1_md_sel[3] = (cpu_hmain0_m1_haddr >= MD3) & (cpu_hmain0_m1_haddr < MD4);
            m1_md_sel[4] = (cpu_hmain0_m1_haddr >= MD4) & (cpu_hmain0_m1_haddr < MD5);
            m1_md_sel[5] = (cpu_hmain0_m1_haddr >= MD5) & (cpu_hmain0_m1_haddr < MD6);
            m1_md_sel[6] = (cpu_hmain0_m1_haddr >= MD6) ;
        end
        else begin
            m1_md_sel = 7'b0;
        end
        if(ahb_transit[2])begin
            m2_md_sel[0] = (cpu_hmain0_m2_haddr >= MD0) & (cpu_hmain0_m2_haddr < MD1);
            m2_md_sel[1] = (cpu_hmain0_m2_haddr >= MD1) & (cpu_hmain0_m2_haddr < MD2);
            m2_md_sel[2] = (cpu_hmain0_m2_haddr >= MD2) & (cpu_hmain0_m2_haddr < MD3);
            m2_md_sel[3] = (cpu_hmain0_m2_haddr >= MD3) & (cpu_hmain0_m2_haddr < MD4);
            m2_md_sel[4] = (cpu_hmain0_m2_haddr >= MD4) & (cpu_hmain0_m2_haddr < MD5);
            m2_md_sel[5] = (cpu_hmain0_m2_haddr >= MD5) & (cpu_hmain0_m2_haddr < MD6);
            m2_md_sel[6] = (cpu_hmain0_m2_haddr >= MD6) ;
        end
        else begin
            m2_md_sel = 7'b0;
        end
    end : MemoyDomainSelect

    always_comb begin : MemoryDomainPriorityCheck
        case(m0_md_sel)
        /* select certain MD & MD enable & (read request & read_enable) or (write request & write enable) */
            7'b0000_000: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_001: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_010: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_100: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0001_000: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0010_000: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0100_000: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b1000_000: m0_md_access_ok = m0_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            default    : m0_md_access_ok = 7'b0;
        endcase
        case(m1_md_sel)
        /* select certain MD & MD enable & (read request & read_enable) or (write request & write enable) */
            7'b0000_000: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_001: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_010: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_100: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0001_000: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0010_000: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0100_000: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b1000_000: m1_md_access_ok = m1_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            default    : m1_md_access_ok = 7'b0;
        endcase
        case(m2_md_sel)
        /* select certain MD & MD enable & (read request & read_enable) or (write request & write enable) */
            7'b0000_000: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_001: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_010: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0000_100: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0001_000: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0010_000: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b0100_000: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            7'b1000_000: m2_md_access_ok = m2_md_sel & (({7{(~cpu_hmain0_m0_hwrite)}} & srcmd_table.srcmd_r[0]) | ({7{cpu_hmain0_m0_hwrite}} & srcmd_table.srcmd_w[0])) & (srcmd_table.srcmd_en[0]);
            default    : m2_md_access_ok = 7'b0;
        endcase
    end : MemoryDomainPriorityCheck

    always_comb begin : EntryMatching
        case(m0_md_access_ok)
            7'b000_0000: begin /* denied, NO ACCESS*/
                m0_entry_match = 0; //No access
                m0_md_idx = 5'd0;
            end
            7'b000_0001: begin /* MD 0, denied, no access*/
            /* 2 entries */
                m0_md_idx = 5'd0;
                m0_entry_match[0] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr); 
                m0_entry_match[1] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr);
                m0_entry_match[15:2] = 0;
            end
            7'b000_0010: begin /* MD 1*/
            /* 1 entries */ 
                m0_md_idx = 5'd1;
                m0_entry_match[0] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[0].entry_addr);
                m0_entry_match[15:1] = 0;
            end
            7'b000_0100: begin /* MD 2*/
            /* 1 entry */
                m0_md_idx = 5'd2;
                m0_entry_match[0] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[0].entry_addr);
                m0_entry_match[15:1] = 0;
            end
            7'b000_1000: begin /* MD 3*/
            /* 13 entries */
                m0_md_idx = 5'd3;
                m0_entry_match[0]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[0].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr);
                m0_entry_match[1]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr);
                m0_entry_match[2]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[3].entry_addr);
                m0_entry_match[3]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[3].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[4].entry_addr);
                m0_entry_match[4]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[4].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[5].entry_addr);
                m0_entry_match[5]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[5].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[6].entry_addr);
                m0_entry_match[6]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[6].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[7].entry_addr);
                m0_entry_match[7]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[7].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[8].entry_addr);
                m0_entry_match[8]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[8].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[9].entry_addr);
                m0_entry_match[9]     = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[9].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[10].entry_addr);
                m0_entry_match[10]    = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[11].entry_addr);
                m0_entry_match[11]    = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[12].entry_addr);
                m0_entry_match[12]    = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[12].entry_addr);
                m0_entry_match[15:13] = 0;
            end
            7'b001_0000: begin /* MD 4*/
            /*16 entries */
                m0_md_idx = 5'd4;
                m0_entry_match[0]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[0].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr);
                m0_entry_match[1]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr);
                m0_entry_match[2]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[3].entry_addr);
                m0_entry_match[3]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[3].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[4].entry_addr);
                m0_entry_match[4]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[4].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[5].entry_addr);
                m0_entry_match[5]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[5].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[6].entry_addr);
                m0_entry_match[6]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[6].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[7].entry_addr);
                m0_entry_match[7]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[7].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[8].entry_addr);
                m0_entry_match[8]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[8].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[9].entry_addr);
                m0_entry_match[9]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[9].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[10].entry_addr);
                m0_entry_match[10] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[11].entry_addr);
                m0_entry_match[11] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[12].entry_addr);
                m0_entry_match[12] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[12].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[13].entry_addr);
                m0_entry_match[13] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[13].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[14].entry_addr);
                m0_entry_match[14] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[14].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[15].entry_addr);
                m0_entry_match[15] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[15].entry_addr);
            end
            7'b010_0000: begin /* MD 5*/
            /* 16 entries*/
                m0_md_idx = 5'd5;
                m0_entry_match[0]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[0].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr);
                m0_entry_match[1]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr);
                m0_entry_match[2]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[3].entry_addr);
                m0_entry_match[3]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[3].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[4].entry_addr);
                m0_entry_match[4]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[4].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[5].entry_addr);
                m0_entry_match[5]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[5].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[6].entry_addr);
                m0_entry_match[6]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[6].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[7].entry_addr);
                m0_entry_match[7]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[7].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[8].entry_addr);
                m0_entry_match[8]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[8].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[9].entry_addr);
                m0_entry_match[9]  = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[9].entry_addr)  & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[10].entry_addr);
                m0_entry_match[10] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[11].entry_addr);
                m0_entry_match[11] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[12].entry_addr);
                m0_entry_match[12] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[12].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[13].entry_addr);
                m0_entry_match[13] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[13].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[14].entry_addr);
                m0_entry_match[14] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[14].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[15].entry_addr);
                m0_entry_match[15] = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[15].entry_addr);
            end
            7'b100_0000: begin /* MD 6*/
            /* 3 entries*/
                m0_md_idx = 5'd6;
                m0_entry_match[0]    = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr);
                m0_entry_match[1]    = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr);
                m0_entry_match[2]    = (cpu_hmain0_m0_haddr >= mdcfg_table.md_entry_array[m0_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m0_haddr < mdcfg_table.md_entry_array[m0_md_idx].entry_array[3].entry_addr);
                m0_entry_match[15:3] = 0;
            end
            default: begin
                m0_entry_match = 0; 
                m0_md_idx = 5'd0;
            end
        endcase

        case(m1_md_access_ok)
            7'b000_0000: begin /* denied, NO ACCESS*/
                m1_entry_match = 0; //No access
                m1_md_idx = 5'd0;
            end
            7'b000_0001: begin /* MD 0, denied, no access*/
            /* 2 entries */
                m1_md_idx = 5'd0;
                m1_entry_match[0] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr); 
                m1_entry_match[1] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr);
                m1_entry_match[15:2] = 0;
            end
            7'b000_0010: begin /* MD 1*/
            /* 1 entries */ 
                m1_md_idx = 5'd1;
                m1_entry_match[0] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[0].entry_addr);
                m1_entry_match[15:1] = 0;
            end
            7'b000_0100: begin /* MD 2*/
            /* 1 entry */
                m1_md_idx = 5'd2;
                m1_entry_match[0] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[0].entry_addr);
                m1_entry_match[15:1] = 0;
            end
            7'b000_1000: begin /* MD 3*/
            /* 12 entries */
                m1_md_idx = 5'd3;
                m1_entry_match[0]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr);
                m1_entry_match[1]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr);
                m1_entry_match[2]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[3].entry_addr);
                m1_entry_match[3]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[3].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[4].entry_addr);
                m1_entry_match[4]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[4].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[5].entry_addr);
                m1_entry_match[5]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[5].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[6].entry_addr);
                m1_entry_match[6]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[6].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[7].entry_addr);
                m1_entry_match[7]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[7].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[8].entry_addr);
                m1_entry_match[8]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[8].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[9].entry_addr);
                m1_entry_match[9]     = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[9].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[10].entry_addr);
                m1_entry_match[10]    = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[11].entry_addr);
                m1_entry_match[11]    = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[12].entry_addr);
                m1_entry_match[12]    = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[12].entry_addr);
                m1_entry_match[15:13] = 0;
            end
            7'b001_0000: begin /* MD 4*/
            /*16 entries */
                m1_md_idx = 5'd4;
                m1_entry_match[0]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr);
                m1_entry_match[1]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr);
                m1_entry_match[2]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[3].entry_addr);
                m1_entry_match[3]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[3].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[4].entry_addr);
                m1_entry_match[4]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[4].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[5].entry_addr);
                m1_entry_match[5]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[5].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[6].entry_addr);
                m1_entry_match[6]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[6].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[7].entry_addr);
                m1_entry_match[7]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[7].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[8].entry_addr);
                m1_entry_match[8]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[8].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[9].entry_addr);
                m1_entry_match[9]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[9].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[10].entry_addr);
                m1_entry_match[10] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[11].entry_addr);
                m1_entry_match[11] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[12].entry_addr);
                m1_entry_match[12] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[12].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[13].entry_addr);
                m1_entry_match[13] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[13].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[14].entry_addr);
                m1_entry_match[14] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[14].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[15].entry_addr);
                m1_entry_match[15] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[15].entry_addr);
            end
            7'b010_0000: begin /* MD 5*/
            /* 16 entries*/
                m1_md_idx = 5'd5;
                m1_entry_match[0]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr);
                m1_entry_match[1]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr);
                m1_entry_match[2]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[3].entry_addr);
                m1_entry_match[3]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[3].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[4].entry_addr);
                m1_entry_match[4]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[4].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[5].entry_addr);
                m1_entry_match[5]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[5].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[6].entry_addr);
                m1_entry_match[6]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[6].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[7].entry_addr);
                m1_entry_match[7]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[7].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[8].entry_addr);
                m1_entry_match[8]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[8].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[9].entry_addr);
                m1_entry_match[9]  = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[9].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[10].entry_addr);
                m1_entry_match[10] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[11].entry_addr);
                m1_entry_match[11] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[12].entry_addr);
                m1_entry_match[12] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[12].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[13].entry_addr);
                m1_entry_match[13] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[13].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[14].entry_addr);
                m1_entry_match[14] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[14].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[15].entry_addr);
                m1_entry_match[15] = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[15].entry_addr);
            end
            7'b100_0000: begin /* MD 6*/
            /* 3 entries*/
                m1_md_idx = 5'd6;
                m1_entry_match[0]    = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr);
                m1_entry_match[1]    = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr);
                m1_entry_match[2]    = (cpu_hmain0_m1_haddr >= mdcfg_table.md_entry_array[m1_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m1_haddr < mdcfg_table.md_entry_array[m1_md_idx].entry_array[3].entry_addr);
                m1_entry_match[15:3] = 0;
            end
            default: begin
                m1_entry_match = 0; 
                m1_md_idx = 5'd0;
            end
        endcase

        case(m2_md_access_ok)
            7'b000_0000: begin /* denied, NO ACCESS*/
                m2_entry_match = 0; //No access
                m2_md_idx = 5'd0;
            end
            7'b000_0001: begin /* MD 0, denied, no access*/
            /* 2 entries */
                m2_md_idx = 5'd0;
                m2_entry_match[0] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr); 
                m2_entry_match[1] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr);
                m2_entry_match[15:2] = 0;
            end
            7'b000_0010: begin /* MD 1*/
            /* 1 entries */ 
                m2_md_idx = 5'd1;
                m2_entry_match[0] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[0].entry_addr);
                m2_entry_match[15:1] = 0;
            end
            7'b000_0100: begin /* MD 2*/
            /* 1 entry */
                m2_md_idx = 5'd2;
                m2_entry_match[0] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[0].entry_addr);
                m2_entry_match[15:1] = 0;
            end
            7'b000_1000: begin /* MD 3*/
            /* 12 entries */
                m2_md_idx = 5'd3;
                m2_entry_match[0]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr);
                m2_entry_match[1]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr);
                m2_entry_match[2]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[3].entry_addr);
                m2_entry_match[3]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[3].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[4].entry_addr);
                m2_entry_match[4]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[4].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[5].entry_addr);
                m2_entry_match[5]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[5].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[6].entry_addr);
                m2_entry_match[6]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[6].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[7].entry_addr);
                m2_entry_match[7]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[7].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[8].entry_addr);
                m2_entry_match[8]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[8].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[9].entry_addr);
                m2_entry_match[9]     = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[9].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[10].entry_addr);
                m1_entry_match[10]    = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[11].entry_addr);
                m2_entry_match[11]    = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[12].entry_addr);
                m2_entry_match[12]    = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[12].entry_addr);
                m2_entry_match[15:13] = 0;
            end
            7'b001_0000: begin /* MD 4*/
            /*16 entries */
                m2_md_idx = 5'd4;
                m2_entry_match[0]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr);
                m2_entry_match[1]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr);
                m2_entry_match[2]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[3].entry_addr);
                m2_entry_match[3]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[3].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[4].entry_addr);
                m2_entry_match[4]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[4].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[5].entry_addr);
                m2_entry_match[5]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[5].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[6].entry_addr);
                m2_entry_match[6]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[6].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[7].entry_addr);
                m2_entry_match[7]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[7].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[8].entry_addr);
                m2_entry_match[8]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[8].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[9].entry_addr);
                m2_entry_match[9]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[9].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[10].entry_addr);
                m2_entry_match[10] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[11].entry_addr);
                m2_entry_match[11] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[12].entry_addr);
                m2_entry_match[12] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[12].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[13].entry_addr);
                m2_entry_match[13] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[13].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[14].entry_addr);
                m2_entry_match[14] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[14].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[15].entry_addr);
                m2_entry_match[15] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[15].entry_addr);
            end
            7'b010_0000: begin /* MD 5*/
            /* 16 entries*/
                m2_md_idx = 5'd5;
                m2_entry_match[0]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr);
                m2_entry_match[1]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr);
                m2_entry_match[2]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[3].entry_addr);
                m2_entry_match[3]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[3].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[4].entry_addr);
                m2_entry_match[4]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[4].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[5].entry_addr);
                m2_entry_match[5]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[5].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[6].entry_addr);
                m2_entry_match[6]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[6].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[7].entry_addr);
                m2_entry_match[7]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[7].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[8].entry_addr);
                m2_entry_match[8]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[8].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[9].entry_addr);
                m2_entry_match[9]  = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[9].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[10].entry_addr);
                m2_entry_match[10] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[10].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[11].entry_addr);
                m2_entry_match[11] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[11].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[12].entry_addr);
                m2_entry_match[12] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[12].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[13].entry_addr);
                m2_entry_match[13] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[13].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[14].entry_addr);
                m2_entry_match[14] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[14].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[15].entry_addr);
                m2_entry_match[15] = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[15].entry_addr);
            end
            7'b100_0000: begin /* MD 6*/
            /* 3 entries*/
                m2_md_idx = 5'd6;
                m2_entry_match[0]    = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[0].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr);
                m2_entry_match[1]    = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[1].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr);
                m2_entry_match[2]    = (cpu_hmain0_m2_haddr >= mdcfg_table.md_entry_array[m2_md_idx].entry_array[2].entry_addr) & (cpu_hmain0_m2_haddr < mdcfg_table.md_entry_array[m2_md_idx].entry_array[3].entry_addr);
                m2_entry_match[15:3] = 0;
            end
            default: begin
                m2_entry_match = 0; 
                m2_md_idx = 5'd0;
            end
        endcase

    end : EntryMatching

    always_comb begin : EntrySelect
        case(m0_entry_match)
            16'h0001:  begin  m0_entry_idx = 6'd0 ; end
            16'h0002:  begin  m0_entry_idx = 6'd1 ; end
            16'h0004:  begin  m0_entry_idx = 6'd2 ; end
            16'h0008:  begin  m0_entry_idx = 6'd3 ; end
            16'h0010:  begin  m0_entry_idx = 6'd4 ; end
            16'h0020:  begin  m0_entry_idx = 6'd5 ; end
            16'h0040:  begin  m0_entry_idx = 6'd6 ; end
            16'h0080:  begin  m0_entry_idx = 6'd7 ; end
            16'h0100:  begin  m0_entry_idx = 6'd8 ; end
            16'h0200:  begin  m0_entry_idx = 6'd9 ; end
            16'h0400:  begin  m0_entry_idx = 6'd10; end
            16'h0800:  begin  m0_entry_idx = 6'd11; end
            16'h1000:  begin  m0_entry_idx = 6'd12; end
            16'h2000:  begin  m0_entry_idx = 6'd13; end
            16'h4000:  begin  m0_entry_idx = 6'd14; end
            16'h8000:  begin  m0_entry_idx = 6'd15; end
            default :  begin  m0_entry_idx = 6'd0; end
        endcase
        case(m1_entry_match)
            16'h0001:  begin  m1_entry_idx = 6'd0 ; end
            16'h0002:  begin  m1_entry_idx = 6'd1 ; end
            16'h0004:  begin  m1_entry_idx = 6'd2 ; end
            16'h0008:  begin  m1_entry_idx = 6'd3 ; end
            16'h0010:  begin  m1_entry_idx = 6'd4 ; end
            16'h0020:  begin  m1_entry_idx = 6'd5 ; end
            16'h0040:  begin  m1_entry_idx = 6'd6 ; end
            16'h0080:  begin  m1_entry_idx = 6'd7 ; end
            16'h0100:  begin  m1_entry_idx = 6'd8 ; end
            16'h0200:  begin  m1_entry_idx = 6'd9 ; end
            16'h0400:  begin  m1_entry_idx = 6'd10; end
            16'h0800:  begin  m1_entry_idx = 6'd11; end
            16'h1000:  begin  m1_entry_idx = 6'd12; end
            16'h2000:  begin  m1_entry_idx = 6'd13; end
            16'h4000:  begin  m1_entry_idx = 6'd14; end
            16'h8000:  begin  m1_entry_idx = 6'd15; end
            default :  begin  m1_entry_idx = 6'd0; end
        endcase
        case(m2_entry_match)
            16'h0001:  begin  m2_entry_idx = 6'd0 ; end
            16'h0002:  begin  m2_entry_idx = 6'd1 ; end
            16'h0004:  begin  m2_entry_idx = 6'd2 ; end
            16'h0008:  begin  m2_entry_idx = 6'd3 ; end
            16'h0010:  begin  m2_entry_idx = 6'd4 ; end
            16'h0020:  begin  m2_entry_idx = 6'd5 ; end
            16'h0040:  begin  m2_entry_idx = 6'd6 ; end
            16'h0080:  begin  m2_entry_idx = 6'd7 ; end
            16'h0100:  begin  m2_entry_idx = 6'd8 ; end
            16'h0200:  begin  m2_entry_idx = 6'd9 ; end
            16'h0400:  begin  m2_entry_idx = 6'd10; end
            16'h0800:  begin  m2_entry_idx = 6'd11; end
            16'h1000:  begin  m2_entry_idx = 6'd12; end
            16'h2000:  begin  m2_entry_idx = 6'd13; end
            16'h4000:  begin  m2_entry_idx = 6'd14; end
            16'h8000:  begin  m2_entry_idx = 6'd15; end
            default :  begin  m2_entry_idx = 6'd0; end
        endcase
    end : EntrySelect

    always_comb begin : EntryPriorityCheck
        table_read_enable[0]  = mdcfg_table.md_entry_array[m0_md_idx].entry_array[m0_entry_idx].entry_cfg.r;
        table_read_enable[1]  = mdcfg_table.md_entry_array[m1_md_idx].entry_array[m1_entry_idx].entry_cfg.r;
        table_read_enable[2]  = mdcfg_table.md_entry_array[m2_md_idx].entry_array[m2_entry_idx].entry_cfg.r;
        table_write_enable[0] = mdcfg_table.md_entry_array[m0_md_idx].entry_array[m0_entry_idx].entry_cfg.w;
        table_write_enable[1] = mdcfg_table.md_entry_array[m1_md_idx].entry_array[m1_entry_idx].entry_cfg.w;
        table_write_enable[2] = mdcfg_table.md_entry_array[m2_md_idx].entry_array[m2_entry_idx].entry_cfg.w;
        read_enable[0]        = (~cpu_hmain0_m0_hwrite) & (|m0_entry_match) & table_read_enable[0];
        read_enable[1]        = (~cpu_hmain0_m1_hwrite) & (|m1_entry_match) & table_read_enable[1];
        read_enable[2]        = (~cpu_hmain0_m2_hwrite) & (|m2_entry_match) & table_read_enable[2];
        write_enable[0]       = cpu_hmain0_m0_hwrite & (|m0_entry_match) & table_write_enable[0];
        write_enable[1]       = cpu_hmain0_m1_hwrite & (|m1_entry_match) & table_write_enable[1];
        write_enable[2]       = cpu_hmain0_m2_hwrite & (|m2_entry_match) & table_write_enable[2];
        iopmp_deny[0]         = ahb_transit[0] & (read_enable[0] == 1'b0) & (write_enable[0] == 1'b0);        //m0 Missed
        iopmp_deny[1]         = ahb_transit[1] & (read_enable[1] == 1'b0) & (write_enable[1] == 1'b0);        //m1 Missed
        iopmp_deny[2]         = ahb_transit[2] & (read_enable[2] == 1'b0) & (write_enable[2] == 1'b0);        //m2 Missed
    end : EntryPriorityCheck

    always_comb begin : AHB_Out
    access_deny_intr           = |iopmp_deny;                                         //if one deny, trigger exception
    iopmp_cpu_hmain0_m0_haddr  = iopmp_deny[0] ? S11_MDUMMY3 : cpu_hmain0_m0_haddr;   //access a dummy
    iopmp_cpu_hmain0_m0_hburst = iopmp_deny[0] ? 3'b0        : cpu_hmain0_m0_hburst;  //single
    iopmp_cpu_hmain0_m0_hprot  = iopmp_deny[0] ? 4'b1        : cpu_hmain0_m0_hprot ;  //data access, user access
    iopmp_cpu_hmain0_m0_hsize  = iopmp_deny[0] ? 3'b0        : cpu_hmain0_m0_hsize ;  //byte
    iopmp_cpu_hmain0_m0_htrans = iopmp_deny[0] ? 2'b0        : cpu_hmain0_m0_htrans;  //IDLE
    iopmp_cpu_hmain0_m0_hwdata = iopmp_deny[0] ? 32'h0       : cpu_hmain0_m0_hwdata ; //zero
    iopmp_cpu_hmain0_m0_hwrite = iopmp_deny[0] ? 1'b0        : cpu_hmain0_m0_hwrite;  //read
    iopmp_cpu_hmain0_m1_haddr  = iopmp_deny[1] ? S11_MDUMMY3 : cpu_hmain0_m1_haddr;   //access a dummy
    iopmp_cpu_hmain0_m1_hburst = iopmp_deny[1] ? 3'b0        : cpu_hmain0_m1_hburst;  //single
    iopmp_cpu_hmain0_m1_hprot  = iopmp_deny[1] ? 4'b1        : cpu_hmain0_m1_hprot ;  //data access, user access
    iopmp_cpu_hmain0_m1_hsize  = iopmp_deny[1] ? 3'b0        : cpu_hmain0_m1_hsize ;  //byte
    iopmp_cpu_hmain0_m1_htrans = iopmp_deny[1] ? 2'b0        : cpu_hmain0_m1_htrans;  //IDLE
    iopmp_cpu_hmain0_m1_hwdata = iopmp_deny[1] ? 32'h0       : cpu_hmain0_m1_hwdata ; //zero
    iopmp_cpu_hmain0_m1_hwrite = iopmp_deny[1] ? 1'b0        : cpu_hmain0_m1_hwrite;  //read
    iopmp_cpu_hmain0_m2_haddr  = iopmp_deny[2] ? S11_MDUMMY3 : cpu_hmain0_m2_haddr;   //access a dummy
    iopmp_cpu_hmain0_m2_hburst = iopmp_deny[2] ? 3'b0        : cpu_hmain0_m2_hburst;  //single
    iopmp_cpu_hmain0_m2_hprot  = iopmp_deny[2] ? 4'b1        : cpu_hmain0_m2_hprot ;  //data access, user access
    iopmp_cpu_hmain0_m2_hsize  = iopmp_deny[2] ? 3'b0        : cpu_hmain0_m2_hsize ;  //byte
    iopmp_cpu_hmain0_m2_htrans = iopmp_deny[2] ? 2'b0        : cpu_hmain0_m2_htrans;  //IDLE
    iopmp_cpu_hmain0_m2_hwdata = iopmp_deny[2] ? 32'h0       : cpu_hmain0_m2_hwdata ; //zero
    iopmp_cpu_hmain0_m2_hwrite = iopmp_deny[2] ? 1'b0        : cpu_hmain0_m2_hwrite;  //read
    end : AHB_Out

    always_ff @( posedge clk ) begin : Exception_Logic
        if(~resetn)begin
            ahb_exp_addr  <= 0;
            ahb_exp_write <= 0;
        end
        else if(access_deny_intr)begin
            case(iopmp_deny)
                3'b001  : begin 
                    ahb_exp_addr  <= cpu_hmain0_m0_haddr;
                    ahb_exp_write <= cpu_hmain0_m0_hwrite;
                end
                3'b010  : begin 
                    ahb_exp_addr  <= cpu_hmain0_m1_haddr;
                    ahb_exp_write <= cpu_hmain0_m1_hwrite;
                end
                3'b100  : begin 
                    ahb_exp_addr  <= cpu_hmain0_m2_haddr;
                    ahb_exp_write <= cpu_hmain0_m2_hwrite;
                end
                default : begin 
                    ahb_exp_addr  <= S11_MDUMMY3;
                    ahb_exp_write <= 1'b0;
                end
            endcase
        end
        else;
    end

    always_ff @( posedge clk )begin : Read_Exception_Info
        if(~resetn)begin
            iopmp_hready <= 1'b1;
            iopmp_hrdata <= 32'h0;
            iopmp_hresp  <= 2'b00;
        end
        else if(iopmp_htrans == 2'b10)begin //Nonseq
            iopmp_hready <= 1'b1;
            case(iopmp_haddr)
            IOPMP_EXP_ADDR : begin //read-only
                if((iopmp_hwrite == 1'b0) & (iopmp_hsize == 3'd2))begin //trans words
                    iopmp_hrdata <= ahb_exp_addr;
                    iopmp_hresp  <= 2'b00;
                end
                else begin
                    iopmp_hrdata <= 32'h0;
                    iopmp_hresp  <= 2'b01;
                end
            end
            IOPMP_WRITE_ADDR : begin //read-only
                if((iopmp_hwrite == 1'b0) & (iopmp_hsize == 3'd2))begin //trans words
                    iopmp_hrdata <= {31'b0, ahb_exp_write};
                    iopmp_hresp  <= 2'b00;
                end
                else begin
                    iopmp_hrdata <= 32'h0;
                    iopmp_hresp  <= 2'b01;
                end
            end
            default : begin
                iopmp_hrdata <= 32'h0; 
                iopmp_hresp  <= 2'b01;
            end
            endcase
        end
        else if( iopmp_htrans == 2'b00 )begin //no transmit
            iopmp_hrdata <= 32'h0; 
            iopmp_hresp  <= 2'b00;
            iopmp_hready <= 1'b1;
        end
        else begin
            iopmp_hrdata <= 32'h0; 
            iopmp_hresp  <= 2'b01;
            iopmp_hready <= 1'b1;
        end
    end : Read_Exception_Info

endmodule