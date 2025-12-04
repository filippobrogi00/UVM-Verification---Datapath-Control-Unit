// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* SCOREBOARD :
  * Checks functionality of DUT
  * Receives Transaction-Level Objects via Analysis Port
  * Also implements Assertions so that it can compare the received
  * data items from the Monitor with the "golden model".
* */

class Class_MEMWB_Scoreboard extends uvm_scoreboard;
  `uvm_component_utils(Class_MEMWB_Scoreboard)

  function new(string name = "Class_MEMWB_Scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Analysis Port to receive data objects from other TB components
  uvm_analysis_imp #(Class_MEMWB_SequenceItem, Class_MEMWB_Scoreboard) analysis_port_imp;

  // Define DUT interface (only used for accessing clocking block)
  virtual Iface_MEMWB #(OPCODE_SIZE, FUNC_SIZE) memwb_dut_iface;
  virtual Iface_MEMWB #(OPCODE_SIZE, FUNC_SIZE) memwb_dut_iface;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual Iface_MEMWB #(OPCODE_SIZE, FUNC_SIZE))::get(
            this, "", "memwb_dut_iface", memwb_dut_iface
        )) begin
      `uvm_error("[MONITOR]", "Could not get handle to DUT interface!")
    end

    analysis_port_imp = new("analysis_port_imp", this);

  endfunction : build_phase

  /*
  * WRITE FUNCTION :
    * Monitor sends via Analysis Port a complete transaction to the Scoreboard
    * Here we re-compute the Expected Result and check it against DUTs'
  * */
  virtual function void write(Class_MEMWB_SequenceItem memwb_seqitem);

  endfunction : write

endclass



