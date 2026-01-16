// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TEST:
  * Wrapper for many environments (useful for different protocols)
  * Starts coverage tracking before initiating a test on a transaction
* */

class Class_EXE_Test extends uvm_test;

  // Register to Factory
    	// coverage off
  `uvm_component_utils(Class_EXE_Test);
    	// coverage on

  // Constructor
  function new(string name = "Class_EXE_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment
  Class_EXE_Environment      exe_environment;

  // Virtual interfaces handles
  virtual Iface_EXE #(NBITS) exe_dut_iface;

  /*
  * Test BUILD PHASE : Instantiate and build components declared above
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual interfaces handles from DB
    	// coverage off
    if (!uvm_config_db#(virtual Iface_EXE #(NBITS))::get(
            this, "", "exe_dut_iface", exe_dut_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get DUT interface handle")
    end
    	// coverage on

    // coverage on b

    // Create Environment
    exe_environment = Class_EXE_Environment::type_id::create("exe_environment", this);
  endfunction : build_phase


  /*
  * END OF ELABORATION: Print modules hierarchy for easier debug
  * */
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
  endfunction : end_of_elaboration_phase


  /*
  * RUN PHASE:
    * Enable Coverage tracking
    * Start a Sequence for this particular Test
  * */
  virtual task run_phase(uvm_phase phase);
    // Create a Sequence
    Class_EXE_Sequence exe_sequence = Class_EXE_Sequence::type_id::create("exe_sequence", this);


    /* Start the test */
    super.run_phase(phase);
    // Do not let phase end
    phase.raise_objection(this);

    // Start Coverage tracking
    exe_environment.exe_coverage_tracker.coverageStart();

    // Send Sequence (list of many transactions)
    exe_sequence.start(exe_environment.exe_agent.exe_sequencer);

    // Stop coverage tracking
    exe_environment.exe_coverage_tracker.coverageStop();

    // Phase can now end
    phase.drop_objection(this);

    /* IF SCOREBOARD UVM_ERROR SIM SHOULD FINISH HERE WITHOUT ADDITIONAL CODE */

    // Check Scoreboard variable to finish simulation
    // if (uvm_config_db#(int)::get(null, "", "stop_simulation") == 1) begin
    // end

    // int detected_count;
    // uvm_config_db#(int)::get(null, "", "detected_count", detected_count);
    // uvm_config_db#(int)::set(null, "", "detected_count", detected_count+1);

    // [TODO:]
    // 1) Finish simulation
    // 2) Increment FC shared variable detected_count
    // 3) Use $system() to export a modify a BASH variable to then read
    //    and save for later fault classification output on the terminal

    // For each simulated fault:
    //  1) Classify it (detected / not-detected)
    //  2) Add it to the detected_count variable in UVM DB
    //  3) From scoreboard, if detected (uvm_error), add the current fault
    //    to a file of detected faults
    // Put back to Bash script to print FC

    // From one sim to the next,

  endtask : run_phase

	// `ifdef FAULT_INJECTION_CAMPAIGN
	// virtual task report_phase(uvm_phase phase);
	// 	int    local_detected;
  // 	string fault_name;
  // 	int    fault_value;
  // 	string fault_result;
  // 	int    fd;
  // 	string outfile;
	// 	super.report_phase(phase);

  // 	// ----------------------------------------
  // 	// Get fault information from UVM DB
  // 	// ----------------------------------------
  // 	if (!uvm_config_db#(string)::get(null, "", "current_fault", fault_name)) begin
  //   	`uvm_warning("REPORT", "current_fault not found in UVM DB")
  //   	fault_name = "UNKNOWN_FAULT";
  // 	end

  // 	if (!uvm_config_db#(int)::get(null, "", "current_inj_value", fault_value)) begin
  //   	`uvm_warning("REPORT", "current_inj_value not found in UVM DB")
  //   	fault_value = -1;
  // 	end

  // 	if (!uvm_config_db#(int)::get(null, "", "detected", local_detected)) begin
  //   	`uvm_warning("REPORT", "detected flag not found in UVM DB")
  //   	local_detected = 0;
  // 	end

  // 	// ----------------------------------------
  // 	// Classify fault
  // 	// ----------------------------------------
  // 	if (local_detected == 1)
  //   	fault_result = "DETECTED";
  // 	else
  //   	fault_result = "UNDETECTED";

  // 	`uvm_info("FAULT_REPORT", $sformatf("Fault %s SA-%0d classified as %s", fault_name, fault_value, fault_result), UVM_MEDIUM)

  // 	// ----------------------------------------
  // 	// Write classification to file
  // 	// ----------------------------------------
  // 	outfile = getenv("DETECTED_FAULTS_FILE");
  // 	if (outfile == "") begin
  //   	`uvm_error("REPORT", "DETECTED_FAULTS_FILE environment variable not set")
  //   	return;
  // 	end

  // 	fd = $fopen(outfile, "a");
  // 	if (!fd) begin
  //   	`uvm_error("REPORT",
  //     	$sformatf("Could not open fault report file: %s", outfile))
  //   	return;
  // 	end

	// 	$fwrite(fd, "%s SA-%0d %s\n", fault_name, fault_value, fault_result);

	// 	$fclose(fd);

	// endtask : report_phase
	// `endif // FAULT_INJECTION_CAMPAIGN
  
endclass


