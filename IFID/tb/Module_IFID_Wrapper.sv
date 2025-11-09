// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

// Wrapper for plug-and-play DUT instantiation
module Module_IFID_Wrapper #(
    parameter NBITS = 32
) (
    Iface_IFID.DUT ifid_iface  // pass modport DUT as argument
);

  // Instantiate DUT (ifid_sv SV wrapper inside design.sv) and connect each of its pins
  // to an interface's signals
  p4_adder #(
      .N(NBITS)
  ) p4_adder_inst (
      .A(ifid_iface.A),
      .B(ifid_iface.B),
      .P4_Cin(ifid_iface.Cin),
      .P4_Sum(ifid_iface.Sum),
      .P4_Cout(ifid_iface.Cout)
  );

endmodule

