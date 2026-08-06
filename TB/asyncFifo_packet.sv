/*This class contains all the constraints and the vital information of the input data */

class asyncFifo_packet extends uvm_sequence_item;
    // Register the class with UVM factory so that we can edit the class in the future and create objects of this class using the factory.
    `uvm_object_utils (asyncFifo_packet);   // Object because this is a passive class in the UVM        

    rand logic [DATA_W-1:0] data;
    rand int unsigned idleCycles;

    /*Constraint:1 Controlling the operation for the FIFO either a read or a write.
    Used Enum for the weighted operation of the FIFO. The read and write operations are equally weighted at 50% each.*/

    typedef enum {WR, RD} op_type;
    rand op_type op;

    constraint readWriteC {op dist {WR:= 50, RD:= 50};}

    /*Constraint 2: To check the number of idle cycles between the read and write operations. 

    constraint idleCyclesC {if (op==WR) idleCycles inside {[0:5]}; 
                            else idleCycles inside {[0:10]};}
    */
    constraint idleCyclesC {if (op==WR) idleCycles dist {0:= 50 , [1:5]:/50}; 
                            else idleCycles dist {0:= 50, [1:10]:/50};}

    /*Constraint 3: To force the data to be written in FIFO test extreme values which are 0x00 and 0xFF with other random values. 
    */
    constraint dataD {if (op == WR)data dist {'h0:= 25, '1:=25, ['h1:'hFE]:/50};}

    //Standard UVM constructor for the class
    function new(string name = "asyncFifo_packet");
        super.new(name);    //Create a new object of the class and call the parent class constructor
        `uvm_info("[AFIFO-PKT-SEQ-IT]","Constraints initialized for data with DataWidth = 8", UVM_LOW);
    endfunction //new()
endclass //asyncFifo_packet extends uvm_sequence_item
