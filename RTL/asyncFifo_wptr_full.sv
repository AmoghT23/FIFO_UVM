/* This module encloses all the FIFO logic that is generated within the write clock domain (except synchronizers). This is a dual n-bit Gray code counter.

***Siganls***

wfull :- FIFO Full flag
winc :- Write pointer increment
wclk :- Write Clock Signal
wrst_n :- Write Reset (Asynchronous Negative) for writer pointer
wptr :- Write pointer
wq2_rptr :- Read pointer signal synchronized to the wclk domain via 2 flip flop synchronized
waddr :- Write Address Bits
*/

//Connecting the modules with the interface <interface>.<modport> <portname> is the format. 
module asyncFifo_wptr_full (asyncFifo_if.fifoFull f);       
                            localparam int ADDR_W = f.ADDR_W;
                            reg [ADDR_W:0] wbin;
                            wire [ADDR_W:0] wbinnext, wgraynext;
                            wire wfull_val;

            //Gray style pointer counter to generate the write pointer
            always_ff @(posedge f.wclk, negedge f.wrst_n) begin
                if (!f.wrst_n) {wbin, f.wptr} <= 0;
                else {wbin, f.wptr} <= {wbinnext, wgraynext};
            end

            //Memory write address pointer    
            assign f.waddr = wbin[ADDR_W-1:0];

            assign wbinnext = wbin + (f.winc & !f.wfull);
            assign wgraynext = (wbinnext>>1) ^ wbinnext;

            //Simplified version of the FIFO full logic to check the next wptr == synchronized rptr with the MSB inverted or on reset condition

            assign wfull_val = (wgraynext == {~f.wq2_rptr[ADDR_W:ADDR_W-1] , f.wq2_rptr[ADDR_W-2:0]});

            always_ff @(posedge f.wclk, negedge f.wrst_n) begin
                if(!f.wrst_n) f.wfull <= 1'b0;
                else f.wfull <= wfull_val;
            end
endmodule 