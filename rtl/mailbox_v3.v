/*
2023/5/15
v3.0
2 channel
*revision history:
*2023/5/16
*set hsel global
*NO BURST, default SINGLE
*changed transfer size
*add htrans logic
*1 interrupt transfer 1 data
*/
module my_mailbox(
    /*GLOBAL*/
    input                   hrst_b,           
    input                   hclk, 
    input                   hsel,
    /*CORE0*/
    input       [3 :0]      c0_hprot,                 
    input       [2 :0]      c0_hsize,  //Only 000(byte),001(half word), 010(word)      
    input       [1 :0]      c0_htrans, //IDLE(00),BUSY(01),NONSEQ(10),SEQ(11)      
    input       [31:0]      c0_hwdata,       
    input                   c0_hwrite,
    input       [31:0]      c0_haddr, 

    output  reg [31:0]      c0_hrdata,
    output  reg             c0_hready,  
    output  reg [1 :0]      c0_hresp,    
    output	                c0_tx_intr,   
    /*CORE1*/
    input       [3 :0]      c1_hprot,                 
    input       [2 :0]      c1_hsize,   //Only 000(byte),001(half word), 010(word)      
    input       [1 :0]      c1_htrans,  //IDLE(00),BUSY(01),NONSEQ(10),SEQ(11)       
    input       [31:0]      c1_hwdata,       
    input                   c1_hwrite,
    input       [31:0]      c1_haddr, 

    output  reg [31:0]      c1_hrdata,
    output  reg             c1_hready,  
    output  reg [1 :0]      c1_hresp,    
    output	                c1_tx_intr   
); //AHB interface
parameter CHANNEL_NUM     = 2;                 //0 for TEE2REE, 1 for REE2TEE
parameter EMPTY_NUM       = 32 - CHANNEL_NUM;
parameter BASE_ADDR       = 32'h4003_0000;
parameter TEE_END_ADDR    = BASE_ADDR + 8 + (((CHANNEL_NUM/2)*3) << 2) ;
parameter REE_END_ADDR    = BASE_ADDR + 8 + (((CHANNEL_NUM)*3) << 2) ;
parameter ACSR_ADDR       = 32'h4003_0000;
parameter ACISR_ADDR      = 32'h4003_0004;
parameter CH0_CTRL_ADDR   = 32'h4003_0008;
parameter CH0_DATA_ADDR   = 32'h4003_000C;
parameter CH0_STATUS_ADDR = 32'h4003_0010;
parameter CH1_CTRL_ADDR   = 32'h4010_0014;
parameter CH1_DATA_ADDR   = 32'h4010_0018;
parameter CH1_STATUS_ADDR = 32'h4010_001C;
parameter HTRANS_IDLE     = 2'b00;
parameter HTRANS_BUSY     = 2'b01;
parameter HTRANS_NONSEQ   = 2'b10;
parameter HTRANS_SEQ      = 2'b11; //no seq
//2023/05/24
parameter CH_IDLE         = 3'b000;
parameter CH_WRITE        = 3'b001;
parameter CH_WAIT_READ    = 3'b010;
parameter CH_READ_END     = 3'b011;

parameter CLEAR_INT_CMD   = 32'h0000_4000;
/* 
*
//TEE CPU R/W, REE CPU READ ONLY
*---------------------------------
*CHANNEL 0/1 ADDR
*----------------------------------
*       CORE0 -> CORE1
*ch0: 32'h4020_0008 - 32h'4020_0010
*--ctrl_reg: 32'h4020_0008
*--data_reg: 32'h4020_000C
*--stat_reg: 32'h4020_0010
*       CORE1 -> CORE0
*ch1: 32'h4020_0014 - 32h'4020_001C
*--ctrl_reg: 32'h4020_0014
*--data_reg: 32'h4020_0018
*--stat_reg: 32'h4020_001C
*/
reg [2:0] ch0_cstate, ch1_cstate;
reg [2:0] ch0_nstate, ch1_nstate;
wire [2:0]  mb_c02c1_wen, mb_c12c0_wen;
wire [2:0]  ch0_ren, ch1_ren;
wire [13:0] c02c1_trans_len, c12c0_trans_len;
reg  [13:0] c02c1_read_ptr, c12c0_read_ptr, c02c1_write_ptr, c12c0_write_ptr;
reg  [2:0]  mb_c02c1_wen_delay, mb_c12c0_wen_delay;
reg  [2:0]  ch0_ren_delay, ch1_ren_delay;
reg         c0_hwrite0, c0_hwrite1, c1_hwrite0, c1_hwrite1;
wire        c0_hwrite_pedge, c0_hwrite_nedge, c1_hwrite_pedge, c1_hwrite_nedge;
reg  [31:0] c02c1_clr_status, c12c0_clr_status;
reg         c02c1_clr_intr, c12c0_clr_intr;
reg  [31:0] c02c1_wdata, c12c0_wdata;


