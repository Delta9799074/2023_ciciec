/*
*Revision History:
*2023/07/10
*--Change to SystemVerilog
*/
`include "mbx.svh"
module mailbox_channel(
    input  logic           clk,
    input  logic           rstn,
    /*READ WRITE*/
    input  logic  [2:0]    wen,
    input  logic  [31:0]   wdata,
    input  logic  [2:0]    ren,
    output logic  [31:0]   rdata,
    /*INTERRUPT*/
    output logic           int_flag,
    /*TRANSFER DATA*/
    /*TRANSFER INSTRUCTION*/
    output logic [31:0]   ch_ctrl,
    output logic [31:0]   ch_status,
    output logic [31:0]   ch_data,
    output logic          read_ok
);
mbx_ctrl_reg ctrl_reg;
mbx_status_reg status_reg;
/*
*DATA REG
*/
logic [31:0] data_reg;
logic full;
logic empty;
logic [7:0] debug_rd_cnt;
logic [7:0] debug_wr_cnt;
data_fifo0 data_fifo_ch0(
  .wr_clk        (clk),            // input wire wr_clk
  .rd_clk        (clk),            // input wire rd_clk
  .din           (wdata),          // input wire [31 : 0] din
  .wr_en         (wen[1]),         // input wire wr_en
  .rd_en         (ren[1]),         // input wire rd_en
  .dout          (data_reg),       // output wire [31 : 0] dout
  .full          (full),           // output wire full
  .empty         (empty),          // output wire empty
  .rd_data_count (debug_rd_cnt),   // output wire [7 : 0] rd_data_count
  .wr_data_count (debug_wr_cnt)    // output wire [7 : 0] wr_data_count
);

/*
*WRITE LOGIC
*/
always_ff @( posedge clk ) begin : WriteRegs
    if(~rstn)begin
        ctrl_reg    <= '{default:0};
        status_reg  <= '{default:0};
    end
    else begin
        status_reg.int_bit <= empty ? 1'b0     : (wen[2]) ? wdata[1] : status_reg.int_bit;
        status_reg.sts_bit <= wen[2]? wdata[0] : status_reg.sts_bit;
        case(wen)
            3'b001: begin 
                ctrl_reg.int_ctrl_bit       <= wdata[31];
                ctrl_reg.mbx_mode           <= wdata[30:29];
                ctrl_reg.trans_len          <= wdata[28:15];
                ctrl_reg.read_ok            <= wdata[14];
                ctrl_reg.mbx_addrmode_write <= wdata[13];
            end
            3'b010: begin 
                ctrl_reg    <= ctrl_reg;
            end
            3'b100:
             begin 
                ctrl_reg    <= ctrl_reg;
            end
            default : begin 
                ctrl_reg   <= ctrl_reg; 
            end
        endcase
    end
end : WriteRegs

logic [2:0] ren_delay;

always_ff @(posedge clk)begin
    ren_delay <= ren;
end

always_comb begin
    case({ren[2], ren_delay[1], ren[0]})
        3'b000:  rdata = 32'b0;
        3'b001:  rdata = ctrl_reg;
        3'b010:  rdata = data_reg;
        3'b100:  rdata = status_reg;
        default: rdata = 32'b0;
    endcase
end 

assign ch_ctrl   = ctrl_reg;
assign ch_status = status_reg;
assign ch_data   = data_reg;
assign int_flag  = status_reg.int_bit && status_reg.sts_bit;
assign read_ok   = empty;
endmodule