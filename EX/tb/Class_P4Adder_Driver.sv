// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.


/*
* DRIVER:
  * Transaction-Level Objects are received from Sequencer
  * Driver drives them to the design via the interface signals
* */

class Class_P4Adder_Driver extends uvm_driver #(Class_P4Adder_SequenceItem);

  // Make driver re-usable
  `uvm_component_utils(Class_P4Adder_Driver);

  // Constructor
  function new(string name = "Class_P4Adder_Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // DUT Virtual interface handle
  virtual Iface_P4Adder #(NBITS) p4adder_dut_iface;
  // Mock clock virtual interface handle
  virtual Iface_MockClock        p4adder_clk_iface;

  /*
  * BUILD PHASE : Check p4adder_dut_iface DB variable exists
  * */
  // NOTE:
  // Function because doesn't consume simulation time
  // Virtual because subclasses may overload it again
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual DUT interface handle from DB
    if (!uvm_config_db#(virtual Iface_P4Adder #(NBITS))::get(
            this, "", "p4adder_dut_iface", p4adder_dut_iface
        )) begin
      `uvm_fatal("[DRIVER]", "Could not get handle to DUT interface!")
    end

    // Get virtual Mock Clock interface handle from DB
    if (!uvm_config_db#(virtual Iface_MockClock)::get(
            this, "", "p4adder_clk_iface", p4adder_clk_iface
        )) begin
      `uvm_fatal("[DRIVER]", "Could not get handle to Mock Clock interface!")
    end

    // coverage on b

  endfunction : build_phase

  /*
  * RUN PHASE : Drive DUT interface signals according to the current
  * Transaction-Level Object sent by Sequencer
  * */
  // NOTE:
  // Task because consumes simulation time!
  // Virtual because subclasses may overload it again
  virtual task run_phase(uvm_phase phase);
    // Transaction Object used to store (current) data sent from Sequencer
    Class_P4Adder_SequenceItem p4adder_seqitem;

    // Just like in C, in SV, statements must follow variable declarations!
    super.run_phase(phase);

    forever begin
      // `uvm_info("[DRIVER]", $sformatf("Waiting for data item from sequencer"), UVM_MEDIUM);

      // Create new Sequence Item to hold current data item
      p4adder_seqitem = Class_P4Adder_SequenceItem::type_id::create("p4adder_seqitem", this);

      // Get next data item
      seq_item_port.get_next_item(p4adder_seqitem);

      // Drive signals on DUT interface at mockClock posedge
      @(posedge p4adder_clk_iface.mockClock);
      p4adder_dut_iface.A   = p4adder_seqitem.A;
      p4adder_dut_iface.B   = p4adder_seqitem.B;
      p4adder_dut_iface.Cin = p4adder_seqitem.Cin;

      // Tell sequence that driver has finished current item
      seq_item_port.item_done();
    end
  endtask : run_phase
endclass



