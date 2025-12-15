/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : S-2021.06-SP4
// Date      : Mon Dec 15 00:13:27 2025
/////////////////////////////////////////////////////////////


module dlx_cu ( Clk, nRst, IR_IN, IR_LATCH_EN, NPC_LATCH_EN, RegA_LATCH_EN, 
        SIGN_UNSIGN_EN, RegIMM_LATCH_EN, JAL_EN, MUXA_SEL, MUXB_SEL, 
        ALU_OUTREG_EN, EQ_COND, JMP, EQZ_NEQZ, ALU_OPCODE, DRAM_WE, 
        LMD_LATCH_EN, JUMP_EN, PC_LATCH_EN, WB_MUX_SEL, RF_WE );
  input [31:0] IR_IN;
  output [4:0] ALU_OPCODE;
  input Clk, nRst;
  output IR_LATCH_EN, NPC_LATCH_EN, RegA_LATCH_EN, SIGN_UNSIGN_EN,
         RegIMM_LATCH_EN, JAL_EN, MUXA_SEL, MUXB_SEL, ALU_OUTREG_EN, EQ_COND,
         JMP, EQZ_NEQZ, DRAM_WE, LMD_LATCH_EN, JUMP_EN, PC_LATCH_EN,
         WB_MUX_SEL, RF_WE;
  wire   n2, n5, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n151, n152, n153,
         n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n203, n204, n205;
  wire   [4:0] aluOpcode1;
  wire   [4:0] aluOpcode_i;
  assign RegA_LATCH_EN = 1'b0;
  assign SIGN_UNSIGN_EN = 1'b0;
  assign RegIMM_LATCH_EN = 1'b0;
  assign JAL_EN = 1'b0;
  assign MUXA_SEL = 1'b0;
  assign MUXB_SEL = 1'b0;
  assign ALU_OUTREG_EN = 1'b0;
  assign EQ_COND = 1'b0;
  assign JMP = 1'b0;
  assign EQZ_NEQZ = 1'b0;
  assign DRAM_WE = 1'b0;
  assign LMD_LATCH_EN = 1'b0;
  assign JUMP_EN = 1'b0;
  assign PC_LATCH_EN = 1'b0;
  assign WB_MUX_SEL = 1'b0;
  assign RF_WE = 1'b0;
  assign NPC_LATCH_EN = 1'b0;
  assign IR_LATCH_EN = 1'b0;

  DFFR_X1 aluOpcode1_reg_4_ ( .D(aluOpcode_i[4]), .CK(Clk), .RN(nRst), .Q(
        aluOpcode1[4]) );
  DFFR_X1 aluOpcode2_reg_4_ ( .D(aluOpcode1[4]), .CK(Clk), .RN(nRst), .Q(
        ALU_OPCODE[4]), .QN(n203) );
  DFFR_X1 aluOpcode1_reg_3_ ( .D(aluOpcode_i[3]), .CK(Clk), .RN(nRst), .Q(
        aluOpcode1[3]) );
  DFFR_X1 aluOpcode2_reg_3_ ( .D(aluOpcode1[3]), .CK(Clk), .RN(nRst), .QN(n2)
         );
  DFFR_X1 aluOpcode1_reg_2_ ( .D(aluOpcode_i[2]), .CK(Clk), .RN(nRst), .Q(
        aluOpcode1[2]) );
  DFFR_X1 aluOpcode2_reg_2_ ( .D(aluOpcode1[2]), .CK(Clk), .RN(nRst), .QN(n204) );
  DFFR_X1 aluOpcode1_reg_1_ ( .D(aluOpcode_i[1]), .CK(Clk), .RN(nRst), .Q(
        aluOpcode1[1]) );
  DFFR_X1 aluOpcode2_reg_1_ ( .D(aluOpcode1[1]), .CK(Clk), .RN(nRst), .QN(n5)
         );
  DFFR_X1 aluOpcode1_reg_0_ ( .D(aluOpcode_i[0]), .CK(Clk), .RN(nRst), .Q(
        aluOpcode1[0]) );
  DFFR_X1 aluOpcode2_reg_0_ ( .D(aluOpcode1[0]), .CK(Clk), .RN(nRst), .QN(n205) );
  OAI22_X1 U135 ( .A1(n111), .A2(n112), .B1(n113), .B2(n114), .ZN(
        aluOpcode_i[4]) );
  INV_X1 U136 ( .A(n115), .ZN(n114) );
  AOI22_X1 U137 ( .A1(n116), .A2(n117), .B1(IR_IN[31]), .B2(n118), .ZN(n113)
         );
  AOI21_X1 U138 ( .B1(IR_IN[1]), .B2(n119), .A(n120), .ZN(n111) );
  OAI21_X1 U139 ( .B1(IR_IN[2]), .B2(n121), .A(n122), .ZN(n119) );
  NAND4_X1 U140 ( .A1(n123), .A2(n124), .A3(n125), .A4(n126), .ZN(
        aluOpcode_i[3]) );
  OAI211_X1 U141 ( .C1(n127), .C2(n128), .A(IR_IN[1]), .B(n129), .ZN(n125) );
  NOR2_X1 U142 ( .A1(IR_IN[0]), .A2(n130), .ZN(n127) );
  OAI211_X1 U143 ( .C1(n131), .C2(n132), .A(IR_IN[27]), .B(n133), .ZN(n124) );
  NOR3_X1 U144 ( .A1(n134), .A2(IR_IN[29]), .A3(n135), .ZN(n131) );
  NAND4_X1 U145 ( .A1(n123), .A2(n136), .A3(n137), .A4(n138), .ZN(
        aluOpcode_i[2]) );
  NAND3_X1 U146 ( .A1(IR_IN[30]), .A2(n139), .A3(n118), .ZN(n137) );
  OAI21_X1 U147 ( .B1(n140), .B2(n141), .A(n117), .ZN(n139) );
  INV_X1 U148 ( .A(n133), .ZN(n117) );
  NAND3_X1 U149 ( .A1(n142), .A2(n143), .A3(n129), .ZN(n136) );
  OAI221_X1 U150 ( .B1(n144), .B2(n145), .C1(IR_IN[0]), .C2(n146), .A(n122), 
        .ZN(n142) );
  AOI21_X1 U151 ( .B1(IR_IN[0]), .B2(n147), .A(n148), .ZN(n144) );
  AOI221_X1 U152 ( .B1(n149), .B2(n129), .C1(n132), .C2(n150), .A(n151), .ZN(
        n123) );
  INV_X1 U153 ( .A(n152), .ZN(n151) );
  OAI21_X1 U154 ( .B1(n153), .B2(n130), .A(n154), .ZN(n149) );
  NAND2_X1 U155 ( .A1(n145), .A2(IR_IN[0]), .ZN(n153) );
  NAND4_X1 U156 ( .A1(n152), .A2(n138), .A3(n126), .A4(n155), .ZN(
        aluOpcode_i[1]) );
  AOI221_X1 U157 ( .B1(n133), .B2(n156), .C1(n129), .C2(n157), .A(n158), .ZN(
        n155) );
  MUX2_X1 U158 ( .A(n159), .B(n160), .S(IR_IN[31]), .Z(n158) );
  AND2_X1 U159 ( .A1(n161), .A2(n115), .ZN(n160) );
  MUX2_X1 U160 ( .A(n116), .B(n118), .S(n141), .Z(n161) );
  NOR2_X1 U161 ( .A1(n162), .A2(n163), .ZN(n159) );
  NAND4_X1 U162 ( .A1(n164), .A2(n165), .A3(n166), .A4(n154), .ZN(n157) );
  NAND3_X1 U163 ( .A1(n167), .A2(n143), .A3(n128), .ZN(n166) );
  MUX2_X1 U164 ( .A(n168), .B(n169), .S(n145), .Z(n164) );
  NAND2_X1 U165 ( .A1(n170), .A2(n147), .ZN(n169) );
  INV_X1 U166 ( .A(n121), .ZN(n147) );
  OR2_X1 U167 ( .A1(n130), .A2(n170), .ZN(n168) );
  OAI22_X1 U168 ( .A1(n134), .A2(n163), .B1(n162), .B2(n171), .ZN(n156) );
  NAND2_X1 U169 ( .A1(IR_IN[30]), .A2(n140), .ZN(n171) );
  INV_X1 U170 ( .A(n118), .ZN(n162) );
  INV_X1 U171 ( .A(n132), .ZN(n163) );
  NOR2_X1 U172 ( .A1(n140), .A2(IR_IN[30]), .ZN(n132) );
  NAND3_X1 U173 ( .A1(n115), .A2(n134), .A3(n133), .ZN(n152) );
  NAND4_X1 U174 ( .A1(n126), .A2(n138), .A3(n172), .A4(n173), .ZN(
        aluOpcode_i[0]) );
  AOI22_X1 U175 ( .A1(n174), .A2(n135), .B1(n129), .B2(n175), .ZN(n173) );
  NAND2_X1 U176 ( .A1(n176), .A2(n165), .ZN(n175) );
  AOI221_X1 U177 ( .B1(n128), .B2(n170), .C1(n167), .C2(n120), .A(n177), .ZN(
        n165) );
  INV_X1 U178 ( .A(n178), .ZN(n177) );
  MUX2_X1 U179 ( .A(n154), .B(n122), .S(n143), .Z(n178) );
  NAND2_X1 U180 ( .A1(IR_IN[0]), .A2(n179), .ZN(n122) );
  NAND2_X1 U181 ( .A1(n179), .A2(n167), .ZN(n154) );
  AND2_X1 U182 ( .A1(n148), .A2(n145), .ZN(n179) );
  NOR3_X1 U183 ( .A1(n121), .A2(IR_IN[1]), .A3(n145), .ZN(n120) );
  NOR2_X1 U184 ( .A1(n143), .A2(n167), .ZN(n170) );
  INV_X1 U185 ( .A(n146), .ZN(n128) );
  NAND3_X1 U186 ( .A1(IR_IN[2]), .A2(n180), .A3(n181), .ZN(n146) );
  NOR3_X1 U187 ( .A1(IR_IN[3]), .A2(IR_IN[5]), .A3(IR_IN[4]), .ZN(n181) );
  MUX2_X1 U188 ( .A(n182), .B(n183), .S(n145), .Z(n176) );
  INV_X1 U189 ( .A(IR_IN[2]), .ZN(n145) );
  AOI22_X1 U190 ( .A1(IR_IN[1]), .A2(n184), .B1(n185), .B2(n167), .ZN(n183) );
  OAI21_X1 U191 ( .B1(IR_IN[0]), .B2(n121), .A(n130), .ZN(n184) );
  INV_X1 U192 ( .A(n185), .ZN(n130) );
  NAND4_X1 U193 ( .A1(IR_IN[5]), .A2(IR_IN[4]), .A3(IR_IN[3]), .A4(n180), .ZN(
        n121) );
  NAND2_X1 U194 ( .A1(n186), .A2(n143), .ZN(n182) );
  INV_X1 U195 ( .A(IR_IN[1]), .ZN(n143) );
  MUX2_X1 U196 ( .A(n185), .B(n148), .S(n167), .Z(n186) );
  INV_X1 U197 ( .A(IR_IN[0]), .ZN(n167) );
  NOR2_X1 U198 ( .A1(n187), .A2(n188), .ZN(n148) );
  INV_X1 U199 ( .A(IR_IN[3]), .ZN(n188) );
  NOR2_X1 U200 ( .A1(n187), .A2(IR_IN[3]), .ZN(n185) );
  NAND3_X1 U201 ( .A1(n180), .A2(n189), .A3(IR_IN[5]), .ZN(n187) );
  INV_X1 U202 ( .A(IR_IN[4]), .ZN(n189) );
  NOR3_X1 U203 ( .A1(IR_IN[6]), .A2(IR_IN[10]), .A3(n190), .ZN(n180) );
  OR3_X1 U204 ( .A1(IR_IN[9]), .A2(IR_IN[8]), .A3(IR_IN[7]), .ZN(n190) );
  INV_X1 U205 ( .A(n112), .ZN(n129) );
  NAND3_X1 U206 ( .A1(n133), .A2(n191), .A3(n192), .ZN(n112) );
  NOR3_X1 U207 ( .A1(IR_IN[28]), .A2(IR_IN[30]), .A3(IR_IN[29]), .ZN(n192) );
  OAI22_X1 U208 ( .A1(IR_IN[31]), .A2(n193), .B1(IR_IN[28]), .B2(n194), .ZN(
        n174) );
  AOI22_X1 U209 ( .A1(n133), .A2(IR_IN[29]), .B1(IR_IN[26]), .B2(IR_IN[27]), 
        .ZN(n194) );
  NOR2_X1 U210 ( .A1(IR_IN[31]), .A2(IR_IN[26]), .ZN(n133) );
  AOI21_X1 U211 ( .B1(n118), .B2(n195), .A(n116), .ZN(n193) );
  NAND2_X1 U212 ( .A1(IR_IN[29]), .A2(n141), .ZN(n195) );
  OAI211_X1 U213 ( .C1(n116), .C2(n118), .A(n141), .B(n115), .ZN(n172) );
  NOR2_X1 U214 ( .A1(n134), .A2(IR_IN[27]), .ZN(n118) );
  INV_X1 U215 ( .A(IR_IN[28]), .ZN(n134) );
  NOR2_X1 U216 ( .A1(n191), .A2(IR_IN[28]), .ZN(n116) );
  NAND3_X1 U217 ( .A1(n115), .A2(n191), .A3(n150), .ZN(n138) );
  NOR3_X1 U218 ( .A1(IR_IN[28]), .A2(IR_IN[31]), .A3(n141), .ZN(n150) );
  INV_X1 U219 ( .A(IR_IN[26]), .ZN(n141) );
  INV_X1 U220 ( .A(IR_IN[27]), .ZN(n191) );
  NOR2_X1 U221 ( .A1(n135), .A2(n140), .ZN(n115) );
  INV_X1 U222 ( .A(IR_IN[29]), .ZN(n140) );
  NAND4_X1 U223 ( .A1(IR_IN[28]), .A2(IR_IN[27]), .A3(IR_IN[26]), .A4(n196), 
        .ZN(n126) );
  NOR3_X1 U224 ( .A1(n135), .A2(IR_IN[31]), .A3(IR_IN[29]), .ZN(n196) );
  INV_X1 U225 ( .A(IR_IN[30]), .ZN(n135) );
  NAND2_X1 U226 ( .A1(n2), .A2(n197), .ZN(ALU_OPCODE[3]) );
  OR3_X1 U227 ( .A1(n204), .A2(n203), .A3(n198), .ZN(n197) );
  OAI21_X1 U228 ( .B1(n203), .B2(n2), .A(n204), .ZN(ALU_OPCODE[2]) );
  NOR2_X1 U229 ( .A1(n199), .A2(n200), .ZN(ALU_OPCODE[1]) );
  INV_X1 U230 ( .A(n201), .ZN(n200) );
  OAI21_X1 U231 ( .B1(n202), .B2(n203), .A(n5), .ZN(n201) );
  AOI221_X1 U232 ( .B1(n202), .B2(n205), .C1(n203), .C2(n205), .A(n199), .ZN(
        ALU_OPCODE[0]) );
  AND2_X1 U233 ( .A1(n198), .A2(n2), .ZN(n199) );
  AND2_X1 U234 ( .A1(n205), .A2(n5), .ZN(n198) );
  AND2_X1 U235 ( .A1(n204), .A2(n2), .ZN(n202) );
endmodule

