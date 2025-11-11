// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Wrapper for plug-and-play DUT instantiation
module Module_ControlUnit_Wrapper #(
    parameter OPCODE_SIZE = 6,
    parameter FUNC_SIZE   = 11
) (
    Iface_ControlUnit.DUT ctrlunit_iface  // pass modport DUT as argument
);

  // Instantiate DUT (ctrlunit_sv SV wrapper inside design.sv) and connect each of its pins
  // to an interface's signals
  fsm_control_unit #(
      .op_code_size(OPCODE_SIZE),
      .func_size   (FUNC_SIZE)
  ) cu_fsm_inst (
      /* INPUTS */
      .opcode(ctrlunit_iface.opcode),
      .func(ctrlunit_iface.func),
      .clk(ctrlunit_iface.clk),
      .rst(ctrlunit_iface.rst_n),  // active low reset!

      /* OUTPUTS */
      // Stage 1
      .en1 (ctrlunit_iface.en_stage1),
      .rf1 (ctrlunit_iface.rf_rden_port1),
      .rf2 (ctrlunit_iface.rf_rden_port2),
      .wf1 (ctrlunit_iface.rf_wren),
      // Stage 2
      .en2 (ctrlunit_iface.en_stage2),
      .s1  (ctrlunit_iface.mux_a_sel),
      .s2  (ctrlunit_iface.mux_b_sel),
      .alu1(ctrlunit_iface.alu_op_sel[0]),
      .alu2(ctrlunit_iface.alu_op_sel[1]),
      // Stage 3
      .en3 (ctrlunit_iface.en_stage3),
      .rm  (ctrlunit_iface.mem_rd_en),
      .wm  (ctrlunit_iface.mem_wr_en),
      .s3  (ctrlunit_iface.mux_wb_sel)

  );

endmodule

