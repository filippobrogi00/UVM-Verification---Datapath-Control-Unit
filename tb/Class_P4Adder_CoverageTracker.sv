// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* COVERAGE TRACKER:
  * Implements Covegroups to track Functional Coverage
  * Current Sequence Item is broadcasted by Monitor and received by
  * Coverage Tracker, which then samples coverage.
*/

class Class_P4Adder_CoverageTracker extends uvm_subscriber #(Class_P4Adder_SequenceItem);
  // Register to Factory
  `uvm_component_utils(Class_P4Adder_CoverageTracker)

  // Analysis Port implementation (broadcast from Monitor)
  uvm_analysis_imp #(Class_P4Adder_SequenceItem, Class_P4Adder_CoverageTracker) analysis_port_imp;

  // Handle to virtual DUT interface
  virtual Iface_P4Adder #(NBITS) p4adder_dut_iface;

  /*
  * COVERGROUPS for Functional Coverage
  * */

  // Covergroup parameterized with transaction item
  covergroup Covergroup_P4Adder with function sample (Class_P4Adder_SequenceItem p4adder_seqitem);

    Coverpoint_OperandA: coverpoint p4adder_seqitem.A {
      bins min_value = {MIN_NEG_VALUE};
      bins minus_one = {MINUS_ONE};
      bins zero = {ZERO};
      bins one = {ONE};
      bins max_value = {MAX_POS_VALUE};

      bins others = default;
    }


    Coverpoint_OperandB: coverpoint p4adder_seqitem.B {
      bins min_value = {MIN_NEG_VALUE};
      bins minus_one = {MINUS_ONE};
      bins zero = {ZERO};
      bins one = {ONE};
      bins max_value = {MAX_POS_VALUE};
      bins others = default;
    }

    Coverpoint_OperandCin: coverpoint p4adder_seqitem.Cin {bins zero = {0}; bins one = {1};}

  endgroup : Covergroup_P4Adder

  // Constructor
  function new(string name = "Class_P4Adder_CoverageTracker", uvm_component parent = null);
    super.new(name, parent);
    // Instantiate the covergroup
    Covergroup_P4Adder = new();
  endfunction

  /*
  * FUNCTIONAL COVERAGE UTILITY FUNCTIONS
  * */
  // Start coverage tracking
  virtual function void coverageStart();
    Covergroup_P4Adder.start();
  endfunction

  // Stop coverage tracking
  virtual function void coverageStop();
    Covergroup_P4Adder.stop();
  endfunction

  // Sample coverage at current time
  virtual function void coverageSample(Class_P4Adder_SequenceItem p4adder_seqitem);
    Covergroup_P4Adder.sample(p4adder_seqitem);
  endfunction

  // Return coverage
  virtual function real coverageGet();
    return Covergroup_P4Adder.get_inst_coverage();
  endfunction


  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get interface from config DB
    if (!uvm_config_db#(virtual Iface_P4Adder #(NBITS))::get(
            this, "", "p4adder_dut_iface", p4adder_dut_iface
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
  virtual function void write(Class_P4Adder_SequenceItem t);
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
    `uvm_info("COVERAGE TRACKER", $sformatf("Functional Coverage: %.2f%%", coverageGet()),
              UVM_MEDIUM);
  endfunction : report_phase

endclass
