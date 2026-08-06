/*This class connects the dyanmic (OOP) based test environment to the static DUT with the help of virtual interface*/

class asyncFifo_driver extends uvm_driver #(asyncFifo_packet);
    `uvm_component_utils(asyncFifo_driver)

    //To connect the dynamic TB with the static DUT we need virtual interface
    virtual asyncFifo_if vif; 
    //asyncFifo_packet item;  

    function new(string name = "asyncFifo_driver", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("[AFIFO-DRV]", "Inside Constructor", UVM_HIGH);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("[AFIFO-DRV]", "Inside Build Phase", UVM_HIGH);

        if(! uvm_config_db #(virtual asyncFifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("[AFIFO-DRV]", "Failed to get the virtual interface 'vif' from config DB");
        end
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            seq_item_port.get_next_item(req);
            if(req.op == WR) begin
                repeat (req.idleCycles) @(posedge vif.wclk);

                @(posedge vif.wclk) begin
                    vif.wdata <= req.data;
                    vif.winc <= 1'b1;
                end
                
                @(posedge vif.wclk)
                    vif.winc <= 1'b0;
                end 
                else begin
                repeat (req.idleCycles) @(posedge vif.rclk);

                @(posedge vif.rclk)
                    vif.rinc <= 1'b1;

                @(posedge vif.rclk) 
                    vif.rinc <= 1'b0; 
                end
            

            seq_item_port.item_done();
        end
    endtask //

endclass //asyncFifo_driver extends uvm_driver
