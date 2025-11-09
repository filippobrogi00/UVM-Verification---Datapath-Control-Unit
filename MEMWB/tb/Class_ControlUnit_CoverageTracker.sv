// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* COVERAGE TRACKER:
  * Implements Covegroups to track Functional Coverage
  * Current Sequence Item is broadcasted by Monitor and received by
  * Coverage Tracker, which then samples coverage.
*/

class Class_ControlUnit_CoverageTracker extends uvm_subscriber #(Class_ControlUnit_SequenceItem);
  // Register to Factory
  `uvm_component_utils(Class_ControlUnit_CoverageTracker)

  // Analysis Port implementation (broadcast from Monitor)
  uvm_analysis_imp #(Class_ControlUnit_SequenceItem, Class_ControlUnit_CoverageTracker) analysis_port_imp;

  // Handle to virtual DUT interface
  virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE) ctrlunit_dut_iface;

  /*
  * COVERGROUPS for Functional Coverage
  * */

  // Covergroup parameterized with transaction item
  covergroup Covergroup_ControlUnit with function sample (
      Class_ControlUnit_SequenceItem ctrlunit_seqitem
  );

    Coverpoint_Opcode: coverpoint ctrlunit_seqitem.opcode {
      // R-TYPE -> '0
      bins r_type = {RTYPE};
      // I-TYPE -> [1, 14]
      bins i_type = {['d1 : 'd14]};

      bins others = default;
    }

    // If instruction is R-TYPE (FUNC defined), sample it among possible
    // values [0, 3]
    Coverpoint_FuncIfDef: coverpoint ctrlunit_seqitem.func iff (ctrlunit_seqitem.opcode == RTYPE) {
      // verilog_format: off
      bins valid_alu_ops = {['d0 : 'd3]};

      bins others = default;
      // verilog_format: on
    }

    // Else, sample 0 as hardcoded inside CW_ARRAY (pkg_const)
    Coverpoint_FuncIfNdef: coverpoint ctrlunit_seqitem.func iff (ctrlunit_seqitem.opcode != RTYPE) {
      bins zero = {'0};
    }

  endgroup : Covergroup_ControlUnit

  // Constructor
  function new(string name = "Class_ControlUnit_CoverageTracker", uvm_component parent = null);
    super.new(name, parent);
    // Instantiate the covergroup
    Covergroup_ControlUnit = new();
  endfunction

  /*
  * FUNCTIONAL COVERAGE UTILITY FUNCTIONS
  * */
  // Start coverage tracking
  virtual function void coverageStart();
    Covergroup_ControlUnit.start();
  endfunction

  // Stop coverage tracking
  virtual function void coverageStop();
    Covergroup_ControlUnit.stop();
  endfunction

  // Sample coverage at current time
  virtual function void coverageSample(Class_ControlUnit_SequenceItem ctrlunit_seqitem);
    Covergroup_ControlUnit.sample(ctrlunit_seqitem);
  endfunction

  // Return coverage
  virtual function real coverageGet();
    return Covergroup_ControlUnit.get_inst_coverage();
  endfunction


  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get interface from config DB
    // coverage off b
    if (!uvm_config_db#(virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE))::get(
            this, "", "ctrlunit_dut_iface", ctrlunit_dut_iface
        )) begin
      `uvm_error("[COVERAGE TRACKER]", "Failed to get DUT interface")
    end
    // coverage on b

    // Create analysis port
    analysis_port_imp = new("analysis_port_imp", this);
  endfunction : build_phase

  /*
  * WRITE: When Monitor sends a Sequence Item to the Scoreboard and Coverage
  * component, we sample coverage!
  * */
  // NOTE: Superclass uvm_subscriber's write() method has argument name 't',
  //  so it enforces subclasses argument names!
  // NOTE: Wrong to call super.write() as uvm_subscriber class defines write()
  //  method as PURE virtual, meaning only child classes have to give it an
  //  implementation!
  virtual function void write(Class_ControlUnit_SequenceItem t);
    // super.write(t);

    // Sample coverage passing in the current Sequence Item broadcasted from
    // Monitor
    coverageSample(t);

  endfunction

  /*
  * REPORT PHASE: Report coverage at end of simulation (phase)
  * */
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    // coverage off b
    `uvm_info("COVERAGE TRACKER", $sformatf("Functional Coverage: %.2f%%", coverageGet()),
              UVM_MEDIUM);
    // coverage on b
  endfunction : report_phase

endclass