///2023/05/24
reg         c0_hwrite_delay, c1_hwrite_delay;
reg  [31:0] c0_haddr_delay, c1_haddr_delay;
reg  [3:0]  c0_hprot_delay, c1_hprot_delay;
reg  [2:0]  c0_hsize_delay, c1_hsize_delay;
reg  [1:0]  c0_htrans_delay, c1_htrans_delay;
reg         hsel_delay;
//2023/05/24
reg          ch0_clear_intr, ch1_clear_intr;
//CTRLs
(*mark_debug = "true"*)wire [31:0] ch0_ctrl, ch1_ctrl;
wire        ch0_int_enable, ch0_read_ok, ch1_int_enable, ch1_read_ok;
wire [1:0]  ch0_trans_mode, ch1_trans_mode;
wire [13:0] ch0_trans_len, ch1_trans_len;

// TODO: 2023/06/20
reg [31:0] acsr, acisr;
always @(posedge hclk) begin
    if(~hrst_b)begin
        acisr  <= 0;
    end
    else begin
        acisr <= {30'b0, c1_tx_intr, c0_tx_intr};
    end
end

wire [31:0] c0_hrdata_temp;
wire [31:0] c1_hrdata_temp;
always @(*) begin
    if(c0_haddr_delay == ACISR_ADDR && (c0_hwrite_delay == 1'b0))begin
        c0_hrdata <= acisr;
    end
    else begin
        c0_hrdata <= c0_hrdata_temp;
    end
end

always @(*) begin
    if(c1_haddr_delay == ACISR_ADDR && (c1_hwrite_delay == 1'b0))begin
        c1_hrdata <= acisr;
    end
    else begin
        c1_hrdata <= c1_hrdata_temp;
    end
end

assign ch0_int_enable = ch0_ctrl[31];
assign ch0_trans_mode = ch0_ctrl[30:29];
assign ch0_trans_len  = ch0_ctrl[28:15];
assign ch0_read_ok    = (ch0_ctrl == CLEAR_INT_CMD);

assign ch1_int_enable = ch1_ctrl[31];
assign ch1_trans_mode = ch1_ctrl[30:29];
assign ch1_trans_len  = ch1_ctrl[28:15];
assign ch1_read_ok    = (ch1_ctrl == CLEAR_INT_CMD);
//Status
(*mark_debug = "true"*)wire [31:0] ch0_status, ch1_status;
wire        ch0_int_status, ch1_int_status;
assign ch0_int_status = ch0_status[1];
assign ch1_int_status = ch1_status[1];

(*mark_debug = "true"*)wire [31:0] ch0_data, ch1_data;



mailbox_channel c02c1(
    .clk        (hclk),
    .rstn       (hrst_b),
    .wen        (mb_c02c1_wen),
    .wdata      (c02c1_wdata),
    .ren        (ch0_ren),
    .rdata      (c0_hrdata_temp),
    .clear_intr (ch0_clear_intr), //2023/05/24
    .int_flag   (c1_tx_intr),
    .ch_ctrl    (ch0_ctrl),
    .ch_status  (ch0_status),
    .ch_data    (ch0_data)
);

mailbox_channel c12c0(
    .clk        (hclk),
    .rstn       (hrst_b),
    .wen        (mb_c12c0_wen),
    .wdata      (c12c0_wdata),
    .ren        (ch1_ren),
    .rdata      (c1_hrdata_temp),
    .clear_intr (ch1_clear_intr), //2023/05/24
    .int_flag   (c0_tx_intr),
    .ch_ctrl    (ch1_ctrl),         //2023/05/24
    .ch_status  (ch1_status),      //2023/05/24
    .ch_data    (ch1_data)
);
//WRITE CHANNEL REG ENABLE
//ch0
assign mb_c02c1_wen[0] =  hsel_delay && c0_hwrite_delay && (c0_haddr_delay == CH0_CTRL_ADDR)    && (c0_htrans_delay == HTRANS_NONSEQ) && (ch0_nstate != CH_WAIT_READ);
assign mb_c02c1_wen[1] =  hsel_delay && c0_hwrite_delay && (c0_haddr_delay == CH0_DATA_ADDR)    && (c0_htrans_delay == HTRANS_NONSEQ) && (ch0_nstate != CH_WAIT_READ);
assign mb_c02c1_wen[2] =  hsel_delay && c0_hwrite_delay && (c0_haddr_delay == CH0_STATUS_ADDR)  && (c0_htrans_delay == HTRANS_NONSEQ) && (ch0_nstate != CH_WAIT_READ);
//ch1
assign mb_c12c0_wen[0] =  hsel_delay && c1_hwrite_delay && (c1_haddr_delay == CH1_CTRL_ADDR)    && (c1_htrans_delay == HTRANS_NONSEQ) && (ch1_nstate != CH_WAIT_READ);
assign mb_c12c0_wen[1] =  hsel_delay && c1_hwrite_delay && (c1_haddr_delay == CH1_DATA_ADDR)    && (c1_htrans_delay == HTRANS_NONSEQ) && (ch1_nstate != CH_WAIT_READ);
assign mb_c12c0_wen[2] =  hsel_delay && c1_hwrite_delay && (c1_haddr_delay == CH1_STATUS_ADDR)  && (c1_htrans_delay == HTRANS_NONSEQ) && (ch1_nstate != CH_WAIT_READ);
//READ CHANNEL REG ENABLE
//ch0
assign ch0_ren[0] = hsel_delay && (~c0_hwrite_delay) && (c0_haddr_delay == CH0_CTRL_ADDR)   && (c0_htrans_delay == HTRANS_NONSEQ);
assign ch0_ren[1] = hsel_delay && (~c0_hwrite_delay) && (c0_haddr_delay == CH0_DATA_ADDR)   && (c0_htrans_delay == HTRANS_NONSEQ);
assign ch0_ren[2] = hsel_delay && (~c0_hwrite_delay) && (c0_haddr_delay == CH0_STATUS_ADDR) && (c0_htrans_delay == HTRANS_NONSEQ);
//ch1
assign ch1_ren[0] = hsel_delay && (~c1_hwrite_delay) && (c1_haddr_delay == CH1_CTRL_ADDR)   && (c1_htrans_delay == HTRANS_NONSEQ);
assign ch1_ren[1] = hsel_delay && (~c1_hwrite_delay) && (c1_haddr_delay == CH1_DATA_ADDR)   && (c1_htrans_delay == HTRANS_NONSEQ);
assign ch1_ren[2] = hsel_delay && (~c1_hwrite_delay) && (c1_haddr_delay == CH1_STATUS_ADDR) && (c1_htrans_delay == HTRANS_NONSEQ);

always @(posedge hclk) begin
    if (~hrst_b) begin
        mb_c02c1_wen_delay <= 0;
        mb_c12c0_wen_delay <= 0;
        c0_hwrite_delay    <= 0;
        c1_hwrite_delay    <= 0;
        c0_haddr_delay     <= 0;
        c1_haddr_delay     <= 0;
        c0_hprot_delay     <= 0;
        c1_hprot_delay     <= 0;
        c0_hsize_delay     <= 0;
        c1_hsize_delay     <= 0;
        c0_htrans_delay    <= 0;
        c1_htrans_delay    <= 0;
        hsel_delay         <= 0;
    end
    else begin
        mb_c02c1_wen_delay <= mb_c02c1_wen;
        mb_c12c0_wen_delay <= mb_c12c0_wen;
        c0_hwrite_delay    <= c0_hwrite;
        c1_hwrite_delay    <= c1_hwrite;
        c0_haddr_delay     <= c0_haddr;
        c1_haddr_delay     <= c1_haddr; 
        c0_hprot_delay     <= c0_hprot;
        c1_hprot_delay     <= c1_hprot;
        c0_hsize_delay     <= c0_hsize;
        c1_hsize_delay     <= c1_hsize;
        c0_htrans_delay    <= c0_htrans;
        c1_htrans_delay    <= c1_htrans;
        hsel_delay         <= hsel;       
    end
end

always @(posedge hclk) begin
    if (~hrst_b) begin
        ch0_ren_delay <= 0;
        ch1_ren_delay <= 0;
    end
    else begin
        ch0_ren_delay <= ch0_ren;
        ch1_ren_delay <= ch1_ren;
    end
end

/*posedge negedge detect*/
always @(posedge hclk) begin
    if (~hrst_b) begin
        c0_hwrite0 <= 0;
        c0_hwrite1 <= 0;
        c1_hwrite0 <= 0;
        c1_hwrite1 <= 0;
    end
    else begin
        c0_hwrite0 <= c0_hwrite;
        c0_hwrite1 <= c0_hwrite0;
        c1_hwrite0 <= c1_hwrite;
        c1_hwrite1 <= c1_hwrite0;
    end
end
assign c0_hwrite_pedge = c0_hwrite0 && (~c0_hwrite1);
assign c0_hwrite_nedge = (~c0_hwrite0) && c0_hwrite1;
assign c1_hwrite_pedge = c1_hwrite0 && (~c1_hwrite1);
assign c1_hwrite_nedge = (~c1_hwrite0) && c1_hwrite1;

/*
*Core 0 -> Core1*/

//Core0 -> Core1 Write Pointer
always @(posedge hclk) begin
    if (~hrst_b) begin
        c02c1_write_ptr <= 0;
    end
    else if (mb_c02c1_wen_delay[0]) begin //write ctrl register
        c02c1_write_ptr <= c02c1_trans_len;
    end
    else if (mb_c02c1_wen[1]) begin //Core0 write data register
        c02c1_write_ptr <= c02c1_write_ptr - 1;
    end
    else ;
end
//Core0 -> Core1 Read Pointer
always @(posedge hclk) begin
    if (~hrst_b) begin
        c02c1_read_ptr  <= 0;
        //c02c1_write_ptr <= 0;
    end
    //Core0 has written ctrl register, delay assures ctrl register is already set.
    else if (mb_c02c1_wen_delay[0]) begin 
        c02c1_read_ptr  <= c02c1_trans_len;
    end
    else if (ch0_ren[1]) begin //Core1 read
        c02c1_read_ptr <= c02c1_read_ptr - 1;
    end
    else ;
end
/*
//call Core0 to write next data
always @(posedge hclk) begin
    if(~hrst_b)begin
        c0_hready <= 0;
    end
    else begin
        //Core0 -> Core1, if Core1 has read data register, Core0 Mailbox is ready for receiving next data.
        //Core1 read condition: select Mailbox, set direction(hwrite), address
        c0_hready <= ch0_ren_delay[1];
    end
end
//call Core1 to read next data
always @(posedge hclk) begin
    if(~hrst_b)begin
        c1_hready <= 0;
    end
    else begin
        //Core 0 -> Core1, if Core0 has written data register, Core1 Mailbox is ready for transmittering next data.
        //Core0 write condition: select Mailbox, set direction(hwrite), address
        c1_hready <= mb_c02c1_wen_delay[1];
    end
end
*/
//Clear intrrupt
always @(posedge hclk) begin
    if (~hrst_b) begin
        c02c1_clr_intr   <= 1'b0;
        c02c1_clr_status <= 32'b0;
    end
    else if ((c02c1_write_ptr==0)  && (c02c1_read_ptr==0) && c1_tx_intr) begin
        c02c1_clr_intr   <= 1'b1;
        c02c1_clr_status <= 32'b0;
    end
    else ;
end
always @(*) begin
    /*if(c02c1_clr_intr)begin
        c02c1_wdata = c02c1_clr_status;
    end
    else */if (mb_c02c1_wen == 3'b010) begin //write data reg
            if (c0_hsize_delay == 3'b000) begin
                c02c1_wdata = {24'b0, c0_hwdata[7:0]};
            end
            else if (c0_hsize_delay == 3'b001) begin
                c02c1_wdata = {16'b0, c0_hwdata[15:0]};    
            end
            else if (c0_hsize_delay == 3'b010) begin
                c02c1_wdata = c0_hwdata;
            end
            else begin
                c02c1_wdata = 0;
            end
    end
    else begin
        c02c1_wdata = c0_hwdata;
    end
end

/*
*Core1 -> Core0*/
//Core1 -> Core0 Write Pointer
always @(posedge hclk) begin
    if (~hrst_b) begin
        c12c0_write_ptr <= 0;
    end
    else if (mb_c12c0_wen_delay[0]) begin //Core1 write ctrl register
        c12c0_write_ptr <= c12c0_trans_len;
    end
    else if (ch1_ren[1]) begin //Core1 write
        c12c0_write_ptr <= c12c0_write_ptr - 1;
    end
    else ;
end

//Core1 -> Core0 Read Pointer
always @(posedge hclk) begin
    if (~hrst_b) begin
        c12c0_read_ptr <= 0;
    end
    else if (mb_c12c0_wen_delay[0]) begin //Core1 write ctrl register
        c12c0_read_ptr <= c12c0_trans_len;
    end
    else if (ch1_ren[1]) begin //Core0 read
        c12c0_read_ptr <= c12c0_read_ptr - 1;
    end
    else ;
end

/* //call Core1 to write next data
always @(posedge hclk) begin
    if(~hrst_b)begin
        c1_hready <= 0;
    end
    else begin
        c1_hready <= ch1_ren_delay[1]; //Core0 read
    end
end

//call Core0 to read next data
always @(posedge hclk) begin
    if(~hrst_b)begin
        c0_hready <= 0;
    end
    else begin
        c0_hready <= mb_c12c0_wen_delay[1]; //Core1 write
    end
end */
//Clear intrrupt
/*always @(posedge hclk) begin
    if (~hrst_b) begin
        c12c0_clr_intr   <= 1'b0;
        c12c0_clr_status <= 32'b0;
    end
    else if ((c12c0_read_ptr==0) && (c12c0_write_ptr==0) && c0_tx_intr) begin
        c12c0_clr_intr   <= 1'b1;
        c12c0_clr_status <= 32'b0;
    end
    else ;
end*/
always @(*) begin
    /*if(c12c0_clr_intr)begin
        c12c0_wdata = c12c0_clr_status;
    end
    else */if (mb_c12c0_wen == 3'b010) begin
        if (c1_hsize_delay == 3'b000) begin
            c12c0_wdata = {24'b0, c1_hwdata[7:0]};
        end
        else if (c1_hsize_delay == 3'b001) begin
            c12c0_wdata = {16'b0, c1_hwdata[15:0]};    
        end
        else if (c1_hsize_delay == 3'b010) begin
            c12c0_wdata = c1_hwdata;
        end
        else begin
            c12c0_wdata = 0;
        end
    end
    else begin
        c12c0_wdata = c1_hwdata;
    end
end

//C0 hready
/*always @(posedge hclk) begin
    if (~hrst_b) begin
        c0_hready <= 1'b0;
    end
    else if (|mb_c02c1_wen_delay) begin  //Write
        c0_hready <= 1'b1;
    end
    //Read
    else if (ch1_ren[0]) begin //c0 read ctrl register
        c0_hready <= 1'b1;
    end
    else if (ch1_ren[2]) begin //c0 read status register
        c0_hready <= 1'b1;
    end
    else if (ch1_ren[1]) begin //c0 read data register
        //MUST c1 writing finished
        c0_hready <= c1_hready && mb_c12c0_wen_delay[1];
    end
    else begin
        c0_hready <= 1'b0;
    end
end
*/
//C1 hready
/*always @(posedge hclk) begin
    if (~hrst_b) begin
        c1_hready <= 1'b0;
    end
    else if (|mb_c12c0_wen_delay) begin  //c1 write
        c1_hready <= 1'b1;
    end
    //Read
    else if (ch0_ren[0]) begin //c1 read ctrl register
        c1_hready <= 1'b1;
    end
    else if (ch0_ren[2]) begin //c1 read status register
        c1_hready <= 1'b1;
    end
    else if (ch0_ren[1]) begin //c1 read data register
        //MUST c0 writing finished
        c1_hready <= c0_hready && mb_c02c1_wen_delay[1];
    end
    else begin
        c1_hready <= 1'b0;
    end
end*/
always @(posedge hclk) begin
    if(~hrst_b)begin
        c0_hresp <= 2'b00;
    end
    else begin
        case(c0_htrans_delay)
            HTRANS_IDLE:    c0_hresp <= 2'b00;
            HTRANS_BUSY:    c0_hresp <= 2'b00;
            HTRANS_NONSEQ:  c0_hresp <= (hsel && c0_hwrite && ((c0_haddr == CH1_DATA_ADDR) | (c0_haddr == CH1_CTRL_ADDR) | (c0_haddr == CH1_STATUS_ADDR))) ? 2'b01 : 2'b00;
            HTRANS_SEQ:     c0_hresp <= 2'b01; //no seq
            default:        c0_hresp <= 2'b10; //retry
        endcase
    end
end

always @(posedge hclk) begin
    if(~hrst_b)begin
        c1_hresp <= 2'b00;
    end
    else begin
        case(c1_htrans_delay)
        HTRANS_IDLE:    c1_hresp <= 2'b00;
        HTRANS_BUSY:    c1_hresp <= 2'b00;
        HTRANS_NONSEQ:  c1_hresp <= (hsel && c1_hwrite && ((c1_haddr == CH0_DATA_ADDR) | (c1_haddr == CH0_CTRL_ADDR) | (c1_haddr == CH0_STATUS_ADDR))) ? 2'b01 : 2'b00;
        HTRANS_SEQ:     c1_hresp <= 2'b01; //no seq
        default:        c1_hresp <= 2'b10; //retry
        endcase
    end
end

//2023/05/24
//Channels FSM
//Channel 0 FSM
always @(posedge hclk) begin
    if(~hrst_b)begin
        ch0_cstate <= CH_IDLE;
    end
    else begin
        ch0_cstate <= ch0_nstate;
    end
end

always @(*) begin
    case(ch0_cstate)
        CH_IDLE     : ch0_nstate = (|mb_c02c1_wen_delay & hsel) ? CH_WRITE     : CH_IDLE;
        CH_WRITE    : ch0_nstate = c1_tx_intr             ? CH_WAIT_READ : CH_WRITE;
        CH_WAIT_READ: ch0_nstate = ch1_read_ok            ? CH_READ_END  : CH_WAIT_READ;
        CH_READ_END : ch0_nstate = CH_IDLE;
        default     : ch0_nstate = CH_IDLE;
    endcase
end

    always @(posedge hclk) begin
        if (~hrst_b) begin
            ch0_clear_intr <= 1'b0;
            c0_hready      <= 1'b1;
        end
        else begin //master wants to transfer data to the other master
            case(ch0_cstate)
                CH_IDLE : begin
                    ch0_clear_intr <= 1'b0;
                    c0_hready      <= 1'b1;
                end
                CH_WRITE: begin
                    ch0_clear_intr <= 1'b0;
                    c0_hready      <= 1'b1;
                end
                CH_WAIT_READ: begin
                    ch0_clear_intr <= 1'b0;
                    c0_hready      <= 1'b1;
                end
                CH_READ_END : begin
                    ch0_clear_intr <= 1'b1; 
                    c0_hready      <= 1'b1;                   
                end
                default:begin
                    ch0_clear_intr <= 1'b0;
                    c0_hready      <= 1'b0;
                end
            endcase
        end
    end
//Channel 1 FSM
    always @(posedge hclk) begin
        if(~hrst_b)begin
            ch1_cstate <= CH_IDLE;
        end
        else begin
            ch1_cstate <= ch1_nstate;
        end
    end
    
    always @(*) begin
        case(ch1_cstate)
            CH_IDLE     : ch1_nstate = (|mb_c12c0_wen_delay & hsel) ? CH_WRITE     : CH_IDLE;
            CH_WRITE    : ch1_nstate = c0_tx_intr             ? CH_WAIT_READ : CH_WRITE;
            CH_WAIT_READ: ch1_nstate = ch0_read_ok            ? CH_READ_END  : CH_WAIT_READ;
            CH_READ_END : ch1_nstate = CH_IDLE;
            default     : ch1_nstate = CH_IDLE;
        endcase
    end
    
        always @(posedge hclk) begin
            if (~hrst_b) begin
                ch1_clear_intr <= 1'b0;
                c1_hready      <= 1'b1;
            end
            else begin //master wants to transfer data to the other master
                case(ch1_cstate)
                    CH_IDLE : begin
                        ch1_clear_intr <= 1'b0;
                        c1_hready      <= 1'b1;
                    end
                    CH_WRITE: begin
                        ch1_clear_intr <= 1'b0;
                        c1_hready      <= 1'b1;
                    end
                    CH_WAIT_READ: begin
                        ch1_clear_intr <= 1'b0;
                        c1_hready      <= 1'b1;
                    end
                    CH_READ_END : begin
                        ch1_clear_intr <= 1'b1; 
                        c1_hready      <= 1'b1;                   
                    end
                    default:begin
                        ch1_clear_intr <= 1'b0;
                        c1_hready      <= 1'b1;
                    end
                endcase
            end
        end
endmodule