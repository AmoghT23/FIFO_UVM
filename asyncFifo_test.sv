/*This is the top-level UVM test. It builds the environment and starts the
  stimulus sequence on the agent's sequencer.*/

class asyncFifo_test extends uvm_test;
    `uvm_component_utils(asyncFifo_test)

    asyncFifo_environment env;
    asyncFifo_sequence     seq;

    function new(string name = "asyncFifo_test", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("[AFIFO-TEST]", "Inside Constructor", UVM_HIGH);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("[AFIFO-TEST]", "Inside Build Phase", UVM_HIGH);

        env = asyncFifo_environment::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("[AFIFO-TEST]", "Starting sequence", UVM_HIGH);

        seq = asyncFifo_sequence::type_id::create("seq");
        seq.start(env.agnt.seqr);

        `uvm_info("[AFIFO-TEST]", "Sequence finished", UVM_HIGH);
        phase.drop_objection(this);
    endtask

endclass //asyncFifo_test extends uvm_test
