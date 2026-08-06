package fp;
    
    parameter int ADDR_W = 4;
    parameter int DATA_W = 8;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "asyncFifo_packet.sv"
    `include "asyncFifo_sequence.sv"
    `include "asyncFifo_sequencer.sv"
    `include "asyncFifo_driver.sv"
    `include "asyncFifo_monitor.sv"
    `include "asyncFifo_agent.sv"
    `include "asyncFifo_scoreboard.sv"
    `include "asyncFifo_coverage.sv"
    `include "asyncFifo_environment.sv"
    `include "asyncFifo_test.sv"
endpackage