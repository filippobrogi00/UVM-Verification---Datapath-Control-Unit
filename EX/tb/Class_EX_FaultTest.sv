// Class_EX_FaultTest.sv
class Class_EXE_FaultTest extends Class_EXE_Test;
  `uvm_component_utils(Class_EXE_FaultTest)

  function new(string name = "Class_EXE_FaultTest", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // Enable fault injection
    uvm_config_db#(bit)::set(this, "exe_environment.exe_fault_injector", 
                             "fault_injection_enabled", 1);
    // Call parent build
    super.build_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
    Class_EXE_Sequence exe_sequence;
    
    super.run_phase(phase);
    phase.raise_objection(this);
    
    // Configure faults BEFORE starting the sequence
    configure_faults();
    
    // Start coverage
    exe_environment.exe_coverage_tracker.coverageStart();
    
    // Create and start sequence
    exe_sequence = Class_EXE_Sequence::type_id::create("exe_sequence", this);
    exe_sequence.start(exe_environment.exe_agent.exe_sequencer);
    
    // Stop coverage
    exe_environment.exe_coverage_tracker.coverageStop();
    
    phase.drop_objection(this);
  endtask
  
  // Override this method in derived tests to configure different faults
  virtual function void configure_faults();
    // Example: Inject stuck-at-0 on MUX_A_SEL at cycle 50 for 10 cycles
    exe_environment.exe_fault_injector.add_mux_a_fault(1'b0, 50, 10);
    
    // Example: Permanent stuck-at-1 on MUX_B_SEL starting at cycle 100
    exe_environment.exe_fault_injector.add_mux_b_fault(1'b1, 100, -1);
    
    // Example: Transient fault on ALU enable
    exe_environment.exe_fault_injector.add_alu_en_fault(1'b0, 75, 5);
  endfunction
endclass
