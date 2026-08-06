class asyncFifo_environment extends uvm_env;
  `uvm_component_utils(asyncFifo_environment);

  asyncFifo_agent agnt;
  asyncFifo_scoreboard scb;
  asyncFifo_coverage cov;

  function new(string name = "asyncFifo_environment", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("[AFIFO-ENV]", "Inside Constructor", UVM_HIGH);
  endfunction //new()

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[AFIFO-ENV]", "Inside Build Phase", UVM_HIGH);

    agnt = asyncFifo_agent::type_id::create("agnt", this);
    scb = asyncFifo_scoreboard::type_id::create("scb", this);
    cov = asyncFifo_coverage::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("[AFIFO-ENV]", "Inside Connect Phase", UVM_HIGH);

    agnt.mon.monitor_port.connect(scb.scoreboard_port);
    agnt.mon.monitor_port.connect(cov.analysis_export);
  endfunction
endclass //asyncFifo extends uvm_environment