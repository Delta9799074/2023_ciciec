/*
2023/07/10
v4.0
2 channel
*revision history:
*2023/07/10
-Change to SystemVerilog
*/
`include "mbx.svh"
module my_mailbox(
    /*GLOBAL*/
    input logic             hrst_b,           
    input logic             hclk, 
    input logic             hsel,
    /*CORE0*/
    input logic [3 :0]      c0_hprot,                 
    input logic [2 :0]      c0_hsize,  //Only 000(byte),001(half word), 010(word)      
    input logic [1 :0]      c0_htrans, //IDLE(00),BUSY(01),NONSEQ(10),SEQ(11)      
    input logic [31:0]      c0_hwdata,       
    input logic             c0_hwrite,
    input logic [31:0]      c0_haddr, 

    output  logic [31:0]     c0_hrdata,
    output  logic            c0_hready,  
    output  logic [1 :0]     c0_hresp,    
    output	logic            c0_tx_intr,   
    /*CORE1*/
    input  logic [3 :0]      c1_hprot,                 
    input  logic [2 :0]      c1_hsize,   //Only 000(byte),001(half word), 010(word)      
    input  logic [1 :0]      c1_htrans,  //IDLE(00),BUSY(01),NONSEQ(10),SEQ(11)       
    input  logic [31:0]      c1_hwdata,       
    input  logic             c1_hwrite,
    input  logic [31:0]      c1_haddr, 

    output logic [31:0]      c1_hrdata,
    output logic             c1_hready,  
    output logic [1 :0]      c1_hresp,    
    output logic             c1_tx_intr   
); //AHB interface
channel_state ch0_cstate, ch1_cstate, ch0_nstate, ch1_nstate;
logic [2:0]  ch0_wen, ch1_wen;
logic [2:0]  ch0_ren, ch1_ren;
logic [13:0] ch0_trans_len, ch1_trans_len;
logic [2:0]  ch0_ren_delay, ch1_ren_delay;
logic [2:0]  ch0_wen_delay, ch1_wen_delay;
logic        c0_hwrite0, c0_hwrite1, c1_hwrite0, c1_hwrite1;
logic        c0_hwrite_pedge, c0_hwrite_nedge, c1_hwrite_pedge, c1_hwrite_nedge;
logic        ch0_intr_clr, ch1_intr_clr;
logic [31:0] ch0_wdata, ch1_wdata;

///2023/05/24
logic         c0_hwrite_delay, c1_hwrite_delay;
logic  [31:0] c0_haddr_delay, c1_haddr_delay;
logic  [3:0]  c0_hprot_delay, c1_hprot_delay;
logic  [2:0]  c0_hsize_delay, c1_hsize_delay;
logic  [1:0]  c0_htrans_delay, c1_htrans_delay;
logic         hsel_delay;
//2023/05/24
logic         ch0_clear_intr, ch1_clear_intr;
//CTRLs
(*mark_debug = "true"*)logic [31:0] ch0_ctrl, ch1_ctrl;
logic        ch0_int_enable, ch0_read_ok, ch1_int_enable, ch1_read_ok;
logic [1:0]  ch0_trans_mode, ch1_trans_mode;

// TODO: 2023/06/20
logic [31:0] acsr, acisr;
always_ff @(posedge hclk) begin
    if(~hrst_b)begin
        acisr  <= 0;
    end
    else begin
        acisr <= {30'b0, c1_tx_intr, c0_tx_intr};
    end
end

logic [31:0] c0_hrdata_temp;
logic [31:0] c1_hrdata_temp;
always_comb begin
    if(c0_haddr_delay == ACISR_ADDR && (c0_hwrite_delay == 1'b0))begin
        c0_hrdata = acisr;
    end
    else begin
        c0_hrdata = c0_hrdata_temp;
    end
end

always_comb begin
    if(c1_haddr_delay == ACISR_ADDR && (c1_hwrite_delay == 1'b0))begin
        c1_hrdata = acisr;
    end
    else begin
        c1_hrdata = c1_hrdata_temp;
    end
end

assign ch0_int_enable = ch0_ctrl[31];
assign ch0_trans_mode = ch0_ctrl[30:29];
assign ch0_trans_len  = ch0_ctrl[28:15];

assign ch1_int_enable = ch1_ctrl[31];
assign ch1_trans_mode = ch1_ctrl[30:29];
assign ch1_trans_len  = ch1_ctrl[28:15];
//Status
(*mark_debug = "true"*)logic [31:0] ch0_status, ch1_status;
logic        ch0_int_status, ch1_int_status;
assign ch0_int_status = ch0_status[1];
assign ch1_int_status = ch1_status[1];

(*mark_debug = "true"*)logic [31:0] ch0_data, ch1_data;

mailbox_channel my_mbx_ch0(
    .clk        (hclk),
    .rstn       (hrst_b),
    .wen        (ch0_wen),
    .wdata      (ch0_wdata),
    .ren        ({ch0_ren_delay[2], ch0_ren[1], ch0_ren_delay[0]}),
    .rdata      (c0_hrdata_temp),
    .int_flag   (c1_tx_intr),
    .ch_ctrl    (ch0_ctrl),
    .ch_status  (ch0_status),
    .ch_data    (ch0_data),
    .read_ok    (ch0_read_ok)
);

mailbox_channel my_mbx_ch1(
    .clk        (hclk),
    .rstn       (hrst_b),
    .wen        (ch1_wen),
    .wdata      (ch1_wdata),
    .ren        ({ch1_ren_delay[2], ch1_ren[1], ch1_ren_delay[0]}),
    .rdata      (c1_hrdata_temp),
    .int_flag   (c0_tx_intr),
    .ch_ctrl    (ch1_ctrl),         //2023/05/24
    .ch_status  (ch1_status),      //2023/05/24
    .ch_data    (ch1_data),
    .read_ok    (ch1_read_ok) //?2023/07/11
);
//WRITE CHANNEL REG ENABLE
//ch0
assign ch0_wen[0] = hsel_delay && c0_hwrite_delay && (c0_haddr_delay == CH0_CTRL_ADDR  )  && (c0_htrans_delay == HTRANS_NONSEQ) && (ch0_nstate != CH_WAIT_READ);
assign ch0_wen[1] = hsel_delay && c0_hwrite_delay && (c0_haddr_delay == CH0_DATA_ADDR  )  && (c0_htrans_delay == HTRANS_NONSEQ) && (ch0_nstate != CH_WAIT_READ);
assign ch0_wen[2] = hsel_delay && c0_hwrite_delay && (c0_haddr_delay == CH0_STATUS_ADDR)  && (c0_htrans_delay == HTRANS_NONSEQ) && (ch0_nstate != CH_WAIT_READ);
//ch1
assign ch1_wen[0] = hsel_delay && c1_hwrite_delay && (c1_haddr_delay == CH1_CTRL_ADDR  )  && (c1_htrans_delay == HTRANS_NONSEQ) && (ch1_nstate != CH_WAIT_READ);
assign ch1_wen[1] = hsel_delay && c1_hwrite_delay && (c1_haddr_delay == CH1_DATA_ADDR  )  && (c1_htrans_delay == HTRANS_NONSEQ) && (ch1_nstate != CH_WAIT_READ);
assign ch1_wen[2] = hsel_delay && c1_hwrite_delay && (c1_haddr_delay == CH1_STATUS_ADDR)  && (c1_htrans_delay == HTRANS_NONSEQ) && (ch1_nstate != CH_WAIT_READ);
/* //READ CHANNEL REG ENABLE
//ch0
assign ch0_ren[0] = hsel_delay && (~c0_hwrite_delay) && (c0_haddr_delay == CH0_CTRL_ADDR  ) && (c0_htrans_delay == HTRANS_NONSEQ);
assign ch0_ren[1] = hsel_delay && (~c0_hwrite_delay) && (c0_haddr_delay == CH0_DATA_ADDR  ) && (c0_htrans_delay == HTRANS_NONSEQ);
assign ch0_ren[2] = hsel_delay && (~c0_hwrite_delay) && (c0_haddr_delay == CH0_STATUS_ADDR) && (c0_htrans_delay == HTRANS_NONSEQ);
//ch1
assign ch1_ren[0] = hsel_delay && (~c1_hwrite_delay) && (c1_haddr_delay == CH1_CTRL_ADDR  ) && (c1_htrans_delay == HTRANS_NONSEQ);
assign ch1_ren[1] = hsel_delay && (~c1_hwrite_delay) && (c1_haddr_delay == CH1_DATA_ADDR  ) && (c1_htrans_delay == HTRANS_NONSEQ);
assign ch1_ren[2] = hsel_delay && (~c1_hwrite_delay) && (c1_haddr_delay == CH1_STATUS_ADDR) && (c1_htrans_delay == HTRANS_NONSEQ); */


assign ch0_ren[0] = hsel && (~c0_hwrite) && (c0_haddr == CH0_CTRL_ADDR  ) && (c0_htrans == HTRANS_NONSEQ);
assign ch0_ren[1] = hsel && (~c0_hwrite) && (c0_haddr == CH0_DATA_ADDR  ) && (c0_htrans == HTRANS_NONSEQ);
assign ch0_ren[2] = hsel && (~c0_hwrite) && (c0_haddr == CH0_STATUS_ADDR) && (c0_htrans == HTRANS_NONSEQ);
//ch1
assign ch1_ren[0] = hsel && (~c1_hwrite) && (c1_haddr == CH1_CTRL_ADDR  ) && (c1_htrans == HTRANS_NONSEQ);
assign ch1_ren[1] = hsel && (~c1_hwrite) && (c1_haddr == CH1_DATA_ADDR  ) && (c1_htrans == HTRANS_NONSEQ);
assign ch1_ren[2] = hsel && (~c1_hwrite) && (c1_haddr == CH1_STATUS_ADDR) && (c1_htrans == HTRANS_NONSEQ); 

always_ff @(posedge hclk) begin
    if (~hrst_b) begin
        ch0_wen_delay   <= 0;
        ch1_wen_delay   <= 0;
        c0_hwrite_delay <= 0;
        c1_hwrite_delay <= 0;
        c0_haddr_delay  <= 0;
        c1_haddr_delay  <= 0;
        c0_hprot_delay  <= 0;
        c1_hprot_delay  <= 0;
        c0_hsize_delay  <= 0;
        c1_hsize_delay  <= 0;
        c0_htrans_delay <= 0;
        c1_htrans_delay <= 0;
        hsel_delay      <= 0;
    end
    else begin
        ch0_wen_delay   <= ch0_wen;
        ch1_wen_delay   <= ch1_wen;
        c0_hwrite_delay <= c0_hwrite;
        c1_hwrite_delay <= c1_hwrite;
        c0_haddr_delay  <= c0_haddr;
        c1_haddr_delay  <= c1_haddr;
        c0_hprot_delay  <= c0_hprot;
        c1_hprot_delay  <= c1_hprot;
        c0_hsize_delay  <= c0_hsize;
        c1_hsize_delay  <= c1_hsize;
        c0_htrans_delay <= c0_htrans;
        c1_htrans_delay <= c1_htrans;
        hsel_delay      <= hsel;
    end
end

always_ff @(posedge hclk) begin
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
always_ff @(posedge hclk) begin
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

always_comb begin : Channel0Write
    if (ch0_wen == 3'b010) begin //write data reg
        if (c0_hsize_delay == 3'b000) begin
            ch0_wdata = {24'b0, c0_hwdata[7:0]};
        end
        else if (c0_hsize_delay == 3'b001) begin
            ch0_wdata = {16'b0, c0_hwdata[15:0]};    
        end
        else if (c0_hsize_delay == 3'b010) begin
            ch0_wdata = c0_hwdata;
        end
        else begin
            ch0_wdata = 0;
        end
    end
    else begin
        ch0_wdata = c0_hwdata;
    end
end : Channel0Write

always_comb begin
if (ch1_wen == 3'b010) begin
    if (c1_hsize_delay == 3'b000) begin
        ch1_wdata = {24'b0, c1_hwdata[7:0]};
    end
    else if (c1_hsize_delay == 3'b001) begin
        ch1_wdata = {16'b0, c1_hwdata[15:0]};    
    end
    else if (c1_hsize_delay == 3'b010) begin
        ch1_wdata = c1_hwdata;
    end
    else begin
        ch1_wdata = 0;
    end
end
else begin
    ch1_wdata = c1_hwdata;
end
end

always_ff @(posedge hclk) begin : Core0_hresp
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
end : Core0_hresp

always_ff @(posedge hclk) begin : Core1_hresp
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
end : Core1_hresp

//2023/05/24
//Channels FSM
//Channel 0 FSM
always_ff @(posedge hclk) begin
    if(~hrst_b)begin
        ch0_cstate <= CH_IDLE;
    end
    else begin
        ch0_cstate <= ch0_nstate;
    end
end

always_comb begin
    case(ch0_cstate)
        CH_IDLE     : ch0_nstate = (ch0_wen[1] & hsel_delay)? CH_WRITE   : CH_IDLE;
        CH_WRITE    : ch0_nstate = c1_tx_intr             ? CH_WAIT_READ : CH_WRITE;
        CH_WAIT_READ: ch0_nstate = ch1_read_ok            ? CH_READ_END  : CH_WAIT_READ;
        CH_READ_END : ch0_nstate = CH_IDLE;
        default     : ch0_nstate = CH_IDLE;
    endcase
end

always_ff @(posedge hclk) begin
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
always_ff @(posedge hclk) begin
    if(~hrst_b)begin
        ch1_cstate <= CH_IDLE;
    end
    else begin
        ch1_cstate <= ch1_nstate;
    end
end

always_comb begin
    case(ch1_cstate)
        CH_IDLE     : ch1_nstate = (ch1_wen[1] & hsel_delay)? CH_WRITE   : CH_IDLE;
        CH_WRITE    : ch1_nstate = c0_tx_intr             ? CH_WAIT_READ : CH_WRITE;
        CH_WAIT_READ: ch1_nstate = ch0_read_ok            ? CH_READ_END  : CH_WAIT_READ;
        CH_READ_END : ch1_nstate = CH_IDLE;
        default     : ch1_nstate = CH_IDLE;
    endcase
end

always_ff @(posedge hclk) begin
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