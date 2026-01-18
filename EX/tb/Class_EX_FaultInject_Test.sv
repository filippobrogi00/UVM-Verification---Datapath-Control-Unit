// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TEST:
  * Wrapper for many environments (useful for different protocols)
  * Starts coverage tracking before initiating a test on a transaction
* */

class Class_EXE_FaultInject_Test extends uvm_test;
  int fault_fd;
  int log_fd;
  int stuckat;
  string signal_name;
  uvm_event signal_fault_detected;

  // Register to Factory
  `uvm_component_utils(Class_EXE_FaultInject_Test);

  // Constructor
  function new(string name = "Class_EXE_FaultInject_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment
  Class_EXE_Environment exe_environment;

  // Virtual interfaces handles
  virtual Iface_EXE #(IR_SIZE) exe_dut_iface;

  /*
  * Test BUILD PHASE : Instantiate and build components declared above
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    signal_fault_detected = new();

    //Register the fault detected event to the config_db
    uvm_config_db#(uvm_event)::set(null, "*", "signal_fault_detected", signal_fault_detected);

    // Get virtual interfaces handles from DB
    if (!uvm_config_db#(virtual Iface_EXE #(IR_SIZE))::get(
            this, "", "exe_dut_iface", exe_dut_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get DUT interface handle")
    end

    fault_fd = $fopen(getenv("FAULT_INJECT_FAULT_FILE"), "r");
    if (!fault_fd)
      `uvm_fatal("[TEST]", "Could not open fault file!")

    log_fd = $fopen(getenv("FAULT_INJECT_LOG_FILE"), "w");
    if (!fault_fd)
      `uvm_fatal("[TEST]", "Could not log file!")

    /*
    * Set a variable to keep track of whether a fault has been detected or
    * not
    */


    // Create Environment
    exe_environment =
        Class_EXE_Environment::type_id::create("exe_environment", this);
  endfunction : build_phase


  /*
  * END OF ELABORATION: Print modules hierarchy for easier debug
  * */
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // Print topology
    // uvm_top.print_topology();  // uvm_top is always the name of the top-level TB module
  endfunction : end_of_elaboration_phase


  /*
  * RUN PHASE:
    * Enable Coverage tracking
    * Start a Sequence for this particular Test
  * */
  virtual task run_phase(uvm_phase phase);
    // Create a Sequence
    Class_EXE_Sequence exe_sequence = Class_EXE_Sequence::type_id::create(
        "exe_sequence", this
    );

    // Before starting the test, wait until global reset is de-asserted
    //wait (exe_dut_iface.rst_n == 1'b1);

    /* Start the test */
    super.run_phase(phase);

    // Do not let phase end
    phase.raise_objection(this);

    // Start Coverage tracking
    //exe_environment.exe_coverage_tracker.coverageStart();

    //super.run_phase(phase);


    // We're sending the same sequence every time, each time forcing a different signal to a different value
    while (!$feof(fault_fd)) begin
      // From the fault file, read the signal to which apply the stuckat fault
      // and to which value to force the value to
      $fscanf(fault_fd, "%s %d\n", signal_name, stuckat);
      //$fscanf(fault_fd, "sa%d %s %d\n", signal_name, stuckat);

      // Set the fault detected flag to on the config_db

      // Force the stuckat fault
      uvm_hdl_force(signal_name, stuckat);
      `uvm_info("[TEST]", $sformatf("Forcing signal %s", signal_name), UVM_MEDIUM)

      //Fork
      //One thread will run the sequence
      //The other one will be responsible for stopping the sequencer if an
      //error were to arise
      fork
        exe_sequence.start(exe_environment.exe_agent.exe_sequencer);
        begin
          signal_fault_detected.wait_on();
          exe_environment.exe_agent.exe_sequencer.stop_sequences();
          `uvm_info("[TEST]", $sformatf("Fault %s stuck-at %1b signaled!", signal_name, stuckat), UVM_MEDIUM)
        end
      join_any
      disable fork;

      //Check if a fault impacted the output
      if (signal_fault_detected.is_on()) begin
        `uvm_info("[TEST]", $sformatf("Fault detected at signal %s stuck-at %1b", signal_name, stuckat), UVM_MEDIUM)
        $fdisplay (log_fd, "%s\t%1b\tDETECTED", signal_name, stuckat);
      end else begin
        `uvm_info("[TEST]", $sformatf("Fault not detected at signal %s stuck-at %1b", signal_name, stuckat), UVM_MEDIUM)
        $fdisplay (log_fd, "%s\t%1b\tUNDETECTED", signal_name, stuckat);
      end
      signal_fault_detected.reset(0);

      uvm_hdl_release(signal_name);
      `uvm_info("[TEST]", $sformatf("Releasing signal %s", signal_name), UVM_MEDIUM)
    end
      
    // Stop coverage tracking
    //exe_environment.exe_coverage_tracker.coverageStop();

    // Phase can now end
    $fclose(fault_fd);
    $fclose(log_fd);
    phase.drop_objection(this);

  endtask : run_phase
endclass


