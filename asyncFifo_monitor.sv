/*This class monitors all the transactions that are comming from the DUT*/

class asyncFifo_monitor extends uvm_monitor;
    `uvm_component_utils(asyncFifo_monitor)

    virtual asyncFifo_if vif;
    asyncFifo_packet item;

    /*The analysis port is like a broadcast of the data irrespective of the any feedback from the sender and receiver */
    uvm_analysis_port #(asyncFifo_packet) monitor_port;

    function new(string name = "asyncFifo_monitor", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("[AFIFO-MON]", "Inside the Constructor", UVM_HIGH);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("[AFIFO-MON]", "Insider the BuildPhase", UVM_HIGH);

        /*Creates a handle for the analysis port
        monitor_port - handle (pointer or object reference)
        monitor_port = name of analysis port used for debugging 
        this - parent component (refers to current object)
        new - with new it gets the value and construct memory allocation of the handle earlier */
        monitor_port = new("monitor_port", this);

        if (!uvm_config_db #(virtual asyncFifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("[AFIFO-MON]", "Failed to get the Vif from the config DB");
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("[AFIFO-MON]", "Inside the connect phase", UVM_HIGH);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("[AFIFO-MON]", "Inside the run phase", UVM_HIGH);


            fork
                //For write 
                forever begin
                    @(posedge vif.wclk);

                    if(vif.winc && !vif.wfull) begin
                    //Create new item handle for each transaction
                    item = asyncFifo_packet::type_id::create("item");
                    item.op = asyncFifo_packet::WR;
                    item.data = vif.wdata;
                    monitor_port.write(item);
                    end
                end

                //For read
                forever begin
                    @(posedge vif.rclk);

                    if(vif.rinc && !vif.rempty) begin
                    //Create new item handle for each transaction
                    item = asyncFifo_packet::type_id::create("item");
                    item.op = asyncFifo_packet::RD;
                    item.data = vif.rdata;
                    monitor_port.write(item);
                    end
                end
                join
    endtask

endclass //asyncFifo_monitor extends uvm_monitor