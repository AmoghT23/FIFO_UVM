class asyncFifo_agent extends uvm_agent;
    `uvm_component_utils(asyncFifo_agent)

    asyncFifo_sequencer seqr;
    asyncFifo_driver drv;
    asyncFifo_monitor mon;

    function new(string name="asyncFifo_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("[AFIFO-AGT]", "Inside Build Phase", UVM_HIGH);

        if(is_active == UVM_ACTIVE) begin
            drv = asyncFifo_driver::type_id::create("drv", this);
            seqr = asyncFifo_sequencer::type_id::create("seqr", this);
        end
        mon = asyncFifo_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("[AFIFO-AGT]", "Inside Connect phase", UVM_HIGH);
        if(is_active == UVM_ACTIVE)
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask //

endclass //asyncFifo_agent extends uvm_agent    