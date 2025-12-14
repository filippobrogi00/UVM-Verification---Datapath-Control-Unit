// Different fault scenarios
class Class_EXE_MuxAStuckTest extends Class_EXE_FaultTest;
  `uvm_component_utils(Class_EXE_MuxAStuckTest)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void configure_faults();
    // Test MUX_A stuck at 0
    exe_environment.exe_fault_injector.add_mux_a_fault(1'b0, 0, 50);
  endfunction
endclass
