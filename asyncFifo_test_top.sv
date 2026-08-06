/*Top-level testbench module. Generates the two asynchronous clocks and the
  two resets, instantiates the interface and the DUT (sharing the same
  signals between them), publishes the virtual interface through
  uvm_config_db, and kicks off the UVM test.*/

`timescale 1ns/1ps

module asyncFifo_test_top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fp::*;

    localparam DATA_W = 8;
    localparam ADDR_W = 4;

    // Signals shared between the interface and the DUT
    logic [DATA_W-1:0] wdata;
    logic               winc, wclk, wrst_n;
    logic               rinc, rclk, rrst_n;
    logic [DATA_W-1:0] rdata;
    logic               wfull;
    logic               rempty;

    //-------------------------------------------------
    // Clock generation - two independent, asynchronous clocks
    //-------------------------------------------------
    initial wclk = 1'b0;
    always #5 wclk = ~wclk;      // 100MHz write clock

    initial rclk = 1'b0;
    always #7 rclk = ~rclk;      // ~71MHz read clock

    //-------------------------------------------------
    // Reset generation - asynchronously asserted, held for a while, released
    //-------------------------------------------------
    initial begin
        wrst_n = 1'b0;
        rrst_n = 1'b0;
        #20;
        wrst_n = 1'b1;
        rrst_n = 1'b1;
    end

    //-------------------------------------------------
    // Interface instance - the UVM driver/monitor talk to the DUT through
    // this, via the virtual interface handle published below
    //-------------------------------------------------
    asyncFifo_if #(DATA_W, ADDR_W) fifo_if (
        .wdata  (wdata),
        .winc   (winc),
        .wclk   (wclk),
        .wrst_n (wrst_n),
        .rinc   (rinc),
        .rclk   (rclk),
        .rrst_n (rrst_n),
        .rdata  (rdata),
        .wfull  (wfull),
        .rempty (rempty)
    );

    //-------------------------------------------------
    // DUT instance - connected to the exact same signals as the interface
    // above, so anything the driver puts on fifo_if reaches the DUT
    //-------------------------------------------------
    asyncFifo_top #(DATA_W, ADDR_W) dut (
        .wdata  (wdata),
        .winc   (winc),
        .wclk   (wclk),
        .wrst_n (wrst_n),
        .rinc   (rinc),
        .rclk   (rclk),
        .rrst_n (rrst_n),
        .rdata  (rdata),
        .wfull  (wfull),
        .rempty (rempty)
    );

    //-------------------------------------------------
    // Publish the virtual interface so every component's build_phase can
    // pick it up via uvm_config_db#(virtual asyncFifo_if)::get(...)
    //-------------------------------------------------
    initial begin
        uvm_config_db #(virtual asyncFifo_if)::set(null, "*", "vif", fifo_if);
    end

    //-------------------------------------------------
    // Kick off the test
    //-------------------------------------------------
    initial begin
        run_test("asyncFifo_test");
    end

endmodule //asyncFifo_test_top
