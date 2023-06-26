`include "iopmp_define.svh"
module sahb_router(
    input clk,
    input resetn,
    /* in AHB*/
    input  logic [3:0]  hmain0_dummy2_s9_hprot,   //to master: CPU2
    input  logic [2:0]  hmain0_dummy2_s9_hsize,   //to master: CPU2
    input  logic [1:0]  hmain0_dummy2_s9_htrans,  //to master: CPU2
    input  logic [31:0] hmain0_dummy2_s9_hwdata,  //to master: CPU2
    input  logic        hmain0_dummy2_s9_hwrite,  //to master: CPU2
    input  logic [31:0] hmain0_dummy2_s9_haddr,   //to master: CPU2
    output logic [31:0] dummy2_hmain0_s9_hrdata,  //to master: CPU2
    output logic        dummy2_hmain0_s9_hready,  //to master: CPU2
    output logic [1:0]  dummy2_hmain0_s9_hresp,   //to master: CPU2
    /* out 2x AHB */
    /* Mailbox AHB */
    output logic [3:0]  mbx_s9_hprot,
    output logic [2:0]  mbx_s9_hsize,
    output logic [1:0]  mbx_s9_htrans,
    output logic [31:0] mbx_s9_hwdata,
    output logic        mbx_s9_hwrite,
    output logic [31:0] mbx_s9_haddr,
    input  logic [31:0] mbx_s9_hrdata,
    input  logic        mbx_s9_hready,
    input  logic [1:0]  mbx_s9_hresp,
    /* IOPMP AHB */
    output logic [3:0]  iopmp_s9_hprot,
    output logic [2:0]  iopmp_s9_hsize,
    output logic [1:0]  iopmp_s9_htrans,
    output logic [31:0] iopmp_s9_hwdata,
    output logic        iopmp_s9_hwrite,
    output logic [31:0] iopmp_s9_haddr,

    input  logic [31:0] iopmp_s9_hrdata,
    input  logic        iopmp_s9_hready,
    input  logic [1:0]  iopmp_s9_hresp
);
    logic [1:0] iopmp_req;
    logic [1:0] iopmp_req_ff; //delay for AHB response
    always_comb begin: address_decode
        iopmp_req[0] = (hmain0_dummy2_s9_haddr == IOPMP_EXP_ADDR);
        iopmp_req[1] = (hmain0_dummy2_s9_haddr == IOPMP_WRITE_ADDR);
    end: address_decode

    always_ff @(posedge clk) begin : AHB_resp_ff
        iopmp_req_ff <= iopmp_req;
    end : AHB_resp_ff

    always_comb begin : mux_out
        case(|iopmp_req)
            1'b1 : begin         //routed to iopmp
                mbx_s9_hprot            = 0;
                mbx_s9_hsize            = 0;
                mbx_s9_htrans           = 0;
                mbx_s9_hwdata           = 0;
                mbx_s9_hwrite           = 0;
                mbx_s9_haddr            = 0;
                iopmp_s9_hprot          = hmain0_dummy2_s9_hprot; 
                iopmp_s9_hsize          = hmain0_dummy2_s9_hsize; 
                iopmp_s9_htrans         = hmain0_dummy2_s9_htrans;
                iopmp_s9_hwdata         = hmain0_dummy2_s9_hwdata;
                iopmp_s9_hwrite         = hmain0_dummy2_s9_hwrite;
                iopmp_s9_haddr          = hmain0_dummy2_s9_haddr; 
            end
            1'b0:  begin //routed to mailbox
                mbx_s9_hprot            = hmain0_dummy2_s9_hprot; 
                mbx_s9_hsize            = hmain0_dummy2_s9_hsize; 
                mbx_s9_htrans           = hmain0_dummy2_s9_htrans;
                mbx_s9_hwdata           = hmain0_dummy2_s9_hwdata;
                mbx_s9_hwrite           = hmain0_dummy2_s9_hwrite;
                mbx_s9_haddr            = hmain0_dummy2_s9_haddr; 
                iopmp_s9_hprot          = 0;
                iopmp_s9_hsize          = 0;
                iopmp_s9_htrans         = 0;
                iopmp_s9_hwdata         = 0;
                iopmp_s9_hwrite         = 0;
                iopmp_s9_haddr          = 0;
            end
        endcase
    end : mux_out

    always_comb begin : AHB_resp_mux
        case(|iopmp_req_ff)
        1'b1 : begin
            dummy2_hmain0_s9_hrdata = iopmp_s9_hrdata;
            dummy2_hmain0_s9_hready = iopmp_s9_hready;
            dummy2_hmain0_s9_hresp  = iopmp_s9_hresp;
        end
        1'b0 :  begin
            dummy2_hmain0_s9_hrdata = mbx_s9_hrdata;
            dummy2_hmain0_s9_hready = mbx_s9_hready;
            dummy2_hmain0_s9_hresp  = mbx_s9_hresp;
        end
        endcase
    end : AHB_resp_mux
    
endmodule