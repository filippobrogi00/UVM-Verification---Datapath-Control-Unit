// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

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

    // Add ANSI escape code based on severity level
    // NOTE: Severities are UVM_INFO, UVM_WARNING, UVM_ERROR, UVM_FATAL
    // coverage off
    case (id)
      "GREEN":   formattedMessage = $sformatf("%s%s", colors[GREEN], message);
      "BLUE":    formattedMessage = $sformatf("%s%s", colors[BLUE], message);
      "YELLOW":  formattedMessage = $sformatf("%s%s", colors[YELLOW], message);
      "RED":     formattedMessage = $sformatf("%s%s", colors[RED], message);
      "BOLDRED": formattedMessage = $sformatf("%s%s", colors[BOLD_RED], message);
      default:   
        case (severity)
          UVM_INFO:    formattedMessage = $sformatf("%s%s", colors[BLUE], message); 
          UVM_ERROR: 
          UVM_FATAL:   formattedMessage = $sformatf("%s%s", colors[RED], message);
          UVM_WARNING: formattedMessage = $sformatf("%s%s", colors[YELLOW], message);
          default:     formattedMessage = message;
        endcase
      endcase
    // coverage on

    // At the end, add ANSI for returning to normal and newline
    formattedMessage = $sformatf("%s%s", formattedMessage, ENDSTRING);

    return formattedMessage;
  endfunction

  /* Redefined message reporting functions */
  //static function void uvm_report_green(string message);
  //  // coverage off b
  //  `uvm_info("GREEN", message, UVM_MEDIUM)
  //  // coverage on b
  //endfunction

  //static function void uvm_report_blue(string message);
  //  // coverage off b
  //  `uvm_info("BLUE", message, UVM_MEDIUM)
  //  // coverage on b
  //endfunction

  //static function void uvm_report_yellow(string message);
  //  // coverage off b
  //  `uvm_info("YELLOW", message, UVM_MEDIUM)
  //  // coverage on b
  //endfunction

  //static function void uvm_report_red(string message);
  //  // coverage off b
  //  `uvm_info("RED", message, UVM_MEDIUM)
  //  // coverage on b
  //endfunction

  //static function void uvm_report_bold_red(string message);
  //  // coverage off b
  //  `uvm_info("BOLDRED", message, UVM_MEDIUM)
  //  // coverage on b
  //endfunction

endclass
