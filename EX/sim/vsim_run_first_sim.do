# example syntax:
# add wave -divider {======= MyDivider =======}
# add wave -radix hex -color red sim:/tb_dlx/U1/cu_i/alu_opcode

# P4 Testbench signals
# add wave -divider {======= Testbench =======}
# add wave -radix dec -color green sim:/testbench/tb_A
# add wave -radix dec -color green sim:/testbench/tb_B
# add wave -radix dec -color green sim:/testbench/tb_Cin
# add wave -radix dec -color red sim:/testbench/tb_S
# add wave -radix dec -color red sim:/testbench/tb_Cout

# Run the simulation
run $RUN_TIME
quit

