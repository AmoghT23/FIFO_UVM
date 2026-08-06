/*This module enclises all the FIFO logic that is generated within the read clock domain (except synchronizers). The read pointer is a dual n-bit Gray code counter. 

***Signals***
rempty :- To check empty before read
rinc :- Read Pointer Increment
rclk :- Read Clock Signal
rrst_n :- Read Reset (Asynchronous Negative) for read pointer
rptr :- Read pointer
rq2_wptr :- Write pointer signal synchronized to the rclk domain via 2 flipflop synchronized
raddr :- Read Address Bits
*/

module asyncFifo_rptr_empty (asyncFifo_if.fifoEmpty f);
                            localparam int ADDR_W = f.ADDR_W;

                            reg [ADDR_W:0] rbin;
                            wire [ADDR_W:0] rgray_next, rbin_next;
                            wire rempty_val;

        //Grey stype pointer counter to generate the read pointer
        always_ff @(posedge f.rclk, negedge f.rrst_n) begin
            if(!f.rrst_n) {rbin, f.rptr} <= '0;
            else {rbin, f.rptr} <= {rbin_next, rgray_next};
        end

        assign f.raddr = rbin[ADDR_W-1:0];

        assign rbin_next = rbin + (f.rinc & !f.rempty);
        assign rgray_next = (rbin_next>>1) ^ rbin_next;

        //FIFO empty logic to check the next rptr == synchronized wptr or on reset condition
        assign rempty_val = (rgray_next == f.rq2_wptr);

        always_ff @(posedge f.rclk, negedge f.rrst_n) begin
            if(!f.rrst_n) f.rempty <= 1'b1;
            else f.rempty <= rempty_val;
        end
endmodule 