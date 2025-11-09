// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

// DUT Interface
interface Iface_P4Adder #(
    parameter NBITS = 32
);
  // port (
  //   -- inputs
  //   A, B   : in std_logic_vector(N downto 1);
  //   P4_Cin    : in std_logic;
  //   -- outputs
  //   P4_Sum : out std_logic_vector(N downto 1);
  //   P4_Cout   : out std_logic
  // );

  logic [NBITS-1:0] A, B;
  logic Cin;
  logic [NBITS-1:0] Sum;
  logic Cout;

  modport DUT(input A, B, Cin, output Sum, Cout);

endinterface

// Mock Clock Interface (DUT is combinational)
interface Iface_MockClock ();

  localparam time MOCKCLOCK_PERIOD = 10ns;
  logic mockClock;

  initial mockClock = 1'b0;

  always #(MOCKCLOCK_PERIOD / 2) mockClock <= ~mockClock;
endinterface


