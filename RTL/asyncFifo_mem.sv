/* The FIFO memory buffer is typically a dual-port synchronous memory device. 


*** Signals ***
rdata :- Read Data Bits
wdata :- Write Data Bits
waddr :- Write Address Bits
raddr :- Read Address Bits
wclk :- Write Clock Signal
wclken :- Write Clock enable, controls the write operation to the FIFO memory. Data must not be written if the FIFO is full (wfull=1)
wfull :- FIFO Full flag */

module asyncFifo_mem (asyncFifo_if.fifoMem f);
                       localparam int DATA_W = f.DATA_W;
                       localparam int ADDR_W = f.ADDR_W;
                       localparam int DEPTH = 1 << ADDR_W;

logic [DATA_W-1:0] mem [DEPTH-1:0];

assign f.rdata = mem[f.raddr];

always_ff @(posedge f.wclk) begin
    if(f.wclken && !f.wfull) 
        mem[f.waddr] <= f.wdata;
end
endmodule 