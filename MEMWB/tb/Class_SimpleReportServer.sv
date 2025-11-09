// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

`include "uvm_macros.svh"
import uvm_pkg::*;

class Class_SimpleReportServer extends uvm_report_server;

  // Colors
  typedef enum {
    RED,
    BOLD_RED,
    GREEN,
    BLUE,
    YELLOW
  } color_t;

  // ANSI color escape codes
  string colors[color_t] = '{
      RED         : "\033[0;31m",
      BOLD_RED    : "\033[0;91m",
      GREEN       : "\033[0;32m",
      BLUE        : "\033[0;34m",
      YELLOW      : "\033[0;33m"
  };

  // ANSI escape code for returning to normal color
  string ENDSTRING = "\033[0m";

  // Constructor (uvm_report_server has no parameters)
  function new();
    super.new();
  endfunction

  // Override messsage composition function
  virtual function string compose_message(uvm_severity severity, string name, string id,
                                          string message, string filename, int line);

    // Just return the message body without hierarchy info
    string formattedMessage = "";

    // coverage off b
    // Add ANSI escape code based on severity level
    // NOTE: Severities are UVM_INFO, UVM_WARNING, UVM_ERROR, UVM_FATAL
    case (id)
      "GREEN":   formattedMessage = $sformatf("%s%s", colors[GREEN], message);
      "BLUE":    formattedMessage = $sformatf("%s%s", colors[BLUE], message);
      "YELLOW":  formattedMessage = $sformatf("%s%s", colors[YELLOW], message);
      "RED":     formattedMessage = $sformatf("%s%s", colors[RED], message);
      "BOLDRED": formattedMessage = $sformatf("%s%s", colors[BOLD_RED], message);
    endcase
    // coverage on b

    // At the end, add ANSI for returning to normal and newline
    formattedMessage = $sformatf("%s%s", formattedMessage, ENDSTRING);

    return formattedMessage;
  endfunction

  /* Redefined message reporting functions */
  //static function void uvm_report_green(string message);
  //  `uvm_info("GREEN", message, UVM_MEDIUM)
  //endfunction

  //static function void uvm_report_blue(string message);
  //  `uvm_info("BLUE", message, UVM_MEDIUM)
  //endfunction

  //static function void uvm_report_yellow(string message);
  //  `uvm_info("YELLOW", message, UVM_MEDIUM)
  //endfunction

  //static function void uvm_report_red(string message);
  //  `uvm_info("RED", message, UVM_MEDIUM)
  //endfunction

  //static function void uvm_report_bold_red(string message);
  //  `uvm_info("BOLDRED", message, UVM_MEDIUM)
  //endfunction

endclass
