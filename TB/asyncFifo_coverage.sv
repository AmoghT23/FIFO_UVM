class asyncFifo_coverage extends uvm_subscriber #(asyncFifo_packet);
    `uvm_component_utils(asyncFifo_coverage)

    asyncFifo_packet pkt;

    real cov;

    covergroup cg;
        coverpoint pkt.op {
            bins opRD = {RD};
            bins opWR = {WR};
        }

        coverpoint pkt.idleCycles {
            bins opidleCycles = {0};
            bins opidleCycles1 = {[1:5]};
            bins opidleCycles2 = {[6:10]};
        }
        IO_cross: cross pkt.op, pkt.idleCycles;

        coverpoint pkt.data {
            bins data0 = {'0};
            bins data1 = {'1};
            bins data2 = {['h1:'hFE]};
        }
    endgroup

    function new(string name = "asyncFifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        
        pkt = asyncFifo_packet::type_id::create("pkt");
        cg = new();
    endfunction //new()

    virtual function void write(input asyncFifo_packet t);
        `uvm_info(get_type_name(), "Reading the data from monitor for coverage", UVM_NONE);
        t.print();

        pkt = t;

        cg.sample();
        cov = cg.get_coverage();
    endfunction
endclass //asyncFifo_coverage extends uvm_subscriber #(asyncFifo_packet)
