/*In this class we actually generate the packets with the constraints mentioned earlier and then they are sent to the sequencer -> driver.*/

class asyncFifo_sequence extends uvm_sequence #(asyncFifo_packet);
// Register the class with UVM factory so that we can edit the class in the future and create objects of this class using the factory.
    `uvm_object_utils(asyncFifo_sequence);      // Object because this is a passive class in the UVM  

    // Packet object to hold the data and control information for the FIFO operations
    asyncFifo_packet pkt;

    //Standard UVM constructor for the class
    function new(string name = "asyncFifo_sequence");
        super.new(name);
        `uvm_info("[AFIFO-SEQ]", "Inside the sequence constructor", UVM_LOW);
    endfunction

    //Task body where the sequence of the operations are defined and the packets are generated and sent to the driver for execution. 
    task body();

    repeat(10) begin
        //Creating factory object that gives UVM to override whenever needed. 
        pkt = asyncFifo_packet::type_id::create("asyncFifo_packet");
        start_item(pkt);
        //Adding a self checking if randomization fails it would throw a fatal error and stop the simulation.
        if (!pkt.randomize())
            `uvm_fatal("[AFIFO-SEQ]", "Randomization has failed for the packet generation");
        // Display the generated packet with some vital information.
        `uvm_info("[AFIFO-SEQ]", $sformatf("Packet generated with data: %0h, operation: %s, idleCycles: %0d", pkt.data, pkt.op.name(), pkt.idleCycles), UVM_LOW);
        finish_item(pkt);
    end
    endtask
endclass
