/* This is the interface of an Asynchronous FIFO based on the Cummings FIFO Design and Verification using UVM

***Signals*** 
DATA_W :- Parameterized Data Width
ADDR_W :- Parameterized Address Width

wdata :- Write Data Bits
winc :- Write pointer increment  
wclk :- Write Clock Signal
wrst_n :- Write Reset (Asynchronous Negative) for writer pointer
wfull :- FIFO Full flag 
w_clken :- Write Clock enable, controls the write operation to the FIFO memory. Data must not be written if the FIFO is full (wfull=1)
w_ptr :- Write Pointer

rdata :- Read Data Bits 
rinc :- Read Pointer Increment
rclk :- Read Clock Signal
rrst_n :- Read Reset (Asynchronous Negative) for read pointer 
rempty :- To check empty before read
rptr :- Read pointer

wq2_rptr :- Read pointer signal synchronized to the wclk domain via 2 flipflop synchronized
rq2_wptr :- Write pointer signal synchronized to the rclk domain via 2 flipflop synchronized
*/

interface asyncFifo_if #(parameter int DATA_W = 8, 
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
wire wclken;
assign wclken = (winc & ~wfull);

modport fifoMem (
input wdata, waddr, raddr, wclk, wclken,
output rdata
);

modport fifoFull (
input wq2_rptr, winc, wclk, wrst_n,
output waddr, wptr, wfull
);

modport fifoEmpty (
input rq2_wptr, rinc, rclk, rrst_n,
output raddr, rptr, rempty
);
    
endinterface //asyncFifo