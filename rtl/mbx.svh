`ifndef MBX_SVH
`define MBX_SVH
//localparam CHANNEL_NUM     = 2;                 //0 for TEE2REE, 1 for REE2TEE
//localparam EMPTY_NUM       = 32 - CHANNEL_NUM;
localparam BASE_ADDR       = 32'h4003_0000;
//localparam TEE_END_ADDR    = BASE_ADDR + 8 + (((CHANNEL_NUM/2)*3) << 2) ;
//localparam REE_END_ADDR    = BASE_ADDR + 8 + (((CHANNEL_NUM)*3) << 2) ;
localparam ACSR_ADDR       = 32'h4003_0000;
localparam ACISR_ADDR      = 32'h4003_0004;
localparam CH0_CTRL_ADDR   = 32'h4003_0008;
localparam CH0_DATA_ADDR   = 32'h4003_000C;
localparam CH0_STATUS_ADDR = 32'h4003_0010;
localparam CH1_CTRL_ADDR   = 32'h4010_0014;
localparam CH1_DATA_ADDR   = 32'h4010_0018;
localparam CH1_STATUS_ADDR = 32'h4010_001C;
localparam CLEAR_INT_CMD   = 32'h0000_4000;

typedef enum logic [1:0] { HTRANS_IDLE, HTRANS_BUSY, HTRANS_NONSEQ, HTRANS_SEQ } htrans_state;
typedef enum logic [1:0] { CH_IDLE, CH_WRITE, CH_WAIT_READ, CH_READ_END} channel_state;
typedef struct packed {
    logic int_ctrl_bit;         /*Interrupt from particular channel*/
    logic [1:0]  mbx_mode;      /*01: transfer data; 10:transfer addresss; 11:transfer command */
    logic [13:0] trans_len;     /*transferring data length*/
    logic read_ok;              /*0: NOT read by destination core; 1:read by destination core*/
    logic mbx_addrmode_write;   /*0: read; 1:write*/
    logic [12:0] reserved;  /*reserved*/
} mbx_ctrl_reg;

typedef struct packed {
    logic [29:0] reserved;
    logic int_bit;  /*Interrupt from the channel*/
    logic sts_bit;  /*1: channel is used for inter-processor communication*/
} mbx_status_reg;
`endif