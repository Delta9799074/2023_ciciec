/*
*Revision History:
*2023/5/24 
*--add clear_intr
*--change output
*/
module mailbox_channel(
    input                clk,
    input                rstn,
    /*READ WRITE*/
    input       [2:0]    wen,
    input       [31:0]   wdata,
    input       [2:0]    ren,
    output reg  [31:0]   rdata,
    /*INTERRUPT*/
    input                clear_intr,
    output               int_flag,
    /*TRANSFER DATA*/
    /*TRANSFER INSTRUCTION*/
    output      [31:0]   ch_ctrl,
    output      [31:0]   ch_status
);
/*
*CTRL REG
*/
reg         INT_ctrl_bit;       /*Interrupt from particular channel*/
reg [1:0]   mailbox_mode;       /*01: transfer data; 10:transfer addresss; 11:transfer command */
reg [13:0]  len_data;           /*transferring data length*/
reg         read_ok;            /*0: NOT read by destination core; 1:read by destination core*/
reg [13:0]  ctrl_reserved = 0;  /*reserved*/
                               /*
*DATA REG
*/
reg [31:0] data_reg;
/*
*STATUS REG
*/
reg INT_bit; /*Interrupt from the channel*/
reg STS_bit; /*1: channel is used for inter-processor communication*/
/*
*WRITE LOGIC
*/
always@(posedge clk) begin
    if(~rstn)begin
        INT_ctrl_bit  <= 1'b0;
        mailbox_mode  <= 2'b0; 
        len_data      <= 14'b0;
        read_ok       <= 1'b0;
        ctrl_reserved <= 14'b0;
        data_reg      <= 32'b0;
        INT_bit       <= 1'b0;
        STS_bit       <= 1'b0;
    end
    else begin
/*         //ctrl
        INT_ctrl_bit  <= INT_ctrl_bit  | wdata[31]    & {wen[0]};
        mailbox_mode  <= mailbox_mode  | wdata[30:29] & {2{wen[0]}};
        len_data      <= len_data      | wdata[28:15] & {14{wen[0]}};
        read_ok       <= read_ok       | wdata[14]    & {wen[0]};
        ctrl_reserved <= ctrl_reserved | wdata[13:0]  & {15{wen[0]}};
        //data
        data_reg      <= data_reg      | wdata[31:0]  & {32{wen[1]}};
        //status
        INT_bit       <= clear_intr ? 1'b0 : (INT_bit | wdata[1] & wen[2]);
        STS_bit       <= STS_bit       | wdata[0] & wen[2]; */
        INT_ctrl_bit  <= wen[0] ? wdata[31] : INT_ctrl_bit;
        mailbox_mode  <= wen[0] ? wdata[30:29] : mailbox_mode;
        len_data      <= wen[0] ? wdata[28:15] : len_data;
        read_ok       <= wen[0] ? wdata[14] : read_ok;
        ctrl_reserved <= wen[0] ? wdata[13:0] : ctrl_reserved;

        data_reg      <= wen[1] ? wdata[31:0] : data_reg;

        INT_bit       <= clear_intr ? 1'b0 : (wen[2] ? wdata[1] : INT_bit);
        STS_bit       <= wen[2] ? wdata[0] : STS_bit; 
    end
end

/*always @(*) begin
    case(ren)
        001:     rdata = {INT_ctrl_bit, mailbox_mode, len_data, read_ok, 14'b0};
        010:     rdata = data_reg;
        100:     rdata = {30'b0, INT_bit, STS_bit};
        default: rdata = 32'b0;
    endcase
end*/
always @(*) begin
    case(ren)
        3'b000:  rdata <= 32'b0;
        3'b001:  rdata <= {INT_ctrl_bit, mailbox_mode, len_data, read_ok, 14'b0};
        3'b010:  rdata <= data_reg;
        3'b100:  rdata <= {30'b0, INT_bit, STS_bit};
        default: rdata <= 32'b0;
    endcase
end
//assign rdata = {{INT_ctrl_bit, mailbox_mode, len_data, read_ok, 14'b0} & {32{ren[0]}}} | {data_reg & {32{ren[1]}}} | {{30'b0, INT_bit, STS_bit} & {32{ren[2]}}};

assign ch_ctrl         = {INT_ctrl_bit, mailbox_mode, len_data, read_ok, 14'b0};
assign ch_status       = {30'b0, INT_bit, STS_bit};
assign int_flag        = INT_ctrl_bit && INT_bit;
endmodule