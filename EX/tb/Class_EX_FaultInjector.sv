// Class_EX_FaultInjector.sv
class Class_EXE_FaultInjector extends uvm_component;
  `uvm_component_utils(Class_EXE_FaultInjector)

  // Virtual interface handle
  virtual Iface_EXE #(NBITS) exe_dut_iface;

  // Fault configuration structure
  typedef struct {
    string signal_name;     // Signal name for logging
    string signal_path;     // Full hierarchical path
    logic value;            // Stuck-at value (0 or 1)
    int start_cycle;        // Cycle to inject fault
    int duration;           // How many cycles to maintain fault (-1 = permanent)
  } fault_config_t;

  // Queue of faults to inject
  fault_config_t fault_queue[$];

  // Active faults (for tracking release)
  fault_config_t active_faults[$];

  // Cycle counter
  int cycle_count = 0;

  // Enable/disable fault injection
  bit fault_injection_enabled = 0;

  function new(string name = "Class_EXE_FaultInjector", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get interface from config DB
    if (!uvm_config_db#(virtual Iface_EXE #(NBITS))::get(
        this, "", "exe_dut_iface", exe_dut_iface)) begin
      `uvm_error("[FAULT INJECTOR]", "Failed to get DUT interface")
    end

    // Get enable flag from config DB
    if (!uvm_config_db#(bit)::get(this, "", "fault_injection_enabled",
                                   fault_injection_enabled)) begin
      fault_injection_enabled = 0; // Default: disabled
    end
  endfunction

  // Method to add a fault to the injection queue
  function void add_fault(string sig_name, string sig_path, logic val,
                         int start, int dur = -1);
    fault_config_t fault;
    fault.signal_name = sig_name;
    fault.signal_path = sig_path;
    fault.value = val;
    fault.start_cycle = start;
    fault.duration = dur;
    fault_queue.push_back(fault);

    `uvm_info("FAULT_INJ", $sformatf(
      "Fault queued: %s stuck-at-%0d at cycle %0d for %0d cycles",
      sig_name, val, start, dur), UVM_LOW);
  endfunction

  // Convenience method for common signals
  function void add_mux_a_fault(logic val, int start, int dur = -1);
    add_fault("MUX_A_SEL",
              "Module_topTestbench.exe_toplevel.DP_EXE_inst.MUX_A_SEL",
              val, start, dur);
  endfunction

  function void add_mux_b_fault(logic val, int start, int dur = -1);
    add_fault("MUX_B_SEL",
              "Module_topTestbench.exe_toplevel.DP_EXE_inst.MUX_B_SEL",
              val, start, dur);
  endfunction

  function void add_alu_en_fault(logic val, int start, int dur = -1);
    add_fault("ALU_OUTREG_EN",
              "Module_topTestbench.exe_toplevel.DP_EXE_inst.ALU_OUTREG_EN",
              val, start, dur);
  endfunction

  virtual task run_phase(uvm_phase phase);
    if (!fault_injection_enabled) begin
      `uvm_info("FAULT_INJ", "Fault injection is DISABLED", UVM_LOW);
      return;
    end

    `uvm_info("FAULT_INJ", "Fault injection is ENABLED", UVM_LOW);

    forever begin
      @(posedge exe_dut_iface.CLK);

      // Check for faults to inject at this cycle
      foreach (fault_queue[i]) begin
        if (cycle_count == fault_queue[i].start_cycle) begin
          inject_fault(fault_queue[i]);
          active_faults.push_back(fault_queue[i]);
          fault_queue.delete(i);
        end
      end

      // Check for faults to release
      for (int i = active_faults.size() - 1; i >= 0; i--) begin
        if (active_faults[i].duration != -1 &&
            cycle_count >= (active_faults[i].start_cycle + active_faults[i].duration)) begin
          release_fault(active_faults[i]);
          active_faults.delete(i);
        end
      end

      cycle_count++;
    end
  endtask

  virtual task inject_fault(fault_config_t fault);
    // Use SystemVerilog force statement directly
    case (fault.signal_name)
      "MUX_A_SEL": begin
        force Module_topTestbench.exe_toplevel.DP_EXE_inst.MUX_A_SEL = 0;
      end
      "MUX_B_SEL": begin
        force Module_topTestbench.exe_toplevel.DP_EXE_inst.MUX_B_SEL = 0;
      end
      "ALU_OUTREG_EN": begin
        force Module_topTestbench.exe_toplevel.DP_EXE_inst.ALU_OUTREG_EN = 0;
        //force Module_topTestbench.exe_toplevel.DP_EXE_inst.ALU_OUTREG_EN = fault.value;
      end
      default: begin
        `uvm_error("FAULT_INJ", $sformatf("Unknown signal: %s", fault.signal_name));
      end
    endcase

    `uvm_info("FAULT_INJ", $sformatf(
      "INJECTED: %s stuck-at-%0d at cycle %0d",
      fault.signal_name, fault.value, cycle_count), UVM_MEDIUM);
  endtask

  virtual task release_fault(fault_config_t fault);
    // Use SystemVerilog release statement directly
    case (fault.signal_name)
      "MUX_A_SEL": begin
        release Module_topTestbench.exe_toplevel.DP_EXE_inst.MUX_A_SEL;
      end
      "MUX_B_SEL": begin
        release Module_topTestbench.exe_toplevel.DP_EXE_inst.MUX_B_SEL;
      end
      "ALU_OUTREG_EN": begin
        release Module_topTestbench.exe_toplevel.DP_EXE_inst.ALU_OUTREG_EN;
      end
      default: begin
        `uvm_error("FAULT_INJ", $sformatf("Unknown signal: %s", fault.signal_name));
      end
    endcase

    `uvm_info("FAULT_INJ", $sformatf(
      "RELEASED: %s at cycle %0d",
      fault.signal_name, cycle_count), UVM_MEDIUM);
  endtask

  // Report phase - show any unreleased faults
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    if (active_faults.size() > 0) begin
      `uvm_info("FAULT_INJ", $sformatf(
        "%0d fault(s) still active (permanent or not released)",
        active_faults.size()), UVM_LOW);
    end

    if (fault_queue.size() > 0) begin
      `uvm_warning("FAULT_INJ", $sformatf(
        "%0d fault(s) never reached their injection cycle",
        fault_queue.size()));
    end
  endfunction
endclass
