/*This class is like a bridge which sends the packet to the driver with the TLM */
class asyncFifo_sequencer extends uvm_sequencer #(asyncFifo_packet);
    `uvm_component_utils(asyncFifo_sequencer)     // Component because this is a active class in the UVM  

    //Standard UVM type needs 2 arguments
    function new(string name = "asyncFifo_sequencer", uvm_component parent = null);         //Put the value of parent as NULL 
        super.new(name, parent);
        `uvm_info("[AFIFO-SEQR]", "Inside the Constructor", UVM_HIGH);
    endfunction //new()

    /*This is the build phase which is a top down phase
    The build_phase in UVM is responsible for constructing the testbench hierarchy and configuring its components before simulation starts.
    */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("[AFIFO-SEQR]", "Build Phase", UVM_HIGH);
    endfunction

    /*This is the connect phase which is a bottom up phase
    The connect_phase is where already-created components are connected together.
    */
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("[AFIFO-SEQR]", "Connect Phase", UVM_HIGH);
    endfunction

endclass //asyncFifo_sequencer extends uvm_sequencer