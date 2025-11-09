// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

`include "uvm_macros.svh"
import uvm_pkg::*;

package pkg_const;
  // Number of bits
  localparam int NBITS = 32;

  // Constants for functional coverage
  localparam logic [NBITS-1:0] MIN_NEG_VALUE = {
    {1'b1, {NBITS - 1{1'b0}}}
  };  // minimum value = 'b1000000
  localparam logic [NBITS-1:0] MINUS_ONE = {{NBITS{1'b1}}};  // -1 = 'b111111
  localparam logic [NBITS-1:0] ZERO = {{NBITS{1'b0}}};
  localparam logic [NBITS-1:0] ONE = {{{NBITS - 1{1'b0}}, 1'b1}};
  localparam logic [NBITS-1:0] MAX_POS_VALUE = {
    {1'b0, {NBITS - 1{1'b1}}}
  };  // maximum value = 'b0111111

endpackage
