/*Top module design of the Asynchronous FIFO based on the Cummings FIFO Design and Verification using UVM

***Signals***
wdata :- Write Data Bits
winc :- Write pointer increment
wclk :- Write Clock Signal
wrst_n :- Write Reset (Asynchronous Negative) for writer pointer
rdata :- Read Data Bits
rinc :- Read Pointer Increment
rclk :- Read Clock Signal
rrst_n :- Read Reset (Asynchronous Negative) for read pointer

wfull :- FIFO Full flag
rempty :- To check empty before read

*/

module asyncFifo_top #(parameter int DATA_W = 8,
                      parameter int ADDR_W = 4)
(
    input  logic [(DATA_W-1):0] wdata,
    input  logic winc, wclk, wrst_n, 
    input  logic rinc, rclk, rrst_n,

    output logic  [(DATA_W-1):0] rdata,
    output logic  wfull,
    output logic  rempty 
);

wire [(ADDR_W-1):0] waddr, raddr;
wire [ADDR_W:0] wptr, rptr, wq2_rptr, rq2_wptr;

asyncFifo_if #(DATA_W, ADDR_W) fifo_if (.*);

// read pointer -> write clock domain, feeds wptr_full
asyncFifo_2FF #(ADDR_W) sync_r2w (.i_clk(wclk), .i_rst_n(wrst_n), .i_ptr(fifo_if.rptr), .o_syncPtr(fifo_if.wq2_rptr));

// write pointer -> read clock domain, feeds rptr_empty
asyncFifo_2FF #(ADDR_W) sync_w2r (.i_clk(rclk), .i_rst_n(rrst_n), .i_ptr(fifo_if.wptr), .o_syncPtr(fifo_if.rq2_wptr));

asyncFifo_mem fifo_mem (.f(fifo_if.fifoMem));

asyncFifo_rptr_empty fifo_rptr_empty (.f(fifo_if.fifoEmpty));

asyncFifo_wptr_full fifo_wptr_full (.f(fifo_if.fifoFull));

endmodule 