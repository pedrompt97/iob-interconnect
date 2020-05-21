`timescale 1ns / 1ps

`include "interconnect.vh"

module split
  #(
    parameter N_SLAVES = 2
    )
   (
    //masters interface
    input [`REQ_W-1:0]           m_req,
    output [`RESP_W-1:0]         m_resp,

    //slave interface
    input [$clog2(N_SLAVES)-1:0] s_sel,
    output [N_SLAVES*`REQ_W-1:0] s_req,
    input [N_SLAVES*`RESP_W-1:0] s_resp
    );

   //master answered by selected slave 
   assign  m_resp = s_resp[`resp(s_sel)];

   //do the split
   genvar                            i;
   generate 
      for (i=0; i<N_SLAVES; i=i+1) begin : split
        assign s_req[`req(i)] = (s_sel == i)? m_req: (m_req & {1'b0, {`REQ_W-1{1'b1}}});
//        assign s_req[`req(i)] = (s_sel == i)? m_req: 0;
      end
   endgenerate
endmodule
