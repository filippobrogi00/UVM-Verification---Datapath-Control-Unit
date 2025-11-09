// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* SCOREBOARD :
  * Checks functionality of DUT
  * Receives Transaction-Level Objects via Analysis Port
  * Also implements Assertions so that it can compare the received
  * data items from the Monitor with the "golden model".
* */

class Class_ControlUnit_Scoreboard extends uvm_scoreboard;

  // Register to Factory
  `uvm_component_utils(Class_ControlUnit_Scoreboard)

  // Constructor
  function new(string name = "Class_ControlUnit_Scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Analysis Port to receive data objects from other TB components
  uvm_analysis_imp #(Class_ControlUnit_SequenceItem, Class_ControlUnit_Scoreboard) analysis_port_imp;

  // Define DUT interface (only used for accessing clocking block)
  virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE) ctrlunit_dut_iface;

  /*
  * CLASS MEMBERS
  * */

  /* SEQUENCE ITEMS HISTORY TRACKING */
  // After having pushed the currently received sequence item,
  // this circular buffer contains:
  // 0: current sequence item
  // 1: previous sequence item (from 3 CCs behind)
  Class_ControlUnit_SequenceItem seqItemHistory[2];

  // Modular index
  int historyIdx = 0;

  /*
  * CLASS METHODS
  * */

  // Initializes the history array
  function void initHistory();

    foreach (seqItemHistory[i]) begin
      // Create the Sequence Items (no need for factory, just call constructor)
      seqItemHistory[i]        = new();
      // Initialize to NOPs (defined in package)
      seqItemHistory[i].opcode = INITIAL_OPCODE;
      seqItemHistory[i].func   = INITIAL_FUNC;
    end
  endfunction

  // Pushes the specified sequence item into the history
  function void insertNewSeqItem(Class_ControlUnit_SequenceItem item);
    // Insert sequence item into history
    // coverage off b
    `uvm_info("YELLOW", $sformatf(
              "insert(): item {%d|%d} @idx=%d", item.opcode, item.func, historyIdx), UVM_MEDIUM)
    // coverage on b
    item.copy(seqItemHistory[historyIdx]);
    // Update index \in [0, 1]
    historyIdx = (historyIdx + 1) % 2;
  endfunction

  // Returns the current sequence item from history
  function Class_ControlUnit_SequenceItem getCurrentSeqItem();
    return seqItemHistory[(historyIdx+1)%2];
  endfunction

  // Returns the previous sequence item from history
  function Class_ControlUnit_SequenceItem getPreviousSeqItem();
    return seqItemHistory[historyIdx];
  endfunction


  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get DUT interface handle
    // coverage off b
    if (!uvm_config_db#(virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE))::get(
            this, "", "ctrlunit_dut_iface", ctrlunit_dut_iface
        )) begin
      `uvm_error("[MONITOR]", "Could not get handle to DUT interface!")
    end
    // coverage on b

    // Instance the Analysis Port
    analysis_port_imp = new("analysis_port_imp", this);

    // Initialize Sequence Item History
    initHistory();

  endfunction : build_phase

  /*
  * WRITE FUNCTION :
    * Monitor sends via Analysis Port a complete transaction to the Scoreboard
    * Here we re-compute the Expected Result and check it against DUTs'
  * */
  virtual function void write(Class_ControlUnit_SequenceItem ctrlunit_seqitem);

    /* Variables declaration */
    // NOTE: Expected Control Words have been defined for each instruction
    // inside package "pkg_const"

    // "Expected" variables
    opcode_field_t previousOpcode;
    func_field_t previousFunc;
    cw_t previousCW;

    // "Received" variables
    opcode_field_t receivedOpcode;
    func_field_t receivedFunc;
    cw_t receivedCW;

    // Initialize "item found" flag
    bit itemFound = 1'b0;

    /* 1) Save current sequence item into history */
    insertNewSeqItem(ctrlunit_seqitem);

    /* 2) Fill "Received" variables with current sequence item fields */
    // Inputs
    receivedOpcode = ctrlunit_seqitem.opcode;
    receivedFunc   = ctrlunit_seqitem.func;

    /*
    * Typical Control Word:
    *    STAGE 1    |      STAGE 2        |     STAGE 3
    *  rf1 rf2 en1  | s1 s2 alu1 alu2 en2 | rm wm en3 s3 wf1
    *
    * Our Control Word:
    *    STAGE 1    |      STAGE 2        |     STAGE 3
    * en1 rf1 rf2   | en2 s1 s2 alu1 alu2 | en3 rm wm s3 wf1
    * */

    /* MODIFIED CONTROL WORD ASSIGNMENTS: */
    // First stage signals
    //receivedCW[0]   = ctrlunit_seqitem.en_stage1;
    //receivedCW[1]   = ctrlunit_seqitem.rf_rden_port1;
    //receivedCW[2]   = ctrlunit_seqitem.rf_rden_port2;
    //
    //// Second stage signals
    //receivedCW[3]   = ctrlunit_seqitem.en_stage2;
    //receivedCW[4]   = ctrlunit_seqitem.mux_a_sel;
    //receivedCW[5]   = ctrlunit_seqitem.mux_b_sel;
    //receivedCW[6] = ctrlunit_seqitem.alu_op_sel[0];
    //receivedCW[7] = ctrlunit_seqitem.alu_op_sel[1];

    //// Third stage signals
    //receivedCW[8]   = ctrlunit_seqitem.en_stage3;
    //receivedCW[9]  = ctrlunit_seqitem.mem_rd_en;
    //receivedCW[10]  = ctrlunit_seqitem.mem_wr_en;
    //receivedCW[11]  = ctrlunit_seqitem.mux_wb_sel;
    //receivedCW[12]   = ctrlunit_seqitem.rf_wren;


    /* ORIGINAL CONTROL WORD ASSIGNMENTS: */
    // First stage signals
    receivedCW[0]  = ctrlunit_seqitem.en_stage1;
    receivedCW[1]  = ctrlunit_seqitem.rf_rden_port1;
    receivedCW[2]  = ctrlunit_seqitem.rf_rden_port2;

    // Second stage signals
    receivedCW[3]  = ctrlunit_seqitem.en_stage2;
    receivedCW[4]  = ctrlunit_seqitem.mux_a_sel;
    receivedCW[5]  = ctrlunit_seqitem.mux_b_sel;
    receivedCW[6]  = ctrlunit_seqitem.alu_op_sel[0];
    receivedCW[7]  = ctrlunit_seqitem.alu_op_sel[1];

    // Third stage signals
    receivedCW[8]  = ctrlunit_seqitem.en_stage3;
    receivedCW[9]  = ctrlunit_seqitem.mem_rd_en;
    receivedCW[10] = ctrlunit_seqitem.mem_wr_en;
    receivedCW[11] = ctrlunit_seqitem.mux_wb_sel;
    receivedCW[12] = ctrlunit_seqitem.rf_wren;

    /* 3) Fill "Expected" variables (previous opcode, previous func,
    *    calculated CW) */
    previousOpcode = getPreviousSeqItem().opcode;
    previousFunc   = getPreviousSeqItem().func;
    previousCW     = CW_ARRAY[{previousOpcode, previousFunc}];

    /* 4) Compare Expected vs DUT: Search result CW inside CW array */
    foreach (CW_ARRAY[opcode_func_concat]) begin

      // Define slices for later use
      opcode_field_t opcode_i = opcode_func_concat[OPCODE_SIZE+FUNC_SIZE-1 : FUNC_SIZE];
      func_field_t   func_i = opcode_func_concat[FUNC_SIZE-1 : 0];
      cw_t           cw_i = CW_ARRAY[opcode_func_concat];

      // Compare CW, OPCODE and FUNC fields searching inside array
      // NOTE: Current CW is relative to previous (OPCODE|FUNC)!
      if (receivedCW == cw_i &&  // CW:      Received now vs current one inside CW_ARRAY (Expected)
          previousOpcode == opcode_i &&  // OPCODE:  Previous vs curent one inside CW_ARRAY
          previousFunc == func_i  // FUNC:    Previous vs curent one inside CW_ARRAY
          ) begin
        // Match! CW is correct
        // coverage off b
        `uvm_info("GREEN", "Control Word OK!", UVM_MEDIUM)
        // coverage on b
        // Set "found" flag and stop searching
        itemFound = 1'b1;
        break;
      end

    end  // foreach


    // After having searched inside the CW_ARRAY, if item was not found
    // print an error message
    if (itemFound == 1'b0) begin
      // coverage off b
      `uvm_info(
          "RED",
          $sformatf(
              "[SCOREBOARD %0t] Item mismatch: Expected [[ {%d|%d} => %3b|%5b|%5b (%s) ]] , Received [[ {%d|%d} => %3b|%5b|%5b ]]",
              $time,
              // Expected: previous OPCODE and FUNC, corresponding CW
              // inside CW_ARRAY
              previousOpcode, previousFunc, previousCW[CW_SIZE-1:CW_SIZE-3],
              previousCW[CW_SIZE-4:CW_SIZE-8], previousCW[CW_SIZE-9:CW_SIZE-13], cw_to_string(
              previousCW),
              // Got: current "opcode", "func" fields of sequence
              // item, and CW inside it (concatenating fields)
              receivedOpcode, receivedFunc, receivedCW[CW_SIZE-1:CW_SIZE-3],
              receivedCW[CW_SIZE-4:CW_SIZE-8],
              receivedCW[CW_SIZE-9:CW_SIZE-13]  //, cw_to_string(receivedCW)
              ), UVM_MEDIUM)
      // coverage on b
    end

  endfunction : write

endclass



