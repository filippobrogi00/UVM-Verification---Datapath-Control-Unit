// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* SCOREBOARD :
  * Checks functionality of DUT
  * Receives Transaction-Level Objects via Analysis Port
  * Also implements Assertions so that it can compare the received
  * data items from the Monitor with the "golden model".
* */

class Class_IFID_Scoreboard extends uvm_scoreboard;

  // Register to Factory
  `uvm_component_utils(Class_IFID_Scoreboard)

  // Constructor
  function new(string name = "Class_IFID_Scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Analysis Port to receive data objects from other TB components
  uvm_analysis_imp #(Class_IFID_SequenceItem, Class_IFID_Scoreboard) analysis_port_imp;

  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Instance the Analysis Port
    analysis_port_imp = new("analysis_port_imp", this);
  endfunction : build_phase

  /*
  * WRITE FUNCTION :
    * Monitor sends via Analysis Port a complete transaction to the Scoreboard
    * Here we re-compute the Expected Result and check it against DUTs'
  * */
  virtual function void write(Class_IFID_SequenceItem ifid_seqitem);

    // Expected Result variables declaration
    logic [NBITS-1:0] expectedSum;
    logic expectedCout;

    // Variables to hold conversions from DUT output bit vectors to signed types
    // (mainly for clean output error formatting)
    int signed sint_A, sint_B, sint_Cin, dut_sint_Sum, dut_sint_Cout;
    sint_A = $signed(ifid_seqitem.A[NBITS-1:0]);
    sint_B = $signed(ifid_seqitem.B[NBITS-1:0]);
    sint_Cin = $signed(ifid_seqitem.Cin);
    dut_sint_Sum = $signed(ifid_seqitem.Sum[NBITS-1:0]);
    dut_sint_Cout = $signed(ifid_seqitem.Cout);

    // Compute Expected Result (on NBITS)
    {expectedCout, expectedSum} = sint_A + sint_B + sint_Cin;

    /* Compare Expected vs DUT (compare NBITS fields) */

    // Print current item
    `uvm_info("BLUE", $sformatf("\nITEM {A = %d, B = %d, Cin = %d}:", sint_A, sint_B, sint_Cin),
              UVM_MEDIUM);

    // Sum comparison
    assert (expectedSum == ifid_seqitem.Sum) begin
      `uvm_info("GREEN", "Sum OK!", UVM_MEDIUM);
    end else
      `uvm_info("RED", $sformatf(
                "Sum mismatch: expected %d, got %d", $signed(expectedSum), dut_sint_Sum),
                UVM_MEDIUM);

    // Cout comparison
    assert (expectedCout == ifid_seqitem.Cout) begin
      `uvm_info("GREEN", "Cout OK!", UVM_MEDIUM);
    end else
      `uvm_info("RED", $sformatf(
                "Cout mismatch: expected %d, got %d",
                $signed(
                    {{NBITS - 1{1'b0}}, expectedCout}
                ),
                dut_sint_Cout
                ), UVM_MEDIUM);

  endfunction : write

endclass



