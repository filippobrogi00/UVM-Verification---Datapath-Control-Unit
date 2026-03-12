###################################################################

# Created by write_sdc on Sat Jan 17 14:10:46 2026

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports CLK]  -name my_clk  -period 10  -waveform {0 5}
