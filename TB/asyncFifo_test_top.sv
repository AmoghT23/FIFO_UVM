/*Top-level testbench module. Generates the two asynchronous clocks and the  two resets, instantiates the interface and the DUT (sharing the same  signals between them), publishes the virtual interface through  uvm_config_db, and kicks off the UVM test.*/
`timescale 1ns/1ps

module asyncFifo_test_top;
	import uvm_pkg::*;

	`include "uvm_macros.svh"
	import fp::*;
	localparam DATA_W = 8;
	localparam ADDR_W = 4;

	// Only the clocks and resets are genuinely driven from outside the
	// interface - wdata/winc/rinc/rdata/wfull/rempty are left as the
	// interface's own internal signals (see below) so the UVM driver can
	// procedurally write them through the virtual interface without
	// Questa treating them as externally-bound nets.

	logic wclk, wrst_n;
	logic rclk, rrst_n;

	//-------------------------------------------------
	// Clock generation - two independent, asynchronous clocks
	//-------------------------------------------------
	initial wclk = 1'b0;
	always #5 wclk = ~wclk;		//100MHz write clock
	initial rclk = 1'b0;
	always #7 rclk = ~rclk;		//~71MHz read clock
	
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
	// this, via the virtual interface handle published below.
	// wdata/winc/rinc/rdata/wfull/rempty are deliberately left unconnected
	// here so they stay free internal variables of this one instance
	// (see the DUT instantiation below for how they actually reach the DUT).

	//-------------------------------------------------
	asyncFifo_if #(DATA_W, ADDR_W) fifo_if (.wclk(wclk),
		.wrst_n (wrst_n),.rclk (rclk),.rrst_n (rrst_n),
		.wdata (),.winc(),.rinc(),.rdata(),.wfull(),.rempty ());

	//-------------------------------------------------
	// DUT instance - connected directly into fifo_if's own internal
	// signals (not through intermediate wires), so anything the driver
	// writes via the virtual interface reaches the DUT, and anything the
	// DUT drives out is what the monitor reads via the virtual interface.
	//-------------------------------------------------
	asyncFifo_top #(DATA_W, ADDR_W) dut (.wdata (fifo_if.wdata),
		.winc(fifo_if.winc),.wclk (wclk),.wrst_n (wrst_n),
		.rinc (fifo_if.rinc),.rclk (rclk), .rrst_n (rrst_n), 
		.rdata (fifo_if.rdata),.wfull (fifo_if.wfull),.rempty (fifo_if.rempty));

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

	$dumpfile("asyncFifo_test_top.vcd");
	$dumpvars(0, asyncFifo_test_top);
	end
endmodule //asyncFifo_test_top