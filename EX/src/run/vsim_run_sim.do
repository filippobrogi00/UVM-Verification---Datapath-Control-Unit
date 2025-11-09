# Testbench signals
add wave -divider {======= Testbench =======}
add wave sim:/tb_dlx/tb_nRst
add wave sim:/tb_dlx/tb_Clock

# DEBUG Signals
add wave -divider {======= Debug =======}
add wave -radix hex -color blue sim:/tb_dlx/U1/IRAM_I/Dout
add wave -radix hex -color blue sim:/tb_dlx/U1/cu_i/alu_opcode
add wave -radix dec -color blue sim:/tb_dlx/U1/alu_out

# IRAM signals
add wave -divider {======= IRAM =======}
add wave -radix hex -color green sim:/tb_dlx/U1/IRAM_I/Addr
add wave -radix hex -color blue sim:/tb_dlx/U1/IRAM_I/Dout

# DRAM signals
add wave -divider {======= DRAM =======}
add wave -radix hex -color purple sim:/tb_dlx/U1/DRAM_I/DRAM_RE
add wave -radix hex -color purple sim:/tb_dlx/U1/DRAM_I/DRAM_WE
add wave -radix hex -color green sim:/tb_dlx/U1/DRAM_I/DataIN
add wave -radix hex -color green sim:/tb_dlx/U1/DRAM_I/ADDR
add wave -radix hex -color blue sim:/tb_dlx/U1/DRAM_I/Dout

# DLX internal PC and IR signals
add wave -divider {======= Internal DLX Signals =======}
add wave -radix hex -color orange sim:/tb_dlx/U1/IR
add wave -radix hex -color orange sim:/tb_dlx/U1/PC
add wave -radix hex -color orange sim:/tb_dlx/U1/PC_to_IRAM

# Control Unit / Datapath signals
add wave -divider {=============================}
add wave -divider {======= CU/DP Signals =======}
add wave -divider {=============================}
add wave -radix hex sim:/tb_dlx/U1/CU_I/IR_IN
add wave -divider {======= STAGE 1 =======}
add wave -radix hex -color green sim:/tb_dlx/U1/CU_I/IR_LATCH_EN
add wave -radix hex -color green sim:/tb_dlx/U1/CU_I/NPC_LATCH_EN
add wave -divider {======= STAGE 2 =======}
add wave -radix hex -color blue sim:/tb_dlx/U1/CU_I/RegA_LATCH_EN
add wave -radix hex -color blue sim:/tb_dlx/U1/CU_I/RegIMM_LATCH_EN
add wave -radix hex -color blue sim:/tb_dlx/U1/CU_I/JAL_EN
add wave -divider {======= STAGE 3 =======}
add wave -radix hex -color red sim:/tb_dlx/U1/CU_I/MUXA_SEL
add wave -radix hex -color red sim:/tb_dlx/U1/CU_I/MUXB_SEL
add wave -radix hex -color red sim:/tb_dlx/U1/CU_I/ALU_OUTREG_EN
add wave -radix hex -color red sim:/tb_dlx/U1/CU_I/EQ_COND
add wave -radix hex -color red sim:/tb_dlx/U1/CU_I/JMP
add wave -radix hex -color red sim:/tb_dlx/U1/CU_I/EQZ_NEQZ
add wave -radix hex -color red sim:/tb_dlx/U1/CU_I/ALU_OPCODE
add wave -divider {======= STAGE 4 =======}
add wave -radix hex -color yellow sim:/tb_dlx/U1/CU_I/DRAM_WE
add wave -radix hex -color yellow sim:/tb_dlx/U1/CU_I/LMD_LATCH_EN
add wave -radix hex -color yellow sim:/tb_dlx/U1/CU_I/JUMP_EN
add wave -radix hex -color yellow sim:/tb_dlx/U1/CU_I/PC_LATCH_EN
add wave -divider {======= STAGE 5 =======}
add wave -radix hex -color purple sim:/tb_dlx/U1/CU_I/WB_MUX_SEL
add wave -radix hex -color purple sim:/tb_dlx/U1/CU_I/RF_WE

# Run the simulation
run $RUN_TIME
quit
