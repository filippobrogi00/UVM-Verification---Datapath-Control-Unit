// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* COVERAGE TRACKER:
  * Implements Covegroups to track Functional Coverage
  * Current Sequence Item is broadcasted by Monitor and received by
  * Coverage Tracker, which then samples coverage.
*/

class Class_MEMWB_CoverageTracker extends uvm_subscriber #(Class_MEMWB_SequenceItem);
  `uvm_component_utils(Class_MEMWB_CoverageTracker)

  uvm_analysis_imp #(Class_MEMWB_SequenceItem, Class_MEMWB_CoverageTracker) analysis_port_imp;

  virtual Iface_MEMWB #(IR_SIZE) memwb_dut_iface;

  covergroup Covergroup_MEMWB with function sample (Class_MEMWB_SequenceItem item);
    s4_mux_jmp:         coverpoint item.S3_FF_COND_OUT && item.JUMP_EN;
    s5_mux_wb:          coverpoint item.WB_MUX_SEL;
    s5_mux_datain:      coverpoint item.S3_FF_JAL_EN_OUT;
    s4_reg_lmd:         coverpoint item.LMD_LATCH_EN;
  endgroup : Covergroup_MEMWB

  function new(string name = "Class_MEMWB_CoverageTracker", uvm_component parent = null);
    super.new(name, parent);
    Covergroup_MEMWB = new();
  endfunction

  virtual function void coverageStart();
    Covergroup_MEMWB.start();
  endfunction

  virtual function void coverageStop();
    Covergroup_MEMWB.stop();
  endfunction

  virtual function void coverageSample(Class_MEMWB_SequenceItem memwb_seqitem);
    Covergroup_MEMWB.sample(memwb_seqitem);
  endfunction

  virtual function real coverageGet();
    return Covergroup_MEMWB.get_inst_coverage();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get interface from config DB
    // coverage off b
    if (!uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::get(
            this, "", "memwb_dut_iface", memwb_dut_iface
        )) begin
      `uvm_error("[COVERAGE TRACKER]", "Failed to get DUT interface")
    end
    // coverage on b

    // Create analysis port
    analysis_port_imp = new("analysis_port_imp", this);
  endfunction : build_phase

  virtual function void write(Class_MEMWB_SequenceItem t);
    // super.write(t);
    coverageSample(t);
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    // coverage off b
    `uvm_info("COVERAGE TRACKER", $sformatf("Functional Coverage: %.2f%%", coverageGet()),
              UVM_MEDIUM);
    // coverage on b
  endfunction : report_phase

endclass
