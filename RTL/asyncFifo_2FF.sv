/*This is the 2FF synchronizer module to synchronize the read pointer to the write clock domain and vice versa. 
This is a two way synchronizer module which is direction agnostic. It can be used to synchronize the read pointer to the write clock domain and vice versa.

***Signals***
i_clk :- Input clock signal to synchronize the pointer
i_rst_n :- Input reset signal to reset the synchronizer
i_ptr :- Input pointer to be synchronized
o_syncPtr :- Output synchronized pointer
q1_ptr :- First flip-flop to hold the input pointer
q2_ptr :- Second flip-flop to hold the synchronized pointer
*/

module asyncFifo_2FF #(parameter int ADDR_W = 4) 
(
    input logic i_clk, i_rst_n,
    input logic [ADDR_W:0] i_ptr, 
    output logic [ADDR_W:0] o_syncPtr
);
    reg [ADDR_W:0] q1_ptr, q2_ptr; 
    
    always_ff @(posedge i_clk, negedge i_rst_n) begin
        if(! i_rst_n)
            {q1_ptr, q2_ptr} <= '0;
        else
            {q1_ptr, q2_ptr} <= {i_ptr, q1_ptr};
    end

    always_comb o_syncPtr = q2_ptr;
endmodule