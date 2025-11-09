// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

// Wrapper for plug-and-play DUT instantiation
module Module_IFID_Wrapper #(
    parameter NBITS = 32
) (
    Iface_IFID.DUT p4adder_iface  // pass modport DUT as argument
);

  // Instantiate DUT (p4adder_sv SV wrapper inside design.sv) and connect each of its pins
  // to an interface's signals
  p4_adder #(
      .N(NBITS)
  ) p4_adder_inst (
      .A(p4adder_iface.A),
      .B(p4adder_iface.B),
      .P4_Cin(p4adder_iface.Cin),
      .P4_Sum(p4adder_iface.Sum),
      .P4_Cout(p4adder_iface.Cout)
  );

endmodule

