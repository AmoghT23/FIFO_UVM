class asyncFifo_scoreboard extends uvm_scoreboard ;
    `uvm_component_utils (asyncFifo_scoreboard)

    //Define analysis TLM interface port 
    uvm_analysis_imp #(asyncFifo_packet, asyncFifo_scoreboard) scoreboard_port;

    //Instantiation for the seq items 
    asyncFifo_packet transactions[$];
    logic [DATA_W-1:0] golden_q[$];

    //UVM Constructor
    function new(string name = "asyncFifo_scoreboard", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("[AFIFO-SCB]", "Inside the Constructor", UVM_HIGH);
    endfunction //new()

    //Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("[AFIFO-SCB]", "Inside Build Phase", UVM_HIGH);
        //Need to create the monitor port
        scoreboard_port = new("scoreboard_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("[AFIFO-SCB]", "Inside Connect Phase", UVM_HIGH);
    endfunction

    function void write(asyncFifo_packet item);
        transactions.push_back(item);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("[AFIFO-SCB]", "Inside Run Phase", UVM_HIGH);

        forever begin
            asyncFifo_packet curr_trans;

            wait ((transactions.size() !=0));
            curr_trans = transactions.pop_front();
            compare(curr_trans);
        end
    endtask

    task compare(asyncFifo_packet curr_trans);
    logic [DATA_W-1:0] expected_data;
    logic [DATA_W-1:0] actual_data;

    if (curr_trans.op == asyncFifo_packet::WR) begin
        golden_q.push_back(curr_trans.data);
        `uvm_info("[AFIFO-SCB]", $sformatf("Write recorded: data=%0h", curr_trans.data), UVM_HIGH);
    end
    else begin
        if (golden_q.size() == 0) begin
            `uvm_error("[AFIFO-SCB]", "Read observed but golden queue is empty!");
        end
        else begin
            expected_data = golden_q.pop_front();
            actual_data   = curr_trans.data;

            if (actual_data != expected_data) begin
                `uvm_error("[AFIFO-SCB]", $sformatf("Transaction Failed! expected: %0h, actual: %0h, operation: %s, idleCycles: %0d", expected_data, actual_data, curr_trans.op.name(), curr_trans.idleCycles));
            end else begin
                `uvm_info("[AFIFO-SCB]", $sformatf("Transaction Passed! data: %0h, operation: %s, idleCycles: %0d", actual_data, curr_trans.op.name(), curr_trans.idleCycles), UVM_HIGH);
            end
        end
    end
endtask

endclass //asyncFifo_scoreboard extends uvm_scoreboard
