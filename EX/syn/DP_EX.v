/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : S-2021.06-SP4
// Date      : Sat Dec 13 11:27:54 2025
/////////////////////////////////////////////////////////////


module DP_EX ( CLK, nRST, S1_REG_NPC_OUT, S2_FF_JAL_EN_OUT, S2_REG_NPC_OUT, 
        S2_REG_ADD_WR_OUT, S2_RFILE_A_OUT, S2_RFILE_B_OUT, S2_REG_SE_IMM_OUT, 
        S2_REG_UE_IMM_OUT, MUX_A_SEL, MUX_B_SEL, ALU_OUTREG_EN, EQ_COND, JMP, 
        EQZ_NEQZ, DP_ALU_OPCODE, S3_FF_JAL_EN_OUT, S3_REG_ADD_WR_OUT, 
        S3_FF_COND_OUT, S3_REG_ALU_OUT, S3_REG_DATA_OUT, S3_REG_NPC_OUT );
  input [31:0] S1_REG_NPC_OUT;
  input [31:0] S2_REG_NPC_OUT;
  input [4:0] S2_REG_ADD_WR_OUT;
  input [31:0] S2_RFILE_A_OUT;
  input [31:0] S2_RFILE_B_OUT;
  input [31:0] S2_REG_SE_IMM_OUT;
  input [31:0] S2_REG_UE_IMM_OUT;
  input [4:0] DP_ALU_OPCODE;
  output [4:0] S3_REG_ADD_WR_OUT;
  output [31:0] S3_REG_ALU_OUT;
  output [31:0] S3_REG_DATA_OUT;
  output [31:0] S3_REG_NPC_OUT;
  input CLK, nRST, S2_FF_JAL_EN_OUT, MUX_A_SEL, MUX_B_SEL, ALU_OUTREG_EN,
         EQ_COND, JMP, EQZ_NEQZ;
  output S3_FF_JAL_EN_OUT, S3_FF_COND_OUT;
  wire   S3_BranchTaken, S3_MUX_A_n5, S3_MUX_A_n4, S3_MUX_A_n3, S3_MUX_A_n2,
         S3_MUX_A_n1, S3_MUX_A_n65, S3_MUX_A_n64, S3_MUX_A_n63, S3_MUX_A_n62,
         S3_MUX_A_n61, S3_MUX_A_n60, S3_MUX_A_n59, S3_MUX_A_n58, S3_MUX_A_n57,
         S3_MUX_A_n56, S3_MUX_A_n55, S3_MUX_A_n54, S3_MUX_A_n53, S3_MUX_A_n52,
         S3_MUX_A_n51, S3_MUX_A_n50, S3_MUX_A_n49, S3_MUX_A_n48, S3_MUX_A_n47,
         S3_MUX_A_n46, S3_MUX_A_n45, S3_MUX_A_n44, S3_MUX_A_n43, S3_MUX_A_n42,
         S3_MUX_A_n41, S3_MUX_A_n40, S3_MUX_A_n39, S3_MUX_A_n38, S3_MUX_A_n37,
         S3_MUX_A_n36, S3_MUX_A_n35, S3_MUX_A_n34, S3_MUX_B_n101,
         S3_MUX_B_n100, S3_MUX_B_n99, S3_MUX_B_n98, S3_MUX_B_n97, S3_MUX_B_n96,
         S3_MUX_B_n95, S3_MUX_B_n94, S3_MUX_B_n93, S3_MUX_B_n92, S3_MUX_B_n91,
         S3_MUX_B_n90, S3_MUX_B_n89, S3_MUX_B_n88, S3_MUX_B_n87, S3_MUX_B_n86,
         S3_MUX_B_n85, S3_MUX_B_n84, S3_MUX_B_n83, S3_MUX_B_n82, S3_MUX_B_n81,
         S3_MUX_B_n80, S3_MUX_B_n79, S3_MUX_B_n78, S3_MUX_B_n77, S3_MUX_B_n76,
         S3_MUX_B_n75, S3_MUX_B_n74, S3_MUX_B_n73, S3_MUX_B_n72, S3_MUX_B_n71,
         S3_MUX_B_n70, S3_MUX_B_n5, S3_MUX_B_n4, S3_MUX_B_n3, S3_MUX_B_n2,
         S3_MUX_B_n1, S3_MUX_JMP_n101, S3_MUX_JMP_n100, S3_MUX_JMP_n99,
         S3_MUX_JMP_n98, S3_MUX_JMP_n97, S3_MUX_JMP_n96, S3_MUX_JMP_n95,
         S3_MUX_JMP_n94, S3_MUX_JMP_n93, S3_MUX_JMP_n92, S3_MUX_JMP_n91,
         S3_MUX_JMP_n90, S3_MUX_JMP_n89, S3_MUX_JMP_n88, S3_MUX_JMP_n87,
         S3_MUX_JMP_n86, S3_MUX_JMP_n85, S3_MUX_JMP_n84, S3_MUX_JMP_n83,
         S3_MUX_JMP_n82, S3_MUX_JMP_n81, S3_MUX_JMP_n80, S3_MUX_JMP_n79,
         S3_MUX_JMP_n78, S3_MUX_JMP_n77, S3_MUX_JMP_n76, S3_MUX_JMP_n75,
         S3_MUX_JMP_n74, S3_MUX_JMP_n73, S3_MUX_JMP_n72, S3_MUX_JMP_n71,
         S3_MUX_JMP_n70, S3_MUX_JMP_n5, S3_MUX_JMP_n4, S3_MUX_JMP_n3,
         S3_MUX_JMP_n2, S3_MUX_JMP_n1, S3_ALU_n316, S3_ALU_n315, S3_ALU_n314,
         S3_ALU_n313, S3_ALU_n312, S3_ALU_n311, S3_ALU_n310, S3_ALU_n309,
         S3_ALU_n308, S3_ALU_n307, S3_ALU_n306, S3_ALU_n305, S3_ALU_n304,
         S3_ALU_n303, S3_ALU_n302, S3_ALU_n301, S3_ALU_n300, S3_ALU_n299,
         S3_ALU_n264, S3_ALU_n258, S3_ALU_n256, S3_ALU_n252, S3_ALU_n247,
         S3_ALU_n246, S3_ALU_n243, S3_ALU_n233, S3_ALU_n227, S3_ALU_n226,
         S3_ALU_n223, S3_ALU_n222, S3_ALU_n216, S3_ALU_n210, S3_ALU_n204,
         S3_ALU_n198, S3_ALU_n192, S3_ALU_n186, S3_ALU_n180, S3_ALU_n174,
         S3_ALU_n168, S3_ALU_n162, S3_ALU_n156, S3_ALU_n150, S3_ALU_n144,
         S3_ALU_n138, S3_ALU_n132, S3_ALU_n126, S3_ALU_n120, S3_ALU_n114,
         S3_ALU_n108, S3_ALU_n102, S3_ALU_n96, S3_ALU_n90, S3_ALU_n84,
         S3_ALU_n78, S3_ALU_n72, S3_ALU_n66, S3_ALU_n60, S3_ALU_n54,
         S3_ALU_n48, S3_ALU_n42, S3_ALU_n40, S3_ALU_n37, S3_ALU_n32,
         S3_ALU_n27, S3_ALU_n26, S3_ALU_n25, S3_ALU_n24, S3_ALU_n23,
         S3_ALU_n22, S3_ALU_n21, S3_ALU_n20, S3_ALU_n19, S3_ALU_n18,
         S3_ALU_n17, S3_ALU_n16, S3_ALU_n15, S3_ALU_n14, S3_ALU_n13,
         S3_ALU_n12, S3_ALU_n11, S3_ALU_n10, S3_ALU_n9, S3_ALU_n8, S3_ALU_n7,
         S3_ALU_n298, S3_ALU_n297, S3_ALU_n296, S3_ALU_n295, S3_ALU_n294,
         S3_ALU_n293, S3_ALU_n292, S3_ALU_n291, S3_ALU_n290, S3_ALU_n289,
         S3_ALU_n288, S3_ALU_n287, S3_ALU_n286, S3_ALU_n285, S3_ALU_n284,
         S3_ALU_n283, S3_ALU_n282, S3_ALU_n281, S3_ALU_n280, S3_ALU_n279,
         S3_ALU_n278, S3_ALU_n277, S3_ALU_n276, S3_ALU_n275, S3_ALU_n274,
         S3_ALU_n273, S3_ALU_n272, S3_ALU_n271, S3_ALU_n270, S3_ALU_n269,
         S3_ALU_n268, S3_ALU_n267, S3_ALU_n266, S3_ALU_n265, S3_ALU_n263,
         S3_ALU_n262, S3_ALU_n261, S3_ALU_n260, S3_ALU_n259, S3_ALU_n257,
         S3_ALU_n255, S3_ALU_n254, S3_ALU_n253, S3_ALU_n251, S3_ALU_n250,
         S3_ALU_n249, S3_ALU_n248, S3_ALU_n245, S3_ALU_n244, S3_ALU_n242,
         S3_ALU_n241, S3_ALU_n240, S3_ALU_n239, S3_ALU_n238, S3_ALU_n237,
         S3_ALU_n236, S3_ALU_n235, S3_ALU_n234, S3_ALU_n232, S3_ALU_n231,
         S3_ALU_n230, S3_ALU_n229, S3_ALU_n228, S3_ALU_n225, S3_ALU_n224,
         S3_ALU_n221, S3_ALU_n220, S3_ALU_n219, S3_ALU_n218, S3_ALU_n217,
         S3_ALU_n215, S3_ALU_n214, S3_ALU_n213, S3_ALU_n212, S3_ALU_n211,
         S3_ALU_n209, S3_ALU_n208, S3_ALU_n207, S3_ALU_n206, S3_ALU_n205,
         S3_ALU_n203, S3_ALU_n202, S3_ALU_n201, S3_ALU_n200, S3_ALU_n199,
         S3_ALU_n197, S3_ALU_n196, S3_ALU_n195, S3_ALU_n194, S3_ALU_n193,
         S3_ALU_n191, S3_ALU_n190, S3_ALU_n189, S3_ALU_n188, S3_ALU_n187,
         S3_ALU_n185, S3_ALU_n184, S3_ALU_n183, S3_ALU_n182, S3_ALU_n181,
         S3_ALU_n179, S3_ALU_n178, S3_ALU_n177, S3_ALU_n176, S3_ALU_n175,
         S3_ALU_n173, S3_ALU_n172, S3_ALU_n171, S3_ALU_n170, S3_ALU_n169,
         S3_ALU_n167, S3_ALU_n166, S3_ALU_n165, S3_ALU_n164, S3_ALU_n163,
         S3_ALU_n161, S3_ALU_n160, S3_ALU_n159, S3_ALU_n158, S3_ALU_n157,
         S3_ALU_n155, S3_ALU_n154, S3_ALU_n153, S3_ALU_n152, S3_ALU_n151,
         S3_ALU_n149, S3_ALU_n148, S3_ALU_n147, S3_ALU_n146, S3_ALU_n145,
         S3_ALU_n143, S3_ALU_n142, S3_ALU_n141, S3_ALU_n140, S3_ALU_n139,
         S3_ALU_n137, S3_ALU_n136, S3_ALU_n135, S3_ALU_n134, S3_ALU_n133,
         S3_ALU_n131, S3_ALU_n130, S3_ALU_n129, S3_ALU_n128, S3_ALU_n127,
         S3_ALU_n125, S3_ALU_n124, S3_ALU_n123, S3_ALU_n122, S3_ALU_n121,
         S3_ALU_n119, S3_ALU_n118, S3_ALU_n117, S3_ALU_n116, S3_ALU_n115,
         S3_ALU_n113, S3_ALU_n112, S3_ALU_n111, S3_ALU_n110, S3_ALU_n109,
         S3_ALU_n107, S3_ALU_n106, S3_ALU_n105, S3_ALU_n104, S3_ALU_n103,
         S3_ALU_n101, S3_ALU_n100, S3_ALU_n99, S3_ALU_n98, S3_ALU_n97,
         S3_ALU_n95, S3_ALU_n94, S3_ALU_n93, S3_ALU_n92, S3_ALU_n91,
         S3_ALU_n89, S3_ALU_n88, S3_ALU_n87, S3_ALU_n86, S3_ALU_n85,
         S3_ALU_n83, S3_ALU_n82, S3_ALU_n81, S3_ALU_n80, S3_ALU_n79,
         S3_ALU_n77, S3_ALU_n76, S3_ALU_n75, S3_ALU_n74, S3_ALU_n73,
         S3_ALU_n71, S3_ALU_n70, S3_ALU_n69, S3_ALU_n68, S3_ALU_n67,
         S3_ALU_n65, S3_ALU_n64, S3_ALU_n63, S3_ALU_n62, S3_ALU_n61,
         S3_ALU_n59, S3_ALU_n58, S3_ALU_n57, S3_ALU_n56, S3_ALU_n55,
         S3_ALU_n53, S3_ALU_n52, S3_ALU_n51, S3_ALU_n50, S3_ALU_n49,
         S3_ALU_n47, S3_ALU_n46, S3_ALU_n45, S3_ALU_n44, S3_ALU_n43,
         S3_ALU_n41, S3_ALU_n39, S3_ALU_n38, S3_ALU_n36, S3_ALU_n35,
         S3_ALU_n34, S3_ALU_n33, S3_ALU_n31, S3_ALU_n30, S3_ALU_n29,
         S3_ALU_N395, S3_ALU_N394, S3_ALU_N393, S3_ALU_N392, S3_ALU_N391,
         S3_ALU_N390, S3_ALU_N389, S3_ALU_N388, S3_ALU_N387, S3_ALU_N386,
         S3_ALU_N385, S3_ALU_N384, S3_ALU_N383, S3_ALU_N382, S3_ALU_N381,
         S3_ALU_N380, S3_ALU_N379, S3_ALU_N378, S3_ALU_N377, S3_ALU_N376,
         S3_ALU_N375, S3_ALU_N374, S3_ALU_N373, S3_ALU_N372, S3_ALU_N371,
         S3_ALU_N370, S3_ALU_N369, S3_ALU_N368, S3_ALU_N367, S3_ALU_N366,
         S3_ALU_N365, S3_ALU_N364, S3_ALU_N363, S3_ALU_N362, S3_ALU_N361,
         S3_ALU_N360, S3_ALU_N359, S3_ALU_N358, S3_ALU_N357, S3_ALU_N356,
         S3_ALU_N355, S3_ALU_N354, S3_ALU_N353, S3_ALU_N352, S3_ALU_N351,
         S3_ALU_N350, S3_ALU_N349, S3_ALU_N348, S3_ALU_N347, S3_ALU_N346,
         S3_ALU_N345, S3_ALU_N344, S3_ALU_N343, S3_ALU_N342, S3_ALU_N341,
         S3_ALU_N340, S3_ALU_N339, S3_ALU_N338, S3_ALU_N337, S3_ALU_N336,
         S3_ALU_N335, S3_ALU_N334, S3_ALU_N333, S3_ALU_N332, S3_ALU_N331,
         S3_ALU_N330, S3_ALU_N329, S3_ALU_N328, S3_ALU_N327, S3_ALU_N326,
         S3_ALU_N325, S3_ALU_N324, S3_ALU_N323, S3_ALU_N322, S3_ALU_N225,
         S3_ALU_N224, S3_ALU_N223, S3_ALU_N222, S3_ALU_N221, S3_ALU_N220,
         S3_ALU_N219, S3_ALU_N218, S3_ALU_N217, S3_ALU_N216, S3_ALU_N215,
         S3_ALU_N214, S3_ALU_N213, S3_ALU_N212, S3_ALU_N211, S3_ALU_N210,
         S3_ALU_N209, S3_ALU_N208, S3_ALU_N207, S3_ALU_N206, S3_ALU_N205,
         S3_ALU_N204, S3_ALU_N203, S3_ALU_N202, S3_ALU_N201, S3_ALU_N200,
         S3_ALU_N199, S3_ALU_N198, S3_ALU_N197, S3_ALU_N196, S3_ALU_N195,
         S3_ALU_N194, S3_ALU_N193, S3_ALU_N192, S3_ALU_N191, S3_ALU_N190,
         S3_ALU_N189, S3_ALU_N188, S3_ALU_N187, S3_ALU_N186, S3_ALU_N185,
         S3_ALU_N184, S3_ALU_N183, S3_ALU_N182, S3_ALU_N181, S3_ALU_N180,
         S3_ALU_N179, S3_ALU_N178, S3_ALU_N177, S3_ALU_N176, S3_ALU_N175,
         S3_ALU_N174, S3_ALU_N173, S3_ALU_N172, S3_ALU_N171, S3_ALU_N170,
         S3_ALU_N169, S3_ALU_N168, S3_ALU_N167, S3_ALU_N166, S3_ALU_N165,
         S3_ALU_N164, S3_ALU_N163, S3_ALU_N162, S3_ALU_shifter_n616,
         S3_ALU_shifter_n615, S3_ALU_shifter_n614, S3_ALU_shifter_n613,
         S3_ALU_shifter_n612, S3_ALU_shifter_n611, S3_ALU_shifter_n610,
         S3_ALU_shifter_n609, S3_ALU_shifter_n608, S3_ALU_shifter_n607,
         S3_ALU_shifter_n606, S3_ALU_shifter_n605, S3_ALU_shifter_n604,
         S3_ALU_shifter_n603, S3_ALU_shifter_n602, S3_ALU_shifter_n601,
         S3_ALU_shifter_n600, S3_ALU_shifter_n599, S3_ALU_shifter_n598,
         S3_ALU_shifter_n597, S3_ALU_shifter_n596, S3_ALU_shifter_n595,
         S3_ALU_shifter_n594, S3_ALU_shifter_n593, S3_ALU_shifter_n592,
         S3_ALU_shifter_n591, S3_ALU_shifter_n590, S3_ALU_shifter_n589,
         S3_ALU_shifter_n588, S3_ALU_shifter_n587, S3_ALU_shifter_n586,
         S3_ALU_shifter_n585, S3_ALU_shifter_n584, S3_ALU_shifter_n583,
         S3_ALU_shifter_n582, S3_ALU_shifter_n581, S3_ALU_shifter_n580,
         S3_ALU_shifter_n579, S3_ALU_shifter_n578, S3_ALU_shifter_n577,
         S3_ALU_shifter_n576, S3_ALU_shifter_n575, S3_ALU_shifter_n574,
         S3_ALU_shifter_n573, S3_ALU_shifter_n572, S3_ALU_shifter_n571,
         S3_ALU_shifter_n570, S3_ALU_shifter_n569, S3_ALU_shifter_n568,
         S3_ALU_shifter_n567, S3_ALU_shifter_n566, S3_ALU_shifter_n565,
         S3_ALU_shifter_n564, S3_ALU_shifter_n563, S3_ALU_shifter_n562,
         S3_ALU_shifter_n561, S3_ALU_shifter_n560, S3_ALU_shifter_n559,
         S3_ALU_shifter_n558, S3_ALU_shifter_n557, S3_ALU_shifter_n556,
         S3_ALU_shifter_n555, S3_ALU_shifter_n554, S3_ALU_shifter_n553,
         S3_ALU_shifter_n552, S3_ALU_shifter_n551, S3_ALU_shifter_n550,
         S3_ALU_shifter_n549, S3_ALU_shifter_n548, S3_ALU_shifter_n547,
         S3_ALU_shifter_n546, S3_ALU_shifter_n545, S3_ALU_shifter_n544,
         S3_ALU_shifter_n543, S3_ALU_shifter_n542, S3_ALU_shifter_n541,
         S3_ALU_shifter_n540, S3_ALU_shifter_n539, S3_ALU_shifter_n538,
         S3_ALU_shifter_n537, S3_ALU_shifter_n536, S3_ALU_shifter_n535,
         S3_ALU_shifter_n534, S3_ALU_shifter_n533, S3_ALU_shifter_n532,
         S3_ALU_shifter_n531, S3_ALU_shifter_n530, S3_ALU_shifter_n529,
         S3_ALU_shifter_n528, S3_ALU_shifter_n527, S3_ALU_shifter_n526,
         S3_ALU_shifter_n525, S3_ALU_shifter_n524, S3_ALU_shifter_n523,
         S3_ALU_shifter_n522, S3_ALU_shifter_n521, S3_ALU_shifter_n520,
         S3_ALU_shifter_n519, S3_ALU_shifter_n518, S3_ALU_shifter_n517,
         S3_ALU_shifter_n516, S3_ALU_shifter_n515, S3_ALU_shifter_n514,
         S3_ALU_shifter_n513, S3_ALU_shifter_n512, S3_ALU_shifter_n511,
         S3_ALU_shifter_n510, S3_ALU_shifter_n509, S3_ALU_shifter_n508,
         S3_ALU_shifter_n507, S3_ALU_shifter_n506, S3_ALU_shifter_n505,
         S3_ALU_shifter_n504, S3_ALU_shifter_n503, S3_ALU_shifter_n502,
         S3_ALU_shifter_n501, S3_ALU_shifter_n500, S3_ALU_shifter_n499,
         S3_ALU_shifter_n498, S3_ALU_shifter_n497, S3_ALU_shifter_n496,
         S3_ALU_shifter_n495, S3_ALU_shifter_n494, S3_ALU_shifter_n493,
         S3_ALU_shifter_n492, S3_ALU_shifter_n491, S3_ALU_shifter_n490,
         S3_ALU_shifter_n489, S3_ALU_shifter_n488, S3_ALU_shifter_n487,
         S3_ALU_shifter_n486, S3_ALU_shifter_n485, S3_ALU_shifter_n484,
         S3_ALU_shifter_n483, S3_ALU_shifter_n482, S3_ALU_shifter_n481,
         S3_ALU_shifter_n480, S3_ALU_shifter_n479, S3_ALU_shifter_n478,
         S3_ALU_shifter_n477, S3_ALU_shifter_n476, S3_ALU_shifter_n475,
         S3_ALU_shifter_n474, S3_ALU_shifter_n473, S3_ALU_shifter_n472,
         S3_ALU_shifter_n471, S3_ALU_shifter_n470, S3_ALU_shifter_n469,
         S3_ALU_shifter_n468, S3_ALU_shifter_n467, S3_ALU_shifter_n466,
         S3_ALU_shifter_n465, S3_ALU_shifter_n464, S3_ALU_shifter_n463,
         S3_ALU_shifter_n462, S3_ALU_shifter_n461, S3_ALU_shifter_n460,
         S3_ALU_shifter_n459, S3_ALU_shifter_n458, S3_ALU_shifter_n457,
         S3_ALU_shifter_n456, S3_ALU_shifter_n455, S3_ALU_shifter_n454,
         S3_ALU_shifter_n453, S3_ALU_shifter_n452, S3_ALU_shifter_n451,
         S3_ALU_shifter_n450, S3_ALU_shifter_n449, S3_ALU_shifter_n448,
         S3_ALU_shifter_n447, S3_ALU_shifter_n446, S3_ALU_shifter_n445,
         S3_ALU_shifter_n444, S3_ALU_shifter_n443, S3_ALU_shifter_n442,
         S3_ALU_shifter_n441, S3_ALU_shifter_n440, S3_ALU_shifter_n439,
         S3_ALU_shifter_n438, S3_ALU_shifter_n437, S3_ALU_shifter_n436,
         S3_ALU_shifter_n435, S3_ALU_shifter_n434, S3_ALU_shifter_n433,
         S3_ALU_shifter_n432, S3_ALU_shifter_n431, S3_ALU_shifter_n430,
         S3_ALU_shifter_n429, S3_ALU_shifter_n428, S3_ALU_shifter_n427,
         S3_ALU_shifter_n426, S3_ALU_shifter_n425, S3_ALU_shifter_n424,
         S3_ALU_shifter_n423, S3_ALU_shifter_n422, S3_ALU_shifter_n421,
         S3_ALU_shifter_n420, S3_ALU_shifter_n419, S3_ALU_shifter_n418,
         S3_ALU_shifter_n417, S3_ALU_shifter_n416, S3_ALU_shifter_n415,
         S3_ALU_shifter_n414, S3_ALU_shifter_n413, S3_ALU_shifter_n412,
         S3_ALU_shifter_n411, S3_ALU_shifter_n410, S3_ALU_shifter_n409,
         S3_ALU_shifter_n408, S3_ALU_shifter_n407, S3_ALU_shifter_n406,
         S3_ALU_shifter_n405, S3_ALU_shifter_n404, S3_ALU_shifter_n403,
         S3_ALU_shifter_n402, S3_ALU_shifter_n401, S3_ALU_shifter_n400,
         S3_ALU_shifter_n399, S3_ALU_shifter_n398, S3_ALU_shifter_n397,
         S3_ALU_shifter_n396, S3_ALU_shifter_n395, S3_ALU_shifter_n394,
         S3_ALU_shifter_n393, S3_ALU_shifter_n392, S3_ALU_shifter_n391,
         S3_ALU_shifter_n390, S3_ALU_shifter_n389, S3_ALU_shifter_n388,
         S3_ALU_shifter_n387, S3_ALU_shifter_n386, S3_ALU_shifter_n385,
         S3_ALU_shifter_n384, S3_ALU_shifter_n383, S3_ALU_shifter_n382,
         S3_ALU_shifter_n381, S3_ALU_shifter_n380, S3_ALU_shifter_n379,
         S3_ALU_shifter_n378, S3_ALU_shifter_n377, S3_ALU_shifter_n376,
         S3_ALU_shifter_n375, S3_ALU_shifter_n374, S3_ALU_shifter_n373,
         S3_ALU_shifter_n372, S3_ALU_shifter_n371, S3_ALU_shifter_n370,
         S3_ALU_shifter_n369, S3_ALU_shifter_n368, S3_ALU_shifter_n367,
         S3_ALU_shifter_n366, S3_ALU_shifter_n365, S3_ALU_shifter_n364,
         S3_ALU_shifter_n363, S3_ALU_shifter_n362, S3_ALU_shifter_n361,
         S3_ALU_shifter_n360, S3_ALU_shifter_n359, S3_ALU_shifter_n358,
         S3_ALU_shifter_n357, S3_ALU_shifter_n356, S3_ALU_shifter_n355,
         S3_ALU_shifter_n354, S3_ALU_shifter_n353, S3_ALU_shifter_n352,
         S3_ALU_shifter_n351, S3_ALU_shifter_n350, S3_ALU_shifter_n349,
         S3_ALU_shifter_n348, S3_ALU_shifter_n347, S3_ALU_shifter_n346,
         S3_ALU_shifter_n345, S3_ALU_shifter_n344, S3_ALU_shifter_n343,
         S3_ALU_shifter_n342, S3_ALU_shifter_n341, S3_ALU_shifter_n340,
         S3_ALU_shifter_n339, S3_ALU_shifter_n338, S3_ALU_shifter_n337,
         S3_ALU_shifter_n336, S3_ALU_shifter_n335, S3_ALU_shifter_n334,
         S3_ALU_shifter_n333, S3_ALU_shifter_n332, S3_ALU_shifter_n331,
         S3_ALU_shifter_n330, S3_ALU_shifter_n329, S3_ALU_shifter_n328,
         S3_ALU_shifter_n327, S3_ALU_shifter_n326, S3_ALU_shifter_n325,
         S3_ALU_shifter_n324, S3_ALU_shifter_n323, S3_ALU_shifter_n322,
         S3_ALU_shifter_n321, S3_ALU_shifter_n320, S3_ALU_shifter_n319,
         S3_ALU_shifter_n318, S3_ALU_shifter_n317, S3_ALU_shifter_n316,
         S3_ALU_shifter_n315, S3_ALU_shifter_n314, S3_ALU_shifter_n313,
         S3_ALU_shifter_n312, S3_ALU_shifter_n311, S3_ALU_shifter_n310,
         S3_ALU_shifter_n309, S3_ALU_shifter_n308, S3_ALU_shifter_n307,
         S3_ALU_shifter_n306, S3_ALU_shifter_n305, S3_ALU_shifter_n304,
         S3_ALU_shifter_n303, S3_ALU_shifter_n302, S3_ALU_shifter_n301,
         S3_ALU_shifter_n300, S3_ALU_shifter_n299, S3_ALU_shifter_n298,
         S3_ALU_shifter_n297, S3_ALU_shifter_n296, S3_ALU_shifter_n295,
         S3_ALU_shifter_n294, S3_ALU_shifter_n293, S3_ALU_shifter_n292,
         S3_ALU_shifter_n291, S3_ALU_shifter_n290, S3_ALU_shifter_n289,
         S3_ALU_shifter_n288, S3_ALU_shifter_n287, S3_ALU_shifter_n286,
         S3_ALU_shifter_n285, S3_ALU_shifter_n284, S3_ALU_shifter_n283,
         S3_ALU_shifter_n282, S3_ALU_shifter_n281, S3_ALU_shifter_n280,
         S3_ALU_shifter_n279, S3_ALU_shifter_n278, S3_ALU_shifter_n277,
         S3_ALU_shifter_n276, S3_ALU_shifter_n275, S3_ALU_shifter_n274,
         S3_ALU_shifter_n273, S3_ALU_shifter_n272, S3_ALU_shifter_n271,
         S3_ALU_shifter_n270, S3_ALU_shifter_n269, S3_ALU_shifter_n268,
         S3_ALU_shifter_n267, S3_ALU_shifter_n266, S3_ALU_shifter_n265,
         S3_ALU_shifter_n264, S3_ALU_shifter_n263, S3_ALU_shifter_n262,
         S3_ALU_shifter_n261, S3_ALU_shifter_n260, S3_ALU_shifter_n259,
         S3_ALU_shifter_n258, S3_ALU_shifter_n257, S3_ALU_shifter_n256,
         S3_ALU_shifter_n255, S3_ALU_shifter_n254, S3_ALU_shifter_n253,
         S3_ALU_shifter_n252, S3_ALU_shifter_n251, S3_ALU_shifter_n250,
         S3_ALU_shifter_n249, S3_ALU_shifter_n248, S3_ALU_shifter_n247,
         S3_ALU_shifter_n246, S3_ALU_shifter_n245, S3_ALU_shifter_n244,
         S3_ALU_shifter_n243, S3_ALU_shifter_n242, S3_ALU_shifter_n241,
         S3_ALU_shifter_n240, S3_ALU_shifter_n239, S3_ALU_shifter_n238,
         S3_ALU_shifter_n237, S3_ALU_shifter_n236, S3_ALU_shifter_n235,
         S3_ALU_shifter_n234, S3_ALU_shifter_n233, S3_ALU_shifter_n232,
         S3_ALU_shifter_n231, S3_ALU_shifter_n230, S3_ALU_shifter_n229,
         S3_ALU_shifter_n228, S3_ALU_shifter_n227, S3_ALU_shifter_n226,
         S3_ALU_shifter_n225, S3_ALU_shifter_n224, S3_ALU_shifter_n223,
         S3_ALU_shifter_n222, S3_ALU_shifter_n221, S3_ALU_shifter_n220,
         S3_ALU_shifter_n219, S3_ALU_shifter_n218, S3_ALU_shifter_n217,
         S3_ALU_shifter_n216, S3_ALU_shifter_n215, S3_ALU_shifter_n214,
         S3_ALU_shifter_n213, S3_ALU_shifter_n212, S3_ALU_shifter_n211,
         S3_ALU_shifter_n210, S3_ALU_shifter_n209, S3_ALU_shifter_n208,
         S3_ALU_shifter_n207, S3_ALU_shifter_n206, S3_ALU_shifter_n205,
         S3_ALU_shifter_n204, S3_ALU_shifter_n203, S3_ALU_shifter_n202,
         S3_ALU_shifter_n201, S3_ALU_shifter_n200, S3_ALU_shifter_n199,
         S3_ALU_shifter_n198, S3_ALU_shifter_n197, S3_ALU_shifter_n196,
         S3_ALU_shifter_n195, S3_ALU_shifter_n194, S3_ALU_shifter_n193,
         S3_ALU_shifter_n192, S3_ALU_shifter_n191, S3_ALU_shifter_n190,
         S3_ALU_shifter_n189, S3_ALU_shifter_n188, S3_ALU_shifter_n187,
         S3_ALU_shifter_n186, S3_ALU_shifter_n185, S3_ALU_shifter_n184,
         S3_ALU_shifter_n183, S3_ALU_shifter_n182, S3_ALU_shifter_n181,
         S3_ALU_shifter_n180, S3_ALU_shifter_n179, S3_ALU_shifter_n178,
         S3_ALU_shifter_n177, S3_ALU_shifter_n176, S3_ALU_shifter_n175,
         S3_ALU_shifter_n174, S3_ALU_shifter_n173, S3_ALU_shifter_n172,
         S3_ALU_shifter_n171, S3_ALU_shifter_n170, S3_ALU_shifter_n169,
         S3_ALU_shifter_n168, S3_ALU_shifter_n167, S3_ALU_shifter_n166,
         S3_ALU_shifter_n165, S3_ALU_shifter_n164, S3_ALU_shifter_n163,
         S3_ALU_shifter_n162, S3_ALU_shifter_n161, S3_ALU_shifter_n160,
         S3_ALU_shifter_n159, S3_ALU_shifter_n158, S3_ALU_shifter_n157,
         S3_ALU_shifter_n156, S3_ALU_shifter_n155, S3_ALU_shifter_n154,
         S3_ALU_shifter_n153, S3_ALU_shifter_n152, S3_ALU_shifter_n151,
         S3_ALU_shifter_n150, S3_ALU_shifter_n149, S3_ALU_shifter_n148,
         S3_ALU_shifter_n147, S3_ALU_shifter_n146, S3_ALU_shifter_n145,
         S3_ALU_shifter_n144, S3_ALU_shifter_n143, S3_ALU_shifter_n142,
         S3_ALU_shifter_n141, S3_ALU_shifter_n140, S3_ALU_shifter_n139,
         S3_ALU_shifter_n138, S3_ALU_shifter_n137, S3_ALU_shifter_n136,
         S3_ALU_shifter_n135, S3_ALU_shifter_n133, S3_ALU_shifter_n130,
         S3_ALU_shifter_n128, S3_ALU_shifter_n125, S3_ALU_shifter_n122,
         S3_ALU_shifter_n120, S3_ALU_shifter_n117, S3_ALU_shifter_n115,
         S3_ALU_shifter_n112, S3_ALU_shifter_n108, S3_ALU_shifter_n106,
         S3_ALU_shifter_n102, S3_ALU_shifter_n99, S3_ALU_shifter_n96,
         S3_ALU_shifter_n94, S3_ALU_shifter_n92, S3_ALU_shifter_n89,
         S3_ALU_shifter_n85, S3_ALU_shifter_n84, S3_ALU_shifter_n83,
         S3_ALU_shifter_n82, S3_ALU_shifter_n81, S3_ALU_shifter_n80,
         S3_ALU_shifter_n79, S3_ALU_shifter_n78, S3_ALU_shifter_n77,
         S3_ALU_shifter_n76, S3_ALU_shifter_n75, S3_ALU_shifter_n74,
         S3_ALU_shifter_n41, S3_ALU_shifter_n39, S3_ALU_shifter_n38,
         S3_ALU_shifter_n37, S3_ALU_shifter_n36, S3_ALU_shifter_n35,
         S3_ALU_shifter_n34, S3_ALU_shifter_n33, S3_ALU_shifter_n32,
         S3_ALU_shifter_n31, S3_ALU_shifter_n30, S3_ALU_shifter_n29,
         S3_ALU_shifter_n28, S3_ALU_shifter_n27, S3_ALU_shifter_n26,
         S3_ALU_shifter_n25, S3_ALU_shifter_n24, S3_ALU_shifter_n23,
         S3_ALU_shifter_n22, S3_ALU_shifter_n21, S3_ALU_shifter_n20,
         S3_ALU_shifter_n19, S3_ALU_shifter_n18, S3_ALU_shifter_n17,
         S3_ALU_shifter_n16, S3_ALU_shifter_n15, S3_ALU_shifter_n14,
         S3_ALU_shifter_n13, S3_ALU_shifter_n12, S3_ALU_shifter_n11,
         S3_ALU_shifter_n10, S3_ALU_shifter_n9, S3_ALU_shifter_n8,
         S3_ALU_shifter_n7, S3_ALU_shifter_n6, S3_ALU_shifter_n5,
         S3_ALU_shifter_n4, S3_ALU_shifter_n3, S3_ALU_shifter_n2,
         S3_ALU_shifter_n1, S3_ALU_shifter_n73, S3_ALU_shifter_n72,
         S3_ALU_shifter_n71, S3_ALU_shifter_n70, S3_ALU_shifter_n69,
         S3_ALU_shifter_n68, S3_ALU_shifter_n67, S3_ALU_shifter_n66,
         S3_ALU_shifter_n65, S3_ALU_shifter_n64, S3_ALU_shifter_n63,
         S3_ALU_shifter_n62, S3_ALU_shifter_n61, S3_ALU_shifter_n60,
         S3_ALU_shifter_n59, S3_ALU_shifter_n58, S3_ALU_shifter_n57,
         S3_ALU_shifter_n56, S3_ALU_shifter_n55, S3_ALU_shifter_n54,
         S3_ALU_shifter_n53, S3_ALU_shifter_n52, S3_ALU_shifter_n51,
         S3_ALU_shifter_n50, S3_ALU_shifter_n49, S3_ALU_shifter_n48,
         S3_ALU_shifter_n47, S3_ALU_shifter_n46, S3_ALU_shifter_n45,
         S3_ALU_shifter_n44, S3_ALU_shifter_n43, S3_ALU_shifter_n42,
         S3_ALU_shifter_n40, S3_ALU_shifter_N197, S3_ALU_shifter_N196,
         S3_ALU_shifter_N195, S3_ALU_shifter_N194, S3_ALU_shifter_N181,
         S3_ALU_shifter_N180, S3_ALU_shifter_N179, S3_ALU_shifter_N178,
         S3_ALU_shifter_N177, S3_ALU_shifter_N176, S3_ALU_shifter_N175,
         S3_ALU_shifter_N174, S3_ALU_shifter_N173, S3_ALU_shifter_N172,
         S3_ALU_shifter_N171, S3_ALU_shifter_N170, S3_ALU_shifter_N169,
         S3_ALU_shifter_N168, S3_ALU_shifter_N167, S3_ALU_shifter_N166,
         S3_ALU_shifter_N68, S3_ALU_shifter_N67, S3_ALU_shifter_N66,
         S3_ALU_shifter_N65, S3_ALU_shifter_N64, S3_ALU_shifter_N63,
         S3_ALU_shifter_N62, S3_ALU_shifter_N61, S3_ALU_shifter_N60,
         S3_ALU_shifter_N59, S3_ALU_shifter_N58, S3_ALU_shifter_N57,
         S3_ALU_shifter_N56, S3_ALU_shifter_N55, S3_ALU_shifter_N54,
         S3_ALU_shifter_N53, S3_ALU_shifter_N52, S3_ALU_shifter_N51,
         S3_ALU_shifter_N50, S3_ALU_shifter_N49, S3_ALU_shifter_N48,
         S3_ALU_shifter_N47, S3_ALU_shifter_N46, S3_ALU_shifter_N45,
         S3_ALU_shifter_N44, S3_ALU_shifter_N43, S3_ALU_shifter_N42,
         S3_ALU_shifter_N41, S3_ALU_shifter_N40, S3_ALU_shifter_N39,
         S3_ALU_shifter_N38, S3_ALU_shifter_N37, S3_ALU_shifter_N35,
         S3_ALU_shifter_N34, S3_ALU_shifter_N33, S3_ALU_shifter_N32,
         S3_ALU_shifter_N31, S3_ALU_shifter_N30, S3_ALU_shifter_N29,
         S3_ALU_shifter_N28, S3_ALU_shifter_N27, S3_ALU_shifter_N26,
         S3_ALU_shifter_N25, S3_ALU_shifter_N24, S3_ALU_shifter_N23,
         S3_ALU_shifter_N22, S3_ALU_shifter_N21, S3_ALU_shifter_N20,
         S3_ALU_shifter_N19, S3_ALU_shifter_N18, S3_ALU_shifter_N17,
         S3_ALU_shifter_N16, S3_ALU_shifter_N15, S3_ALU_shifter_N14,
         S3_ALU_shifter_N13, S3_ALU_shifter_N12, S3_ALU_shifter_N11,
         S3_ALU_shifter_N10, S3_ALU_shifter_N9, S3_ALU_shifter_N8,
         S3_ALU_shifter_N7, S3_ALU_shifter_N6, S3_ALU_shifter_N5,
         S3_ALU_sub_116_n33, S3_ALU_sub_116_n32, S3_ALU_sub_116_n31,
         S3_ALU_sub_116_n30, S3_ALU_sub_116_n29, S3_ALU_sub_116_n28,
         S3_ALU_sub_116_n27, S3_ALU_sub_116_n26, S3_ALU_sub_116_n25,
         S3_ALU_sub_116_n24, S3_ALU_sub_116_n23, S3_ALU_sub_116_n22,
         S3_ALU_sub_116_n21, S3_ALU_sub_116_n20, S3_ALU_sub_116_n19,
         S3_ALU_sub_116_n18, S3_ALU_sub_116_n17, S3_ALU_sub_116_n16,
         S3_ALU_sub_116_n15, S3_ALU_sub_116_n14, S3_ALU_sub_116_n13,
         S3_ALU_sub_116_n12, S3_ALU_sub_116_n11, S3_ALU_sub_116_n10,
         S3_ALU_sub_116_n9, S3_ALU_sub_116_n8, S3_ALU_sub_116_n7,
         S3_ALU_sub_116_n6, S3_ALU_sub_116_n5, S3_ALU_sub_116_n4,
         S3_ALU_sub_116_n3, S3_ALU_sub_116_n2, S3_ALU_sub_116_n1,
         S3_ALU_add_113_n2, S3_ALU_sub_73_n33, S3_ALU_sub_73_n32,
         S3_ALU_sub_73_n31, S3_ALU_sub_73_n30, S3_ALU_sub_73_n29,
         S3_ALU_sub_73_n28, S3_ALU_sub_73_n27, S3_ALU_sub_73_n26,
         S3_ALU_sub_73_n25, S3_ALU_sub_73_n24, S3_ALU_sub_73_n23,
         S3_ALU_sub_73_n22, S3_ALU_sub_73_n21, S3_ALU_sub_73_n20,
         S3_ALU_sub_73_n19, S3_ALU_sub_73_n18, S3_ALU_sub_73_n17,
         S3_ALU_sub_73_n16, S3_ALU_sub_73_n15, S3_ALU_sub_73_n14,
         S3_ALU_sub_73_n13, S3_ALU_sub_73_n12, S3_ALU_sub_73_n11,
         S3_ALU_sub_73_n10, S3_ALU_sub_73_n9, S3_ALU_sub_73_n8,
         S3_ALU_sub_73_n7, S3_ALU_sub_73_n6, S3_ALU_sub_73_n5,
         S3_ALU_sub_73_n4, S3_ALU_sub_73_n3, S3_ALU_sub_73_n2,
         S3_ALU_sub_73_n1, S3_ALU_add_70_n2, S3_ALU_r396_n202,
         S3_ALU_r396_n201, S3_ALU_r396_n200, S3_ALU_r396_n199,
         S3_ALU_r396_n198, S3_ALU_r396_n197, S3_ALU_r396_n196,
         S3_ALU_r396_n195, S3_ALU_r396_n194, S3_ALU_r396_n193,
         S3_ALU_r396_n192, S3_ALU_r396_n191, S3_ALU_r396_n190,
         S3_ALU_r396_n189, S3_ALU_r396_n188, S3_ALU_r396_n187,
         S3_ALU_r396_n186, S3_ALU_r396_n185, S3_ALU_r396_n184,
         S3_ALU_r396_n183, S3_ALU_r396_n182, S3_ALU_r396_n181,
         S3_ALU_r396_n180, S3_ALU_r396_n179, S3_ALU_r396_n178,
         S3_ALU_r396_n177, S3_ALU_r396_n176, S3_ALU_r396_n175,
         S3_ALU_r396_n174, S3_ALU_r396_n173, S3_ALU_r396_n172,
         S3_ALU_r396_n171, S3_ALU_r396_n170, S3_ALU_r396_n169,
         S3_ALU_r396_n168, S3_ALU_r396_n167, S3_ALU_r396_n166,
         S3_ALU_r396_n165, S3_ALU_r396_n164, S3_ALU_r396_n163,
         S3_ALU_r396_n162, S3_ALU_r396_n161, S3_ALU_r396_n160,
         S3_ALU_r396_n159, S3_ALU_r396_n158, S3_ALU_r396_n157,
         S3_ALU_r396_n156, S3_ALU_r396_n155, S3_ALU_r396_n154,
         S3_ALU_r396_n153, S3_ALU_r396_n152, S3_ALU_r396_n151,
         S3_ALU_r396_n150, S3_ALU_r396_n149, S3_ALU_r396_n148,
         S3_ALU_r396_n147, S3_ALU_r396_n146, S3_ALU_r396_n145,
         S3_ALU_r396_n144, S3_ALU_r396_n143, S3_ALU_r396_n142,
         S3_ALU_r396_n141, S3_ALU_r396_n140, S3_ALU_r396_n139,
         S3_ALU_r396_n138, S3_ALU_r396_n137, S3_ALU_r396_n136,
         S3_ALU_r396_n135, S3_ALU_r396_n134, S3_ALU_r396_n133,
         S3_ALU_r396_n132, S3_ALU_r396_n131, S3_ALU_r396_n130,
         S3_ALU_r396_n129, S3_ALU_r396_n128, S3_ALU_r396_n127,
         S3_ALU_r396_n126, S3_ALU_r396_n125, S3_ALU_r396_n124,
         S3_ALU_r396_n123, S3_ALU_r396_n122, S3_ALU_r396_n121,
         S3_ALU_r396_n120, S3_ALU_r396_n119, S3_ALU_r396_n118,
         S3_ALU_r396_n117, S3_ALU_r396_n116, S3_ALU_r396_n115,
         S3_ALU_r396_n114, S3_ALU_r396_n113, S3_ALU_r396_n112,
         S3_ALU_r396_n111, S3_ALU_r396_n110, S3_ALU_r396_n109,
         S3_ALU_r396_n108, S3_ALU_r396_n107, S3_ALU_r396_n106,
         S3_ALU_r396_n105, S3_ALU_r396_n104, S3_ALU_r396_n103,
         S3_ALU_r396_n102, S3_ALU_r396_n101, S3_ALU_r396_n100, S3_ALU_r396_n99,
         S3_ALU_r396_n98, S3_ALU_r396_n97, S3_ALU_r396_n96, S3_ALU_r396_n95,
         S3_ALU_r396_n94, S3_ALU_r396_n93, S3_ALU_r396_n92, S3_ALU_r396_n91,
         S3_ALU_r396_n90, S3_ALU_r396_n89, S3_ALU_r396_n88, S3_ALU_r396_n87,
         S3_ALU_r396_n86, S3_ALU_r396_n85, S3_ALU_r396_n84, S3_ALU_r396_n83,
         S3_ALU_r396_n82, S3_ALU_r396_n81, S3_ALU_r396_n80, S3_ALU_r396_n79,
         S3_ALU_r396_n78, S3_ALU_r396_n77, S3_ALU_r396_n76, S3_ALU_r396_n75,
         S3_ALU_r396_n74, S3_ALU_r396_n73, S3_ALU_r396_n72, S3_ALU_r396_n71,
         S3_ALU_r396_n70, S3_ALU_r396_n69, S3_ALU_r396_n68, S3_ALU_r396_n67,
         S3_ALU_r396_n66, S3_ALU_r396_n65, S3_ALU_r396_n64, S3_ALU_r396_n63,
         S3_ALU_r396_n62, S3_ALU_r396_n61, S3_ALU_r396_n60, S3_ALU_r396_n59,
         S3_ALU_r396_n58, S3_ALU_r396_n57, S3_ALU_r396_n56, S3_ALU_r396_n55,
         S3_ALU_r396_n54, S3_ALU_r396_n53, S3_ALU_r396_n52, S3_ALU_r396_n51,
         S3_ALU_r396_n50, S3_ALU_r396_n49, S3_ALU_r396_n48, S3_ALU_r396_n47,
         S3_ALU_r396_n46, S3_ALU_r396_n45, S3_ALU_r396_n44, S3_ALU_r396_n43,
         S3_ALU_r396_n42, S3_ALU_r396_n41, S3_ALU_r396_n40, S3_ALU_r396_n39,
         S3_ALU_r396_n38, S3_ALU_r396_n37, S3_ALU_r396_n36, S3_ALU_r396_n35,
         S3_ALU_r396_n34, S3_ALU_r396_n33, S3_ALU_r396_n32, S3_ALU_r396_n31,
         S3_ALU_r396_n30, S3_ALU_r396_n29, S3_ALU_r396_n28, S3_ALU_r396_n27,
         S3_ALU_r396_n26, S3_ALU_r396_n25, S3_ALU_r396_n24, S3_ALU_r396_n23,
         S3_ALU_r396_n22, S3_ALU_r396_n21, S3_ALU_r396_n20, S3_ALU_r396_n19,
         S3_ALU_r396_n18, S3_ALU_r396_n17, S3_ALU_r396_n16, S3_ALU_r396_n15,
         S3_ALU_r396_n14, S3_ALU_r396_n13, S3_ALU_r396_n12, S3_ALU_r396_n11,
         S3_ALU_r396_n10, S3_ALU_r396_n9, S3_ALU_r396_n8, S3_ALU_r396_n7,
         S3_ALU_r396_n6, S3_ALU_r396_n5, S3_ALU_r396_n1, S3_ALU_r395_n203,
         S3_ALU_r395_n202, S3_ALU_r395_n201, S3_ALU_r395_n200,
         S3_ALU_r395_n199, S3_ALU_r395_n198, S3_ALU_r395_n197,
         S3_ALU_r395_n196, S3_ALU_r395_n195, S3_ALU_r395_n194,
         S3_ALU_r395_n193, S3_ALU_r395_n192, S3_ALU_r395_n191,
         S3_ALU_r395_n190, S3_ALU_r395_n189, S3_ALU_r395_n188,
         S3_ALU_r395_n187, S3_ALU_r395_n186, S3_ALU_r395_n185,
         S3_ALU_r395_n184, S3_ALU_r395_n183, S3_ALU_r395_n182,
         S3_ALU_r395_n181, S3_ALU_r395_n180, S3_ALU_r395_n179,
         S3_ALU_r395_n178, S3_ALU_r395_n177, S3_ALU_r395_n176,
         S3_ALU_r395_n175, S3_ALU_r395_n174, S3_ALU_r395_n173,
         S3_ALU_r395_n172, S3_ALU_r395_n171, S3_ALU_r395_n170,
         S3_ALU_r395_n169, S3_ALU_r395_n168, S3_ALU_r395_n167,
         S3_ALU_r395_n166, S3_ALU_r395_n165, S3_ALU_r395_n164,
         S3_ALU_r395_n163, S3_ALU_r395_n162, S3_ALU_r395_n161,
         S3_ALU_r395_n160, S3_ALU_r395_n159, S3_ALU_r395_n158,
         S3_ALU_r395_n157, S3_ALU_r395_n156, S3_ALU_r395_n155,
         S3_ALU_r395_n154, S3_ALU_r395_n153, S3_ALU_r395_n152,
         S3_ALU_r395_n151, S3_ALU_r395_n150, S3_ALU_r395_n149,
         S3_ALU_r395_n148, S3_ALU_r395_n147, S3_ALU_r395_n146,
         S3_ALU_r395_n145, S3_ALU_r395_n144, S3_ALU_r395_n143,
         S3_ALU_r395_n142, S3_ALU_r395_n141, S3_ALU_r395_n140,
         S3_ALU_r395_n139, S3_ALU_r395_n138, S3_ALU_r395_n137,
         S3_ALU_r395_n136, S3_ALU_r395_n135, S3_ALU_r395_n134,
         S3_ALU_r395_n133, S3_ALU_r395_n132, S3_ALU_r395_n131,
         S3_ALU_r395_n130, S3_ALU_r395_n129, S3_ALU_r395_n128,
         S3_ALU_r395_n127, S3_ALU_r395_n126, S3_ALU_r395_n125,
         S3_ALU_r395_n124, S3_ALU_r395_n123, S3_ALU_r395_n122,
         S3_ALU_r395_n121, S3_ALU_r395_n120, S3_ALU_r395_n119,
         S3_ALU_r395_n118, S3_ALU_r395_n117, S3_ALU_r395_n116,
         S3_ALU_r395_n115, S3_ALU_r395_n114, S3_ALU_r395_n113,
         S3_ALU_r395_n112, S3_ALU_r395_n111, S3_ALU_r395_n110,
         S3_ALU_r395_n109, S3_ALU_r395_n108, S3_ALU_r395_n107,
         S3_ALU_r395_n106, S3_ALU_r395_n105, S3_ALU_r395_n104,
         S3_ALU_r395_n103, S3_ALU_r395_n102, S3_ALU_r395_n101,
         S3_ALU_r395_n100, S3_ALU_r395_n99, S3_ALU_r395_n98, S3_ALU_r395_n97,
         S3_ALU_r395_n96, S3_ALU_r395_n95, S3_ALU_r395_n94, S3_ALU_r395_n93,
         S3_ALU_r395_n92, S3_ALU_r395_n91, S3_ALU_r395_n90, S3_ALU_r395_n89,
         S3_ALU_r395_n88, S3_ALU_r395_n87, S3_ALU_r395_n86, S3_ALU_r395_n85,
         S3_ALU_r395_n84, S3_ALU_r395_n83, S3_ALU_r395_n82, S3_ALU_r395_n81,
         S3_ALU_r395_n80, S3_ALU_r395_n79, S3_ALU_r395_n78, S3_ALU_r395_n77,
         S3_ALU_r395_n76, S3_ALU_r395_n75, S3_ALU_r395_n74, S3_ALU_r395_n73,
         S3_ALU_r395_n72, S3_ALU_r395_n71, S3_ALU_r395_n70, S3_ALU_r395_n69,
         S3_ALU_r395_n68, S3_ALU_r395_n67, S3_ALU_r395_n66, S3_ALU_r395_n65,
         S3_ALU_r395_n64, S3_ALU_r395_n63, S3_ALU_r395_n62, S3_ALU_r395_n61,
         S3_ALU_r395_n60, S3_ALU_r395_n59, S3_ALU_r395_n58, S3_ALU_r395_n57,
         S3_ALU_r395_n56, S3_ALU_r395_n55, S3_ALU_r395_n54, S3_ALU_r395_n53,
         S3_ALU_r395_n52, S3_ALU_r395_n51, S3_ALU_r395_n50, S3_ALU_r395_n49,
         S3_ALU_r395_n48, S3_ALU_r395_n47, S3_ALU_r395_n46, S3_ALU_r395_n45,
         S3_ALU_r395_n44, S3_ALU_r395_n43, S3_ALU_r395_n42, S3_ALU_r395_n41,
         S3_ALU_r395_n40, S3_ALU_r395_n39, S3_ALU_r395_n38, S3_ALU_r395_n37,
         S3_ALU_r395_n36, S3_ALU_r395_n35, S3_ALU_r395_n34, S3_ALU_r395_n33,
         S3_ALU_r395_n32, S3_ALU_r395_n31, S3_ALU_r395_n30, S3_ALU_r395_n29,
         S3_ALU_r395_n28, S3_ALU_r395_n27, S3_ALU_r395_n26, S3_ALU_r395_n25,
         S3_ALU_r395_n24, S3_ALU_r395_n23, S3_ALU_r395_n22, S3_ALU_r395_n21,
         S3_ALU_r395_n20, S3_ALU_r395_n19, S3_ALU_r395_n18, S3_ALU_r395_n17,
         S3_ALU_r395_n16, S3_ALU_r395_n15, S3_ALU_r395_n14, S3_ALU_r395_n13,
         S3_ALU_r395_n12, S3_ALU_r395_n11, S3_ALU_r395_n10, S3_ALU_r395_n9,
         S3_ALU_r395_n8, S3_ALU_r395_n7, S3_ALU_r395_n6, S3_ALU_r395_n5,
         S3_ALU_r395_n2, S3_ALU_r395_n1, S3_REG_ALU_n75, S3_REG_ALU_n74,
         S3_REG_ALU_n73, S3_REG_ALU_n72, S3_REG_ALU_n71, S3_REG_ALU_n70,
         S3_REG_ALU_n69, S3_REG_ALU_n68, S3_REG_ALU_n33, S3_REG_ALU_n32,
         S3_REG_ALU_n31, S3_REG_ALU_n30, S3_REG_ALU_n29, S3_REG_ALU_n28,
         S3_REG_ALU_n27, S3_REG_ALU_n26, S3_REG_ALU_n25, S3_REG_ALU_n24,
         S3_REG_ALU_n23, S3_REG_ALU_n22, S3_REG_ALU_n21, S3_REG_ALU_n20,
         S3_REG_ALU_n19, S3_REG_ALU_n18, S3_REG_ALU_n17, S3_REG_ALU_n16,
         S3_REG_ALU_n15, S3_REG_ALU_n14, S3_REG_ALU_n13, S3_REG_ALU_n12,
         S3_REG_ALU_n11, S3_REG_ALU_n10, S3_REG_ALU_n9, S3_REG_ALU_n8,
         S3_REG_ALU_n7, S3_REG_ALU_n6, S3_REG_ALU_n5, S3_REG_ALU_n4,
         S3_REG_ALU_n3, S3_REG_ALU_n2, S3_REG_ALU_n1, S3_REG_ALU_n67,
         S3_REG_ALU_n66, S3_REG_ALU_n65, S3_REG_ALU_n64, S3_REG_ALU_n63,
         S3_REG_ALU_n62, S3_REG_ALU_n61, S3_REG_ALU_n60, S3_REG_ALU_n59,
         S3_REG_ALU_n58, S3_REG_ALU_n57, S3_REG_ALU_n56, S3_REG_ALU_n55,
         S3_REG_ALU_n54, S3_REG_ALU_n53, S3_REG_ALU_n52, S3_REG_ALU_n51,
         S3_REG_ALU_n50, S3_REG_ALU_n49, S3_REG_ALU_n48, S3_REG_ALU_n47,
         S3_REG_ALU_n46, S3_REG_ALU_n45, S3_REG_ALU_n44, S3_REG_ALU_n43,
         S3_REG_ALU_n42, S3_REG_ALU_n41, S3_REG_ALU_n40, S3_REG_ALU_n39,
         S3_REG_ALU_n38, S3_REG_ALU_n37, S3_REG_ALU_n36, S3_REG_ALU_n35,
         S3_REG_ALU_n34, S3_REG_DATA_n109, S3_REG_DATA_n108, S3_REG_DATA_n107,
         S3_REG_DATA_n106, S3_REG_DATA_n105, S3_REG_DATA_n104,
         S3_REG_DATA_n103, S3_REG_DATA_n102, S3_REG_DATA_n101,
         S3_REG_DATA_n100, S3_REG_DATA_n99, S3_REG_DATA_n98, S3_REG_DATA_n97,
         S3_REG_DATA_n96, S3_REG_DATA_n95, S3_REG_DATA_n94, S3_REG_DATA_n93,
         S3_REG_DATA_n92, S3_REG_DATA_n91, S3_REG_DATA_n90, S3_REG_DATA_n89,
         S3_REG_DATA_n88, S3_REG_DATA_n87, S3_REG_DATA_n86, S3_REG_DATA_n85,
         S3_REG_DATA_n84, S3_REG_DATA_n83, S3_REG_DATA_n82, S3_REG_DATA_n81,
         S3_REG_DATA_n80, S3_REG_DATA_n79, S3_REG_DATA_n78, S3_REG_DATA_n77,
         S3_REG_DATA_n76, S3_REG_DATA_n75, S3_REG_DATA_n74, S3_REG_DATA_n73,
         S3_REG_DATA_n72, S3_REG_DATA_n71, S3_REG_DATA_n70, S3_REG_DATA_n69,
         S3_REG_DATA_n68, S3_REG_DATA_n33, S3_REG_DATA_n32, S3_REG_DATA_n31,
         S3_REG_DATA_n30, S3_REG_DATA_n29, S3_REG_DATA_n28, S3_REG_DATA_n27,
         S3_REG_DATA_n26, S3_REG_DATA_n25, S3_REG_DATA_n24, S3_REG_DATA_n23,
         S3_REG_DATA_n22, S3_REG_DATA_n21, S3_REG_DATA_n20, S3_REG_DATA_n19,
         S3_REG_DATA_n18, S3_REG_DATA_n17, S3_REG_DATA_n16, S3_REG_DATA_n15,
         S3_REG_DATA_n14, S3_REG_DATA_n13, S3_REG_DATA_n12, S3_REG_DATA_n11,
         S3_REG_DATA_n10, S3_REG_DATA_n9, S3_REG_DATA_n8, S3_REG_DATA_n7,
         S3_REG_DATA_n6, S3_REG_DATA_n5, S3_REG_DATA_n4, S3_REG_DATA_n3,
         S3_REG_DATA_n2, S3_REG_DATA_n1, S3_REG_COND_n2, S3_REG_COND_n1,
         S3_REG_COND_n4, S3_REG_COND_n3, S3_ZeroCompa_n12, S3_ZeroCompa_n11,
         S3_ZeroCompa_n10, S3_ZeroCompa_n9, S3_ZeroCompa_n8, S3_ZeroCompa_n7,
         S3_ZeroCompa_n6, S3_ZeroCompa_n5, S3_ZeroCompa_n4, S3_ZeroCompa_n3,
         S3_ZeroCompa_n2, S3_ZeroCompa_n1, S3_FF_JAL_EN_n6, S3_FF_JAL_EN_n5,
         S3_FF_JAL_EN_n2, S3_FF_JAL_EN_n1, S3_REG_NPC_n109, S3_REG_NPC_n108,
         S3_REG_NPC_n107, S3_REG_NPC_n106, S3_REG_NPC_n105, S3_REG_NPC_n104,
         S3_REG_NPC_n103, S3_REG_NPC_n102, S3_REG_NPC_n101, S3_REG_NPC_n100,
         S3_REG_NPC_n99, S3_REG_NPC_n98, S3_REG_NPC_n97, S3_REG_NPC_n96,
         S3_REG_NPC_n95, S3_REG_NPC_n94, S3_REG_NPC_n93, S3_REG_NPC_n92,
         S3_REG_NPC_n91, S3_REG_NPC_n90, S3_REG_NPC_n89, S3_REG_NPC_n88,
         S3_REG_NPC_n87, S3_REG_NPC_n86, S3_REG_NPC_n85, S3_REG_NPC_n84,
         S3_REG_NPC_n83, S3_REG_NPC_n82, S3_REG_NPC_n81, S3_REG_NPC_n80,
         S3_REG_NPC_n79, S3_REG_NPC_n78, S3_REG_NPC_n77, S3_REG_NPC_n76,
         S3_REG_NPC_n75, S3_REG_NPC_n74, S3_REG_NPC_n73, S3_REG_NPC_n72,
         S3_REG_NPC_n71, S3_REG_NPC_n70, S3_REG_NPC_n69, S3_REG_NPC_n68,
         S3_REG_NPC_n33, S3_REG_NPC_n32, S3_REG_NPC_n31, S3_REG_NPC_n30,
         S3_REG_NPC_n29, S3_REG_NPC_n28, S3_REG_NPC_n27, S3_REG_NPC_n26,
         S3_REG_NPC_n25, S3_REG_NPC_n24, S3_REG_NPC_n23, S3_REG_NPC_n22,
         S3_REG_NPC_n21, S3_REG_NPC_n20, S3_REG_NPC_n19, S3_REG_NPC_n18,
         S3_REG_NPC_n17, S3_REG_NPC_n16, S3_REG_NPC_n15, S3_REG_NPC_n14,
         S3_REG_NPC_n13, S3_REG_NPC_n12, S3_REG_NPC_n11, S3_REG_NPC_n10,
         S3_REG_NPC_n9, S3_REG_NPC_n8, S3_REG_NPC_n7, S3_REG_NPC_n6,
         S3_REG_NPC_n5, S3_REG_NPC_n4, S3_REG_NPC_n3, S3_REG_NPC_n2,
         S3_REG_NPC_n1, S3_REG_ADD_WR_n6, S3_REG_ADD_WR_n5, S3_REG_ADD_WR_n4,
         S3_REG_ADD_WR_n3, S3_REG_ADD_WR_n2, S3_REG_ADD_WR_n1,
         S3_REG_ADD_WR_n13, S3_REG_ADD_WR_n12, S3_REG_ADD_WR_n11,
         S3_REG_ADD_WR_n10, S3_REG_ADD_WR_n9, S3_REG_ADD_WR_n8,
         S3_REG_ADD_WR_n7;
  wire   [31:0] S3_MUX_A_OUT;
  wire   [31:0] S3_MUX_JMP_OUT;
  wire   [31:0] S3_MUX_B_OUT;
  wire   [31:0] S3_ALU_RESULT_shftr;
  wire   [31:1] S3_ALU_sub_116_carry;
  wire   [31:2] S3_ALU_add_113_carry;
  wire   [31:1] S3_ALU_sub_73_carry;
  wire   [31:2] S3_ALU_add_70_carry;
  tri   [31:0] S3_ALU_OUT;
  tri   S3_ALU_SHIFT_ROTATE_shftr;
  tri   S3_ALU_LEFT_RIGHT_shftr;
  tri   S3_ALU_LOGIC_ARITH_shftr;

  INV_X1 S3_MUX_A_U69 ( .A(MUX_A_SEL), .ZN(S3_MUX_A_n5) );
  AOI22_X1 S3_MUX_A_U68 ( .A1(S2_RFILE_A_OUT[2]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[2]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n43) );
  INV_X1 S3_MUX_A_U67 ( .A(S3_MUX_A_n43), .ZN(S3_MUX_A_OUT[2]) );
  AOI22_X1 S3_MUX_A_U66 ( .A1(S2_RFILE_A_OUT[29]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[29]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n44) );
  INV_X1 S3_MUX_A_U65 ( .A(S3_MUX_A_n44), .ZN(S3_MUX_A_OUT[29]) );
  AOI22_X1 S3_MUX_A_U64 ( .A1(S2_RFILE_A_OUT[3]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[3]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n40) );
  INV_X1 S3_MUX_A_U63 ( .A(S3_MUX_A_n40), .ZN(S3_MUX_A_OUT[3]) );
  AOI22_X1 S3_MUX_A_U62 ( .A1(S2_RFILE_A_OUT[5]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[5]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n38) );
  INV_X1 S3_MUX_A_U61 ( .A(S3_MUX_A_n38), .ZN(S3_MUX_A_OUT[5]) );
  AOI22_X1 S3_MUX_A_U60 ( .A1(S2_RFILE_A_OUT[6]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[6]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n37) );
  INV_X1 S3_MUX_A_U59 ( .A(S3_MUX_A_n37), .ZN(S3_MUX_A_OUT[6]) );
  AOI22_X1 S3_MUX_A_U58 ( .A1(S2_RFILE_A_OUT[7]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[7]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n36) );
  INV_X1 S3_MUX_A_U57 ( .A(S3_MUX_A_n36), .ZN(S3_MUX_A_OUT[7]) );
  AOI22_X1 S3_MUX_A_U56 ( .A1(S2_RFILE_A_OUT[8]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[8]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n35) );
  INV_X1 S3_MUX_A_U55 ( .A(S3_MUX_A_n35), .ZN(S3_MUX_A_OUT[8]) );
  AOI22_X1 S3_MUX_A_U54 ( .A1(MUX_A_SEL), .A2(S2_RFILE_A_OUT[9]), .B1(
        S1_REG_NPC_OUT[9]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n34) );
  INV_X1 S3_MUX_A_U53 ( .A(S3_MUX_A_n34), .ZN(S3_MUX_A_OUT[9]) );
  AOI22_X1 S3_MUX_A_U52 ( .A1(S2_RFILE_A_OUT[10]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[10]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n64) );
  INV_X1 S3_MUX_A_U51 ( .A(S3_MUX_A_n64), .ZN(S3_MUX_A_OUT[10]) );
  AOI22_X1 S3_MUX_A_U50 ( .A1(S2_RFILE_A_OUT[11]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[11]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n63) );
  INV_X1 S3_MUX_A_U49 ( .A(S3_MUX_A_n63), .ZN(S3_MUX_A_OUT[11]) );
  AOI22_X1 S3_MUX_A_U48 ( .A1(S2_RFILE_A_OUT[18]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[18]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n56) );
  INV_X1 S3_MUX_A_U47 ( .A(S3_MUX_A_n56), .ZN(S3_MUX_A_OUT[18]) );
  AOI22_X1 S3_MUX_A_U46 ( .A1(S2_RFILE_A_OUT[19]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[19]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n55) );
  INV_X1 S3_MUX_A_U45 ( .A(S3_MUX_A_n55), .ZN(S3_MUX_A_OUT[19]) );
  AOI22_X1 S3_MUX_A_U44 ( .A1(S2_RFILE_A_OUT[20]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[20]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n53) );
  INV_X1 S3_MUX_A_U43 ( .A(S3_MUX_A_n53), .ZN(S3_MUX_A_OUT[20]) );
  AOI22_X1 S3_MUX_A_U42 ( .A1(S2_RFILE_A_OUT[21]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[21]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n52) );
  INV_X1 S3_MUX_A_U41 ( .A(S3_MUX_A_n52), .ZN(S3_MUX_A_OUT[21]) );
  AOI22_X1 S3_MUX_A_U40 ( .A1(S2_RFILE_A_OUT[22]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[22]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n51) );
  INV_X1 S3_MUX_A_U39 ( .A(S3_MUX_A_n51), .ZN(S3_MUX_A_OUT[22]) );
  AOI22_X1 S3_MUX_A_U38 ( .A1(S2_RFILE_A_OUT[23]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[23]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n50) );
  INV_X1 S3_MUX_A_U37 ( .A(S3_MUX_A_n50), .ZN(S3_MUX_A_OUT[23]) );
  AOI22_X1 S3_MUX_A_U36 ( .A1(S2_RFILE_A_OUT[24]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[24]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n49) );
  INV_X1 S3_MUX_A_U35 ( .A(S3_MUX_A_n49), .ZN(S3_MUX_A_OUT[24]) );
  AOI22_X1 S3_MUX_A_U34 ( .A1(S2_RFILE_A_OUT[25]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[25]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n48) );
  INV_X1 S3_MUX_A_U33 ( .A(S3_MUX_A_n48), .ZN(S3_MUX_A_OUT[25]) );
  AOI22_X1 S3_MUX_A_U32 ( .A1(S2_RFILE_A_OUT[26]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[26]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n47) );
  INV_X1 S3_MUX_A_U31 ( .A(S3_MUX_A_n47), .ZN(S3_MUX_A_OUT[26]) );
  AOI22_X1 S3_MUX_A_U30 ( .A1(S2_RFILE_A_OUT[28]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[28]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n45) );
  INV_X1 S3_MUX_A_U29 ( .A(S3_MUX_A_n45), .ZN(S3_MUX_A_OUT[28]) );
  AOI22_X1 S3_MUX_A_U28 ( .A1(S2_RFILE_A_OUT[4]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[4]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n39) );
  INV_X1 S3_MUX_A_U27 ( .A(S3_MUX_A_n39), .ZN(S3_MUX_A_OUT[4]) );
  AOI22_X1 S3_MUX_A_U26 ( .A1(S2_RFILE_A_OUT[27]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[27]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n46) );
  INV_X1 S3_MUX_A_U25 ( .A(S3_MUX_A_n46), .ZN(S3_MUX_A_OUT[27]) );
  AOI22_X1 S3_MUX_A_U24 ( .A1(S2_RFILE_A_OUT[13]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[13]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n61) );
  INV_X1 S3_MUX_A_U23 ( .A(S3_MUX_A_n61), .ZN(S3_MUX_A_OUT[13]) );
  AOI22_X1 S3_MUX_A_U22 ( .A1(S2_RFILE_A_OUT[14]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[14]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n60) );
  INV_X1 S3_MUX_A_U21 ( .A(S3_MUX_A_n60), .ZN(S3_MUX_A_OUT[14]) );
  AOI22_X1 S3_MUX_A_U20 ( .A1(S2_RFILE_A_OUT[15]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[15]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n59) );
  INV_X1 S3_MUX_A_U19 ( .A(S3_MUX_A_n59), .ZN(S3_MUX_A_OUT[15]) );
  AOI22_X1 S3_MUX_A_U18 ( .A1(S2_RFILE_A_OUT[16]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[16]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n58) );
  INV_X1 S3_MUX_A_U17 ( .A(S3_MUX_A_n58), .ZN(S3_MUX_A_OUT[16]) );
  AOI22_X1 S3_MUX_A_U16 ( .A1(S2_RFILE_A_OUT[17]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[17]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n57) );
  INV_X1 S3_MUX_A_U15 ( .A(S3_MUX_A_n57), .ZN(S3_MUX_A_OUT[17]) );
  AOI22_X1 S3_MUX_A_U14 ( .A1(S2_RFILE_A_OUT[12]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[12]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n62) );
  INV_X1 S3_MUX_A_U13 ( .A(S3_MUX_A_n62), .ZN(S3_MUX_A_OUT[12]) );
  AOI22_X1 S3_MUX_A_U12 ( .A1(S2_RFILE_A_OUT[1]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[1]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n54) );
  INV_X1 S3_MUX_A_U11 ( .A(S3_MUX_A_n54), .ZN(S3_MUX_A_OUT[1]) );
  AOI22_X1 S3_MUX_A_U10 ( .A1(S2_RFILE_A_OUT[30]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[30]), .B2(S3_MUX_A_n2), .ZN(S3_MUX_A_n42) );
  INV_X1 S3_MUX_A_U9 ( .A(S3_MUX_A_n42), .ZN(S3_MUX_A_OUT[30]) );
  AOI22_X1 S3_MUX_A_U8 ( .A1(S2_RFILE_A_OUT[31]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[31]), .B2(S3_MUX_A_n3), .ZN(S3_MUX_A_n41) );
  AOI22_X1 S3_MUX_A_U7 ( .A1(S2_RFILE_A_OUT[0]), .A2(MUX_A_SEL), .B1(
        S1_REG_NPC_OUT[0]), .B2(S3_MUX_A_n1), .ZN(S3_MUX_A_n65) );
  BUF_X1 S3_MUX_A_U6 ( .A(S3_MUX_A_n4), .Z(S3_MUX_A_n3) );
  BUF_X1 S3_MUX_A_U5 ( .A(S3_MUX_A_n4), .Z(S3_MUX_A_n1) );
  BUF_X1 S3_MUX_A_U4 ( .A(S3_MUX_A_n4), .Z(S3_MUX_A_n2) );
  BUF_X1 S3_MUX_A_U3 ( .A(S3_MUX_A_n5), .Z(S3_MUX_A_n4) );
  INV_X1 S3_MUX_A_U2 ( .A(S3_MUX_A_n65), .ZN(S3_MUX_A_OUT[0]) );
  INV_X1 S3_MUX_A_U1 ( .A(S3_MUX_A_n41), .ZN(S3_MUX_A_OUT[31]) );
  INV_X1 S3_MUX_B_U69 ( .A(MUX_B_SEL), .ZN(S3_MUX_B_n5) );
  AOI22_X1 S3_MUX_B_U68 ( .A1(S3_MUX_JMP_OUT[4]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[4]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n96) );
  INV_X1 S3_MUX_B_U67 ( .A(S3_MUX_B_n96), .ZN(S3_MUX_B_OUT[4]) );
  AOI22_X1 S3_MUX_B_U66 ( .A1(S3_MUX_JMP_OUT[2]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[2]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n92) );
  INV_X1 S3_MUX_B_U65 ( .A(S3_MUX_B_n92), .ZN(S3_MUX_B_OUT[2]) );
  AOI22_X1 S3_MUX_B_U64 ( .A1(S3_MUX_JMP_OUT[3]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[3]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n95) );
  INV_X1 S3_MUX_B_U63 ( .A(S3_MUX_B_n95), .ZN(S3_MUX_B_OUT[3]) );
  AOI22_X1 S3_MUX_B_U62 ( .A1(S3_MUX_JMP_OUT[0]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[0]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n70) );
  INV_X1 S3_MUX_B_U61 ( .A(S3_MUX_B_n70), .ZN(S3_MUX_B_OUT[0]) );
  AOI22_X1 S3_MUX_B_U60 ( .A1(S3_MUX_JMP_OUT[1]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[1]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n81) );
  INV_X1 S3_MUX_B_U59 ( .A(S3_MUX_B_n81), .ZN(S3_MUX_B_OUT[1]) );
  AOI22_X1 S3_MUX_B_U58 ( .A1(S3_MUX_JMP_OUT[8]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[8]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n100) );
  INV_X1 S3_MUX_B_U57 ( .A(S3_MUX_B_n100), .ZN(S3_MUX_B_OUT[8]) );
  AOI22_X1 S3_MUX_B_U56 ( .A1(S3_MUX_JMP_OUT[12]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[12]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n73) );
  INV_X1 S3_MUX_B_U55 ( .A(S3_MUX_B_n73), .ZN(S3_MUX_B_OUT[12]) );
  AOI22_X1 S3_MUX_B_U54 ( .A1(S3_MUX_JMP_OUT[16]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[16]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n77) );
  INV_X1 S3_MUX_B_U53 ( .A(S3_MUX_B_n77), .ZN(S3_MUX_B_OUT[16]) );
  AOI22_X1 S3_MUX_B_U52 ( .A1(S3_MUX_JMP_OUT[20]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[20]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n82) );
  INV_X1 S3_MUX_B_U51 ( .A(S3_MUX_B_n82), .ZN(S3_MUX_B_OUT[20]) );
  AOI22_X1 S3_MUX_B_U50 ( .A1(S3_MUX_JMP_OUT[24]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[24]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n86) );
  INV_X1 S3_MUX_B_U49 ( .A(S3_MUX_B_n86), .ZN(S3_MUX_B_OUT[24]) );
  AOI22_X1 S3_MUX_B_U48 ( .A1(S3_MUX_JMP_OUT[28]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[28]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n90) );
  INV_X1 S3_MUX_B_U47 ( .A(S3_MUX_B_n90), .ZN(S3_MUX_B_OUT[28]) );
  AOI22_X1 S3_MUX_B_U46 ( .A1(S3_MUX_JMP_OUT[6]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[6]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n98) );
  INV_X1 S3_MUX_B_U45 ( .A(S3_MUX_B_n98), .ZN(S3_MUX_B_OUT[6]) );
  AOI22_X1 S3_MUX_B_U44 ( .A1(S3_MUX_JMP_OUT[7]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[7]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n99) );
  INV_X1 S3_MUX_B_U43 ( .A(S3_MUX_B_n99), .ZN(S3_MUX_B_OUT[7]) );
  AOI22_X1 S3_MUX_B_U42 ( .A1(S3_MUX_JMP_OUT[10]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[10]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n71) );
  INV_X1 S3_MUX_B_U41 ( .A(S3_MUX_B_n71), .ZN(S3_MUX_B_OUT[10]) );
  AOI22_X1 S3_MUX_B_U40 ( .A1(S3_MUX_JMP_OUT[11]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[11]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n72) );
  INV_X1 S3_MUX_B_U39 ( .A(S3_MUX_B_n72), .ZN(S3_MUX_B_OUT[11]) );
  AOI22_X1 S3_MUX_B_U38 ( .A1(S3_MUX_JMP_OUT[14]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[14]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n75) );
  INV_X1 S3_MUX_B_U37 ( .A(S3_MUX_B_n75), .ZN(S3_MUX_B_OUT[14]) );
  AOI22_X1 S3_MUX_B_U36 ( .A1(S3_MUX_JMP_OUT[15]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[15]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n76) );
  INV_X1 S3_MUX_B_U35 ( .A(S3_MUX_B_n76), .ZN(S3_MUX_B_OUT[15]) );
  AOI22_X1 S3_MUX_B_U34 ( .A1(S3_MUX_JMP_OUT[18]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[18]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n79) );
  INV_X1 S3_MUX_B_U33 ( .A(S3_MUX_B_n79), .ZN(S3_MUX_B_OUT[18]) );
  AOI22_X1 S3_MUX_B_U32 ( .A1(S3_MUX_JMP_OUT[19]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[19]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n80) );
  INV_X1 S3_MUX_B_U31 ( .A(S3_MUX_B_n80), .ZN(S3_MUX_B_OUT[19]) );
  AOI22_X1 S3_MUX_B_U30 ( .A1(S3_MUX_JMP_OUT[22]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[22]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n84) );
  INV_X1 S3_MUX_B_U29 ( .A(S3_MUX_B_n84), .ZN(S3_MUX_B_OUT[22]) );
  AOI22_X1 S3_MUX_B_U28 ( .A1(S3_MUX_JMP_OUT[23]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[23]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n85) );
  INV_X1 S3_MUX_B_U27 ( .A(S3_MUX_B_n85), .ZN(S3_MUX_B_OUT[23]) );
  AOI22_X1 S3_MUX_B_U26 ( .A1(S3_MUX_JMP_OUT[26]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[26]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n88) );
  INV_X1 S3_MUX_B_U25 ( .A(S3_MUX_B_n88), .ZN(S3_MUX_B_OUT[26]) );
  AOI22_X1 S3_MUX_B_U24 ( .A1(S3_MUX_JMP_OUT[27]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[27]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n89) );
  INV_X1 S3_MUX_B_U23 ( .A(S3_MUX_B_n89), .ZN(S3_MUX_B_OUT[27]) );
  AOI22_X1 S3_MUX_B_U22 ( .A1(S3_MUX_JMP_OUT[5]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[5]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n97) );
  INV_X1 S3_MUX_B_U21 ( .A(S3_MUX_B_n97), .ZN(S3_MUX_B_OUT[5]) );
  AOI22_X1 S3_MUX_B_U20 ( .A1(MUX_B_SEL), .A2(S3_MUX_JMP_OUT[9]), .B1(
        S2_RFILE_B_OUT[9]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n101) );
  INV_X1 S3_MUX_B_U19 ( .A(S3_MUX_B_n101), .ZN(S3_MUX_B_OUT[9]) );
  AOI22_X1 S3_MUX_B_U18 ( .A1(S3_MUX_JMP_OUT[13]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[13]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n74) );
  INV_X1 S3_MUX_B_U17 ( .A(S3_MUX_B_n74), .ZN(S3_MUX_B_OUT[13]) );
  AOI22_X1 S3_MUX_B_U16 ( .A1(S3_MUX_JMP_OUT[17]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[17]), .B2(S3_MUX_B_n1), .ZN(S3_MUX_B_n78) );
  INV_X1 S3_MUX_B_U15 ( .A(S3_MUX_B_n78), .ZN(S3_MUX_B_OUT[17]) );
  AOI22_X1 S3_MUX_B_U14 ( .A1(S3_MUX_JMP_OUT[21]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[21]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n83) );
  INV_X1 S3_MUX_B_U13 ( .A(S3_MUX_B_n83), .ZN(S3_MUX_B_OUT[21]) );
  AOI22_X1 S3_MUX_B_U12 ( .A1(S3_MUX_JMP_OUT[25]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[25]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n87) );
  INV_X1 S3_MUX_B_U11 ( .A(S3_MUX_B_n87), .ZN(S3_MUX_B_OUT[25]) );
  AOI22_X1 S3_MUX_B_U10 ( .A1(S3_MUX_JMP_OUT[29]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[29]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n91) );
  INV_X1 S3_MUX_B_U9 ( .A(S3_MUX_B_n91), .ZN(S3_MUX_B_OUT[29]) );
  AOI22_X1 S3_MUX_B_U8 ( .A1(S3_MUX_JMP_OUT[31]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[31]), .B2(S3_MUX_B_n3), .ZN(S3_MUX_B_n94) );
  INV_X1 S3_MUX_B_U7 ( .A(S3_MUX_B_n94), .ZN(S3_MUX_B_OUT[31]) );
  AOI22_X1 S3_MUX_B_U6 ( .A1(S3_MUX_JMP_OUT[30]), .A2(MUX_B_SEL), .B1(
        S2_RFILE_B_OUT[30]), .B2(S3_MUX_B_n2), .ZN(S3_MUX_B_n93) );
  INV_X1 S3_MUX_B_U5 ( .A(S3_MUX_B_n93), .ZN(S3_MUX_B_OUT[30]) );
  BUF_X1 S3_MUX_B_U4 ( .A(S3_MUX_B_n4), .Z(S3_MUX_B_n3) );
  BUF_X1 S3_MUX_B_U3 ( .A(S3_MUX_B_n4), .Z(S3_MUX_B_n1) );
  BUF_X1 S3_MUX_B_U2 ( .A(S3_MUX_B_n4), .Z(S3_MUX_B_n2) );
  BUF_X1 S3_MUX_B_U1 ( .A(S3_MUX_B_n5), .Z(S3_MUX_B_n4) );
  INV_X1 S3_MUX_JMP_U69 ( .A(JMP), .ZN(S3_MUX_JMP_n5) );
  INV_X1 S3_MUX_JMP_U68 ( .A(S3_MUX_JMP_n96), .ZN(S3_MUX_JMP_OUT[4]) );
  INV_X1 S3_MUX_JMP_U67 ( .A(S3_MUX_JMP_n92), .ZN(S3_MUX_JMP_OUT[2]) );
  INV_X1 S3_MUX_JMP_U66 ( .A(S3_MUX_JMP_n95), .ZN(S3_MUX_JMP_OUT[3]) );
  INV_X1 S3_MUX_JMP_U65 ( .A(S3_MUX_JMP_n70), .ZN(S3_MUX_JMP_OUT[0]) );
  INV_X1 S3_MUX_JMP_U64 ( .A(S3_MUX_JMP_n81), .ZN(S3_MUX_JMP_OUT[1]) );
  AOI22_X1 S3_MUX_JMP_U63 ( .A1(S2_REG_UE_IMM_OUT[0]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[0]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n70) );
  AOI22_X1 S3_MUX_JMP_U62 ( .A1(S2_REG_UE_IMM_OUT[1]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[1]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n81) );
  AOI22_X1 S3_MUX_JMP_U61 ( .A1(S2_REG_UE_IMM_OUT[2]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[2]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n92) );
  AOI22_X1 S3_MUX_JMP_U60 ( .A1(S2_REG_UE_IMM_OUT[3]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[3]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n95) );
  AOI22_X1 S3_MUX_JMP_U59 ( .A1(S2_REG_UE_IMM_OUT[4]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[4]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n96) );
  AOI22_X1 S3_MUX_JMP_U58 ( .A1(S2_REG_UE_IMM_OUT[8]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[8]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n100) );
  INV_X1 S3_MUX_JMP_U57 ( .A(S3_MUX_JMP_n100), .ZN(S3_MUX_JMP_OUT[8]) );
  AOI22_X1 S3_MUX_JMP_U56 ( .A1(S2_REG_UE_IMM_OUT[12]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[12]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n73) );
  INV_X1 S3_MUX_JMP_U55 ( .A(S3_MUX_JMP_n73), .ZN(S3_MUX_JMP_OUT[12]) );
  AOI22_X1 S3_MUX_JMP_U54 ( .A1(S2_REG_UE_IMM_OUT[16]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[16]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n77) );
  INV_X1 S3_MUX_JMP_U53 ( .A(S3_MUX_JMP_n77), .ZN(S3_MUX_JMP_OUT[16]) );
  AOI22_X1 S3_MUX_JMP_U52 ( .A1(S2_REG_UE_IMM_OUT[20]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[20]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n82) );
  INV_X1 S3_MUX_JMP_U51 ( .A(S3_MUX_JMP_n82), .ZN(S3_MUX_JMP_OUT[20]) );
  AOI22_X1 S3_MUX_JMP_U50 ( .A1(S2_REG_UE_IMM_OUT[24]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[24]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n86) );
  INV_X1 S3_MUX_JMP_U49 ( .A(S3_MUX_JMP_n86), .ZN(S3_MUX_JMP_OUT[24]) );
  AOI22_X1 S3_MUX_JMP_U48 ( .A1(S2_REG_UE_IMM_OUT[28]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[28]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n90) );
  INV_X1 S3_MUX_JMP_U47 ( .A(S3_MUX_JMP_n90), .ZN(S3_MUX_JMP_OUT[28]) );
  AOI22_X1 S3_MUX_JMP_U46 ( .A1(S2_REG_UE_IMM_OUT[6]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[6]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n98) );
  INV_X1 S3_MUX_JMP_U45 ( .A(S3_MUX_JMP_n98), .ZN(S3_MUX_JMP_OUT[6]) );
  AOI22_X1 S3_MUX_JMP_U44 ( .A1(S2_REG_UE_IMM_OUT[7]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[7]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n99) );
  INV_X1 S3_MUX_JMP_U43 ( .A(S3_MUX_JMP_n99), .ZN(S3_MUX_JMP_OUT[7]) );
  AOI22_X1 S3_MUX_JMP_U42 ( .A1(S2_REG_UE_IMM_OUT[10]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[10]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n71) );
  INV_X1 S3_MUX_JMP_U41 ( .A(S3_MUX_JMP_n71), .ZN(S3_MUX_JMP_OUT[10]) );
  AOI22_X1 S3_MUX_JMP_U40 ( .A1(S2_REG_UE_IMM_OUT[11]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[11]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n72) );
  INV_X1 S3_MUX_JMP_U39 ( .A(S3_MUX_JMP_n72), .ZN(S3_MUX_JMP_OUT[11]) );
  AOI22_X1 S3_MUX_JMP_U38 ( .A1(S2_REG_UE_IMM_OUT[14]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[14]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n75) );
  INV_X1 S3_MUX_JMP_U37 ( .A(S3_MUX_JMP_n75), .ZN(S3_MUX_JMP_OUT[14]) );
  AOI22_X1 S3_MUX_JMP_U36 ( .A1(S2_REG_UE_IMM_OUT[15]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[15]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n76) );
  INV_X1 S3_MUX_JMP_U35 ( .A(S3_MUX_JMP_n76), .ZN(S3_MUX_JMP_OUT[15]) );
  AOI22_X1 S3_MUX_JMP_U34 ( .A1(S2_REG_UE_IMM_OUT[18]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[18]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n79) );
  INV_X1 S3_MUX_JMP_U33 ( .A(S3_MUX_JMP_n79), .ZN(S3_MUX_JMP_OUT[18]) );
  AOI22_X1 S3_MUX_JMP_U32 ( .A1(S2_REG_UE_IMM_OUT[19]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[19]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n80) );
  INV_X1 S3_MUX_JMP_U31 ( .A(S3_MUX_JMP_n80), .ZN(S3_MUX_JMP_OUT[19]) );
  AOI22_X1 S3_MUX_JMP_U30 ( .A1(S2_REG_UE_IMM_OUT[22]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[22]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n84) );
  INV_X1 S3_MUX_JMP_U29 ( .A(S3_MUX_JMP_n84), .ZN(S3_MUX_JMP_OUT[22]) );
  AOI22_X1 S3_MUX_JMP_U28 ( .A1(S2_REG_UE_IMM_OUT[23]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[23]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n85) );
  INV_X1 S3_MUX_JMP_U27 ( .A(S3_MUX_JMP_n85), .ZN(S3_MUX_JMP_OUT[23]) );
  AOI22_X1 S3_MUX_JMP_U26 ( .A1(S2_REG_UE_IMM_OUT[26]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[26]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n88) );
  INV_X1 S3_MUX_JMP_U25 ( .A(S3_MUX_JMP_n88), .ZN(S3_MUX_JMP_OUT[26]) );
  AOI22_X1 S3_MUX_JMP_U24 ( .A1(S2_REG_UE_IMM_OUT[27]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[27]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n89) );
  INV_X1 S3_MUX_JMP_U23 ( .A(S3_MUX_JMP_n89), .ZN(S3_MUX_JMP_OUT[27]) );
  AOI22_X1 S3_MUX_JMP_U22 ( .A1(S2_REG_UE_IMM_OUT[5]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[5]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n97) );
  INV_X1 S3_MUX_JMP_U21 ( .A(S3_MUX_JMP_n97), .ZN(S3_MUX_JMP_OUT[5]) );
  AOI22_X1 S3_MUX_JMP_U20 ( .A1(JMP), .A2(S2_REG_UE_IMM_OUT[9]), .B1(
        S2_REG_SE_IMM_OUT[9]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n101) );
  INV_X1 S3_MUX_JMP_U19 ( .A(S3_MUX_JMP_n101), .ZN(S3_MUX_JMP_OUT[9]) );
  AOI22_X1 S3_MUX_JMP_U18 ( .A1(S2_REG_UE_IMM_OUT[13]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[13]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n74) );
  INV_X1 S3_MUX_JMP_U17 ( .A(S3_MUX_JMP_n74), .ZN(S3_MUX_JMP_OUT[13]) );
  AOI22_X1 S3_MUX_JMP_U16 ( .A1(S2_REG_UE_IMM_OUT[17]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[17]), .B2(S3_MUX_JMP_n1), .ZN(S3_MUX_JMP_n78) );
  INV_X1 S3_MUX_JMP_U15 ( .A(S3_MUX_JMP_n78), .ZN(S3_MUX_JMP_OUT[17]) );
  AOI22_X1 S3_MUX_JMP_U14 ( .A1(S2_REG_UE_IMM_OUT[21]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[21]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n83) );
  INV_X1 S3_MUX_JMP_U13 ( .A(S3_MUX_JMP_n83), .ZN(S3_MUX_JMP_OUT[21]) );
  AOI22_X1 S3_MUX_JMP_U12 ( .A1(S2_REG_UE_IMM_OUT[25]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[25]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n87) );
  INV_X1 S3_MUX_JMP_U11 ( .A(S3_MUX_JMP_n87), .ZN(S3_MUX_JMP_OUT[25]) );
  AOI22_X1 S3_MUX_JMP_U10 ( .A1(S2_REG_UE_IMM_OUT[29]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[29]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n91) );
  INV_X1 S3_MUX_JMP_U9 ( .A(S3_MUX_JMP_n91), .ZN(S3_MUX_JMP_OUT[29]) );
  AOI22_X1 S3_MUX_JMP_U8 ( .A1(S2_REG_UE_IMM_OUT[31]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[31]), .B2(S3_MUX_JMP_n3), .ZN(S3_MUX_JMP_n94) );
  INV_X1 S3_MUX_JMP_U7 ( .A(S3_MUX_JMP_n94), .ZN(S3_MUX_JMP_OUT[31]) );
  AOI22_X1 S3_MUX_JMP_U6 ( .A1(S2_REG_UE_IMM_OUT[30]), .A2(JMP), .B1(
        S2_REG_SE_IMM_OUT[30]), .B2(S3_MUX_JMP_n2), .ZN(S3_MUX_JMP_n93) );
  INV_X1 S3_MUX_JMP_U5 ( .A(S3_MUX_JMP_n93), .ZN(S3_MUX_JMP_OUT[30]) );
  BUF_X1 S3_MUX_JMP_U4 ( .A(S3_MUX_JMP_n4), .Z(S3_MUX_JMP_n3) );
  BUF_X1 S3_MUX_JMP_U3 ( .A(S3_MUX_JMP_n4), .Z(S3_MUX_JMP_n1) );
  BUF_X1 S3_MUX_JMP_U2 ( .A(S3_MUX_JMP_n4), .Z(S3_MUX_JMP_n2) );
  BUF_X1 S3_MUX_JMP_U1 ( .A(S3_MUX_JMP_n5), .Z(S3_MUX_JMP_n4) );
  INV_X1 S3_ALU_U318 ( .A(DP_ALU_OPCODE[2]), .ZN(S3_ALU_n313) );
  BUF_X1 S3_ALU_U317 ( .A(S3_ALU_n39), .Z(S3_ALU_n32) );
  AND3_X1 S3_ALU_U316 ( .A1(S3_ALU_n259), .A2(S3_ALU_n316), .A3(
        DP_ALU_OPCODE[1]), .ZN(S3_ALU_n34) );
  NAND2_X1 S3_ALU_U315 ( .A1(S3_ALU_n260), .A2(DP_ALU_OPCODE[1]), .ZN(
        S3_ALU_n38) );
  AOI22_X1 S3_ALU_U314 ( .A1(S3_ALU_n245), .A2(S3_ALU_N389), .B1(S3_ALU_N323), 
        .B2(S3_ALU_n311), .ZN(S3_ALU_n242) );
  NAND4_X1 S3_ALU_U313 ( .A1(S3_ALU_N322), .A2(DP_ALU_OPCODE[0]), .A3(
        S3_ALU_n315), .A4(S3_ALU_n312), .ZN(S3_ALU_n244) );
  OAI21_X1 S3_ALU_U312 ( .B1(S3_ALU_n242), .B2(S3_ALU_n315), .A(S3_ALU_n244), 
        .ZN(S3_ALU_n241) );
  AND3_X1 S3_ALU_U311 ( .A1(S3_ALU_n241), .A2(S3_ALU_n310), .A3(
        DP_ALU_OPCODE[2]), .ZN(S3_ALU_n240) );
  NOR3_X1 S3_ALU_U310 ( .A1(S3_ALU_n261), .A2(DP_ALU_OPCODE[0]), .A3(
        S3_ALU_n232), .ZN(S3_ALU_n41) );
  NAND2_X1 S3_ALU_U309 ( .A1(DP_ALU_OPCODE[1]), .A2(DP_ALU_OPCODE[2]), .ZN(
        S3_ALU_n232) );
  NOR2_X1 S3_ALU_U308 ( .A1(DP_ALU_OPCODE[2]), .A2(S3_ALU_n255), .ZN(
        S3_ALU_n254) );
  NAND2_X1 S3_ALU_U307 ( .A1(DP_ALU_OPCODE[3]), .A2(S3_ALU_n310), .ZN(
        S3_ALU_n261) );
  OAI22_X1 S3_ALU_U306 ( .A1(S3_ALU_n251), .A2(S3_ALU_n313), .B1(
        DP_ALU_OPCODE[2]), .B2(S3_ALU_n253), .ZN(S3_ALU_n250) );
  AOI22_X1 S3_ALU_U305 ( .A1(S3_ALU_n254), .A2(S3_ALU_N392), .B1(S3_ALU_N393), 
        .B2(DP_ALU_OPCODE[0]), .ZN(S3_ALU_n248) );
  OAI21_X1 S3_ALU_U304 ( .B1(S3_ALU_n248), .B2(S3_ALU_n315), .A(S3_ALU_n249), 
        .ZN(S3_ALU_n239) );
  AOI221_X1 S3_ALU_U303 ( .B1(S3_MUX_A_OUT[0]), .B2(S3_ALU_n238), .C1(
        DP_ALU_OPCODE[4]), .C2(S3_ALU_n239), .A(S3_ALU_n240), .ZN(S3_ALU_n237)
         );
  AOI22_X1 S3_ALU_U302 ( .A1(S3_ALU_N324), .A2(S3_ALU_n308), .B1(S3_ALU_n150), 
        .B2(S3_ALU_n257), .ZN(S3_ALU_n236) );
  AOI22_X1 S3_ALU_U301 ( .A1(S3_ALU_N194), .A2(S3_ALU_n108), .B1(
        S3_ALU_RESULT_shftr[0]), .B2(S3_ALU_n9), .ZN(S3_ALU_n234) );
  NAND4_X1 S3_ALU_U300 ( .A1(S3_ALU_n234), .A2(S3_ALU_n235), .A3(S3_ALU_n236), 
        .A4(S3_ALU_n237), .ZN(S3_ALU_n298) );
  NOR2_X1 S3_ALU_U299 ( .A1(S3_ALU_n261), .A2(DP_ALU_OPCODE[2]), .ZN(
        S3_ALU_n259) );
  AOI22_X1 S3_ALU_U298 ( .A1(S3_ALU_N394), .A2(S3_ALU_n316), .B1(S3_ALU_N395), 
        .B2(DP_ALU_OPCODE[0]), .ZN(S3_ALU_n251) );
  AOI22_X1 S3_ALU_U297 ( .A1(S3_ALU_N390), .A2(S3_ALU_n316), .B1(S3_ALU_N391), 
        .B2(DP_ALU_OPCODE[0]), .ZN(S3_ALU_n253) );
  INV_X1 S3_ALU_U296 ( .A(DP_ALU_OPCODE[4]), .ZN(S3_ALU_n310) );
  INV_X1 S3_ALU_U295 ( .A(DP_ALU_OPCODE[3]), .ZN(S3_ALU_n312) );
  INV_X1 S3_ALU_U294 ( .A(DP_ALU_OPCODE[0]), .ZN(S3_ALU_n316) );
  INV_X1 S3_ALU_U293 ( .A(DP_ALU_OPCODE[1]), .ZN(S3_ALU_n315) );
  AOI21_X1 S3_ALU_U292 ( .B1(DP_ALU_OPCODE[0]), .B2(DP_ALU_OPCODE[3]), .A(
        DP_ALU_OPCODE[2]), .ZN(S3_ALU_n263) );
  AOI21_X1 S3_ALU_U291 ( .B1(DP_ALU_OPCODE[1]), .B2(DP_ALU_OPCODE[3]), .A(
        S3_ALU_n263), .ZN(S3_ALU_n262) );
  NAND4_X1 S3_ALU_U290 ( .A1(S3_ALU_n231), .A2(S3_ALU_n310), .A3(S3_ALU_n255), 
        .A4(S3_ALU_n262), .ZN(S3_ALU_n265) );
  NOR4_X1 S3_ALU_U289 ( .A1(S3_ALU_n316), .A2(DP_ALU_OPCODE[2]), .A3(
        DP_ALU_OPCODE[3]), .A4(DP_ALU_OPCODE[4]), .ZN(S3_ALU_n260) );
  BUF_X1 S3_ALU_U288 ( .A(S3_ALU_n22), .Z(S3_ALU_n21) );
  BUF_X1 S3_ALU_U287 ( .A(S3_ALU_n78), .Z(S3_ALU_n96) );
  BUF_X1 S3_ALU_U286 ( .A(S3_ALU_n102), .Z(S3_ALU_n120) );
  BUF_X1 S3_ALU_U285 ( .A(S3_ALU_n102), .Z(S3_ALU_n114) );
  BUF_X1 S3_ALU_U284 ( .A(S3_ALU_n102), .Z(S3_ALU_n108) );
  BUF_X1 S3_ALU_U283 ( .A(S3_ALU_n78), .Z(S3_ALU_n84) );
  BUF_X1 S3_ALU_U282 ( .A(S3_ALU_n78), .Z(S3_ALU_n90) );
  BUF_X1 S3_ALU_U281 ( .A(S3_ALU_n22), .Z(S3_ALU_n20) );
  BUF_X1 S3_ALU_U280 ( .A(S3_ALU_n22), .Z(S3_ALU_n19) );
  INV_X1 S3_ALU_U279 ( .A(S3_ALU_n265), .ZN(S3_ALU_n309) );
  AND2_X1 S3_ALU_U278 ( .A1(S3_ALU_n260), .A2(S3_ALU_n315), .ZN(S3_ALU_n33) );
  NOR2_X1 S3_ALU_U276 ( .A1(S3_ALU_n312), .A2(S3_ALU_n316), .ZN(S3_ALU_n245)
         );
  AOI222_X1 S3_ALU_U275 ( .A1(S3_ALU_RESULT_shftr[1]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N163), .B2(S3_ALU_n138), .C1(S3_ALU_N195), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n159) );
  AOI22_X1 S3_ALU_U274 ( .A1(S3_MUX_A_OUT[1]), .A2(S3_ALU_n160), .B1(
        S3_MUX_B_OUT[1]), .B2(S3_ALU_n161), .ZN(S3_ALU_n158) );
  AOI22_X1 S3_ALU_U273 ( .A1(S3_ALU_N358), .A2(S3_ALU_n20), .B1(S3_ALU_N326), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n157) );
  AOI222_X1 S3_ALU_U272 ( .A1(S3_ALU_RESULT_shftr[2]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N164), .B2(S3_ALU_n132), .C1(S3_ALU_N196), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n93) );
  AOI22_X1 S3_ALU_U271 ( .A1(S3_MUX_A_OUT[2]), .A2(S3_ALU_n94), .B1(
        S3_MUX_B_OUT[2]), .B2(S3_ALU_n95), .ZN(S3_ALU_n92) );
  AOI22_X1 S3_ALU_U269 ( .A1(S3_ALU_N359), .A2(S3_ALU_n19), .B1(S3_ALU_N327), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n91) );
  AOI222_X1 S3_ALU_U268 ( .A1(S3_ALU_RESULT_shftr[3]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N165), .B2(S3_ALU_n132), .C1(S3_ALU_N197), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n75) );
  AOI22_X1 S3_ALU_U267 ( .A1(S3_MUX_A_OUT[3]), .A2(S3_ALU_n76), .B1(
        S3_MUX_B_OUT[3]), .B2(S3_ALU_n77), .ZN(S3_ALU_n74) );
  AOI22_X1 S3_ALU_U266 ( .A1(S3_ALU_N360), .A2(S3_ALU_n19), .B1(S3_ALU_N328), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n73) );
  AOI222_X1 S3_ALU_U265 ( .A1(S3_ALU_RESULT_shftr[4]), .A2(S3_ALU_n11), .B1(
        S3_ALU_N166), .B2(S3_ALU_n132), .C1(S3_ALU_N198), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n69) );
  AOI22_X1 S3_ALU_U264 ( .A1(S3_MUX_A_OUT[4]), .A2(S3_ALU_n70), .B1(
        S3_MUX_B_OUT[4]), .B2(S3_ALU_n71), .ZN(S3_ALU_n68) );
  AOI22_X1 S3_ALU_U263 ( .A1(S3_ALU_N361), .A2(S3_ALU_n19), .B1(S3_ALU_N329), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n67) );
  AOI222_X1 S3_ALU_U262 ( .A1(S3_ALU_RESULT_shftr[5]), .A2(S3_ALU_n11), .B1(
        S3_ALU_N167), .B2(S3_ALU_n132), .C1(S3_ALU_N199), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n63) );
  AOI22_X1 S3_ALU_U261 ( .A1(S3_MUX_A_OUT[5]), .A2(S3_ALU_n64), .B1(
        S3_MUX_B_OUT[5]), .B2(S3_ALU_n65), .ZN(S3_ALU_n62) );
  AOI22_X1 S3_ALU_U260 ( .A1(S3_ALU_N362), .A2(S3_ALU_n19), .B1(S3_ALU_N330), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n61) );
  AOI222_X1 S3_ALU_U259 ( .A1(S3_ALU_RESULT_shftr[6]), .A2(S3_ALU_n11), .B1(
        S3_ALU_N168), .B2(S3_ALU_n132), .C1(S3_ALU_N200), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n57) );
  AOI22_X1 S3_ALU_U257 ( .A1(S3_MUX_A_OUT[6]), .A2(S3_ALU_n58), .B1(
        S3_MUX_B_OUT[6]), .B2(S3_ALU_n59), .ZN(S3_ALU_n56) );
  AOI22_X1 S3_ALU_U256 ( .A1(S3_ALU_N363), .A2(S3_ALU_n19), .B1(S3_ALU_N331), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n55) );
  AOI222_X1 S3_ALU_U255 ( .A1(S3_ALU_RESULT_shftr[7]), .A2(S3_ALU_n11), .B1(
        S3_ALU_N169), .B2(S3_ALU_n132), .C1(S3_ALU_N201), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n51) );
  AOI22_X1 S3_ALU_U253 ( .A1(S3_MUX_A_OUT[7]), .A2(S3_ALU_n52), .B1(
        S3_MUX_B_OUT[7]), .B2(S3_ALU_n53), .ZN(S3_ALU_n50) );
  AOI22_X1 S3_ALU_U252 ( .A1(S3_ALU_N364), .A2(S3_ALU_n19), .B1(S3_ALU_N332), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n49) );
  AOI222_X1 S3_ALU_U251 ( .A1(S3_ALU_RESULT_shftr[8]), .A2(S3_ALU_n11), .B1(
        S3_ALU_N170), .B2(S3_ALU_n132), .C1(S3_ALU_N202), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n45) );
  AOI22_X1 S3_ALU_U250 ( .A1(S3_MUX_A_OUT[8]), .A2(S3_ALU_n46), .B1(
        S3_MUX_B_OUT[8]), .B2(S3_ALU_n47), .ZN(S3_ALU_n44) );
  AOI22_X1 S3_ALU_U249 ( .A1(S3_ALU_N365), .A2(S3_ALU_n19), .B1(S3_ALU_N333), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n43) );
  AOI222_X1 S3_ALU_U248 ( .A1(S3_ALU_RESULT_shftr[9]), .A2(S3_ALU_n11), .B1(
        S3_ALU_N171), .B2(S3_ALU_n132), .C1(S3_ALU_N203), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n31) );
  AOI22_X1 S3_ALU_U247 ( .A1(S3_MUX_A_OUT[9]), .A2(S3_ALU_n35), .B1(
        S3_MUX_B_OUT[9]), .B2(S3_ALU_n36), .ZN(S3_ALU_n30) );
  AOI22_X1 S3_ALU_U246 ( .A1(S3_ALU_N366), .A2(S3_ALU_n19), .B1(S3_ALU_N334), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n29) );
  AOI222_X1 S3_ALU_U245 ( .A1(S3_ALU_RESULT_shftr[10]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N172), .B2(S3_ALU_n144), .C1(S3_ALU_N204), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n219) );
  AOI22_X1 S3_ALU_U244 ( .A1(S3_MUX_A_OUT[10]), .A2(S3_ALU_n220), .B1(
        S3_MUX_B_OUT[10]), .B2(S3_ALU_n221), .ZN(S3_ALU_n218) );
  AOI22_X1 S3_ALU_U243 ( .A1(S3_ALU_N367), .A2(S3_ALU_n21), .B1(S3_ALU_N335), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n217) );
  AOI222_X1 S3_ALU_U241 ( .A1(S3_ALU_RESULT_shftr[11]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N173), .B2(S3_ALU_n144), .C1(S3_ALU_N205), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n213) );
  AOI22_X1 S3_ALU_U240 ( .A1(S3_MUX_A_OUT[11]), .A2(S3_ALU_n214), .B1(
        S3_MUX_B_OUT[11]), .B2(S3_ALU_n215), .ZN(S3_ALU_n212) );
  AOI22_X1 S3_ALU_U239 ( .A1(S3_ALU_N368), .A2(S3_ALU_n21), .B1(S3_ALU_N336), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n211) );
  AOI222_X1 S3_ALU_U238 ( .A1(S3_ALU_RESULT_shftr[12]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N174), .B2(S3_ALU_n144), .C1(S3_ALU_N206), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n207) );
  AOI22_X1 S3_ALU_U237 ( .A1(S3_MUX_A_OUT[12]), .A2(S3_ALU_n208), .B1(
        S3_MUX_B_OUT[12]), .B2(S3_ALU_n209), .ZN(S3_ALU_n206) );
  AOI22_X1 S3_ALU_U236 ( .A1(S3_ALU_N369), .A2(S3_ALU_n21), .B1(S3_ALU_N337), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n205) );
  AOI222_X1 S3_ALU_U235 ( .A1(S3_ALU_RESULT_shftr[13]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N175), .B2(S3_ALU_n144), .C1(S3_ALU_N207), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n201) );
  AOI22_X1 S3_ALU_U234 ( .A1(S3_MUX_A_OUT[13]), .A2(S3_ALU_n202), .B1(
        S3_MUX_B_OUT[13]), .B2(S3_ALU_n203), .ZN(S3_ALU_n200) );
  AOI22_X1 S3_ALU_U233 ( .A1(S3_ALU_N370), .A2(S3_ALU_n21), .B1(S3_ALU_N338), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n199) );
  AOI222_X1 S3_ALU_U232 ( .A1(S3_ALU_RESULT_shftr[14]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N176), .B2(S3_ALU_n144), .C1(S3_ALU_N208), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n195) );
  AOI22_X1 S3_ALU_U231 ( .A1(S3_MUX_A_OUT[14]), .A2(S3_ALU_n196), .B1(
        S3_MUX_B_OUT[14]), .B2(S3_ALU_n197), .ZN(S3_ALU_n194) );
  AOI22_X1 S3_ALU_U230 ( .A1(S3_ALU_N371), .A2(S3_ALU_n21), .B1(S3_ALU_N339), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n193) );
  AOI222_X1 S3_ALU_U229 ( .A1(S3_ALU_RESULT_shftr[15]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N177), .B2(S3_ALU_n144), .C1(S3_ALU_N209), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n189) );
  AOI22_X1 S3_ALU_U227 ( .A1(S3_MUX_A_OUT[15]), .A2(S3_ALU_n190), .B1(
        S3_MUX_B_OUT[15]), .B2(S3_ALU_n191), .ZN(S3_ALU_n188) );
  AOI22_X1 S3_ALU_U226 ( .A1(S3_ALU_N372), .A2(S3_ALU_n21), .B1(S3_ALU_N340), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n187) );
  AOI222_X1 S3_ALU_U225 ( .A1(S3_ALU_RESULT_shftr[16]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N178), .B2(S3_ALU_n144), .C1(S3_ALU_N210), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n183) );
  AOI22_X1 S3_ALU_U224 ( .A1(S3_MUX_A_OUT[16]), .A2(S3_ALU_n184), .B1(
        S3_MUX_B_OUT[16]), .B2(S3_ALU_n185), .ZN(S3_ALU_n182) );
  AOI22_X1 S3_ALU_U223 ( .A1(S3_ALU_N373), .A2(S3_ALU_n21), .B1(S3_ALU_N341), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n181) );
  AOI222_X1 S3_ALU_U222 ( .A1(S3_ALU_RESULT_shftr[17]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N179), .B2(S3_ALU_n138), .C1(S3_ALU_N211), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n177) );
  AOI22_X1 S3_ALU_U221 ( .A1(S3_MUX_A_OUT[17]), .A2(S3_ALU_n178), .B1(
        S3_MUX_B_OUT[17]), .B2(S3_ALU_n179), .ZN(S3_ALU_n176) );
  AOI22_X1 S3_ALU_U220 ( .A1(S3_ALU_N374), .A2(S3_ALU_n20), .B1(S3_ALU_N342), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n175) );
  AOI222_X1 S3_ALU_U218 ( .A1(S3_ALU_RESULT_shftr[18]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N180), .B2(S3_ALU_n138), .C1(S3_ALU_N212), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n171) );
  AOI22_X1 S3_ALU_U217 ( .A1(S3_MUX_A_OUT[18]), .A2(S3_ALU_n172), .B1(
        S3_MUX_B_OUT[18]), .B2(S3_ALU_n173), .ZN(S3_ALU_n170) );
  AOI22_X1 S3_ALU_U216 ( .A1(S3_ALU_N375), .A2(S3_ALU_n20), .B1(S3_ALU_N343), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n169) );
  AOI222_X1 S3_ALU_U215 ( .A1(S3_ALU_RESULT_shftr[19]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N181), .B2(S3_ALU_n138), .C1(S3_ALU_N213), .C2(S3_ALU_n108), 
        .ZN(S3_ALU_n165) );
  AOI22_X1 S3_ALU_U214 ( .A1(S3_MUX_A_OUT[19]), .A2(S3_ALU_n166), .B1(
        S3_MUX_B_OUT[19]), .B2(S3_ALU_n167), .ZN(S3_ALU_n164) );
  AOI22_X1 S3_ALU_U213 ( .A1(S3_ALU_N376), .A2(S3_ALU_n20), .B1(S3_ALU_N344), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n163) );
  AOI222_X1 S3_ALU_U211 ( .A1(S3_ALU_RESULT_shftr[20]), .A2(S3_ALU_n9), .B1(
        S3_ALU_N182), .B2(S3_ALU_n138), .C1(S3_ALU_N214), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n153) );
  AOI22_X1 S3_ALU_U210 ( .A1(S3_MUX_A_OUT[20]), .A2(S3_ALU_n154), .B1(
        S3_MUX_B_OUT[20]), .B2(S3_ALU_n155), .ZN(S3_ALU_n152) );
  AOI22_X1 S3_ALU_U209 ( .A1(S3_ALU_N377), .A2(S3_ALU_n20), .B1(S3_ALU_N345), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n151) );
  AOI222_X1 S3_ALU_U208 ( .A1(S3_ALU_RESULT_shftr[21]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N183), .B2(S3_ALU_n138), .C1(S3_ALU_N215), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n147) );
  AOI22_X1 S3_ALU_U207 ( .A1(S3_MUX_A_OUT[21]), .A2(S3_ALU_n148), .B1(
        S3_MUX_B_OUT[21]), .B2(S3_ALU_n149), .ZN(S3_ALU_n146) );
  AOI22_X1 S3_ALU_U206 ( .A1(S3_ALU_N378), .A2(S3_ALU_n20), .B1(S3_ALU_N346), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n145) );
  AOI222_X1 S3_ALU_U204 ( .A1(S3_ALU_RESULT_shftr[22]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N184), .B2(S3_ALU_n138), .C1(S3_ALU_N216), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n141) );
  AOI22_X1 S3_ALU_U203 ( .A1(S3_MUX_A_OUT[22]), .A2(S3_ALU_n142), .B1(
        S3_MUX_B_OUT[22]), .B2(S3_ALU_n143), .ZN(S3_ALU_n140) );
  AOI22_X1 S3_ALU_U202 ( .A1(S3_ALU_N379), .A2(S3_ALU_n20), .B1(S3_ALU_N347), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n139) );
  AOI222_X1 S3_ALU_U201 ( .A1(S3_ALU_RESULT_shftr[23]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N185), .B2(S3_ALU_n138), .C1(S3_ALU_N217), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n135) );
  AOI22_X1 S3_ALU_U200 ( .A1(S3_MUX_A_OUT[23]), .A2(S3_ALU_n136), .B1(
        S3_MUX_B_OUT[23]), .B2(S3_ALU_n137), .ZN(S3_ALU_n134) );
  AOI22_X1 S3_ALU_U199 ( .A1(S3_ALU_N380), .A2(S3_ALU_n20), .B1(S3_ALU_N348), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n133) );
  AOI222_X1 S3_ALU_U197 ( .A1(S3_ALU_RESULT_shftr[24]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N186), .B2(S3_ALU_n138), .C1(S3_ALU_N218), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n129) );
  AOI22_X1 S3_ALU_U196 ( .A1(S3_MUX_A_OUT[24]), .A2(S3_ALU_n130), .B1(
        S3_MUX_B_OUT[24]), .B2(S3_ALU_n131), .ZN(S3_ALU_n128) );
  AOI22_X1 S3_ALU_U195 ( .A1(S3_ALU_N381), .A2(S3_ALU_n20), .B1(S3_ALU_N349), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n127) );
  AOI222_X1 S3_ALU_U194 ( .A1(S3_ALU_RESULT_shftr[25]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N187), .B2(S3_ALU_n138), .C1(S3_ALU_N219), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n123) );
  AOI22_X1 S3_ALU_U193 ( .A1(S3_MUX_A_OUT[25]), .A2(S3_ALU_n124), .B1(
        S3_MUX_B_OUT[25]), .B2(S3_ALU_n125), .ZN(S3_ALU_n122) );
  AOI22_X1 S3_ALU_U192 ( .A1(S3_ALU_N382), .A2(S3_ALU_n20), .B1(S3_ALU_N350), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n121) );
  AOI222_X1 S3_ALU_U190 ( .A1(S3_ALU_RESULT_shftr[26]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N188), .B2(S3_ALU_n138), .C1(S3_ALU_N220), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n117) );
  AOI22_X1 S3_ALU_U189 ( .A1(S3_MUX_A_OUT[26]), .A2(S3_ALU_n118), .B1(
        S3_MUX_B_OUT[26]), .B2(S3_ALU_n119), .ZN(S3_ALU_n116) );
  AOI22_X1 S3_ALU_U188 ( .A1(S3_ALU_N383), .A2(S3_ALU_n20), .B1(S3_ALU_N351), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n115) );
  AOI222_X1 S3_ALU_U187 ( .A1(S3_ALU_RESULT_shftr[27]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N189), .B2(S3_ALU_n138), .C1(S3_ALU_N221), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n111) );
  AOI22_X1 S3_ALU_U186 ( .A1(S3_MUX_A_OUT[27]), .A2(S3_ALU_n112), .B1(
        S3_MUX_B_OUT[27]), .B2(S3_ALU_n113), .ZN(S3_ALU_n110) );
  AOI22_X1 S3_ALU_U185 ( .A1(S3_ALU_N384), .A2(S3_ALU_n20), .B1(S3_ALU_N352), 
        .B2(S3_ALU_n17), .ZN(S3_ALU_n109) );
  AOI222_X1 S3_ALU_U183 ( .A1(S3_ALU_RESULT_shftr[28]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N190), .B2(S3_ALU_n132), .C1(S3_ALU_N222), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n105) );
  AOI22_X1 S3_ALU_U182 ( .A1(S3_MUX_A_OUT[28]), .A2(S3_ALU_n106), .B1(
        S3_MUX_B_OUT[28]), .B2(S3_ALU_n107), .ZN(S3_ALU_n104) );
  AOI22_X1 S3_ALU_U181 ( .A1(S3_ALU_N385), .A2(S3_ALU_n19), .B1(S3_ALU_N353), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n103) );
  AOI222_X1 S3_ALU_U180 ( .A1(S3_ALU_RESULT_shftr[29]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N191), .B2(S3_ALU_n132), .C1(S3_ALU_N223), .C2(S3_ALU_n114), 
        .ZN(S3_ALU_n99) );
  AOI22_X1 S3_ALU_U179 ( .A1(S3_MUX_A_OUT[29]), .A2(S3_ALU_n100), .B1(
        S3_MUX_B_OUT[29]), .B2(S3_ALU_n101), .ZN(S3_ALU_n98) );
  AOI22_X1 S3_ALU_U178 ( .A1(S3_ALU_N386), .A2(S3_ALU_n19), .B1(S3_ALU_N354), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n97) );
  AOI222_X1 S3_ALU_U176 ( .A1(S3_ALU_RESULT_shftr[30]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N192), .B2(S3_ALU_n132), .C1(S3_ALU_N224), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n87) );
  AOI22_X1 S3_ALU_U175 ( .A1(S3_MUX_A_OUT[30]), .A2(S3_ALU_n88), .B1(
        S3_MUX_B_OUT[30]), .B2(S3_ALU_n89), .ZN(S3_ALU_n86) );
  AOI22_X1 S3_ALU_U174 ( .A1(S3_ALU_N387), .A2(S3_ALU_n19), .B1(S3_ALU_N355), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n85) );
  AOI222_X1 S3_ALU_U173 ( .A1(S3_ALU_RESULT_shftr[31]), .A2(S3_ALU_n10), .B1(
        S3_ALU_N193), .B2(S3_ALU_n132), .C1(S3_ALU_N225), .C2(S3_ALU_n120), 
        .ZN(S3_ALU_n81) );
  AOI22_X1 S3_ALU_U172 ( .A1(S3_MUX_A_OUT[31]), .A2(S3_ALU_n82), .B1(
        S3_MUX_B_OUT[31]), .B2(S3_ALU_n83), .ZN(S3_ALU_n80) );
  AOI22_X1 S3_ALU_U171 ( .A1(S3_ALU_N388), .A2(S3_ALU_n19), .B1(S3_ALU_N356), 
        .B2(S3_ALU_n16), .ZN(S3_ALU_n79) );
  NAND2_X1 S3_ALU_U169 ( .A1(S3_ALU_n316), .A2(S3_ALU_n312), .ZN(S3_ALU_n255)
         );
  OAI21_X1 S3_ALU_U168 ( .B1(S3_ALU_n150), .B2(S3_ALU_n37), .A(S3_ALU_n24), 
        .ZN(S3_ALU_n238) );
  OAI21_X1 S3_ALU_U167 ( .B1(S3_MUX_B_OUT[1]), .B2(S3_ALU_n42), .A(S3_ALU_n24), 
        .ZN(S3_ALU_n160) );
  OAI21_X1 S3_ALU_U166 ( .B1(S3_MUX_B_OUT[2]), .B2(S3_ALU_n40), .A(S3_ALU_n25), 
        .ZN(S3_ALU_n94) );
  OAI21_X1 S3_ALU_U165 ( .B1(S3_MUX_B_OUT[3]), .B2(S3_ALU_n37), .A(S3_ALU_n25), 
        .ZN(S3_ALU_n76) );
  OAI21_X1 S3_ALU_U164 ( .B1(S3_MUX_B_OUT[4]), .B2(S3_ALU_n37), .A(S3_ALU_n25), 
        .ZN(S3_ALU_n70) );
  OAI21_X1 S3_ALU_U162 ( .B1(S3_MUX_B_OUT[8]), .B2(S3_ALU_n37), .A(S3_ALU_n25), 
        .ZN(S3_ALU_n46) );
  OAI21_X1 S3_ALU_U161 ( .B1(S3_MUX_B_OUT[12]), .B2(S3_ALU_n37), .A(S3_ALU_n24), .ZN(S3_ALU_n208) );
  OAI21_X1 S3_ALU_U160 ( .B1(S3_MUX_B_OUT[16]), .B2(S3_ALU_n40), .A(S3_ALU_n24), .ZN(S3_ALU_n184) );
  OAI21_X1 S3_ALU_U159 ( .B1(S3_MUX_B_OUT[20]), .B2(S3_ALU_n42), .A(S3_ALU_n24), .ZN(S3_ALU_n154) );
  OAI21_X1 S3_ALU_U158 ( .B1(S3_MUX_B_OUT[24]), .B2(S3_ALU_n42), .A(S3_ALU_n25), .ZN(S3_ALU_n130) );
  OAI21_X1 S3_ALU_U157 ( .B1(S3_MUX_B_OUT[28]), .B2(S3_ALU_n40), .A(S3_ALU_n25), .ZN(S3_ALU_n106) );
  OAI21_X1 S3_ALU_U155 ( .B1(S3_MUX_B_OUT[6]), .B2(S3_ALU_n37), .A(S3_ALU_n25), 
        .ZN(S3_ALU_n58) );
  OAI21_X1 S3_ALU_U154 ( .B1(S3_MUX_B_OUT[7]), .B2(S3_ALU_n37), .A(S3_ALU_n23), 
        .ZN(S3_ALU_n52) );
  OAI21_X1 S3_ALU_U153 ( .B1(S3_MUX_B_OUT[10]), .B2(S3_ALU_n37), .A(S3_ALU_n25), .ZN(S3_ALU_n220) );
  OAI21_X1 S3_ALU_U152 ( .B1(S3_MUX_B_OUT[11]), .B2(S3_ALU_n37), .A(S3_ALU_n24), .ZN(S3_ALU_n214) );
  OAI21_X1 S3_ALU_U151 ( .B1(S3_MUX_B_OUT[14]), .B2(S3_ALU_n40), .A(S3_ALU_n24), .ZN(S3_ALU_n196) );
  OAI21_X1 S3_ALU_U150 ( .B1(S3_MUX_B_OUT[15]), .B2(S3_ALU_n40), .A(S3_ALU_n24), .ZN(S3_ALU_n190) );
  OAI21_X1 S3_ALU_U148 ( .B1(S3_MUX_B_OUT[18]), .B2(S3_ALU_n42), .A(S3_ALU_n24), .ZN(S3_ALU_n172) );
  OAI21_X1 S3_ALU_U147 ( .B1(S3_MUX_B_OUT[19]), .B2(S3_ALU_n42), .A(S3_ALU_n24), .ZN(S3_ALU_n166) );
  OAI21_X1 S3_ALU_U146 ( .B1(S3_MUX_B_OUT[22]), .B2(S3_ALU_n42), .A(S3_ALU_n24), .ZN(S3_ALU_n142) );
  OAI21_X1 S3_ALU_U145 ( .B1(S3_MUX_B_OUT[23]), .B2(S3_ALU_n42), .A(S3_ALU_n24), .ZN(S3_ALU_n136) );
  OAI21_X1 S3_ALU_U144 ( .B1(S3_MUX_B_OUT[26]), .B2(S3_ALU_n40), .A(S3_ALU_n25), .ZN(S3_ALU_n118) );
  OAI21_X1 S3_ALU_U143 ( .B1(S3_MUX_B_OUT[27]), .B2(S3_ALU_n40), .A(S3_ALU_n25), .ZN(S3_ALU_n112) );
  OAI21_X1 S3_ALU_U141 ( .B1(S3_MUX_B_OUT[5]), .B2(S3_ALU_n37), .A(S3_ALU_n25), 
        .ZN(S3_ALU_n64) );
  OAI21_X1 S3_ALU_U140 ( .B1(S3_MUX_B_OUT[9]), .B2(S3_ALU_n37), .A(S3_ALU_n23), 
        .ZN(S3_ALU_n35) );
  OAI21_X1 S3_ALU_U139 ( .B1(S3_MUX_B_OUT[13]), .B2(S3_ALU_n40), .A(S3_ALU_n23), .ZN(S3_ALU_n202) );
  OAI21_X1 S3_ALU_U138 ( .B1(S3_MUX_B_OUT[17]), .B2(S3_ALU_n40), .A(S3_ALU_n24), .ZN(S3_ALU_n178) );
  OAI21_X1 S3_ALU_U137 ( .B1(S3_MUX_B_OUT[21]), .B2(S3_ALU_n42), .A(S3_ALU_n24), .ZN(S3_ALU_n148) );
  OAI21_X1 S3_ALU_U136 ( .B1(S3_MUX_B_OUT[25]), .B2(S3_ALU_n40), .A(S3_ALU_n25), .ZN(S3_ALU_n124) );
  OAI21_X1 S3_ALU_U134 ( .B1(S3_MUX_B_OUT[29]), .B2(S3_ALU_n40), .A(S3_ALU_n25), .ZN(S3_ALU_n100) );
  OAI21_X1 S3_ALU_U133 ( .B1(S3_MUX_B_OUT[31]), .B2(S3_ALU_n40), .A(S3_ALU_n25), .ZN(S3_ALU_n82) );
  OAI21_X1 S3_ALU_U132 ( .B1(S3_MUX_B_OUT[30]), .B2(S3_ALU_n37), .A(S3_ALU_n25), .ZN(S3_ALU_n88) );
  INV_X1 S3_ALU_U131 ( .A(S3_MUX_A_OUT[0]), .ZN(S3_ALU_n307) );
  OAI221_X1 S3_ALU_U130 ( .B1(S3_ALU_n84), .B2(S3_ALU_n307), .C1(
        S3_MUX_A_OUT[0]), .C2(S3_ALU_n48), .A(S3_ALU_n23), .ZN(S3_ALU_n257) );
  INV_X1 S3_ALU_U129 ( .A(S3_MUX_A_OUT[1]), .ZN(S3_ALU_n306) );
  OAI221_X1 S3_ALU_U127 ( .B1(S3_ALU_n84), .B2(S3_ALU_n306), .C1(
        S3_MUX_A_OUT[1]), .C2(S3_ALU_n48), .A(S3_ALU_n24), .ZN(S3_ALU_n161) );
  INV_X1 S3_ALU_U126 ( .A(S3_MUX_A_OUT[2]), .ZN(S3_ALU_n305) );
  OAI221_X1 S3_ALU_U125 ( .B1(S3_ALU_n90), .B2(S3_ALU_n305), .C1(
        S3_MUX_A_OUT[2]), .C2(S3_ALU_n54), .A(S3_ALU_n23), .ZN(S3_ALU_n95) );
  INV_X1 S3_ALU_U124 ( .A(S3_MUX_A_OUT[3]), .ZN(S3_ALU_n304) );
  OAI221_X1 S3_ALU_U123 ( .B1(S3_ALU_n96), .B2(S3_ALU_n304), .C1(
        S3_MUX_A_OUT[3]), .C2(S3_ALU_n54), .A(S3_ALU_n23), .ZN(S3_ALU_n77) );
  INV_X1 S3_ALU_U122 ( .A(S3_MUX_A_OUT[4]), .ZN(S3_ALU_n303) );
  OAI221_X1 S3_ALU_U120 ( .B1(S3_ALU_n96), .B2(S3_ALU_n303), .C1(
        S3_MUX_A_OUT[4]), .C2(S3_ALU_n54), .A(S3_ALU_n23), .ZN(S3_ALU_n71) );
  INV_X1 S3_ALU_U119 ( .A(S3_MUX_A_OUT[5]), .ZN(S3_ALU_n302) );
  OAI221_X1 S3_ALU_U118 ( .B1(S3_ALU_n96), .B2(S3_ALU_n302), .C1(
        S3_MUX_A_OUT[5]), .C2(S3_ALU_n60), .A(S3_ALU_n23), .ZN(S3_ALU_n65) );
  INV_X1 S3_ALU_U117 ( .A(S3_MUX_A_OUT[6]), .ZN(S3_ALU_n301) );
  OAI221_X1 S3_ALU_U116 ( .B1(S3_ALU_n96), .B2(S3_ALU_n301), .C1(
        S3_MUX_A_OUT[6]), .C2(S3_ALU_n60), .A(S3_ALU_n23), .ZN(S3_ALU_n59) );
  INV_X1 S3_ALU_U115 ( .A(S3_MUX_A_OUT[7]), .ZN(S3_ALU_n300) );
  OAI221_X1 S3_ALU_U113 ( .B1(S3_ALU_n96), .B2(S3_ALU_n300), .C1(
        S3_MUX_A_OUT[7]), .C2(S3_ALU_n60), .A(S3_ALU_n23), .ZN(S3_ALU_n53) );
  INV_X1 S3_ALU_U112 ( .A(S3_MUX_A_OUT[8]), .ZN(S3_ALU_n299) );
  OAI221_X1 S3_ALU_U111 ( .B1(S3_ALU_n96), .B2(S3_ALU_n299), .C1(
        S3_MUX_A_OUT[8]), .C2(S3_ALU_n60), .A(S3_ALU_n23), .ZN(S3_ALU_n47) );
  INV_X1 S3_ALU_U110 ( .A(S3_MUX_A_OUT[9]), .ZN(S3_ALU_n264) );
  OAI221_X1 S3_ALU_U109 ( .B1(S3_ALU_n264), .B2(S3_ALU_n96), .C1(
        S3_MUX_A_OUT[9]), .C2(S3_ALU_n42), .A(S3_ALU_n23), .ZN(S3_ALU_n36) );
  INV_X1 S3_ALU_U108 ( .A(S3_MUX_A_OUT[10]), .ZN(S3_ALU_n258) );
  OAI221_X1 S3_ALU_U106 ( .B1(S3_ALU_n84), .B2(S3_ALU_n258), .C1(
        S3_MUX_A_OUT[10]), .C2(S3_ALU_n42), .A(S3_ALU_n23), .ZN(S3_ALU_n221)
         );
  INV_X1 S3_ALU_U105 ( .A(S3_MUX_A_OUT[11]), .ZN(S3_ALU_n256) );
  OAI221_X1 S3_ALU_U104 ( .B1(S3_ALU_n84), .B2(S3_ALU_n256), .C1(
        S3_MUX_A_OUT[11]), .C2(S3_ALU_n42), .A(S3_ALU_n23), .ZN(S3_ALU_n215)
         );
  INV_X1 S3_ALU_U103 ( .A(S3_MUX_A_OUT[12]), .ZN(S3_ALU_n252) );
  OAI221_X1 S3_ALU_U102 ( .B1(S3_ALU_n84), .B2(S3_ALU_n252), .C1(
        S3_MUX_A_OUT[12]), .C2(S3_ALU_n48), .A(S3_ALU_n23), .ZN(S3_ALU_n209)
         );
  INV_X1 S3_ALU_U101 ( .A(S3_MUX_A_OUT[13]), .ZN(S3_ALU_n247) );
  OAI221_X1 S3_ALU_U99 ( .B1(S3_ALU_n84), .B2(S3_ALU_n247), .C1(
        S3_MUX_A_OUT[13]), .C2(S3_ALU_n42), .A(S3_ALU_n25), .ZN(S3_ALU_n203)
         );
  INV_X1 S3_ALU_U98 ( .A(S3_MUX_A_OUT[14]), .ZN(S3_ALU_n246) );
  OAI221_X1 S3_ALU_U97 ( .B1(S3_ALU_n84), .B2(S3_ALU_n246), .C1(
        S3_MUX_A_OUT[14]), .C2(S3_ALU_n48), .A(S3_ALU_n24), .ZN(S3_ALU_n197)
         );
  INV_X1 S3_ALU_U96 ( .A(S3_MUX_A_OUT[15]), .ZN(S3_ALU_n243) );
  OAI221_X1 S3_ALU_U95 ( .B1(S3_ALU_n84), .B2(S3_ALU_n243), .C1(
        S3_MUX_A_OUT[15]), .C2(S3_ALU_n48), .A(S3_ALU_n23), .ZN(S3_ALU_n191)
         );
  INV_X1 S3_ALU_U94 ( .A(S3_MUX_A_OUT[16]), .ZN(S3_ALU_n233) );
  OAI221_X1 S3_ALU_U92 ( .B1(S3_ALU_n90), .B2(S3_ALU_n233), .C1(
        S3_MUX_A_OUT[16]), .C2(S3_ALU_n48), .A(S3_ALU_n25), .ZN(S3_ALU_n185)
         );
  INV_X1 S3_ALU_U91 ( .A(S3_MUX_A_OUT[17]), .ZN(S3_ALU_n227) );
  OAI221_X1 S3_ALU_U90 ( .B1(S3_ALU_n84), .B2(S3_ALU_n227), .C1(
        S3_MUX_A_OUT[17]), .C2(S3_ALU_n48), .A(S3_ALU_n23), .ZN(S3_ALU_n179)
         );
  INV_X1 S3_ALU_U89 ( .A(S3_MUX_A_OUT[18]), .ZN(S3_ALU_n226) );
  OAI221_X1 S3_ALU_U88 ( .B1(S3_ALU_n84), .B2(S3_ALU_n226), .C1(
        S3_MUX_A_OUT[18]), .C2(S3_ALU_n48), .A(S3_ALU_n23), .ZN(S3_ALU_n173)
         );
  INV_X1 S3_ALU_U87 ( .A(S3_MUX_A_OUT[19]), .ZN(S3_ALU_n223) );
  OAI221_X1 S3_ALU_U85 ( .B1(S3_ALU_n84), .B2(S3_ALU_n223), .C1(
        S3_MUX_A_OUT[19]), .C2(S3_ALU_n48), .A(S3_ALU_n24), .ZN(S3_ALU_n167)
         );
  INV_X1 S3_ALU_U84 ( .A(S3_MUX_A_OUT[20]), .ZN(S3_ALU_n222) );
  OAI221_X1 S3_ALU_U83 ( .B1(S3_ALU_n84), .B2(S3_ALU_n222), .C1(
        S3_MUX_A_OUT[20]), .C2(S3_ALU_n48), .A(S3_ALU_n25), .ZN(S3_ALU_n155)
         );
  INV_X1 S3_ALU_U82 ( .A(S3_MUX_A_OUT[21]), .ZN(S3_ALU_n216) );
  OAI221_X1 S3_ALU_U81 ( .B1(S3_ALU_n90), .B2(S3_ALU_n216), .C1(
        S3_MUX_A_OUT[21]), .C2(S3_ALU_n48), .A(S3_ALU_n25), .ZN(S3_ALU_n149)
         );
  INV_X1 S3_ALU_U80 ( .A(S3_MUX_A_OUT[22]), .ZN(S3_ALU_n210) );
  OAI221_X1 S3_ALU_U78 ( .B1(S3_ALU_n90), .B2(S3_ALU_n210), .C1(
        S3_MUX_A_OUT[22]), .C2(S3_ALU_n48), .A(S3_ALU_n24), .ZN(S3_ALU_n143)
         );
  INV_X1 S3_ALU_U77 ( .A(S3_MUX_A_OUT[23]), .ZN(S3_ALU_n204) );
  OAI221_X1 S3_ALU_U76 ( .B1(S3_ALU_n90), .B2(S3_ALU_n204), .C1(
        S3_MUX_A_OUT[23]), .C2(S3_ALU_n54), .A(S3_ALU_n23), .ZN(S3_ALU_n137)
         );
  INV_X1 S3_ALU_U75 ( .A(S3_MUX_A_OUT[24]), .ZN(S3_ALU_n198) );
  OAI221_X1 S3_ALU_U74 ( .B1(S3_ALU_n90), .B2(S3_ALU_n198), .C1(
        S3_MUX_A_OUT[24]), .C2(S3_ALU_n54), .A(S3_ALU_n24), .ZN(S3_ALU_n131)
         );
  INV_X1 S3_ALU_U73 ( .A(S3_MUX_A_OUT[25]), .ZN(S3_ALU_n192) );
  OAI221_X1 S3_ALU_U71 ( .B1(S3_ALU_n90), .B2(S3_ALU_n192), .C1(
        S3_MUX_A_OUT[25]), .C2(S3_ALU_n54), .A(S3_ALU_n23), .ZN(S3_ALU_n125)
         );
  INV_X1 S3_ALU_U70 ( .A(S3_MUX_A_OUT[26]), .ZN(S3_ALU_n186) );
  OAI221_X1 S3_ALU_U69 ( .B1(S3_ALU_n90), .B2(S3_ALU_n186), .C1(
        S3_MUX_A_OUT[26]), .C2(S3_ALU_n54), .A(S3_ALU_n25), .ZN(S3_ALU_n119)
         );
  INV_X1 S3_ALU_U68 ( .A(S3_MUX_A_OUT[27]), .ZN(S3_ALU_n180) );
  OAI221_X1 S3_ALU_U67 ( .B1(S3_ALU_n90), .B2(S3_ALU_n180), .C1(
        S3_MUX_A_OUT[27]), .C2(S3_ALU_n54), .A(S3_ALU_n24), .ZN(S3_ALU_n113)
         );
  INV_X1 S3_ALU_U66 ( .A(S3_MUX_A_OUT[28]), .ZN(S3_ALU_n174) );
  OAI221_X1 S3_ALU_U64 ( .B1(S3_ALU_n90), .B2(S3_ALU_n174), .C1(
        S3_MUX_A_OUT[28]), .C2(S3_ALU_n54), .A(S3_ALU_n23), .ZN(S3_ALU_n107)
         );
  INV_X1 S3_ALU_U63 ( .A(S3_MUX_A_OUT[29]), .ZN(S3_ALU_n168) );
  OAI221_X1 S3_ALU_U62 ( .B1(S3_ALU_n90), .B2(S3_ALU_n168), .C1(
        S3_MUX_A_OUT[29]), .C2(S3_ALU_n54), .A(S3_ALU_n25), .ZN(S3_ALU_n101)
         );
  INV_X1 S3_ALU_U61 ( .A(S3_MUX_A_OUT[30]), .ZN(S3_ALU_n162) );
  OAI221_X1 S3_ALU_U60 ( .B1(S3_ALU_n90), .B2(S3_ALU_n162), .C1(
        S3_MUX_A_OUT[30]), .C2(S3_ALU_n54), .A(S3_ALU_n24), .ZN(S3_ALU_n89) );
  INV_X1 S3_ALU_U59 ( .A(S3_MUX_A_OUT[31]), .ZN(S3_ALU_n156) );
  OAI221_X1 S3_ALU_U57 ( .B1(S3_ALU_n96), .B2(S3_ALU_n156), .C1(
        S3_MUX_A_OUT[31]), .C2(S3_ALU_n54), .A(S3_ALU_n23), .ZN(S3_ALU_n83) );
  INV_X1 S3_ALU_U56 ( .A(S3_ALU_n232), .ZN(S3_ALU_n314) );
  OAI21_X1 S3_ALU_U55 ( .B1(S3_ALU_n314), .B2(S3_ALU_n310), .A(S3_ALU_n231), 
        .ZN(S3_ALU_n228) );
  AOI221_X1 S3_ALU_U54 ( .B1(S3_ALU_n314), .B2(S3_ALU_n310), .C1(S3_ALU_n228), 
        .C2(S3_ALU_n312), .A(S3_ALU_n229), .ZN(S3_ALU_n225) );
  AOI222_X1 S3_ALU_U53 ( .A1(S3_ALU_N162), .A2(S3_ALU_n144), .B1(S3_ALU_N357), 
        .B2(S3_ALU_n21), .C1(S3_ALU_N325), .C2(S3_ALU_n17), .ZN(S3_ALU_n235)
         );
  BUF_X1 S3_ALU_U52 ( .A(S3_ALU_n66), .Z(S3_ALU_n60) );
  BUF_X1 S3_ALU_U50 ( .A(S3_ALU_n309), .Z(S3_ALU_n11) );
  BUF_X1 S3_ALU_U49 ( .A(S3_ALU_n126), .Z(S3_ALU_n144) );
  INV_X1 S3_ALU_U48 ( .A(S3_ALU_n26), .ZN(S3_ALU_n24) );
  INV_X1 S3_ALU_U47 ( .A(S3_ALU_n26), .ZN(S3_ALU_n25) );
  INV_X1 S3_ALU_U46 ( .A(S3_ALU_n27), .ZN(S3_ALU_n23) );
  BUF_X1 S3_ALU_U45 ( .A(S3_ALU_n66), .Z(S3_ALU_n48) );
  BUF_X1 S3_ALU_U43 ( .A(S3_ALU_n66), .Z(S3_ALU_n54) );
  BUF_X1 S3_ALU_U42 ( .A(S3_ALU_n72), .Z(S3_ALU_n42) );
  BUF_X1 S3_ALU_U41 ( .A(S3_ALU_n72), .Z(S3_ALU_n37) );
  BUF_X1 S3_ALU_U40 ( .A(S3_ALU_n72), .Z(S3_ALU_n40) );
  BUF_X1 S3_ALU_U39 ( .A(S3_ALU_n126), .Z(S3_ALU_n138) );
  BUF_X1 S3_ALU_U38 ( .A(S3_ALU_n126), .Z(S3_ALU_n132) );
  BUF_X1 S3_ALU_U36 ( .A(S3_ALU_n309), .Z(S3_ALU_n10) );
  BUF_X1 S3_ALU_U35 ( .A(S3_ALU_n309), .Z(S3_ALU_n9) );
  NOR3_X1 S3_ALU_U34 ( .A1(S3_ALU_n144), .A2(S3_ALU_n8), .A3(S3_ALU_n108), 
        .ZN(S3_ALU_n224) );
  AND4_X1 S3_ALU_U33 ( .A1(S3_ALU_n60), .A2(S3_ALU_n7), .A3(S3_ALU_n224), .A4(
        S3_ALU_n225), .ZN(S3_ALU_n289) );
  INV_X1 S3_ALU_U32 ( .A(S3_ALU_n230), .ZN(S3_ALU_n308) );
  INV_X1 S3_ALU_U31 ( .A(S3_ALU_n255), .ZN(S3_ALU_n311) );
  BUF_X1 S3_ALU_U29 ( .A(S3_ALU_n15), .Z(S3_ALU_n14) );
  BUF_X1 S3_ALU_U28 ( .A(S3_ALU_n15), .Z(S3_ALU_n13) );
  BUF_X1 S3_ALU_U27 ( .A(S3_ALU_n15), .Z(S3_ALU_n12) );
  INV_X1 S3_ALU_U26 ( .A(S3_ALU_n18), .ZN(S3_ALU_n17) );
  INV_X1 S3_ALU_U25 ( .A(S3_ALU_n18), .ZN(S3_ALU_n16) );
  BUF_X1 S3_ALU_U24 ( .A(S3_ALU_n38), .Z(S3_ALU_n78) );
  BUF_X1 S3_ALU_U22 ( .A(S3_ALU_n34), .Z(S3_ALU_n102) );
  BUF_X1 S3_ALU_U21 ( .A(S3_ALU_n41), .Z(S3_ALU_n22) );
  AND4_X1 S3_ALU_U20 ( .A1(DP_ALU_OPCODE[2]), .A2(S3_ALU_n311), .A3(
        S3_ALU_n315), .A4(S3_ALU_n310), .ZN(S3_ALU_n8) );
  BUF_X1 S3_ALU_U19 ( .A(S3_MUX_B_OUT[0]), .Z(S3_ALU_n150) );
  BUF_X1 S3_ALU_U18 ( .A(S3_ALU_n33), .Z(S3_ALU_n126) );
  BUF_X1 S3_ALU_U17 ( .A(S3_ALU_n32), .Z(S3_ALU_n66) );
  BUF_X1 S3_ALU_U15 ( .A(S3_ALU_n32), .Z(S3_ALU_n72) );
  BUF_X1 S3_ALU_U14 ( .A(S3_ALU_n8), .Z(S3_ALU_n27) );
  BUF_X1 S3_ALU_U13 ( .A(S3_ALU_n8), .Z(S3_ALU_n26) );
  BUF_X1 S3_ALU_U12 ( .A(S3_ALU_n289), .Z(S3_ALU_n15) );
  BUF_X1 S3_ALU_U11 ( .A(S3_ALU_n7), .Z(S3_ALU_n18) );
  OR2_X1 S3_ALU_U10 ( .A1(S3_ALU_n231), .A2(S3_ALU_n261), .ZN(S3_ALU_n7) );
  TBUF_X1 S3_ALU_SHIFT_ROTATE_shftr_tri ( .A(1'b1), .EN(S3_ALU_n265), .Z(
        S3_ALU_SHIFT_ROTATE_shftr) );
  TBUF_X1 S3_ALU_LOGIC_ARITH_shftr_tri ( .A(DP_ALU_OPCODE[0]), .EN(S3_ALU_n265), .Z(S3_ALU_LOGIC_ARITH_shftr) );
  TBUF_X1 S3_ALU_Y_tri_31_ ( .A(S3_ALU_n266), .EN(S3_ALU_n14), .Z(
        S3_ALU_OUT[31]) );
  TBUF_X1 S3_ALU_Y_tri_30_ ( .A(S3_ALU_n267), .EN(S3_ALU_n12), .Z(
        S3_ALU_OUT[30]) );
  TBUF_X1 S3_ALU_Y_tri_29_ ( .A(S3_ALU_n268), .EN(S3_ALU_n12), .Z(
        S3_ALU_OUT[29]) );
  TBUF_X1 S3_ALU_Y_tri_28_ ( .A(S3_ALU_n269), .EN(S3_ALU_n14), .Z(
        S3_ALU_OUT[28]) );
  TBUF_X1 S3_ALU_Y_tri_27_ ( .A(S3_ALU_n270), .EN(S3_ALU_n12), .Z(
        S3_ALU_OUT[27]) );
  TBUF_X1 S3_ALU_Y_tri_26_ ( .A(S3_ALU_n271), .EN(S3_ALU_n14), .Z(
        S3_ALU_OUT[26]) );
  TBUF_X1 S3_ALU_Y_tri_25_ ( .A(S3_ALU_n272), .EN(S3_ALU_n12), .Z(
        S3_ALU_OUT[25]) );
  TBUF_X1 S3_ALU_Y_tri_24_ ( .A(S3_ALU_n273), .EN(S3_ALU_n14), .Z(
        S3_ALU_OUT[24]) );
  TBUF_X1 S3_ALU_Y_tri_23_ ( .A(S3_ALU_n274), .EN(S3_ALU_n12), .Z(
        S3_ALU_OUT[23]) );
  TBUF_X1 S3_ALU_Y_tri_22_ ( .A(S3_ALU_n275), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[22]) );
  TBUF_X1 S3_ALU_Y_tri_21_ ( .A(S3_ALU_n276), .EN(S3_ALU_n12), .Z(
        S3_ALU_OUT[21]) );
  TBUF_X1 S3_ALU_Y_tri_20_ ( .A(S3_ALU_n277), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[20]) );
  TBUF_X1 S3_ALU_Y_tri_19_ ( .A(S3_ALU_n278), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[19]) );
  TBUF_X1 S3_ALU_Y_tri_18_ ( .A(S3_ALU_n279), .EN(S3_ALU_n12), .Z(
        S3_ALU_OUT[18]) );
  TBUF_X1 S3_ALU_Y_tri_17_ ( .A(S3_ALU_n280), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[17]) );
  TBUF_X1 S3_ALU_Y_tri_16_ ( .A(S3_ALU_n281), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[16]) );
  TBUF_X1 S3_ALU_Y_tri_15_ ( .A(S3_ALU_n282), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[15]) );
  TBUF_X1 S3_ALU_Y_tri_14_ ( .A(S3_ALU_n283), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[14]) );
  TBUF_X1 S3_ALU_Y_tri_13_ ( .A(S3_ALU_n284), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[13]) );
  TBUF_X1 S3_ALU_Y_tri_12_ ( .A(S3_ALU_n285), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[12]) );
  TBUF_X1 S3_ALU_Y_tri_11_ ( .A(S3_ALU_n286), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[11]) );
  TBUF_X1 S3_ALU_Y_tri_10_ ( .A(S3_ALU_n287), .EN(S3_ALU_n13), .Z(
        S3_ALU_OUT[10]) );
  TBUF_X1 S3_ALU_Y_tri_9_ ( .A(S3_ALU_n288), .EN(S3_ALU_n12), .Z(S3_ALU_OUT[9]) );
  TBUF_X1 S3_ALU_Y_tri_8_ ( .A(S3_ALU_n290), .EN(S3_ALU_n14), .Z(S3_ALU_OUT[8]) );
  TBUF_X1 S3_ALU_Y_tri_7_ ( .A(S3_ALU_n291), .EN(S3_ALU_n12), .Z(S3_ALU_OUT[7]) );
  TBUF_X1 S3_ALU_Y_tri_6_ ( .A(S3_ALU_n292), .EN(S3_ALU_n14), .Z(S3_ALU_OUT[6]) );
  TBUF_X1 S3_ALU_Y_tri_5_ ( .A(S3_ALU_n293), .EN(S3_ALU_n12), .Z(S3_ALU_OUT[5]) );
  TBUF_X1 S3_ALU_Y_tri_4_ ( .A(S3_ALU_n294), .EN(S3_ALU_n14), .Z(S3_ALU_OUT[4]) );
  TBUF_X1 S3_ALU_Y_tri_3_ ( .A(S3_ALU_n295), .EN(S3_ALU_n12), .Z(S3_ALU_OUT[3]) );
  TBUF_X1 S3_ALU_Y_tri_2_ ( .A(S3_ALU_n296), .EN(S3_ALU_n14), .Z(S3_ALU_OUT[2]) );
  TBUF_X1 S3_ALU_Y_tri_1_ ( .A(S3_ALU_n297), .EN(S3_ALU_n12), .Z(S3_ALU_OUT[1]) );
  TBUF_X1 S3_ALU_Y_tri_0_ ( .A(S3_ALU_n298), .EN(S3_ALU_n13), .Z(S3_ALU_OUT[0]) );
  NAND3_X1 S3_ALU_U277 ( .A1(DP_ALU_OPCODE[2]), .A2(S3_ALU_n315), .A3(
        DP_ALU_OPCODE[0]), .ZN(S3_ALU_n231) );
  NAND3_X1 S3_ALU_U258 ( .A1(S3_ALU_n316), .A2(S3_ALU_n315), .A3(S3_ALU_n259), 
        .ZN(S3_ALU_n230) );
  NAND3_X1 S3_ALU_U254 ( .A1(DP_ALU_OPCODE[1]), .A2(S3_ALU_n259), .A3(
        DP_ALU_OPCODE[0]), .ZN(S3_ALU_n39) );
  NAND3_X1 S3_ALU_U242 ( .A1(S3_ALU_n315), .A2(S3_ALU_n312), .A3(S3_ALU_n250), 
        .ZN(S3_ALU_n249) );
  NAND3_X1 S3_ALU_U228 ( .A1(S3_ALU_n230), .A2(S3_ALU_n96), .A3(S3_ALU_n265), 
        .ZN(S3_ALU_n229) );
  NAND3_X1 S3_ALU_U219 ( .A1(S3_ALU_n217), .A2(S3_ALU_n218), .A3(S3_ALU_n219), 
        .ZN(S3_ALU_n287) );
  NAND3_X1 S3_ALU_U212 ( .A1(S3_ALU_n211), .A2(S3_ALU_n212), .A3(S3_ALU_n213), 
        .ZN(S3_ALU_n286) );
  NAND3_X1 S3_ALU_U205 ( .A1(S3_ALU_n205), .A2(S3_ALU_n206), .A3(S3_ALU_n207), 
        .ZN(S3_ALU_n285) );
  NAND3_X1 S3_ALU_U198 ( .A1(S3_ALU_n199), .A2(S3_ALU_n200), .A3(S3_ALU_n201), 
        .ZN(S3_ALU_n284) );
  NAND3_X1 S3_ALU_U191 ( .A1(S3_ALU_n193), .A2(S3_ALU_n194), .A3(S3_ALU_n195), 
        .ZN(S3_ALU_n283) );
  NAND3_X1 S3_ALU_U184 ( .A1(S3_ALU_n187), .A2(S3_ALU_n188), .A3(S3_ALU_n189), 
        .ZN(S3_ALU_n282) );
  NAND3_X1 S3_ALU_U177 ( .A1(S3_ALU_n181), .A2(S3_ALU_n182), .A3(S3_ALU_n183), 
        .ZN(S3_ALU_n281) );
  NAND3_X1 S3_ALU_U170 ( .A1(S3_ALU_n175), .A2(S3_ALU_n176), .A3(S3_ALU_n177), 
        .ZN(S3_ALU_n280) );
  NAND3_X1 S3_ALU_U163 ( .A1(S3_ALU_n169), .A2(S3_ALU_n170), .A3(S3_ALU_n171), 
        .ZN(S3_ALU_n279) );
  NAND3_X1 S3_ALU_U156 ( .A1(S3_ALU_n163), .A2(S3_ALU_n164), .A3(S3_ALU_n165), 
        .ZN(S3_ALU_n278) );
  NAND3_X1 S3_ALU_U149 ( .A1(S3_ALU_n157), .A2(S3_ALU_n158), .A3(S3_ALU_n159), 
        .ZN(S3_ALU_n297) );
  NAND3_X1 S3_ALU_U142 ( .A1(S3_ALU_n151), .A2(S3_ALU_n152), .A3(S3_ALU_n153), 
        .ZN(S3_ALU_n277) );
  NAND3_X1 S3_ALU_U135 ( .A1(S3_ALU_n145), .A2(S3_ALU_n146), .A3(S3_ALU_n147), 
        .ZN(S3_ALU_n276) );
  NAND3_X1 S3_ALU_U128 ( .A1(S3_ALU_n139), .A2(S3_ALU_n140), .A3(S3_ALU_n141), 
        .ZN(S3_ALU_n275) );
  NAND3_X1 S3_ALU_U121 ( .A1(S3_ALU_n133), .A2(S3_ALU_n134), .A3(S3_ALU_n135), 
        .ZN(S3_ALU_n274) );
  NAND3_X1 S3_ALU_U114 ( .A1(S3_ALU_n127), .A2(S3_ALU_n128), .A3(S3_ALU_n129), 
        .ZN(S3_ALU_n273) );
  NAND3_X1 S3_ALU_U107 ( .A1(S3_ALU_n121), .A2(S3_ALU_n122), .A3(S3_ALU_n123), 
        .ZN(S3_ALU_n272) );
  NAND3_X1 S3_ALU_U100 ( .A1(S3_ALU_n115), .A2(S3_ALU_n116), .A3(S3_ALU_n117), 
        .ZN(S3_ALU_n271) );
  NAND3_X1 S3_ALU_U93 ( .A1(S3_ALU_n109), .A2(S3_ALU_n110), .A3(S3_ALU_n111), 
        .ZN(S3_ALU_n270) );
  NAND3_X1 S3_ALU_U86 ( .A1(S3_ALU_n103), .A2(S3_ALU_n104), .A3(S3_ALU_n105), 
        .ZN(S3_ALU_n269) );
  NAND3_X1 S3_ALU_U79 ( .A1(S3_ALU_n97), .A2(S3_ALU_n98), .A3(S3_ALU_n99), 
        .ZN(S3_ALU_n268) );
  NAND3_X1 S3_ALU_U72 ( .A1(S3_ALU_n91), .A2(S3_ALU_n92), .A3(S3_ALU_n93), 
        .ZN(S3_ALU_n296) );
  NAND3_X1 S3_ALU_U65 ( .A1(S3_ALU_n85), .A2(S3_ALU_n86), .A3(S3_ALU_n87), 
        .ZN(S3_ALU_n267) );
  NAND3_X1 S3_ALU_U58 ( .A1(S3_ALU_n79), .A2(S3_ALU_n80), .A3(S3_ALU_n81), 
        .ZN(S3_ALU_n266) );
  NAND3_X1 S3_ALU_U51 ( .A1(S3_ALU_n73), .A2(S3_ALU_n74), .A3(S3_ALU_n75), 
        .ZN(S3_ALU_n295) );
  NAND3_X1 S3_ALU_U44 ( .A1(S3_ALU_n67), .A2(S3_ALU_n68), .A3(S3_ALU_n69), 
        .ZN(S3_ALU_n294) );
  NAND3_X1 S3_ALU_U37 ( .A1(S3_ALU_n61), .A2(S3_ALU_n62), .A3(S3_ALU_n63), 
        .ZN(S3_ALU_n293) );
  NAND3_X1 S3_ALU_U30 ( .A1(S3_ALU_n55), .A2(S3_ALU_n56), .A3(S3_ALU_n57), 
        .ZN(S3_ALU_n292) );
  NAND3_X1 S3_ALU_U23 ( .A1(S3_ALU_n49), .A2(S3_ALU_n50), .A3(S3_ALU_n51), 
        .ZN(S3_ALU_n291) );
  NAND3_X1 S3_ALU_U16 ( .A1(S3_ALU_n43), .A2(S3_ALU_n44), .A3(S3_ALU_n45), 
        .ZN(S3_ALU_n290) );
  NAND3_X1 S3_ALU_U3 ( .A1(S3_ALU_n29), .A2(S3_ALU_n30), .A3(S3_ALU_n31), .ZN(
        S3_ALU_n288) );
  TBUF_X2 S3_ALU_LEFT_RIGHT_shftr_tri ( .A(S3_ALU_n312), .EN(S3_ALU_n265), .Z(
        S3_ALU_LEFT_RIGHT_shftr) );
  MUX2_X1 S3_ALU_shifter_U699 ( .A(S3_ALU_shifter_n616), .B(
        S3_ALU_shifter_n615), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_N46)
         );
  MUX2_X1 S3_ALU_shifter_U698 ( .A(S3_ALU_shifter_n614), .B(
        S3_ALU_shifter_n613), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n616)
         );
  MUX2_X1 S3_ALU_shifter_U697 ( .A(S3_ALU_shifter_n612), .B(
        S3_ALU_shifter_n115), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N45)
         );
  MUX2_X1 S3_ALU_shifter_U696 ( .A(S3_ALU_shifter_n610), .B(
        S3_ALU_shifter_n609), .S(S3_MUX_B_OUT[3]), .Z(S3_ALU_shifter_n612) );
  MUX2_X1 S3_ALU_shifter_U695 ( .A(S3_ALU_shifter_n608), .B(
        S3_ALU_shifter_n607), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N44)
         );
  MUX2_X1 S3_ALU_shifter_U694 ( .A(S3_ALU_shifter_n606), .B(
        S3_ALU_shifter_n605), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n608)
         );
  MUX2_X1 S3_ALU_shifter_U693 ( .A(S3_ALU_shifter_n604), .B(
        S3_ALU_shifter_n603), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n606)
         );
  MUX2_X1 S3_ALU_shifter_U692 ( .A(S3_ALU_shifter_n602), .B(
        S3_ALU_shifter_n601), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N43)
         );
  MUX2_X1 S3_ALU_shifter_U691 ( .A(S3_ALU_shifter_n600), .B(
        S3_ALU_shifter_n599), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n602)
         );
  MUX2_X1 S3_ALU_shifter_U690 ( .A(S3_ALU_shifter_n598), .B(
        S3_ALU_shifter_n597), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n600)
         );
  MUX2_X1 S3_ALU_shifter_U689 ( .A(S3_ALU_shifter_n596), .B(
        S3_ALU_shifter_n595), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N42)
         );
  MUX2_X1 S3_ALU_shifter_U688 ( .A(S3_ALU_shifter_n594), .B(
        S3_ALU_shifter_n593), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n596)
         );
  MUX2_X1 S3_ALU_shifter_U687 ( .A(S3_ALU_shifter_n592), .B(
        S3_ALU_shifter_n591), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n594)
         );
  MUX2_X1 S3_ALU_shifter_U686 ( .A(S3_ALU_shifter_n590), .B(
        S3_ALU_shifter_n589), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N41)
         );
  MUX2_X1 S3_ALU_shifter_U685 ( .A(S3_ALU_shifter_n588), .B(
        S3_ALU_shifter_n587), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n590)
         );
  MUX2_X1 S3_ALU_shifter_U684 ( .A(S3_ALU_shifter_n586), .B(
        S3_ALU_shifter_n585), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n588)
         );
  MUX2_X1 S3_ALU_shifter_U683 ( .A(S3_ALU_shifter_n584), .B(S3_ALU_shifter_n92), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N40) );
  MUX2_X1 S3_ALU_shifter_U682 ( .A(S3_ALU_shifter_n582), .B(
        S3_ALU_shifter_n581), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n584)
         );
  MUX2_X1 S3_ALU_shifter_U681 ( .A(S3_ALU_shifter_n580), .B(
        S3_ALU_shifter_n604), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n582)
         );
  MUX2_X1 S3_ALU_shifter_U680 ( .A(S3_ALU_shifter_n579), .B(
        S3_ALU_shifter_n578), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n604)
         );
  MUX2_X1 S3_ALU_shifter_U679 ( .A(S3_ALU_shifter_n577), .B(
        S3_ALU_shifter_n576), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n580)
         );
  MUX2_X1 S3_ALU_shifter_U678 ( .A(S3_ALU_shifter_n573), .B(
        S3_ALU_shifter_n128), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N39)
         );
  MUX2_X1 S3_ALU_shifter_U677 ( .A(S3_ALU_shifter_n571), .B(
        S3_ALU_shifter_n570), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n573)
         );
  MUX2_X1 S3_ALU_shifter_U676 ( .A(S3_ALU_shifter_n569), .B(
        S3_ALU_shifter_n598), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n571)
         );
  MUX2_X1 S3_ALU_shifter_U675 ( .A(S3_ALU_shifter_n568), .B(
        S3_ALU_shifter_n567), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n598)
         );
  MUX2_X1 S3_ALU_shifter_U674 ( .A(S3_ALU_shifter_n566), .B(
        S3_ALU_shifter_n565), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n569)
         );
  MUX2_X1 S3_ALU_shifter_U673 ( .A(S3_ALU_shifter_n558), .B(
        S3_ALU_shifter_n557), .S(S3_ALU_shifter_n41), .Z(S3_ALU_shifter_n607)
         );
  MUX2_X1 S3_ALU_shifter_U672 ( .A(S3_ALU_shifter_n556), .B(
        S3_ALU_shifter_n555), .S(S3_ALU_shifter_n41), .Z(S3_ALU_shifter_n601)
         );
  MUX2_X1 S3_ALU_shifter_U671 ( .A(S3_ALU_shifter_n554), .B(
        S3_ALU_shifter_n553), .S(S3_ALU_shifter_n41), .Z(S3_ALU_shifter_n595)
         );
  MUX2_X1 S3_ALU_shifter_U670 ( .A(S3_ALU_shifter_n552), .B(
        S3_ALU_shifter_n551), .S(S3_ALU_shifter_n41), .Z(S3_ALU_shifter_n589)
         );
  MUX2_X1 S3_ALU_shifter_U669 ( .A(S3_ALU_shifter_n550), .B(
        S3_ALU_shifter_n106), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N38)
         );
  MUX2_X1 S3_ALU_shifter_U668 ( .A(S3_ALU_shifter_n548), .B(
        S3_ALU_shifter_n614), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n550)
         );
  MUX2_X1 S3_ALU_shifter_U667 ( .A(S3_ALU_shifter_n591), .B(
        S3_ALU_shifter_n547), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n614)
         );
  MUX2_X1 S3_ALU_shifter_U666 ( .A(S3_ALU_shifter_n578), .B(
        S3_ALU_shifter_n546), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n591)
         );
  MUX2_X1 S3_ALU_shifter_U665 ( .A(S3_MUX_A_OUT[9]), .B(S3_MUX_A_OUT[10]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n578) );
  MUX2_X1 S3_ALU_shifter_U664 ( .A(S3_ALU_shifter_n545), .B(
        S3_ALU_shifter_n592), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n548)
         );
  MUX2_X1 S3_ALU_shifter_U663 ( .A(S3_ALU_shifter_n576), .B(
        S3_ALU_shifter_n579), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n592)
         );
  MUX2_X1 S3_ALU_shifter_U662 ( .A(S3_MUX_A_OUT[7]), .B(S3_MUX_A_OUT[8]), .S(
        S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n579) );
  MUX2_X1 S3_ALU_shifter_U661 ( .A(S3_MUX_A_OUT[5]), .B(S3_MUX_A_OUT[6]), .S(
        S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n576) );
  MUX2_X1 S3_ALU_shifter_U660 ( .A(S3_ALU_shifter_n544), .B(
        S3_ALU_shifter_n577), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n545)
         );
  MUX2_X1 S3_ALU_shifter_U659 ( .A(S3_MUX_A_OUT[4]), .B(S3_MUX_A_OUT[3]), .S(
        S3_ALU_shifter_n18), .Z(S3_ALU_shifter_n577) );
  MUX2_X1 S3_ALU_shifter_U658 ( .A(S3_MUX_A_OUT[1]), .B(S3_MUX_A_OUT[2]), .S(
        S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n544) );
  MUX2_X1 S3_ALU_shifter_U657 ( .A(S3_ALU_shifter_n168), .B(
        S3_ALU_shifter_n543), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n583)
         );
  MUX2_X1 S3_ALU_shifter_U656 ( .A(S3_ALU_shifter_n172), .B(
        S3_ALU_shifter_n541), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n572)
         );
  MUX2_X1 S3_ALU_shifter_U655 ( .A(S3_ALU_shifter_n176), .B(
        S3_ALU_shifter_n560), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n549)
         );
  MUX2_X1 S3_ALU_shifter_U654 ( .A(S3_ALU_shifter_n163), .B(
        S3_ALU_shifter_n539), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n560)
         );
  MUX2_X1 S3_ALU_shifter_U653 ( .A(S3_ALU_shifter_n537), .B(
        S3_ALU_shifter_n536), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n613)
         );
  MUX2_X1 S3_ALU_shifter_U652 ( .A(S3_ALU_shifter_n534), .B(S3_ALU_shifter_n94), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N52) );
  MUX2_X1 S3_ALU_shifter_U651 ( .A(S3_ALU_shifter_n605), .B(
        S3_ALU_shifter_n557), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n534)
         );
  MUX2_X1 S3_ALU_shifter_U650 ( .A(S3_ALU_shifter_n532), .B(
        S3_ALU_shifter_n531), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n557)
         );
  MUX2_X1 S3_ALU_shifter_U649 ( .A(S3_ALU_shifter_n530), .B(
        S3_ALU_shifter_n529), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n605)
         );
  MUX2_X1 S3_ALU_shifter_U648 ( .A(S3_ALU_shifter_n528), .B(
        S3_ALU_shifter_n130), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_N51)
         );
  MUX2_X1 S3_ALU_shifter_U647 ( .A(S3_ALU_shifter_n599), .B(
        S3_ALU_shifter_n555), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n528)
         );
  MUX2_X1 S3_ALU_shifter_U646 ( .A(S3_ALU_shifter_n526), .B(
        S3_ALU_shifter_n525), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n555)
         );
  MUX2_X1 S3_ALU_shifter_U645 ( .A(S3_ALU_shifter_n524), .B(
        S3_ALU_shifter_n523), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n599)
         );
  MUX2_X1 S3_ALU_shifter_U644 ( .A(S3_ALU_shifter_n522), .B(S3_ALU_shifter_n99), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N50) );
  MUX2_X1 S3_ALU_shifter_U643 ( .A(S3_ALU_shifter_n159), .B(
        S3_ALU_shifter_n521), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n539)
         );
  MUX2_X1 S3_ALU_shifter_U642 ( .A(S3_ALU_shifter_n593), .B(
        S3_ALU_shifter_n553), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n522)
         );
  MUX2_X1 S3_ALU_shifter_U641 ( .A(S3_ALU_shifter_n536), .B(
        S3_ALU_shifter_n538), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n553)
         );
  MUX2_X1 S3_ALU_shifter_U640 ( .A(S3_ALU_shifter_n519), .B(
        S3_ALU_shifter_n518), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n538)
         );
  MUX2_X1 S3_ALU_shifter_U639 ( .A(S3_ALU_shifter_n517), .B(
        S3_ALU_shifter_n516), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n536)
         );
  MUX2_X1 S3_ALU_shifter_U638 ( .A(S3_ALU_shifter_n547), .B(
        S3_ALU_shifter_n537), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n593)
         );
  MUX2_X1 S3_ALU_shifter_U637 ( .A(S3_ALU_shifter_n515), .B(
        S3_ALU_shifter_n514), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n537)
         );
  MUX2_X1 S3_ALU_shifter_U636 ( .A(S3_ALU_shifter_n513), .B(
        S3_ALU_shifter_n512), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n547)
         );
  MUX2_X1 S3_ALU_shifter_U635 ( .A(S3_ALU_shifter_n511), .B(
        S3_ALU_shifter_n117), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N49)
         );
  MUX2_X1 S3_ALU_shifter_U634 ( .A(S3_ALU_shifter_n587), .B(
        S3_ALU_shifter_n551), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n511)
         );
  MUX2_X1 S3_ALU_shifter_U633 ( .A(S3_ALU_shifter_n509), .B(
        S3_ALU_shifter_n508), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n551)
         );
  MUX2_X1 S3_ALU_shifter_U632 ( .A(S3_ALU_shifter_n507), .B(
        S3_ALU_shifter_n506), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n587)
         );
  MUX2_X1 S3_ALU_shifter_U631 ( .A(S3_ALU_shifter_n505), .B(
        S3_ALU_shifter_n562), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N48)
         );
  MUX2_X1 S3_ALU_shifter_U630 ( .A(S3_ALU_shifter_n158), .B(
        S3_ALU_shifter_n533), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n543)
         );
  MUX2_X1 S3_ALU_shifter_U629 ( .A(S3_ALU_shifter_n518), .B(
        S3_ALU_shifter_n520), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n531)
         );
  MUX2_X1 S3_ALU_shifter_U628 ( .A(S3_MUX_A_OUT[29]), .B(S3_MUX_A_OUT[30]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n520) );
  MUX2_X1 S3_ALU_shifter_U627 ( .A(S3_MUX_A_OUT[27]), .B(S3_MUX_A_OUT[28]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n518) );
  MUX2_X1 S3_ALU_shifter_U626 ( .A(S3_ALU_shifter_n581), .B(
        S3_ALU_shifter_n542), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n505)
         );
  MUX2_X1 S3_ALU_shifter_U625 ( .A(S3_ALU_shifter_n529), .B(
        S3_ALU_shifter_n532), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n542)
         );
  MUX2_X1 S3_ALU_shifter_U624 ( .A(S3_ALU_shifter_n516), .B(
        S3_ALU_shifter_n519), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n532)
         );
  MUX2_X1 S3_ALU_shifter_U623 ( .A(S3_MUX_A_OUT[25]), .B(S3_MUX_A_OUT[26]), 
        .S(S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n519) );
  MUX2_X1 S3_ALU_shifter_U622 ( .A(S3_MUX_A_OUT[23]), .B(S3_MUX_A_OUT[24]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n516) );
  MUX2_X1 S3_ALU_shifter_U621 ( .A(S3_ALU_shifter_n514), .B(
        S3_ALU_shifter_n517), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n529)
         );
  MUX2_X1 S3_ALU_shifter_U620 ( .A(S3_MUX_A_OUT[21]), .B(S3_MUX_A_OUT[22]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n517) );
  MUX2_X1 S3_ALU_shifter_U619 ( .A(S3_MUX_A_OUT[19]), .B(S3_MUX_A_OUT[20]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n514) );
  MUX2_X1 S3_ALU_shifter_U618 ( .A(S3_ALU_shifter_n603), .B(
        S3_ALU_shifter_n530), .S(S3_ALU_shifter_n28), .Z(S3_ALU_shifter_n581)
         );
  MUX2_X1 S3_ALU_shifter_U617 ( .A(S3_ALU_shifter_n512), .B(
        S3_ALU_shifter_n515), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n530)
         );
  MUX2_X1 S3_ALU_shifter_U616 ( .A(S3_MUX_A_OUT[17]), .B(S3_MUX_A_OUT[18]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n515) );
  MUX2_X1 S3_ALU_shifter_U615 ( .A(S3_MUX_A_OUT[15]), .B(S3_MUX_A_OUT[16]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n512) );
  MUX2_X1 S3_ALU_shifter_U614 ( .A(S3_ALU_shifter_n546), .B(
        S3_ALU_shifter_n513), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n603)
         );
  MUX2_X1 S3_ALU_shifter_U613 ( .A(S3_MUX_A_OUT[13]), .B(S3_MUX_A_OUT[14]), 
        .S(S3_ALU_n150), .Z(S3_ALU_shifter_n513) );
  MUX2_X1 S3_ALU_shifter_U612 ( .A(S3_MUX_A_OUT[11]), .B(S3_MUX_A_OUT[12]), 
        .S(S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n546) );
  MUX2_X1 S3_ALU_shifter_U611 ( .A(S3_ALU_shifter_n504), .B(
        S3_ALU_shifter_n561), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N47)
         );
  MUX2_X1 S3_ALU_shifter_U610 ( .A(S3_ALU_shifter_n161), .B(
        S3_ALU_shifter_n527), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n541)
         );
  MUX2_X1 S3_ALU_shifter_U609 ( .A(S3_ALU_shifter_n502), .B(
        S3_ALU_shifter_n501), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n525)
         );
  MUX2_X1 S3_ALU_shifter_U608 ( .A(S3_ALU_shifter_n570), .B(
        S3_ALU_shifter_n540), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n504)
         );
  MUX2_X1 S3_ALU_shifter_U607 ( .A(S3_ALU_shifter_n523), .B(
        S3_ALU_shifter_n526), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n540)
         );
  MUX2_X1 S3_ALU_shifter_U606 ( .A(S3_ALU_shifter_n500), .B(
        S3_ALU_shifter_n499), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n526)
         );
  MUX2_X1 S3_ALU_shifter_U605 ( .A(S3_ALU_shifter_n498), .B(
        S3_ALU_shifter_n497), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n523)
         );
  MUX2_X1 S3_ALU_shifter_U604 ( .A(S3_ALU_shifter_n597), .B(
        S3_ALU_shifter_n524), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n570)
         );
  MUX2_X1 S3_ALU_shifter_U603 ( .A(S3_ALU_shifter_n496), .B(
        S3_ALU_shifter_n495), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n524)
         );
  MUX2_X1 S3_ALU_shifter_U602 ( .A(S3_ALU_shifter_n494), .B(
        S3_ALU_shifter_n493), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n597)
         );
  MUX2_X1 S3_ALU_shifter_U601 ( .A(S3_ALU_shifter_n492), .B(
        S3_ALU_shifter_n535), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N37)
         );
  MUX2_X1 S3_ALU_shifter_U600 ( .A(S3_ALU_shifter_n609), .B(
        S3_ALU_shifter_n559), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n535)
         );
  MUX2_X1 S3_ALU_shifter_U599 ( .A(S3_ALU_shifter_n508), .B(
        S3_ALU_shifter_n510), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n559)
         );
  MUX2_X1 S3_ALU_shifter_U598 ( .A(S3_ALU_shifter_n501), .B(
        S3_ALU_shifter_n503), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n510)
         );
  MUX2_X1 S3_ALU_shifter_U597 ( .A(S3_MUX_A_OUT[30]), .B(S3_ALU_shifter_n2), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n503) );
  MUX2_X1 S3_ALU_shifter_U596 ( .A(S3_MUX_A_OUT[28]), .B(S3_MUX_A_OUT[29]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n501) );
  MUX2_X1 S3_ALU_shifter_U595 ( .A(S3_ALU_shifter_n499), .B(
        S3_ALU_shifter_n502), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n508)
         );
  MUX2_X1 S3_ALU_shifter_U594 ( .A(S3_MUX_A_OUT[26]), .B(S3_MUX_A_OUT[27]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n502) );
  MUX2_X1 S3_ALU_shifter_U593 ( .A(S3_MUX_A_OUT[24]), .B(S3_MUX_A_OUT[25]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n499) );
  MUX2_X1 S3_ALU_shifter_U592 ( .A(S3_ALU_shifter_n506), .B(
        S3_ALU_shifter_n509), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n609)
         );
  MUX2_X1 S3_ALU_shifter_U591 ( .A(S3_ALU_shifter_n497), .B(
        S3_ALU_shifter_n500), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n509)
         );
  MUX2_X1 S3_ALU_shifter_U590 ( .A(S3_MUX_A_OUT[22]), .B(S3_MUX_A_OUT[23]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n500) );
  MUX2_X1 S3_ALU_shifter_U589 ( .A(S3_MUX_A_OUT[20]), .B(S3_MUX_A_OUT[21]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n497) );
  MUX2_X1 S3_ALU_shifter_U588 ( .A(S3_ALU_shifter_n495), .B(
        S3_ALU_shifter_n498), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n506)
         );
  MUX2_X1 S3_ALU_shifter_U587 ( .A(S3_MUX_A_OUT[18]), .B(S3_MUX_A_OUT[19]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n498) );
  MUX2_X1 S3_ALU_shifter_U586 ( .A(S3_MUX_A_OUT[16]), .B(S3_MUX_A_OUT[17]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n495) );
  MUX2_X1 S3_ALU_shifter_U585 ( .A(S3_ALU_shifter_n491), .B(
        S3_ALU_shifter_n610), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n492)
         );
  MUX2_X1 S3_ALU_shifter_U584 ( .A(S3_ALU_shifter_n585), .B(
        S3_ALU_shifter_n507), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n610)
         );
  MUX2_X1 S3_ALU_shifter_U583 ( .A(S3_ALU_shifter_n493), .B(
        S3_ALU_shifter_n496), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n507)
         );
  MUX2_X1 S3_ALU_shifter_U582 ( .A(S3_MUX_A_OUT[14]), .B(S3_MUX_A_OUT[15]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n496) );
  MUX2_X1 S3_ALU_shifter_U581 ( .A(S3_MUX_A_OUT[12]), .B(S3_MUX_A_OUT[13]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n493) );
  MUX2_X1 S3_ALU_shifter_U580 ( .A(S3_ALU_shifter_n567), .B(
        S3_ALU_shifter_n494), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n585)
         );
  MUX2_X1 S3_ALU_shifter_U579 ( .A(S3_MUX_A_OUT[10]), .B(S3_MUX_A_OUT[11]), 
        .S(S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n494) );
  MUX2_X1 S3_ALU_shifter_U578 ( .A(S3_MUX_A_OUT[8]), .B(S3_MUX_A_OUT[9]), .S(
        S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n567) );
  MUX2_X1 S3_ALU_shifter_U577 ( .A(S3_ALU_shifter_n490), .B(
        S3_ALU_shifter_n586), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n491)
         );
  MUX2_X1 S3_ALU_shifter_U576 ( .A(S3_ALU_shifter_n565), .B(
        S3_ALU_shifter_n568), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n586)
         );
  MUX2_X1 S3_ALU_shifter_U575 ( .A(S3_MUX_A_OUT[6]), .B(S3_MUX_A_OUT[7]), .S(
        S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n568) );
  MUX2_X1 S3_ALU_shifter_U574 ( .A(S3_MUX_A_OUT[4]), .B(S3_MUX_A_OUT[5]), .S(
        S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n565) );
  MUX2_X1 S3_ALU_shifter_U573 ( .A(S3_ALU_shifter_n489), .B(
        S3_ALU_shifter_n566), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n490)
         );
  MUX2_X1 S3_ALU_shifter_U572 ( .A(S3_MUX_A_OUT[3]), .B(S3_MUX_A_OUT[2]), .S(
        S3_ALU_shifter_n18), .Z(S3_ALU_shifter_n566) );
  MUX2_X1 S3_ALU_shifter_U571 ( .A(S3_MUX_A_OUT[0]), .B(S3_MUX_A_OUT[1]), .S(
        S3_ALU_shifter_n15), .Z(S3_ALU_shifter_n489) );
  MUX2_X1 S3_ALU_shifter_U570 ( .A(S3_ALU_shifter_n488), .B(
        S3_ALU_shifter_n487), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N14)
         );
  MUX2_X1 S3_ALU_shifter_U569 ( .A(S3_ALU_shifter_n486), .B(
        S3_ALU_shifter_n485), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n488)
         );
  MUX2_X1 S3_ALU_shifter_U568 ( .A(S3_ALU_shifter_n484), .B(
        S3_ALU_shifter_n483), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N13)
         );
  MUX2_X1 S3_ALU_shifter_U567 ( .A(S3_ALU_shifter_n482), .B(
        S3_ALU_shifter_n481), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n484)
         );
  MUX2_X1 S3_ALU_shifter_U566 ( .A(S3_ALU_shifter_n480), .B(
        S3_ALU_shifter_n479), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N12)
         );
  MUX2_X1 S3_ALU_shifter_U565 ( .A(S3_ALU_shifter_n478), .B(
        S3_ALU_shifter_n477), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n480)
         );
  MUX2_X1 S3_ALU_shifter_U564 ( .A(S3_ALU_shifter_n476), .B(
        S3_ALU_shifter_n475), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n478)
         );
  MUX2_X1 S3_ALU_shifter_U563 ( .A(S3_ALU_shifter_n474), .B(
        S3_ALU_shifter_n473), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N11)
         );
  MUX2_X1 S3_ALU_shifter_U562 ( .A(S3_ALU_shifter_n472), .B(
        S3_ALU_shifter_n471), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n474)
         );
  MUX2_X1 S3_ALU_shifter_U561 ( .A(S3_ALU_shifter_n470), .B(
        S3_ALU_shifter_n469), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n472)
         );
  MUX2_X1 S3_ALU_shifter_U560 ( .A(S3_ALU_shifter_n468), .B(
        S3_ALU_shifter_n467), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N10)
         );
  MUX2_X1 S3_ALU_shifter_U559 ( .A(S3_ALU_shifter_n466), .B(
        S3_ALU_shifter_n465), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n468)
         );
  MUX2_X1 S3_ALU_shifter_U558 ( .A(S3_ALU_shifter_n464), .B(
        S3_ALU_shifter_n463), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n466)
         );
  MUX2_X1 S3_ALU_shifter_U557 ( .A(S3_ALU_shifter_n462), .B(
        S3_ALU_shifter_n461), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N9) );
  MUX2_X1 S3_ALU_shifter_U556 ( .A(S3_ALU_shifter_n460), .B(
        S3_ALU_shifter_n459), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n462)
         );
  MUX2_X1 S3_ALU_shifter_U555 ( .A(S3_ALU_shifter_n458), .B(
        S3_ALU_shifter_n457), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n460)
         );
  MUX2_X1 S3_ALU_shifter_U554 ( .A(S3_ALU_shifter_n456), .B(
        S3_ALU_shifter_n455), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N8) );
  MUX2_X1 S3_ALU_shifter_U553 ( .A(S3_ALU_shifter_n454), .B(
        S3_ALU_shifter_n453), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n456)
         );
  MUX2_X1 S3_ALU_shifter_U552 ( .A(S3_ALU_shifter_n452), .B(
        S3_ALU_shifter_n476), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n454)
         );
  MUX2_X1 S3_ALU_shifter_U551 ( .A(S3_ALU_shifter_n451), .B(
        S3_ALU_shifter_n450), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n476)
         );
  MUX2_X1 S3_ALU_shifter_U550 ( .A(S3_ALU_shifter_n449), .B(
        S3_ALU_shifter_n448), .S(S3_ALU_shifter_n26), .Z(S3_ALU_shifter_n452)
         );
  MUX2_X1 S3_ALU_shifter_U549 ( .A(S3_ALU_shifter_n445), .B(
        S3_ALU_shifter_n143), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N7) );
  MUX2_X1 S3_ALU_shifter_U548 ( .A(S3_ALU_shifter_n443), .B(
        S3_ALU_shifter_n442), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n445)
         );
  MUX2_X1 S3_ALU_shifter_U547 ( .A(S3_ALU_shifter_n441), .B(
        S3_ALU_shifter_n470), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n443)
         );
  MUX2_X1 S3_ALU_shifter_U546 ( .A(S3_ALU_shifter_n440), .B(
        S3_ALU_shifter_n439), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n470)
         );
  MUX2_X1 S3_ALU_shifter_U545 ( .A(S3_ALU_shifter_n438), .B(
        S3_ALU_shifter_n437), .S(S3_ALU_shifter_n26), .Z(S3_ALU_shifter_n441)
         );
  MUX2_X1 S3_ALU_shifter_U544 ( .A(S3_ALU_shifter_n429), .B(
        S3_ALU_shifter_n428), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n473)
         );
  MUX2_X1 S3_ALU_shifter_U543 ( .A(S3_ALU_shifter_n427), .B(
        S3_ALU_shifter_n426), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n467)
         );
  MUX2_X1 S3_ALU_shifter_U542 ( .A(S3_ALU_shifter_n425), .B(
        S3_ALU_shifter_n424), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n461)
         );
  MUX2_X1 S3_ALU_shifter_U541 ( .A(S3_ALU_shifter_n423), .B(
        S3_ALU_shifter_n150), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N6) );
  MUX2_X1 S3_ALU_shifter_U540 ( .A(S3_ALU_shifter_n421), .B(
        S3_ALU_shifter_n486), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n423)
         );
  MUX2_X1 S3_ALU_shifter_U539 ( .A(S3_ALU_shifter_n463), .B(
        S3_ALU_shifter_n420), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n486)
         );
  MUX2_X1 S3_ALU_shifter_U538 ( .A(S3_ALU_shifter_n450), .B(
        S3_ALU_shifter_n419), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n463)
         );
  MUX2_X1 S3_ALU_shifter_U537 ( .A(S3_MUX_A_OUT[9]), .B(S3_MUX_A_OUT[10]), .S(
        S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n450) );
  MUX2_X1 S3_ALU_shifter_U536 ( .A(S3_ALU_shifter_n418), .B(
        S3_ALU_shifter_n464), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n421)
         );
  MUX2_X1 S3_ALU_shifter_U535 ( .A(S3_ALU_shifter_n451), .B(
        S3_ALU_shifter_n449), .S(S3_ALU_shifter_n26), .Z(S3_ALU_shifter_n464)
         );
  MUX2_X1 S3_ALU_shifter_U534 ( .A(S3_MUX_A_OUT[5]), .B(S3_MUX_A_OUT[6]), .S(
        S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n449) );
  MUX2_X1 S3_ALU_shifter_U533 ( .A(S3_MUX_A_OUT[7]), .B(S3_MUX_A_OUT[8]), .S(
        S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n451) );
  MUX2_X1 S3_ALU_shifter_U532 ( .A(S3_ALU_shifter_n448), .B(
        S3_ALU_shifter_n417), .S(S3_ALU_shifter_n26), .Z(S3_ALU_shifter_n418)
         );
  MUX2_X1 S3_ALU_shifter_U531 ( .A(S3_MUX_A_OUT[1]), .B(S3_MUX_A_OUT[2]), .S(
        S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n417) );
  MUX2_X1 S3_ALU_shifter_U530 ( .A(S3_MUX_A_OUT[3]), .B(S3_MUX_A_OUT[4]), .S(
        S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n448) );
  MUX2_X1 S3_ALU_shifter_U529 ( .A(S3_ALU_shifter_n416), .B(
        S3_ALU_shifter_n415), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n455)
         );
  MUX2_X1 S3_ALU_shifter_U528 ( .A(S3_ALU_shifter_n171), .B(
        S3_ALU_shifter_n414), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n444)
         );
  MUX2_X1 S3_ALU_shifter_U527 ( .A(S3_ALU_shifter_n175), .B(
        S3_ALU_shifter_n432), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n422)
         );
  MUX2_X1 S3_ALU_shifter_U526 ( .A(S3_ALU_shifter_n162), .B(
        S3_ALU_shifter_n412), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n432)
         );
  MUX2_X1 S3_ALU_shifter_U525 ( .A(S3_ALU_shifter_n410), .B(
        S3_ALU_shifter_n409), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n485)
         );
  MUX2_X1 S3_ALU_shifter_U524 ( .A(S3_ALU_shifter_n183), .B(
        S3_ALU_shifter_n157), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n407)
         );
  MUX2_X1 S3_ALU_shifter_U523 ( .A(S3_ALU_shifter_n405), .B(
        S3_ALU_shifter_n404), .S(S3_ALU_shifter_n29), .Z(S3_ALU_shifter_n406)
         );
  MUX2_X1 S3_ALU_shifter_U522 ( .A(S3_ALU_shifter_n403), .B(
        S3_ALU_shifter_n402), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n477)
         );
  MUX2_X1 S3_ALU_shifter_U521 ( .A(S3_ALU_shifter_n401), .B(
        S3_ALU_shifter_n446), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N19)
         );
  MUX2_X1 S3_ALU_shifter_U520 ( .A(S3_ALU_shifter_n471), .B(
        S3_ALU_shifter_n429), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n401)
         );
  MUX2_X1 S3_ALU_shifter_U519 ( .A(S3_ALU_shifter_n398), .B(
        S3_ALU_shifter_n397), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n429)
         );
  MUX2_X1 S3_ALU_shifter_U518 ( .A(S3_ALU_shifter_n396), .B(
        S3_ALU_shifter_n395), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n471)
         );
  MUX2_X1 S3_ALU_shifter_U517 ( .A(S3_ALU_shifter_n394), .B(
        S3_ALU_shifter_n436), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N18)
         );
  MUX2_X1 S3_ALU_shifter_U516 ( .A(S3_ALU_shifter_n465), .B(
        S3_ALU_shifter_n427), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n394)
         );
  MUX2_X1 S3_ALU_shifter_U515 ( .A(S3_ALU_shifter_n409), .B(
        S3_ALU_shifter_n411), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n427)
         );
  MUX2_X1 S3_ALU_shifter_U514 ( .A(S3_ALU_shifter_n391), .B(
        S3_ALU_shifter_n390), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n411)
         );
  MUX2_X1 S3_ALU_shifter_U513 ( .A(S3_ALU_shifter_n389), .B(
        S3_ALU_shifter_n388), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n409)
         );
  MUX2_X1 S3_ALU_shifter_U512 ( .A(S3_ALU_shifter_n420), .B(
        S3_ALU_shifter_n410), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n465)
         );
  MUX2_X1 S3_ALU_shifter_U511 ( .A(S3_ALU_shifter_n387), .B(
        S3_ALU_shifter_n386), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n410)
         );
  MUX2_X1 S3_ALU_shifter_U510 ( .A(S3_ALU_shifter_n385), .B(
        S3_ALU_shifter_n384), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n420)
         );
  MUX2_X1 S3_ALU_shifter_U509 ( .A(S3_ALU_shifter_n383), .B(
        S3_ALU_shifter_n435), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N17)
         );
  MUX2_X1 S3_ALU_shifter_U508 ( .A(S3_ALU_shifter_n459), .B(
        S3_ALU_shifter_n425), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n383)
         );
  MUX2_X1 S3_ALU_shifter_U507 ( .A(S3_ALU_shifter_n381), .B(
        S3_ALU_shifter_n380), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n425)
         );
  MUX2_X1 S3_ALU_shifter_U506 ( .A(S3_ALU_shifter_n379), .B(
        S3_ALU_shifter_n378), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n459)
         );
  MUX2_X1 S3_ALU_shifter_U505 ( .A(S3_ALU_shifter_n377), .B(
        S3_ALU_shifter_n434), .S(S3_ALU_shifter_n80), .Z(S3_ALU_shifter_N16)
         );
  MUX2_X1 S3_ALU_shifter_U504 ( .A(S3_ALU_shifter_n390), .B(
        S3_ALU_shifter_n393), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n404)
         );
  MUX2_X1 S3_ALU_shifter_U503 ( .A(S3_MUX_A_OUT[29]), .B(S3_MUX_A_OUT[30]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n393) );
  MUX2_X1 S3_ALU_shifter_U502 ( .A(S3_MUX_A_OUT[27]), .B(S3_MUX_A_OUT[28]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n390) );
  MUX2_X1 S3_ALU_shifter_U501 ( .A(S3_ALU_shifter_n453), .B(
        S3_ALU_shifter_n416), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n377)
         );
  MUX2_X1 S3_ALU_shifter_U500 ( .A(S3_ALU_shifter_n402), .B(
        S3_ALU_shifter_n405), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n416)
         );
  MUX2_X1 S3_ALU_shifter_U499 ( .A(S3_ALU_shifter_n388), .B(
        S3_ALU_shifter_n391), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n405)
         );
  MUX2_X1 S3_ALU_shifter_U498 ( .A(S3_MUX_A_OUT[25]), .B(S3_MUX_A_OUT[26]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n391) );
  MUX2_X1 S3_ALU_shifter_U497 ( .A(S3_MUX_A_OUT[23]), .B(S3_MUX_A_OUT[24]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n388) );
  MUX2_X1 S3_ALU_shifter_U496 ( .A(S3_ALU_shifter_n386), .B(
        S3_ALU_shifter_n389), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n402)
         );
  MUX2_X1 S3_ALU_shifter_U495 ( .A(S3_MUX_A_OUT[21]), .B(S3_MUX_A_OUT[22]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n389) );
  MUX2_X1 S3_ALU_shifter_U494 ( .A(S3_MUX_A_OUT[19]), .B(S3_MUX_A_OUT[20]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n386) );
  MUX2_X1 S3_ALU_shifter_U493 ( .A(S3_ALU_shifter_n475), .B(
        S3_ALU_shifter_n403), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n453)
         );
  MUX2_X1 S3_ALU_shifter_U492 ( .A(S3_ALU_shifter_n384), .B(
        S3_ALU_shifter_n387), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n403)
         );
  MUX2_X1 S3_ALU_shifter_U491 ( .A(S3_MUX_A_OUT[17]), .B(S3_MUX_A_OUT[18]), 
        .S(S3_ALU_shifter_n14), .Z(S3_ALU_shifter_n387) );
  MUX2_X1 S3_ALU_shifter_U490 ( .A(S3_MUX_A_OUT[15]), .B(S3_MUX_A_OUT[16]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n384) );
  MUX2_X1 S3_ALU_shifter_U489 ( .A(S3_ALU_shifter_n419), .B(
        S3_ALU_shifter_n385), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n475)
         );
  MUX2_X1 S3_ALU_shifter_U488 ( .A(S3_MUX_A_OUT[13]), .B(S3_MUX_A_OUT[14]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n385) );
  MUX2_X1 S3_ALU_shifter_U487 ( .A(S3_MUX_A_OUT[11]), .B(S3_MUX_A_OUT[12]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n419) );
  MUX2_X1 S3_ALU_shifter_U486 ( .A(S3_ALU_shifter_n376), .B(
        S3_ALU_shifter_n433), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_N15)
         );
  MUX2_X1 S3_ALU_shifter_U485 ( .A(S3_ALU_shifter_n160), .B(
        S3_ALU_shifter_n400), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n414)
         );
  MUX2_X1 S3_ALU_shifter_U484 ( .A(S3_ALU_shifter_n374), .B(
        S3_ALU_shifter_n373), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n397)
         );
  MUX2_X1 S3_ALU_shifter_U483 ( .A(S3_ALU_shifter_n442), .B(
        S3_ALU_shifter_n413), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n376)
         );
  MUX2_X1 S3_ALU_shifter_U482 ( .A(S3_ALU_shifter_n395), .B(
        S3_ALU_shifter_n398), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n413)
         );
  MUX2_X1 S3_ALU_shifter_U481 ( .A(S3_ALU_shifter_n372), .B(
        S3_ALU_shifter_n371), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n398)
         );
  MUX2_X1 S3_ALU_shifter_U480 ( .A(S3_ALU_shifter_n370), .B(
        S3_ALU_shifter_n369), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n395)
         );
  MUX2_X1 S3_ALU_shifter_U479 ( .A(S3_ALU_shifter_n469), .B(
        S3_ALU_shifter_n396), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n442)
         );
  MUX2_X1 S3_ALU_shifter_U478 ( .A(S3_ALU_shifter_n368), .B(
        S3_ALU_shifter_n367), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n396)
         );
  MUX2_X1 S3_ALU_shifter_U477 ( .A(S3_ALU_shifter_n366), .B(
        S3_ALU_shifter_n365), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n469)
         );
  MUX2_X1 S3_ALU_shifter_U476 ( .A(S3_ALU_shifter_n364), .B(
        S3_ALU_shifter_n408), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_N5) );
  MUX2_X1 S3_ALU_shifter_U475 ( .A(S3_ALU_shifter_n481), .B(
        S3_ALU_shifter_n430), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n408)
         );
  MUX2_X1 S3_ALU_shifter_U474 ( .A(S3_ALU_shifter_n380), .B(
        S3_ALU_shifter_n382), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n430)
         );
  MUX2_X1 S3_ALU_shifter_U473 ( .A(S3_ALU_shifter_n373), .B(
        S3_ALU_shifter_n375), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n382)
         );
  MUX2_X1 S3_ALU_shifter_U472 ( .A(S3_MUX_A_OUT[30]), .B(S3_ALU_shifter_n2), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n375) );
  MUX2_X1 S3_ALU_shifter_U471 ( .A(S3_MUX_A_OUT[28]), .B(S3_MUX_A_OUT[29]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n373) );
  MUX2_X1 S3_ALU_shifter_U470 ( .A(S3_ALU_shifter_n371), .B(
        S3_ALU_shifter_n374), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n380)
         );
  MUX2_X1 S3_ALU_shifter_U469 ( .A(S3_MUX_A_OUT[26]), .B(S3_MUX_A_OUT[27]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n374) );
  MUX2_X1 S3_ALU_shifter_U468 ( .A(S3_MUX_A_OUT[24]), .B(S3_MUX_A_OUT[25]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n371) );
  MUX2_X1 S3_ALU_shifter_U467 ( .A(S3_ALU_shifter_n378), .B(
        S3_ALU_shifter_n381), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n481)
         );
  MUX2_X1 S3_ALU_shifter_U466 ( .A(S3_ALU_shifter_n369), .B(
        S3_ALU_shifter_n372), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n381)
         );
  MUX2_X1 S3_ALU_shifter_U465 ( .A(S3_MUX_A_OUT[22]), .B(S3_MUX_A_OUT[23]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n372) );
  MUX2_X1 S3_ALU_shifter_U464 ( .A(S3_MUX_A_OUT[20]), .B(S3_MUX_A_OUT[21]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n369) );
  MUX2_X1 S3_ALU_shifter_U463 ( .A(S3_ALU_shifter_n367), .B(
        S3_ALU_shifter_n370), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n378)
         );
  MUX2_X1 S3_ALU_shifter_U462 ( .A(S3_MUX_A_OUT[18]), .B(S3_MUX_A_OUT[19]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n370) );
  MUX2_X1 S3_ALU_shifter_U461 ( .A(S3_MUX_A_OUT[16]), .B(S3_MUX_A_OUT[17]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n367) );
  MUX2_X1 S3_ALU_shifter_U460 ( .A(S3_ALU_shifter_n363), .B(
        S3_ALU_shifter_n482), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n364)
         );
  MUX2_X1 S3_ALU_shifter_U459 ( .A(S3_ALU_shifter_n457), .B(
        S3_ALU_shifter_n379), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n482)
         );
  MUX2_X1 S3_ALU_shifter_U458 ( .A(S3_ALU_shifter_n365), .B(
        S3_ALU_shifter_n368), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n379)
         );
  MUX2_X1 S3_ALU_shifter_U457 ( .A(S3_MUX_A_OUT[14]), .B(S3_MUX_A_OUT[15]), 
        .S(S3_ALU_shifter_n13), .Z(S3_ALU_shifter_n368) );
  MUX2_X1 S3_ALU_shifter_U456 ( .A(S3_MUX_A_OUT[12]), .B(S3_MUX_A_OUT[13]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n365) );
  MUX2_X1 S3_ALU_shifter_U455 ( .A(S3_ALU_shifter_n439), .B(
        S3_ALU_shifter_n366), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n457)
         );
  MUX2_X1 S3_ALU_shifter_U454 ( .A(S3_MUX_A_OUT[10]), .B(S3_MUX_A_OUT[11]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n366) );
  MUX2_X1 S3_ALU_shifter_U453 ( .A(S3_MUX_A_OUT[8]), .B(S3_MUX_A_OUT[9]), .S(
        S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n439) );
  MUX2_X1 S3_ALU_shifter_U452 ( .A(S3_ALU_shifter_n362), .B(
        S3_ALU_shifter_n458), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n363)
         );
  MUX2_X1 S3_ALU_shifter_U451 ( .A(S3_ALU_shifter_n440), .B(
        S3_ALU_shifter_n438), .S(S3_ALU_shifter_n26), .Z(S3_ALU_shifter_n458)
         );
  MUX2_X1 S3_ALU_shifter_U450 ( .A(S3_MUX_A_OUT[4]), .B(S3_MUX_A_OUT[5]), .S(
        S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n438) );
  MUX2_X1 S3_ALU_shifter_U449 ( .A(S3_MUX_A_OUT[6]), .B(S3_MUX_A_OUT[7]), .S(
        S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n440) );
  MUX2_X1 S3_ALU_shifter_U448 ( .A(S3_ALU_shifter_n437), .B(
        S3_ALU_shifter_n361), .S(S3_ALU_shifter_n26), .Z(S3_ALU_shifter_n362)
         );
  MUX2_X1 S3_ALU_shifter_U447 ( .A(S3_MUX_A_OUT[0]), .B(S3_MUX_A_OUT[1]), .S(
        S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n361) );
  MUX2_X1 S3_ALU_shifter_U446 ( .A(S3_MUX_A_OUT[2]), .B(S3_MUX_A_OUT[3]), .S(
        S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n437) );
  MUX2_X1 S3_ALU_shifter_U445 ( .A(S3_ALU_shifter_n353), .B(
        S3_ALU_shifter_n198), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_N197)
         );
  MUX2_X1 S3_ALU_shifter_U444 ( .A(S3_ALU_shifter_n351), .B(
        S3_ALU_shifter_n178), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n353)
         );
  MUX2_X1 S3_ALU_shifter_U443 ( .A(S3_ALU_shifter_n349), .B(
        S3_ALU_shifter_n348), .S(S3_ALU_shifter_n30), .Z(S3_ALU_shifter_n351)
         );
  MUX2_X1 S3_ALU_shifter_U442 ( .A(S3_ALU_shifter_n347), .B(
        S3_ALU_shifter_n346), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n349)
         );
  MUX2_X1 S3_ALU_shifter_U441 ( .A(S3_ALU_shifter_n2), .B(S3_MUX_A_OUT[30]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n347) );
  MUX2_X1 S3_ALU_shifter_U440 ( .A(S3_ALU_shifter_n345), .B(
        S3_ALU_shifter_n200), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_N196)
         );
  MUX2_X1 S3_ALU_shifter_U439 ( .A(S3_ALU_shifter_n343), .B(
        S3_ALU_shifter_n181), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n345)
         );
  MUX2_X1 S3_ALU_shifter_U438 ( .A(S3_ALU_shifter_n341), .B(
        S3_ALU_shifter_n340), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n343)
         );
  MUX2_X1 S3_ALU_shifter_U437 ( .A(S3_ALU_shifter_n339), .B(
        S3_ALU_shifter_n338), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n341)
         );
  MUX2_X1 S3_ALU_shifter_U436 ( .A(S3_MUX_A_OUT[30]), .B(S3_MUX_A_OUT[29]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n339) );
  MUX2_X1 S3_ALU_shifter_U435 ( .A(S3_ALU_shifter_n336), .B(
        S3_ALU_shifter_n202), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_N195)
         );
  MUX2_X1 S3_ALU_shifter_U434 ( .A(S3_ALU_shifter_n334), .B(
        S3_ALU_shifter_n185), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n336)
         );
  MUX2_X1 S3_ALU_shifter_U433 ( .A(S3_ALU_shifter_n332), .B(
        S3_ALU_shifter_n331), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n334)
         );
  MUX2_X1 S3_ALU_shifter_U432 ( .A(S3_ALU_shifter_n346), .B(
        S3_ALU_shifter_n330), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n332)
         );
  MUX2_X1 S3_ALU_shifter_U431 ( .A(S3_MUX_A_OUT[28]), .B(S3_MUX_A_OUT[29]), 
        .S(S3_ALU_shifter_n18), .Z(S3_ALU_shifter_n346) );
  MUX2_X1 S3_ALU_shifter_U430 ( .A(S3_ALU_shifter_n329), .B(
        S3_ALU_shifter_n204), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_N194)
         );
  MUX2_X1 S3_ALU_shifter_U429 ( .A(S3_ALU_shifter_n327), .B(
        S3_ALU_shifter_n188), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n329)
         );
  MUX2_X1 S3_ALU_shifter_U428 ( .A(S3_ALU_shifter_n325), .B(
        S3_ALU_shifter_n324), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n327)
         );
  MUX2_X1 S3_ALU_shifter_U427 ( .A(S3_ALU_shifter_n338), .B(
        S3_ALU_shifter_n323), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n325)
         );
  MUX2_X1 S3_ALU_shifter_U426 ( .A(S3_MUX_A_OUT[27]), .B(S3_MUX_A_OUT[28]), 
        .S(S3_ALU_shifter_n18), .Z(S3_ALU_shifter_n338) );
  MUX2_X1 S3_ALU_shifter_U425 ( .A(S3_ALU_shifter_n321), .B(
        S3_ALU_shifter_n320), .S(S3_ALU_shifter_n81), .Z(S3_ALU_shifter_n322)
         );
  MUX2_X1 S3_ALU_shifter_U424 ( .A(S3_ALU_shifter_n165), .B(
        S3_ALU_shifter_n319), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n321)
         );
  MUX2_X1 S3_ALU_shifter_U423 ( .A(S3_ALU_shifter_n348), .B(
        S3_ALU_shifter_n317), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n318)
         );
  MUX2_X1 S3_ALU_shifter_U422 ( .A(S3_ALU_shifter_n330), .B(
        S3_ALU_shifter_n316), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n348)
         );
  MUX2_X1 S3_ALU_shifter_U421 ( .A(S3_MUX_A_OUT[27]), .B(S3_MUX_A_OUT[26]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n330) );
  MUX2_X1 S3_ALU_shifter_U420 ( .A(S3_ALU_shifter_n314), .B(
        S3_ALU_shifter_n313), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n315)
         );
  MUX2_X1 S3_ALU_shifter_U419 ( .A(S3_ALU_shifter_n167), .B(
        S3_ALU_shifter_n312), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n314)
         );
  MUX2_X1 S3_ALU_shifter_U418 ( .A(S3_ALU_shifter_n340), .B(
        S3_ALU_shifter_n310), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n311)
         );
  MUX2_X1 S3_ALU_shifter_U417 ( .A(S3_ALU_shifter_n323), .B(
        S3_ALU_shifter_n309), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n340)
         );
  MUX2_X1 S3_ALU_shifter_U416 ( .A(S3_MUX_A_OUT[26]), .B(S3_MUX_A_OUT[25]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n323) );
  MUX2_X1 S3_ALU_shifter_U415 ( .A(S3_ALU_shifter_n307), .B(
        S3_ALU_shifter_n360), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n308)
         );
  MUX2_X1 S3_ALU_shifter_U414 ( .A(S3_ALU_shifter_n218), .B(
        S3_ALU_shifter_n306), .S(S3_ALU_shifter_n41), .Z(S3_ALU_shifter_n360)
         );
  MUX2_X1 S3_ALU_shifter_U413 ( .A(S3_ALU_shifter_n170), .B(
        S3_ALU_shifter_n304), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n307)
         );
  MUX2_X1 S3_ALU_shifter_U412 ( .A(S3_ALU_shifter_n331), .B(
        S3_ALU_shifter_n302), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n303)
         );
  MUX2_X1 S3_ALU_shifter_U411 ( .A(S3_ALU_shifter_n316), .B(
        S3_ALU_shifter_n301), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n331)
         );
  MUX2_X1 S3_ALU_shifter_U410 ( .A(S3_MUX_A_OUT[25]), .B(S3_MUX_A_OUT[24]), 
        .S(S3_ALU_shifter_n12), .Z(S3_ALU_shifter_n316) );
  MUX2_X1 S3_ALU_shifter_U409 ( .A(S3_ALU_shifter_n299), .B(
        S3_ALU_shifter_n359), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n300)
         );
  MUX2_X1 S3_ALU_shifter_U408 ( .A(S3_ALU_shifter_n219), .B(
        S3_ALU_shifter_n298), .S(S3_ALU_shifter_n41), .Z(S3_ALU_shifter_n359)
         );
  MUX2_X1 S3_ALU_shifter_U407 ( .A(S3_ALU_shifter_n174), .B(
        S3_ALU_shifter_n296), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n299)
         );
  MUX2_X1 S3_ALU_shifter_U406 ( .A(S3_ALU_shifter_n324), .B(
        S3_ALU_shifter_n294), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n295)
         );
  MUX2_X1 S3_ALU_shifter_U405 ( .A(S3_ALU_shifter_n309), .B(
        S3_ALU_shifter_n293), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n324)
         );
  MUX2_X1 S3_ALU_shifter_U404 ( .A(S3_MUX_A_OUT[24]), .B(S3_MUX_A_OUT[23]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n309) );
  MUX2_X1 S3_ALU_shifter_U403 ( .A(S3_ALU_shifter_n291), .B(
        S3_ALU_shifter_n358), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n292)
         );
  MUX2_X1 S3_ALU_shifter_U402 ( .A(S3_ALU_shifter_n350), .B(
        S3_ALU_shifter_n289), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n291)
         );
  MUX2_X1 S3_ALU_shifter_U401 ( .A(S3_ALU_shifter_n179), .B(
        S3_ALU_shifter_n288), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n350)
         );
  MUX2_X1 S3_ALU_shifter_U400 ( .A(S3_ALU_shifter_n301), .B(
        S3_ALU_shifter_n287), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n317)
         );
  MUX2_X1 S3_ALU_shifter_U399 ( .A(S3_MUX_A_OUT[23]), .B(S3_MUX_A_OUT[22]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n301) );
  MUX2_X1 S3_ALU_shifter_U398 ( .A(S3_ALU_shifter_n285), .B(
        S3_ALU_shifter_n357), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n286)
         );
  MUX2_X1 S3_ALU_shifter_U397 ( .A(S3_ALU_shifter_n342), .B(
        S3_ALU_shifter_n283), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n285)
         );
  MUX2_X1 S3_ALU_shifter_U396 ( .A(S3_ALU_shifter_n182), .B(
        S3_ALU_shifter_n282), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n342)
         );
  MUX2_X1 S3_ALU_shifter_U395 ( .A(S3_ALU_shifter_n293), .B(
        S3_ALU_shifter_n281), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n310)
         );
  MUX2_X1 S3_ALU_shifter_U394 ( .A(S3_MUX_A_OUT[22]), .B(S3_MUX_A_OUT[21]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n293) );
  MUX2_X1 S3_ALU_shifter_U393 ( .A(S3_ALU_shifter_n279), .B(
        S3_ALU_shifter_n356), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n280)
         );
  MUX2_X1 S3_ALU_shifter_U392 ( .A(S3_ALU_shifter_n333), .B(
        S3_ALU_shifter_n277), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n279)
         );
  MUX2_X1 S3_ALU_shifter_U391 ( .A(S3_ALU_shifter_n186), .B(
        S3_ALU_shifter_n276), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n333)
         );
  MUX2_X1 S3_ALU_shifter_U390 ( .A(S3_ALU_shifter_n287), .B(
        S3_ALU_shifter_n275), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n302)
         );
  MUX2_X1 S3_ALU_shifter_U389 ( .A(S3_MUX_A_OUT[21]), .B(S3_MUX_A_OUT[20]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n287) );
  MUX2_X1 S3_ALU_shifter_U388 ( .A(S3_ALU_shifter_n273), .B(
        S3_ALU_shifter_n355), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n274)
         );
  MUX2_X1 S3_ALU_shifter_U387 ( .A(S3_ALU_shifter_n326), .B(
        S3_ALU_shifter_n271), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n273)
         );
  MUX2_X1 S3_ALU_shifter_U386 ( .A(S3_ALU_shifter_n189), .B(
        S3_ALU_shifter_n270), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n326)
         );
  MUX2_X1 S3_ALU_shifter_U385 ( .A(S3_ALU_shifter_n281), .B(
        S3_ALU_shifter_n269), .S(S3_MUX_B_OUT[1]), .Z(S3_ALU_shifter_n294) );
  MUX2_X1 S3_ALU_shifter_U384 ( .A(S3_MUX_A_OUT[20]), .B(S3_MUX_A_OUT[19]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n281) );
  MUX2_X1 S3_ALU_shifter_U383 ( .A(S3_ALU_shifter_n266), .B(
        S3_ALU_shifter_n354), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n267)
         );
  MUX2_X1 S3_ALU_shifter_U382 ( .A(S3_ALU_shifter_n319), .B(
        S3_ALU_shifter_n207), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n266)
         );
  MUX2_X1 S3_ALU_shifter_U381 ( .A(S3_ALU_shifter_n288), .B(
        S3_ALU_shifter_n264), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n319)
         );
  MUX2_X1 S3_ALU_shifter_U380 ( .A(S3_ALU_shifter_n191), .B(
        S3_ALU_shifter_n263), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n288)
         );
  MUX2_X1 S3_ALU_shifter_U379 ( .A(S3_MUX_A_OUT[19]), .B(S3_MUX_A_OUT[18]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n275) );
  MUX2_X1 S3_ALU_shifter_U378 ( .A(S3_ALU_shifter_n261), .B(
        S3_ALU_shifter_n337), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n262)
         );
  MUX2_X1 S3_ALU_shifter_U377 ( .A(S3_ALU_shifter_n312), .B(
        S3_ALU_shifter_n259), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n261)
         );
  MUX2_X1 S3_ALU_shifter_U376 ( .A(S3_ALU_shifter_n282), .B(
        S3_ALU_shifter_n258), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n312)
         );
  MUX2_X1 S3_ALU_shifter_U375 ( .A(S3_ALU_shifter_n193), .B(
        S3_ALU_shifter_n257), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n282)
         );
  MUX2_X1 S3_ALU_shifter_U374 ( .A(S3_MUX_A_OUT[18]), .B(S3_MUX_A_OUT[17]), 
        .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n269) );
  MUX2_X1 S3_ALU_shifter_U373 ( .A(S3_ALU_shifter_n255), .B(
        S3_ALU_shifter_n268), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n256)
         );
  MUX2_X1 S3_ALU_shifter_U372 ( .A(S3_ALU_shifter_n304), .B(
        S3_ALU_shifter_n306), .S(S3_MUX_B_OUT[3]), .Z(S3_ALU_shifter_n255) );
  MUX2_X1 S3_ALU_shifter_U371 ( .A(S3_ALU_shifter_n211), .B(
        S3_ALU_shifter_n215), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n306)
         );
  MUX2_X1 S3_ALU_shifter_U370 ( .A(S3_ALU_shifter_n276), .B(
        S3_ALU_shifter_n253), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n304)
         );
  MUX2_X1 S3_ALU_shifter_U369 ( .A(S3_ALU_shifter_n263), .B(
        S3_ALU_shifter_n252), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n276)
         );
  MUX2_X1 S3_ALU_shifter_U368 ( .A(S3_ALU_shifter_n195), .B(
        S3_ALU_shifter_n197), .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n263)
         );
  MUX2_X1 S3_ALU_shifter_U367 ( .A(S3_ALU_shifter_n250), .B(
        S3_ALU_shifter_n249), .S(S3_ALU_shifter_n79), .Z(S3_ALU_shifter_n251)
         );
  MUX2_X1 S3_ALU_shifter_U366 ( .A(S3_ALU_shifter_n296), .B(
        S3_ALU_shifter_n298), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n250)
         );
  MUX2_X1 S3_ALU_shifter_U365 ( .A(S3_ALU_shifter_n248), .B(
        S3_ALU_shifter_n247), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n298)
         );
  MUX2_X1 S3_ALU_shifter_U364 ( .A(S3_ALU_shifter_n270), .B(
        S3_ALU_shifter_n246), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n296)
         );
  MUX2_X1 S3_ALU_shifter_U363 ( .A(S3_ALU_shifter_n257), .B(
        S3_ALU_shifter_n245), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n270)
         );
  MUX2_X1 S3_ALU_shifter_U362 ( .A(S3_ALU_shifter_n197), .B(
        S3_ALU_shifter_n199), .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n257)
         );
  MUX2_X1 S3_ALU_shifter_U361 ( .A(S3_ALU_shifter_n289), .B(
        S3_ALU_shifter_n213), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n352)
         );
  MUX2_X1 S3_ALU_shifter_U360 ( .A(S3_ALU_shifter_n244), .B(
        S3_ALU_shifter_n243), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n290)
         );
  MUX2_X1 S3_ALU_shifter_U359 ( .A(S3_ALU_shifter_n264), .B(
        S3_ALU_shifter_n208), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n289) );
  MUX2_X1 S3_ALU_shifter_U358 ( .A(S3_ALU_shifter_n252), .B(
        S3_ALU_shifter_n241), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n264)
         );
  MUX2_X1 S3_ALU_shifter_U357 ( .A(S3_ALU_shifter_n199), .B(
        S3_ALU_shifter_n201), .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n252)
         );
  MUX2_X1 S3_ALU_shifter_U356 ( .A(S3_ALU_shifter_n283), .B(
        S3_ALU_shifter_n284), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n344)
         );
  MUX2_X1 S3_ALU_shifter_U355 ( .A(S3_ALU_shifter_n240), .B(
        S3_ALU_shifter_n239), .S(S3_ALU_shifter_n31), .Z(S3_ALU_shifter_n284)
         );
  MUX2_X1 S3_ALU_shifter_U354 ( .A(S3_ALU_shifter_n258), .B(
        S3_ALU_shifter_n238), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n283) );
  MUX2_X1 S3_ALU_shifter_U353 ( .A(S3_ALU_shifter_n245), .B(
        S3_ALU_shifter_n205), .S(S3_MUX_B_OUT[1]), .Z(S3_ALU_shifter_n258) );
  MUX2_X1 S3_ALU_shifter_U352 ( .A(S3_ALU_shifter_n201), .B(
        S3_ALU_shifter_n203), .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n245)
         );
  MUX2_X1 S3_ALU_shifter_U351 ( .A(S3_ALU_shifter_n277), .B(
        S3_ALU_shifter_n278), .S(S3_MUX_B_OUT[3]), .Z(S3_ALU_shifter_n335) );
  MUX2_X1 S3_ALU_shifter_U350 ( .A(S3_ALU_shifter_n215), .B(
        S3_ALU_shifter_n254), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n278) );
  MUX2_X1 S3_ALU_shifter_U349 ( .A(S3_ALU_shifter_n235), .B(
        S3_ALU_shifter_n234), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n236)
         );
  MUX2_X1 S3_ALU_shifter_U348 ( .A(S3_ALU_shifter_n253), .B(
        S3_ALU_shifter_n211), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n277) );
  MUX2_X1 S3_ALU_shifter_U347 ( .A(S3_ALU_shifter_n232), .B(
        S3_ALU_shifter_n231), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n233)
         );
  MUX2_X1 S3_ALU_shifter_U346 ( .A(S3_ALU_shifter_n241), .B(
        S3_ALU_shifter_n209), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n253)
         );
  MUX2_X1 S3_ALU_shifter_U345 ( .A(S3_ALU_shifter_n203), .B(
        S3_ALU_shifter_n206), .S(S3_ALU_shifter_n11), .Z(S3_ALU_shifter_n241)
         );
  MUX2_X1 S3_ALU_shifter_U344 ( .A(S3_ALU_shifter_n271), .B(
        S3_ALU_shifter_n272), .S(S3_ALU_shifter_n37), .Z(S3_ALU_shifter_n328)
         );
  MUX2_X1 S3_ALU_shifter_U343 ( .A(S3_ALU_shifter_n247), .B(
        S3_ALU_shifter_n229), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n272) );
  MUX2_X1 S3_ALU_shifter_U342 ( .A(S3_ALU_shifter_n216), .B(
        S3_ALU_shifter_n217), .S(S3_MUX_B_OUT[1]), .Z(S3_ALU_shifter_n247) );
  MUX2_X1 S3_ALU_shifter_U341 ( .A(S3_ALU_shifter_n246), .B(
        S3_ALU_shifter_n248), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n271) );
  MUX2_X1 S3_ALU_shifter_U340 ( .A(S3_ALU_shifter_n212), .B(
        S3_ALU_shifter_n214), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n248)
         );
  MUX2_X1 S3_ALU_shifter_U339 ( .A(S3_ALU_shifter_n205), .B(
        S3_ALU_shifter_n210), .S(S3_ALU_shifter_n22), .Z(S3_ALU_shifter_n246)
         );
  MUX2_X1 S3_ALU_shifter_U338 ( .A(S3_MUX_A_OUT[12]), .B(S3_MUX_A_OUT[11]), 
        .S(S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n228) );
  MUX2_X1 S3_ALU_shifter_U337 ( .A(S3_ALU_shifter_n207), .B(
        S3_ALU_shifter_n265), .S(S3_ALU_shifter_n38), .Z(S3_ALU_shifter_n320)
         );
  MUX2_X1 S3_ALU_shifter_U336 ( .A(S3_ALU_shifter_n234), .B(
        S3_ALU_shifter_n237), .S(S3_ALU_shifter_n24), .Z(S3_ALU_shifter_n243)
         );
  MUX2_X1 S3_ALU_shifter_U335 ( .A(S3_MUX_A_OUT[1]), .B(S3_MUX_A_OUT[0]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n237) );
  MUX2_X1 S3_ALU_shifter_U334 ( .A(S3_MUX_A_OUT[3]), .B(S3_MUX_A_OUT[2]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n234) );
  MUX2_X1 S3_ALU_shifter_U333 ( .A(S3_ALU_shifter_n242), .B(
        S3_ALU_shifter_n244), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n227) );
  MUX2_X1 S3_ALU_shifter_U332 ( .A(S3_ALU_shifter_n231), .B(
        S3_ALU_shifter_n235), .S(S3_ALU_shifter_n23), .Z(S3_ALU_shifter_n244)
         );
  MUX2_X1 S3_ALU_shifter_U331 ( .A(S3_MUX_A_OUT[5]), .B(S3_MUX_A_OUT[4]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n235) );
  MUX2_X1 S3_ALU_shifter_U330 ( .A(S3_MUX_A_OUT[7]), .B(S3_MUX_A_OUT[6]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n231) );
  MUX2_X1 S3_ALU_shifter_U329 ( .A(S3_ALU_shifter_n230), .B(
        S3_ALU_shifter_n232), .S(S3_ALU_shifter_n21), .Z(S3_ALU_shifter_n242)
         );
  MUX2_X1 S3_ALU_shifter_U328 ( .A(S3_MUX_A_OUT[9]), .B(S3_MUX_A_OUT[8]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n232) );
  MUX2_X1 S3_ALU_shifter_U327 ( .A(S3_MUX_A_OUT[11]), .B(S3_MUX_A_OUT[10]), 
        .S(S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n230) );
  MUX2_X1 S3_ALU_shifter_U326 ( .A(S3_ALU_shifter_n259), .B(
        S3_ALU_shifter_n260), .S(S3_ALU_shifter_n36), .Z(S3_ALU_shifter_n313)
         );
  MUX2_X1 S3_ALU_shifter_U325 ( .A(S3_ALU_shifter_n217), .B(
        S3_ALU_shifter_n226), .S(S3_ALU_shifter_n20), .Z(S3_ALU_shifter_n239)
         );
  MUX2_X1 S3_ALU_shifter_U324 ( .A(S3_MUX_A_OUT[2]), .B(S3_MUX_A_OUT[1]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n225) );
  MUX2_X1 S3_ALU_shifter_U323 ( .A(S3_ALU_shifter_n238), .B(
        S3_ALU_shifter_n240), .S(S3_MUX_B_OUT[2]), .Z(S3_ALU_shifter_n259) );
  MUX2_X1 S3_ALU_shifter_U322 ( .A(S3_ALU_shifter_n214), .B(
        S3_ALU_shifter_n216), .S(S3_MUX_B_OUT[1]), .Z(S3_ALU_shifter_n240) );
  MUX2_X1 S3_ALU_shifter_U321 ( .A(S3_MUX_A_OUT[4]), .B(S3_MUX_A_OUT[3]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n224) );
  MUX2_X1 S3_ALU_shifter_U320 ( .A(S3_MUX_A_OUT[6]), .B(S3_MUX_A_OUT[5]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n223) );
  MUX2_X1 S3_ALU_shifter_U319 ( .A(S3_ALU_shifter_n210), .B(
        S3_ALU_shifter_n212), .S(S3_MUX_B_OUT[1]), .Z(S3_ALU_shifter_n238) );
  MUX2_X1 S3_ALU_shifter_U318 ( .A(S3_MUX_A_OUT[8]), .B(S3_MUX_A_OUT[7]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n222) );
  MUX2_X1 S3_ALU_shifter_U317 ( .A(S3_MUX_A_OUT[10]), .B(S3_MUX_A_OUT[9]), .S(
        S3_ALU_shifter_n10), .Z(S3_ALU_shifter_n221) );
  INV_X1 S3_ALU_shifter_U316 ( .A(S3_ALU_LOGIC_ARITH_shftr), .ZN(
        S3_ALU_shifter_n220) );
  NOR2_X1 S3_ALU_shifter_U315 ( .A1(S3_ALU_shifter_n220), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .ZN(S3_ALU_shifter_n42) );
  AOI222_X1 S3_ALU_shifter_U314 ( .A1(S3_ALU_shifter_N166), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N5), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N37), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n73) );
  INV_X1 S3_ALU_shifter_U313 ( .A(S3_ALU_shifter_n73), .ZN(
        S3_ALU_RESULT_shftr[0]) );
  AOI222_X1 S3_ALU_shifter_U312 ( .A1(S3_ALU_shifter_N167), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N6), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N38), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n62) );
  INV_X1 S3_ALU_shifter_U311 ( .A(S3_ALU_shifter_n62), .ZN(
        S3_ALU_RESULT_shftr[1]) );
  AOI222_X1 S3_ALU_shifter_U310 ( .A1(S3_ALU_shifter_N168), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N7), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N39), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n51) );
  INV_X1 S3_ALU_shifter_U309 ( .A(S3_ALU_shifter_n51), .ZN(
        S3_ALU_RESULT_shftr[2]) );
  AOI222_X1 S3_ALU_shifter_U308 ( .A1(S3_ALU_shifter_N169), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N8), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N40), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n48) );
  INV_X1 S3_ALU_shifter_U307 ( .A(S3_ALU_shifter_n48), .ZN(
        S3_ALU_RESULT_shftr[3]) );
  AOI222_X1 S3_ALU_shifter_U306 ( .A1(S3_ALU_shifter_N170), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N9), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N41), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n47) );
  INV_X1 S3_ALU_shifter_U305 ( .A(S3_ALU_shifter_n47), .ZN(
        S3_ALU_RESULT_shftr[4]) );
  AOI222_X1 S3_ALU_shifter_U304 ( .A1(S3_ALU_shifter_N171), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N10), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N42), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n46) );
  INV_X1 S3_ALU_shifter_U303 ( .A(S3_ALU_shifter_n46), .ZN(
        S3_ALU_RESULT_shftr[5]) );
  AOI222_X1 S3_ALU_shifter_U302 ( .A1(S3_ALU_shifter_N172), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N11), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N43), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n45) );
  INV_X1 S3_ALU_shifter_U301 ( .A(S3_ALU_shifter_n45), .ZN(
        S3_ALU_RESULT_shftr[6]) );
  AOI222_X1 S3_ALU_shifter_U300 ( .A1(S3_ALU_shifter_N173), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N12), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N44), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n44) );
  INV_X1 S3_ALU_shifter_U299 ( .A(S3_ALU_shifter_n44), .ZN(
        S3_ALU_RESULT_shftr[7]) );
  AOI222_X1 S3_ALU_shifter_U298 ( .A1(S3_ALU_shifter_N174), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N13), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N45), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n43) );
  INV_X1 S3_ALU_shifter_U297 ( .A(S3_ALU_shifter_n43), .ZN(
        S3_ALU_RESULT_shftr[8]) );
  AOI222_X1 S3_ALU_shifter_U296 ( .A1(S3_ALU_shifter_N175), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N14), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N46), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n40) );
  INV_X1 S3_ALU_shifter_U295 ( .A(S3_ALU_shifter_n40), .ZN(
        S3_ALU_RESULT_shftr[9]) );
  AOI222_X1 S3_ALU_shifter_U294 ( .A1(S3_ALU_shifter_N176), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N15), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N47), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n72) );
  INV_X1 S3_ALU_shifter_U293 ( .A(S3_ALU_shifter_n72), .ZN(
        S3_ALU_RESULT_shftr[10]) );
  AOI222_X1 S3_ALU_shifter_U292 ( .A1(S3_ALU_shifter_N177), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N16), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N48), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n71) );
  INV_X1 S3_ALU_shifter_U291 ( .A(S3_ALU_shifter_n71), .ZN(
        S3_ALU_RESULT_shftr[11]) );
  AOI222_X1 S3_ALU_shifter_U290 ( .A1(S3_ALU_shifter_N178), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N17), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N49), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n70) );
  INV_X1 S3_ALU_shifter_U289 ( .A(S3_ALU_shifter_n70), .ZN(
        S3_ALU_RESULT_shftr[12]) );
  AOI222_X1 S3_ALU_shifter_U288 ( .A1(S3_ALU_shifter_N179), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N18), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N50), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n69) );
  INV_X1 S3_ALU_shifter_U287 ( .A(S3_ALU_shifter_n69), .ZN(
        S3_ALU_RESULT_shftr[13]) );
  AOI222_X1 S3_ALU_shifter_U286 ( .A1(S3_ALU_shifter_N180), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N19), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N51), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n68) );
  INV_X1 S3_ALU_shifter_U285 ( .A(S3_ALU_shifter_n68), .ZN(
        S3_ALU_RESULT_shftr[14]) );
  NOR2_X1 S3_ALU_shifter_U284 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n352), .ZN(S3_ALU_shifter_N181) );
  AOI222_X1 S3_ALU_shifter_U283 ( .A1(S3_ALU_shifter_N181), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N20), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N52), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n67) );
  INV_X1 S3_ALU_shifter_U282 ( .A(S3_ALU_shifter_n67), .ZN(
        S3_ALU_RESULT_shftr[15]) );
  NOR2_X1 S3_ALU_shifter_U281 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n112), .ZN(S3_ALU_shifter_N53) );
  INV_X1 S3_ALU_shifter_U280 ( .A(S3_ALU_shifter_n251), .ZN(
        S3_ALU_shifter_n196) );
  AOI222_X1 S3_ALU_shifter_U279 ( .A1(S3_ALU_shifter_n196), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N21), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N53), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n66) );
  INV_X1 S3_ALU_shifter_U278 ( .A(S3_ALU_shifter_n66), .ZN(
        S3_ALU_RESULT_shftr[16]) );
  NOR2_X1 S3_ALU_shifter_U277 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n549), .ZN(S3_ALU_shifter_N54) );
  INV_X1 S3_ALU_shifter_U276 ( .A(S3_ALU_shifter_n256), .ZN(
        S3_ALU_shifter_n194) );
  AOI222_X1 S3_ALU_shifter_U275 ( .A1(S3_ALU_shifter_n194), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N22), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N54), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n65) );
  INV_X1 S3_ALU_shifter_U274 ( .A(S3_ALU_shifter_n65), .ZN(
        S3_ALU_RESULT_shftr[17]) );
  NOR2_X1 S3_ALU_shifter_U273 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n572), .ZN(S3_ALU_shifter_N55) );
  INV_X1 S3_ALU_shifter_U272 ( .A(S3_ALU_shifter_n262), .ZN(
        S3_ALU_shifter_n192) );
  AOI222_X1 S3_ALU_shifter_U271 ( .A1(S3_ALU_shifter_n192), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N23), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N55), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n64) );
  INV_X1 S3_ALU_shifter_U270 ( .A(S3_ALU_shifter_n64), .ZN(
        S3_ALU_RESULT_shftr[18]) );
  NOR2_X1 S3_ALU_shifter_U269 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n583), .ZN(S3_ALU_shifter_N56) );
  INV_X1 S3_ALU_shifter_U268 ( .A(S3_ALU_shifter_n267), .ZN(
        S3_ALU_shifter_n190) );
  AOI222_X1 S3_ALU_shifter_U267 ( .A1(S3_ALU_shifter_n190), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N24), .B2(
        S3_ALU_shifter_n7), .C1(S3_ALU_shifter_N56), .C2(S3_ALU_shifter_n3), 
        .ZN(S3_ALU_shifter_n63) );
  INV_X1 S3_ALU_shifter_U266 ( .A(S3_ALU_shifter_n63), .ZN(
        S3_ALU_RESULT_shftr[19]) );
  NOR2_X1 S3_ALU_shifter_U265 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n120), .ZN(S3_ALU_shifter_N57) );
  INV_X1 S3_ALU_shifter_U264 ( .A(S3_ALU_shifter_n274), .ZN(
        S3_ALU_shifter_n187) );
  AOI222_X1 S3_ALU_shifter_U263 ( .A1(S3_ALU_shifter_n187), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N25), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N57), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n61) );
  INV_X1 S3_ALU_shifter_U262 ( .A(S3_ALU_shifter_n61), .ZN(
        S3_ALU_RESULT_shftr[20]) );
  NOR2_X1 S3_ALU_shifter_U261 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n102), .ZN(S3_ALU_shifter_N58) );
  INV_X1 S3_ALU_shifter_U260 ( .A(S3_ALU_shifter_n280), .ZN(
        S3_ALU_shifter_n184) );
  AOI222_X1 S3_ALU_shifter_U259 ( .A1(S3_ALU_shifter_n184), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N26), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N58), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n60) );
  INV_X1 S3_ALU_shifter_U258 ( .A(S3_ALU_shifter_n60), .ZN(
        S3_ALU_RESULT_shftr[21]) );
  NOR2_X1 S3_ALU_shifter_U257 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n133), .ZN(S3_ALU_shifter_N59) );
  INV_X1 S3_ALU_shifter_U256 ( .A(S3_ALU_shifter_n286), .ZN(
        S3_ALU_shifter_n180) );
  AOI222_X1 S3_ALU_shifter_U255 ( .A1(S3_ALU_shifter_n180), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N27), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N59), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n59) );
  INV_X1 S3_ALU_shifter_U254 ( .A(S3_ALU_shifter_n59), .ZN(
        S3_ALU_RESULT_shftr[22]) );
  NOR2_X1 S3_ALU_shifter_U253 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n96), .ZN(S3_ALU_shifter_N60) );
  INV_X1 S3_ALU_shifter_U252 ( .A(S3_ALU_shifter_n292), .ZN(
        S3_ALU_shifter_n177) );
  AOI222_X1 S3_ALU_shifter_U251 ( .A1(S3_ALU_shifter_n177), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N28), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N60), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n58) );
  INV_X1 S3_ALU_shifter_U250 ( .A(S3_ALU_shifter_n58), .ZN(
        S3_ALU_RESULT_shftr[23]) );
  NOR2_X1 S3_ALU_shifter_U249 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n611), .ZN(S3_ALU_shifter_N61) );
  INV_X1 S3_ALU_shifter_U248 ( .A(S3_ALU_shifter_n300), .ZN(
        S3_ALU_shifter_n173) );
  AOI222_X1 S3_ALU_shifter_U247 ( .A1(S3_ALU_shifter_n173), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N29), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N61), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n57) );
  INV_X1 S3_ALU_shifter_U246 ( .A(S3_ALU_shifter_n57), .ZN(
        S3_ALU_RESULT_shftr[24]) );
  NOR2_X1 S3_ALU_shifter_U245 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n108), .ZN(S3_ALU_shifter_N62) );
  INV_X1 S3_ALU_shifter_U244 ( .A(S3_ALU_shifter_n308), .ZN(
        S3_ALU_shifter_n169) );
  AOI222_X1 S3_ALU_shifter_U243 ( .A1(S3_ALU_shifter_n169), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N30), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N62), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n56) );
  INV_X1 S3_ALU_shifter_U242 ( .A(S3_ALU_shifter_n56), .ZN(
        S3_ALU_RESULT_shftr[25]) );
  NOR2_X1 S3_ALU_shifter_U241 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n125), .ZN(S3_ALU_shifter_N63) );
  INV_X1 S3_ALU_shifter_U240 ( .A(S3_ALU_shifter_n315), .ZN(
        S3_ALU_shifter_n166) );
  AOI222_X1 S3_ALU_shifter_U239 ( .A1(S3_ALU_shifter_n166), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N31), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N63), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n55) );
  INV_X1 S3_ALU_shifter_U238 ( .A(S3_ALU_shifter_n55), .ZN(
        S3_ALU_RESULT_shftr[26]) );
  NOR2_X1 S3_ALU_shifter_U237 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n89), .ZN(S3_ALU_shifter_N64) );
  INV_X1 S3_ALU_shifter_U236 ( .A(S3_ALU_shifter_n322), .ZN(
        S3_ALU_shifter_n164) );
  AOI222_X1 S3_ALU_shifter_U235 ( .A1(S3_ALU_shifter_n164), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N32), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N64), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n54) );
  INV_X1 S3_ALU_shifter_U234 ( .A(S3_ALU_shifter_n54), .ZN(
        S3_ALU_RESULT_shftr[27]) );
  NOR2_X1 S3_ALU_shifter_U233 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n563), .ZN(S3_ALU_shifter_N65) );
  AOI222_X1 S3_ALU_shifter_U232 ( .A1(S3_ALU_shifter_N194), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N33), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N65), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n53) );
  INV_X1 S3_ALU_shifter_U231 ( .A(S3_ALU_shifter_n53), .ZN(
        S3_ALU_RESULT_shftr[28]) );
  NOR2_X1 S3_ALU_shifter_U230 ( .A1(S3_ALU_shifter_n77), .A2(
        S3_ALU_shifter_n564), .ZN(S3_ALU_shifter_N66) );
  AOI222_X1 S3_ALU_shifter_U229 ( .A1(S3_ALU_shifter_N195), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N34), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N66), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n52) );
  INV_X1 S3_ALU_shifter_U228 ( .A(S3_ALU_shifter_n52), .ZN(
        S3_ALU_RESULT_shftr[29]) );
  NOR2_X1 S3_ALU_shifter_U227 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n574), .ZN(S3_ALU_shifter_N67) );
  AOI222_X1 S3_ALU_shifter_U226 ( .A1(S3_ALU_shifter_N196), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_N35), .B2(
        S3_ALU_shifter_n8), .C1(S3_ALU_shifter_N67), .C2(S3_ALU_shifter_n4), 
        .ZN(S3_ALU_shifter_n50) );
  INV_X1 S3_ALU_shifter_U225 ( .A(S3_ALU_shifter_n50), .ZN(
        S3_ALU_RESULT_shftr[30]) );
  NOR2_X1 S3_ALU_shifter_U224 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n575), .ZN(S3_ALU_shifter_N68) );
  AOI222_X1 S3_ALU_shifter_U223 ( .A1(S3_ALU_shifter_N197), .A2(
        S3_ALU_LEFT_RIGHT_shftr), .B1(S3_ALU_shifter_n2), .B2(
        S3_ALU_shifter_n9), .C1(S3_ALU_shifter_N68), .C2(S3_ALU_shifter_n5), 
        .ZN(S3_ALU_shifter_n49) );
  INV_X1 S3_ALU_shifter_U222 ( .A(S3_ALU_shifter_n49), .ZN(
        S3_ALU_RESULT_shftr[31]) );
  BUF_X1 S3_ALU_shifter_U221 ( .A(S3_ALU_shifter_n6), .Z(S3_ALU_shifter_n5) );
  BUF_X1 S3_ALU_shifter_U220 ( .A(S3_ALU_shifter_n1), .Z(S3_ALU_shifter_n9) );
  BUF_X1 S3_ALU_shifter_U219 ( .A(S3_ALU_shifter_n6), .Z(S3_ALU_shifter_n3) );
  BUF_X1 S3_ALU_shifter_U218 ( .A(S3_ALU_shifter_n6), .Z(S3_ALU_shifter_n4) );
  INV_X1 S3_ALU_shifter_U217 ( .A(S3_ALU_shifter_n222), .ZN(
        S3_ALU_shifter_n212) );
  INV_X1 S3_ALU_shifter_U216 ( .A(S3_ALU_shifter_n223), .ZN(
        S3_ALU_shifter_n214) );
  INV_X1 S3_ALU_shifter_U215 ( .A(S3_ALU_shifter_n224), .ZN(
        S3_ALU_shifter_n216) );
  INV_X1 S3_ALU_shifter_U214 ( .A(S3_ALU_shifter_n221), .ZN(
        S3_ALU_shifter_n210) );
  INV_X1 S3_ALU_shifter_U213 ( .A(S3_ALU_shifter_n228), .ZN(
        S3_ALU_shifter_n205) );
  INV_X1 S3_ALU_shifter_U212 ( .A(S3_ALU_shifter_n225), .ZN(
        S3_ALU_shifter_n217) );
  BUF_X1 S3_ALU_shifter_U211 ( .A(S3_ALU_shifter_n1), .Z(S3_ALU_shifter_n7) );
  BUF_X1 S3_ALU_shifter_U210 ( .A(S3_ALU_shifter_n1), .Z(S3_ALU_shifter_n8) );
  INV_X1 S3_ALU_shifter_U209 ( .A(S3_MUX_B_OUT[3]), .ZN(S3_ALU_shifter_n74) );
  BUF_X1 S3_ALU_shifter_U208 ( .A(S3_MUX_A_OUT[31]), .Z(S3_ALU_shifter_n2) );
  INV_X1 S3_ALU_shifter_U207 ( .A(S3_MUX_B_OUT[2]), .ZN(S3_ALU_shifter_n35) );
  INV_X1 S3_ALU_shifter_U206 ( .A(S3_ALU_n150), .ZN(S3_ALU_shifter_n19) );
  INV_X1 S3_ALU_shifter_U205 ( .A(S3_MUX_B_OUT[1]), .ZN(S3_ALU_shifter_n27) );
  INV_X1 S3_ALU_shifter_U204 ( .A(S3_MUX_A_OUT[17]), .ZN(S3_ALU_shifter_n195)
         );
  INV_X1 S3_ALU_shifter_U203 ( .A(S3_MUX_A_OUT[12]), .ZN(S3_ALU_shifter_n206)
         );
  INV_X1 S3_ALU_shifter_U202 ( .A(S3_MUX_A_OUT[16]), .ZN(S3_ALU_shifter_n197)
         );
  INV_X1 S3_ALU_shifter_U201 ( .A(S3_MUX_A_OUT[15]), .ZN(S3_ALU_shifter_n199)
         );
  INV_X1 S3_ALU_shifter_U200 ( .A(S3_MUX_A_OUT[14]), .ZN(S3_ALU_shifter_n201)
         );
  INV_X1 S3_ALU_shifter_U199 ( .A(S3_MUX_A_OUT[13]), .ZN(S3_ALU_shifter_n203)
         );
  NAND2_X1 S3_ALU_shifter_U198 ( .A1(S3_MUX_A_OUT[0]), .A2(S3_ALU_shifter_n18), 
        .ZN(S3_ALU_shifter_n226) );
  BUF_X1 S3_ALU_shifter_U197 ( .A(S3_ALU_shifter_n85), .Z(S3_ALU_shifter_n84)
         );
  BUF_X1 S3_ALU_shifter_U196 ( .A(S3_ALU_shifter_n84), .Z(S3_ALU_shifter_n75)
         );
  INV_X1 S3_ALU_shifter_U195 ( .A(S3_ALU_shifter_n233), .ZN(
        S3_ALU_shifter_n211) );
  INV_X1 S3_ALU_shifter_U194 ( .A(S3_ALU_shifter_n236), .ZN(
        S3_ALU_shifter_n215) );
  NAND2_X1 S3_ALU_shifter_U193 ( .A1(S3_ALU_shifter_n243), .A2(
        S3_ALU_shifter_n35), .ZN(S3_ALU_shifter_n265) );
  OR2_X1 S3_ALU_shifter_U192 ( .A1(S3_ALU_shifter_n226), .A2(S3_MUX_B_OUT[1]), 
        .ZN(S3_ALU_shifter_n229) );
  NAND2_X1 S3_ALU_shifter_U191 ( .A1(S3_ALU_shifter_n2), .A2(
        S3_ALU_shifter_n18), .ZN(S3_ALU_shifter_n521) );
  INV_X1 S3_ALU_shifter_U190 ( .A(S3_ALU_shifter_n326), .ZN(
        S3_ALU_shifter_n188) );
  INV_X1 S3_ALU_shifter_U189 ( .A(S3_ALU_shifter_n333), .ZN(
        S3_ALU_shifter_n185) );
  INV_X1 S3_ALU_shifter_U188 ( .A(S3_ALU_shifter_n342), .ZN(
        S3_ALU_shifter_n181) );
  INV_X1 S3_ALU_shifter_U187 ( .A(S3_ALU_shifter_n350), .ZN(
        S3_ALU_shifter_n178) );
  INV_X1 S3_ALU_shifter_U186 ( .A(S3_ALU_shifter_n230), .ZN(
        S3_ALU_shifter_n209) );
  INV_X1 S3_ALU_shifter_U185 ( .A(S3_ALU_shifter_n269), .ZN(
        S3_ALU_shifter_n193) );
  INV_X1 S3_ALU_shifter_U184 ( .A(S3_ALU_shifter_n275), .ZN(
        S3_ALU_shifter_n191) );
  NAND2_X1 S3_ALU_shifter_U183 ( .A1(S3_ALU_shifter_n503), .A2(
        S3_ALU_shifter_n26), .ZN(S3_ALU_shifter_n527) );
  NAND2_X1 S3_ALU_shifter_U182 ( .A1(S3_ALU_shifter_n237), .A2(
        S3_ALU_shifter_n26), .ZN(S3_ALU_shifter_n254) );
  AND2_X1 S3_ALU_shifter_U181 ( .A1(S3_ALU_shifter_n2), .A2(S3_ALU_shifter_n23), .ZN(S3_ALU_shifter_n392) );
  INV_X1 S3_ALU_shifter_U180 ( .A(S3_ALU_shifter_n520), .ZN(
        S3_ALU_shifter_n159) );
  NAND2_X1 S3_ALU_shifter_U179 ( .A1(S3_ALU_shifter_n2), .A2(
        S3_ALU_shifter_n28), .ZN(S3_ALU_shifter_n399) );
  AOI21_X1 S3_ALU_shifter_U178 ( .B1(S3_ALU_shifter_n26), .B2(
        S3_ALU_shifter_n393), .A(S3_ALU_shifter_n392), .ZN(S3_ALU_shifter_n412) );
  AOI21_X1 S3_ALU_shifter_U177 ( .B1(S3_ALU_shifter_n26), .B2(
        S3_ALU_shifter_n375), .A(S3_ALU_shifter_n392), .ZN(S3_ALU_shifter_n400) );
  NAND2_X1 S3_ALU_shifter_U176 ( .A1(S3_ALU_shifter_n2), .A2(S3_MUX_B_OUT[3]), 
        .ZN(S3_ALU_shifter_n431) );
  INV_X1 S3_ALU_shifter_U175 ( .A(S3_ALU_shifter_n18), .ZN(S3_ALU_shifter_n11)
         );
  INV_X1 S3_ALU_shifter_U174 ( .A(S3_ALU_shifter_n18), .ZN(S3_ALU_shifter_n10)
         );
  INV_X1 S3_ALU_shifter_U173 ( .A(S3_ALU_shifter_n26), .ZN(S3_ALU_shifter_n21)
         );
  INV_X1 S3_ALU_shifter_U172 ( .A(S3_ALU_shifter_n26), .ZN(S3_ALU_shifter_n20)
         );
  INV_X1 S3_ALU_shifter_U171 ( .A(S3_ALU_shifter_n25), .ZN(S3_ALU_shifter_n22)
         );
  INV_X1 S3_ALU_shifter_U170 ( .A(S3_ALU_shifter_n25), .ZN(S3_ALU_shifter_n24)
         );
  INV_X1 S3_ALU_shifter_U169 ( .A(S3_ALU_shifter_n16), .ZN(S3_ALU_shifter_n15)
         );
  INV_X1 S3_ALU_shifter_U168 ( .A(S3_ALU_shifter_n17), .ZN(S3_ALU_shifter_n12)
         );
  INV_X1 S3_ALU_shifter_U167 ( .A(S3_ALU_shifter_n17), .ZN(S3_ALU_shifter_n14)
         );
  INV_X1 S3_ALU_shifter_U166 ( .A(S3_ALU_shifter_n25), .ZN(S3_ALU_shifter_n23)
         );
  INV_X1 S3_ALU_shifter_U165 ( .A(S3_ALU_shifter_n17), .ZN(S3_ALU_shifter_n13)
         );
  BUF_X1 S3_ALU_shifter_U164 ( .A(S3_ALU_shifter_n82), .Z(S3_ALU_shifter_n81)
         );
  INV_X1 S3_ALU_shifter_U163 ( .A(S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n36)
         );
  INV_X1 S3_ALU_shifter_U162 ( .A(S3_ALU_shifter_n39), .ZN(S3_ALU_shifter_n37)
         );
  INV_X1 S3_ALU_shifter_U161 ( .A(S3_ALU_shifter_n39), .ZN(S3_ALU_shifter_n38)
         );
  INV_X1 S3_ALU_shifter_U160 ( .A(S3_ALU_shifter_n32), .ZN(S3_ALU_shifter_n30)
         );
  INV_X1 S3_ALU_shifter_U159 ( .A(S3_ALU_shifter_n33), .ZN(S3_ALU_shifter_n28)
         );
  INV_X1 S3_ALU_shifter_U158 ( .A(S3_ALU_shifter_n33), .ZN(S3_ALU_shifter_n29)
         );
  INV_X1 S3_ALU_shifter_U157 ( .A(S3_ALU_shifter_n32), .ZN(S3_ALU_shifter_n31)
         );
  BUF_X1 S3_ALU_shifter_U156 ( .A(S3_ALU_shifter_n83), .Z(S3_ALU_shifter_n77)
         );
  BUF_X1 S3_ALU_shifter_U155 ( .A(S3_ALU_shifter_n83), .Z(S3_ALU_shifter_n76)
         );
  BUF_X1 S3_ALU_shifter_U154 ( .A(S3_ALU_shifter_n82), .Z(S3_ALU_shifter_n80)
         );
  BUF_X1 S3_ALU_shifter_U153 ( .A(S3_ALU_shifter_n82), .Z(S3_ALU_shifter_n79)
         );
  INV_X1 S3_ALU_shifter_U152 ( .A(S3_ALU_shifter_n227), .ZN(
        S3_ALU_shifter_n207) );
  BUF_X1 S3_ALU_shifter_U151 ( .A(S3_ALU_shifter_n83), .Z(S3_ALU_shifter_n78)
         );
  OR2_X1 S3_ALU_shifter_U150 ( .A1(S3_ALU_shifter_n239), .A2(
        S3_ALU_shifter_n28), .ZN(S3_ALU_shifter_n260) );
  OR2_X1 S3_ALU_shifter_U149 ( .A1(S3_ALU_shifter_n521), .A2(S3_MUX_B_OUT[1]), 
        .ZN(S3_ALU_shifter_n533) );
  INV_X1 S3_ALU_shifter_U148 ( .A(S3_ALU_shifter_n406), .ZN(
        S3_ALU_shifter_n157) );
  OR2_X1 S3_ALU_shifter_U147 ( .A1(S3_ALU_shifter_n265), .A2(
        S3_ALU_shifter_n36), .ZN(S3_ALU_shifter_n354) );
  INV_X1 S3_ALU_shifter_U146 ( .A(S3_ALU_shifter_n242), .ZN(
        S3_ALU_shifter_n208) );
  NAND2_X1 S3_ALU_shifter_U145 ( .A1(S3_ALU_shifter_n297), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n249) );
  NAND2_X1 S3_ALU_shifter_U144 ( .A1(S3_ALU_shifter_n305), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n268) );
  NAND2_X1 S3_ALU_shifter_U143 ( .A1(S3_ALU_shifter_n290), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n358) );
  INV_X1 S3_ALU_shifter_U142 ( .A(S3_ALU_shifter_n295), .ZN(
        S3_ALU_shifter_n174) );
  INV_X1 S3_ALU_shifter_U141 ( .A(S3_ALU_shifter_n303), .ZN(
        S3_ALU_shifter_n170) );
  INV_X1 S3_ALU_shifter_U140 ( .A(S3_ALU_shifter_n311), .ZN(
        S3_ALU_shifter_n167) );
  INV_X1 S3_ALU_shifter_U139 ( .A(S3_ALU_shifter_n318), .ZN(
        S3_ALU_shifter_n165) );
  NAND2_X1 S3_ALU_shifter_U138 ( .A1(S3_ALU_shifter_n559), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n611) );
  NAND2_X1 S3_ALU_shifter_U137 ( .A1(S3_ALU_shifter_n552), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n563) );
  NAND2_X1 S3_ALU_shifter_U136 ( .A1(S3_ALU_shifter_n554), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n564) );
  NAND2_X1 S3_ALU_shifter_U135 ( .A1(S3_ALU_shifter_n556), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n574) );
  NAND2_X1 S3_ALU_shifter_U134 ( .A1(S3_ALU_shifter_n558), .A2(
        S3_ALU_shifter_n41), .ZN(S3_ALU_shifter_n575) );
  INV_X1 S3_ALU_shifter_U133 ( .A(S3_ALU_shifter_n294), .ZN(
        S3_ALU_shifter_n189) );
  INV_X1 S3_ALU_shifter_U132 ( .A(S3_ALU_shifter_n302), .ZN(
        S3_ALU_shifter_n186) );
  INV_X1 S3_ALU_shifter_U131 ( .A(S3_ALU_shifter_n310), .ZN(
        S3_ALU_shifter_n182) );
  INV_X1 S3_ALU_shifter_U130 ( .A(S3_ALU_shifter_n317), .ZN(
        S3_ALU_shifter_n179) );
  NOR2_X1 S3_ALU_shifter_U129 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n249), .ZN(S3_ALU_shifter_N166) );
  NOR2_X1 S3_ALU_shifter_U128 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n268), .ZN(S3_ALU_shifter_N167) );
  NOR2_X1 S3_ALU_shifter_U127 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n337), .ZN(S3_ALU_shifter_N168) );
  NOR2_X1 S3_ALU_shifter_U126 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n354), .ZN(S3_ALU_shifter_N169) );
  NOR2_X1 S3_ALU_shifter_U125 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n355), .ZN(S3_ALU_shifter_N170) );
  NOR2_X1 S3_ALU_shifter_U124 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n313), .ZN(S3_ALU_shifter_N176) );
  NOR2_X1 S3_ALU_shifter_U123 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n320), .ZN(S3_ALU_shifter_N177) );
  NOR2_X1 S3_ALU_shifter_U122 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n328), .ZN(S3_ALU_shifter_N178) );
  NOR2_X1 S3_ALU_shifter_U121 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n335), .ZN(S3_ALU_shifter_N179) );
  NOR2_X1 S3_ALU_shifter_U120 ( .A1(S3_ALU_shifter_n75), .A2(
        S3_ALU_shifter_n344), .ZN(S3_ALU_shifter_N180) );
  INV_X1 S3_ALU_shifter_U119 ( .A(S3_ALU_shifter_n538), .ZN(
        S3_ALU_shifter_n163) );
  INV_X1 S3_ALU_shifter_U118 ( .A(S3_ALU_shifter_n525), .ZN(
        S3_ALU_shifter_n161) );
  INV_X1 S3_ALU_shifter_U117 ( .A(S3_ALU_shifter_n531), .ZN(
        S3_ALU_shifter_n158) );
  INV_X1 S3_ALU_shifter_U116 ( .A(S3_ALU_shifter_n411), .ZN(
        S3_ALU_shifter_n162) );
  INV_X1 S3_ALU_shifter_U115 ( .A(S3_ALU_shifter_n397), .ZN(
        S3_ALU_shifter_n160) );
  INV_X1 S3_ALU_shifter_U114 ( .A(S3_ALU_shifter_n297), .ZN(
        S3_ALU_shifter_n219) );
  INV_X1 S3_ALU_shifter_U113 ( .A(S3_ALU_shifter_n305), .ZN(
        S3_ALU_shifter_n218) );
  INV_X1 S3_ALU_shifter_U112 ( .A(S3_ALU_shifter_n510), .ZN(
        S3_ALU_shifter_n122) );
  NOR2_X1 S3_ALU_shifter_U111 ( .A1(S3_ALU_shifter_n122), .A2(
        S3_ALU_shifter_n30), .ZN(S3_ALU_shifter_n552) );
  NOR2_X1 S3_ALU_shifter_U110 ( .A1(S3_ALU_shifter_n527), .A2(
        S3_ALU_shifter_n31), .ZN(S3_ALU_shifter_n556) );
  NOR2_X1 S3_ALU_shifter_U109 ( .A1(S3_ALU_shifter_n539), .A2(
        S3_ALU_shifter_n29), .ZN(S3_ALU_shifter_n554) );
  INV_X1 S3_ALU_shifter_U108 ( .A(S3_ALU_shifter_n477), .ZN(
        S3_ALU_shifter_n183) );
  OAI21_X1 S3_ALU_shifter_U107 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n407), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N20)
         );
  INV_X1 S3_ALU_shifter_U106 ( .A(S3_ALU_shifter_n408), .ZN(
        S3_ALU_shifter_n135) );
  OAI21_X1 S3_ALU_shifter_U105 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n135), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N21)
         );
  OAI21_X1 S3_ALU_shifter_U104 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n422), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N22)
         );
  OAI21_X1 S3_ALU_shifter_U103 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n444), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N23)
         );
  INV_X1 S3_ALU_shifter_U102 ( .A(S3_ALU_shifter_n455), .ZN(
        S3_ALU_shifter_n155) );
  OAI21_X1 S3_ALU_shifter_U101 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n155), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N24)
         );
  INV_X1 S3_ALU_shifter_U100 ( .A(S3_ALU_shifter_n461), .ZN(
        S3_ALU_shifter_n140) );
  OAI21_X1 S3_ALU_shifter_U99 ( .B1(S3_ALU_shifter_n77), .B2(
        S3_ALU_shifter_n140), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N25)
         );
  INV_X1 S3_ALU_shifter_U98 ( .A(S3_ALU_shifter_n467), .ZN(S3_ALU_shifter_n149) );
  OAI21_X1 S3_ALU_shifter_U97 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n149), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N26)
         );
  INV_X1 S3_ALU_shifter_U96 ( .A(S3_ALU_shifter_n473), .ZN(S3_ALU_shifter_n146) );
  OAI21_X1 S3_ALU_shifter_U95 ( .B1(S3_ALU_shifter_n77), .B2(
        S3_ALU_shifter_n146), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N27)
         );
  INV_X1 S3_ALU_shifter_U94 ( .A(S3_ALU_shifter_n479), .ZN(S3_ALU_shifter_n153) );
  OAI21_X1 S3_ALU_shifter_U93 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n153), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N28)
         );
  INV_X1 S3_ALU_shifter_U92 ( .A(S3_ALU_shifter_n483), .ZN(S3_ALU_shifter_n136) );
  OAI21_X1 S3_ALU_shifter_U91 ( .B1(S3_ALU_shifter_n77), .B2(
        S3_ALU_shifter_n136), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N29)
         );
  INV_X1 S3_ALU_shifter_U90 ( .A(S3_ALU_shifter_n487), .ZN(S3_ALU_shifter_n151) );
  OAI21_X1 S3_ALU_shifter_U89 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n151), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N30)
         );
  INV_X1 S3_ALU_shifter_U88 ( .A(S3_ALU_shifter_n433), .ZN(S3_ALU_shifter_n142) );
  OAI21_X1 S3_ALU_shifter_U87 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n142), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N31)
         );
  INV_X1 S3_ALU_shifter_U86 ( .A(S3_ALU_shifter_n434), .ZN(S3_ALU_shifter_n152) );
  OAI21_X1 S3_ALU_shifter_U85 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n152), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N32)
         );
  INV_X1 S3_ALU_shifter_U84 ( .A(S3_ALU_shifter_n435), .ZN(S3_ALU_shifter_n138) );
  OAI21_X1 S3_ALU_shifter_U83 ( .B1(S3_ALU_shifter_n77), .B2(
        S3_ALU_shifter_n138), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N33)
         );
  INV_X1 S3_ALU_shifter_U82 ( .A(S3_ALU_shifter_n436), .ZN(S3_ALU_shifter_n147) );
  OAI21_X1 S3_ALU_shifter_U81 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n147), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N34)
         );
  INV_X1 S3_ALU_shifter_U80 ( .A(S3_ALU_shifter_n446), .ZN(S3_ALU_shifter_n144) );
  OAI21_X1 S3_ALU_shifter_U79 ( .B1(S3_ALU_shifter_n78), .B2(
        S3_ALU_shifter_n144), .A(S3_ALU_shifter_n447), .ZN(S3_ALU_shifter_N35)
         );
  OAI21_X1 S3_ALU_shifter_U78 ( .B1(S3_ALU_shifter_n36), .B2(
        S3_ALU_shifter_n157), .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n479) );
  INV_X1 S3_ALU_shifter_U77 ( .A(S3_ALU_shifter_n430), .ZN(S3_ALU_shifter_n137) );
  OAI21_X1 S3_ALU_shifter_U76 ( .B1(S3_MUX_B_OUT[3]), .B2(S3_ALU_shifter_n137), 
        .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n483) );
  OAI21_X1 S3_ALU_shifter_U75 ( .B1(S3_ALU_shifter_n37), .B2(
        S3_ALU_shifter_n432), .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n487) );
  OAI21_X1 S3_ALU_shifter_U74 ( .B1(S3_MUX_B_OUT[3]), .B2(S3_ALU_shifter_n414), 
        .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n433) );
  INV_X1 S3_ALU_shifter_U73 ( .A(S3_ALU_shifter_n415), .ZN(S3_ALU_shifter_n154) );
  OAI21_X1 S3_ALU_shifter_U72 ( .B1(S3_MUX_B_OUT[3]), .B2(S3_ALU_shifter_n154), 
        .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n434) );
  INV_X1 S3_ALU_shifter_U71 ( .A(S3_ALU_shifter_n424), .ZN(S3_ALU_shifter_n139) );
  OAI21_X1 S3_ALU_shifter_U70 ( .B1(S3_MUX_B_OUT[3]), .B2(S3_ALU_shifter_n139), 
        .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n435) );
  INV_X1 S3_ALU_shifter_U69 ( .A(S3_ALU_shifter_n426), .ZN(S3_ALU_shifter_n148) );
  OAI21_X1 S3_ALU_shifter_U68 ( .B1(S3_ALU_shifter_n37), .B2(
        S3_ALU_shifter_n148), .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n436) );
  INV_X1 S3_ALU_shifter_U67 ( .A(S3_ALU_shifter_n428), .ZN(S3_ALU_shifter_n145) );
  OAI21_X1 S3_ALU_shifter_U66 ( .B1(S3_MUX_B_OUT[3]), .B2(S3_ALU_shifter_n145), 
        .A(S3_ALU_shifter_n431), .ZN(S3_ALU_shifter_n446) );
  INV_X1 S3_ALU_shifter_U65 ( .A(S3_ALU_shifter_n404), .ZN(S3_ALU_shifter_n156) );
  OAI21_X1 S3_ALU_shifter_U64 ( .B1(S3_ALU_shifter_n30), .B2(
        S3_ALU_shifter_n156), .A(S3_ALU_shifter_n399), .ZN(S3_ALU_shifter_n415) );
  INV_X1 S3_ALU_shifter_U63 ( .A(S3_ALU_shifter_n382), .ZN(S3_ALU_shifter_n141) );
  OAI21_X1 S3_ALU_shifter_U62 ( .B1(S3_ALU_shifter_n31), .B2(
        S3_ALU_shifter_n141), .A(S3_ALU_shifter_n399), .ZN(S3_ALU_shifter_n424) );
  OAI21_X1 S3_ALU_shifter_U61 ( .B1(S3_MUX_B_OUT[2]), .B2(S3_ALU_shifter_n412), 
        .A(S3_ALU_shifter_n399), .ZN(S3_ALU_shifter_n426) );
  OAI21_X1 S3_ALU_shifter_U60 ( .B1(S3_ALU_shifter_n28), .B2(
        S3_ALU_shifter_n400), .A(S3_ALU_shifter_n399), .ZN(S3_ALU_shifter_n428) );
  NOR2_X1 S3_ALU_shifter_U59 ( .A1(S3_ALU_shifter_n229), .A2(S3_MUX_B_OUT[2]), 
        .ZN(S3_ALU_shifter_n297) );
  NOR2_X1 S3_ALU_shifter_U58 ( .A1(S3_ALU_shifter_n254), .A2(
        S3_ALU_shifter_n28), .ZN(S3_ALU_shifter_n305) );
  INV_X1 S3_ALU_shifter_U57 ( .A(S3_ALU_shifter_n611), .ZN(S3_ALU_shifter_n115) );
  INV_X1 S3_ALU_shifter_U56 ( .A(S3_ALU_shifter_n563), .ZN(S3_ALU_shifter_n117) );
  INV_X1 S3_ALU_shifter_U55 ( .A(S3_ALU_shifter_n564), .ZN(S3_ALU_shifter_n99)
         );
  INV_X1 S3_ALU_shifter_U54 ( .A(S3_ALU_shifter_n574), .ZN(S3_ALU_shifter_n130) );
  INV_X1 S3_ALU_shifter_U53 ( .A(S3_ALU_shifter_n575), .ZN(S3_ALU_shifter_n94)
         );
  INV_X1 S3_ALU_shifter_U52 ( .A(S3_ALU_shifter_n589), .ZN(S3_ALU_shifter_n120) );
  INV_X1 S3_ALU_shifter_U51 ( .A(S3_ALU_shifter_n595), .ZN(S3_ALU_shifter_n102) );
  INV_X1 S3_ALU_shifter_U50 ( .A(S3_ALU_shifter_n601), .ZN(S3_ALU_shifter_n133) );
  INV_X1 S3_ALU_shifter_U49 ( .A(S3_ALU_shifter_n607), .ZN(S3_ALU_shifter_n96)
         );
  OR2_X1 S3_ALU_shifter_U48 ( .A1(S3_ALU_shifter_n260), .A2(S3_ALU_shifter_n38), .ZN(S3_ALU_shifter_n337) );
  OR2_X1 S3_ALU_shifter_U47 ( .A1(S3_ALU_shifter_n272), .A2(S3_MUX_B_OUT[3]), 
        .ZN(S3_ALU_shifter_n355) );
  OR2_X1 S3_ALU_shifter_U46 ( .A1(S3_ALU_shifter_n278), .A2(S3_ALU_shifter_n37), .ZN(S3_ALU_shifter_n356) );
  OR2_X1 S3_ALU_shifter_U45 ( .A1(S3_ALU_shifter_n284), .A2(S3_MUX_B_OUT[3]), 
        .ZN(S3_ALU_shifter_n357) );
  NOR2_X1 S3_ALU_shifter_U44 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n356), .ZN(S3_ALU_shifter_N171) );
  NOR2_X1 S3_ALU_shifter_U43 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n357), .ZN(S3_ALU_shifter_N172) );
  NOR2_X1 S3_ALU_shifter_U42 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n358), .ZN(S3_ALU_shifter_N173) );
  NOR2_X1 S3_ALU_shifter_U41 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n359), .ZN(S3_ALU_shifter_N174) );
  NOR2_X1 S3_ALU_shifter_U40 ( .A1(S3_ALU_shifter_n76), .A2(
        S3_ALU_shifter_n360), .ZN(S3_ALU_shifter_N175) );
  NOR2_X1 S3_ALU_shifter_U39 ( .A1(S3_ALU_shifter_n533), .A2(
        S3_ALU_shifter_n29), .ZN(S3_ALU_shifter_n558) );
  NOR2_X1 S3_ALU_shifter_U38 ( .A1(S3_ALU_shifter_n560), .A2(S3_MUX_B_OUT[3]), 
        .ZN(S3_ALU_shifter_n615) );
  NOR2_X1 S3_ALU_shifter_U37 ( .A1(S3_ALU_shifter_n541), .A2(
        S3_ALU_shifter_n38), .ZN(S3_ALU_shifter_n561) );
  NOR2_X1 S3_ALU_shifter_U36 ( .A1(S3_ALU_shifter_n543), .A2(S3_MUX_B_OUT[3]), 
        .ZN(S3_ALU_shifter_n562) );
  INV_X1 S3_ALU_shifter_U35 ( .A(S3_ALU_shifter_n485), .ZN(S3_ALU_shifter_n175) );
  INV_X1 S3_ALU_shifter_U34 ( .A(S3_ALU_shifter_n413), .ZN(S3_ALU_shifter_n171) );
  INV_X1 S3_ALU_shifter_U33 ( .A(S3_ALU_shifter_n290), .ZN(S3_ALU_shifter_n213) );
  INV_X1 S3_ALU_shifter_U32 ( .A(S3_ALU_shifter_n613), .ZN(S3_ALU_shifter_n176) );
  INV_X1 S3_ALU_shifter_U31 ( .A(S3_ALU_shifter_n540), .ZN(S3_ALU_shifter_n172) );
  INV_X1 S3_ALU_shifter_U30 ( .A(S3_ALU_shifter_n542), .ZN(S3_ALU_shifter_n168) );
  INV_X1 S3_ALU_shifter_U29 ( .A(S3_ALU_shifter_n549), .ZN(S3_ALU_shifter_n106) );
  INV_X1 S3_ALU_shifter_U28 ( .A(S3_ALU_shifter_n572), .ZN(S3_ALU_shifter_n128) );
  INV_X1 S3_ALU_shifter_U27 ( .A(S3_ALU_shifter_n583), .ZN(S3_ALU_shifter_n92)
         );
  INV_X1 S3_ALU_shifter_U26 ( .A(S3_ALU_shifter_n328), .ZN(S3_ALU_shifter_n204) );
  INV_X1 S3_ALU_shifter_U25 ( .A(S3_ALU_shifter_n335), .ZN(S3_ALU_shifter_n202) );
  INV_X1 S3_ALU_shifter_U24 ( .A(S3_ALU_shifter_n344), .ZN(S3_ALU_shifter_n200) );
  INV_X1 S3_ALU_shifter_U23 ( .A(S3_ALU_shifter_n352), .ZN(S3_ALU_shifter_n198) );
  INV_X1 S3_ALU_shifter_U22 ( .A(S3_ALU_shifter_n422), .ZN(S3_ALU_shifter_n150) );
  INV_X1 S3_ALU_shifter_U21 ( .A(S3_ALU_shifter_n444), .ZN(S3_ALU_shifter_n143) );
  INV_X1 S3_ALU_shifter_U20 ( .A(S3_ALU_shifter_n615), .ZN(S3_ALU_shifter_n108) );
  INV_X1 S3_ALU_shifter_U19 ( .A(S3_ALU_shifter_n561), .ZN(S3_ALU_shifter_n125) );
  INV_X1 S3_ALU_shifter_U18 ( .A(S3_ALU_shifter_n562), .ZN(S3_ALU_shifter_n89)
         );
  INV_X1 S3_ALU_shifter_U17 ( .A(S3_ALU_shifter_n535), .ZN(S3_ALU_shifter_n112) );
  BUF_X1 S3_ALU_shifter_U16 ( .A(S3_ALU_shifter_n42), .Z(S3_ALU_shifter_n6) );
  BUF_X1 S3_ALU_shifter_U15 ( .A(S3_ALU_shifter_n35), .Z(S3_ALU_shifter_n34)
         );
  BUF_X1 S3_ALU_shifter_U14 ( .A(S3_MUX_B_OUT[4]), .Z(S3_ALU_shifter_n85) );
  BUF_X1 S3_ALU_shifter_U13 ( .A(S3_ALU_shifter_n85), .Z(S3_ALU_shifter_n82)
         );
  BUF_X1 S3_ALU_shifter_U12 ( .A(S3_ALU_shifter_n85), .Z(S3_ALU_shifter_n83)
         );
  BUF_X1 S3_ALU_shifter_U11 ( .A(S3_ALU_shifter_n34), .Z(S3_ALU_shifter_n33)
         );
  BUF_X1 S3_ALU_shifter_U10 ( .A(S3_ALU_shifter_n27), .Z(S3_ALU_shifter_n25)
         );
  BUF_X1 S3_ALU_shifter_U9 ( .A(S3_ALU_shifter_n34), .Z(S3_ALU_shifter_n32) );
  BUF_X1 S3_ALU_shifter_U8 ( .A(S3_ALU_shifter_n19), .Z(S3_ALU_shifter_n16) );
  BUF_X1 S3_ALU_shifter_U7 ( .A(S3_ALU_shifter_n19), .Z(S3_ALU_shifter_n17) );
  BUF_X1 S3_ALU_shifter_U6 ( .A(S3_ALU_shifter_n74), .Z(S3_ALU_shifter_n39) );
  BUF_X1 S3_ALU_shifter_U5 ( .A(S3_ALU_shifter_n19), .Z(S3_ALU_shifter_n18) );
  BUF_X1 S3_ALU_shifter_U4 ( .A(S3_ALU_shifter_n27), .Z(S3_ALU_shifter_n26) );
  BUF_X1 S3_ALU_shifter_U3 ( .A(S3_ALU_shifter_n74), .Z(S3_ALU_shifter_n41) );
  NOR2_X1 S3_ALU_shifter_U2 ( .A1(S3_ALU_LEFT_RIGHT_shftr), .A2(
        S3_ALU_LOGIC_ARITH_shftr), .ZN(S3_ALU_shifter_n1) );
  NAND2_X1 S3_ALU_shifter_U1 ( .A1(S3_ALU_shifter_n78), .A2(S3_ALU_shifter_n2), 
        .ZN(S3_ALU_shifter_n447) );
  INV_X1 S3_ALU_sub_116_U35 ( .A(S3_MUX_B_OUT[31]), .ZN(S3_ALU_sub_116_n7) );
  INV_X1 S3_ALU_sub_116_U34 ( .A(S3_ALU_n150), .ZN(S3_ALU_sub_116_n2) );
  NAND2_X1 S3_ALU_sub_116_U33 ( .A1(S3_ALU_n150), .A2(S3_ALU_sub_116_n1), .ZN(
        S3_ALU_sub_116_carry[1]) );
  INV_X1 S3_ALU_sub_116_U32 ( .A(S3_MUX_B_OUT[1]), .ZN(S3_ALU_sub_116_n3) );
  INV_X1 S3_ALU_sub_116_U31 ( .A(S3_MUX_B_OUT[2]), .ZN(S3_ALU_sub_116_n4) );
  INV_X1 S3_ALU_sub_116_U30 ( .A(S3_MUX_B_OUT[3]), .ZN(S3_ALU_sub_116_n5) );
  INV_X1 S3_ALU_sub_116_U29 ( .A(S3_MUX_B_OUT[4]), .ZN(S3_ALU_sub_116_n6) );
  INV_X1 S3_ALU_sub_116_U28 ( .A(S3_MUX_B_OUT[5]), .ZN(S3_ALU_sub_116_n33) );
  INV_X1 S3_ALU_sub_116_U27 ( .A(S3_MUX_B_OUT[6]), .ZN(S3_ALU_sub_116_n32) );
  INV_X1 S3_ALU_sub_116_U26 ( .A(S3_MUX_B_OUT[7]), .ZN(S3_ALU_sub_116_n31) );
  INV_X1 S3_ALU_sub_116_U25 ( .A(S3_MUX_B_OUT[8]), .ZN(S3_ALU_sub_116_n30) );
  INV_X1 S3_ALU_sub_116_U24 ( .A(S3_MUX_B_OUT[9]), .ZN(S3_ALU_sub_116_n29) );
  INV_X1 S3_ALU_sub_116_U23 ( .A(S3_MUX_B_OUT[10]), .ZN(S3_ALU_sub_116_n28) );
  INV_X1 S3_ALU_sub_116_U22 ( .A(S3_MUX_B_OUT[11]), .ZN(S3_ALU_sub_116_n27) );
  INV_X1 S3_ALU_sub_116_U21 ( .A(S3_MUX_B_OUT[12]), .ZN(S3_ALU_sub_116_n26) );
  INV_X1 S3_ALU_sub_116_U20 ( .A(S3_MUX_B_OUT[13]), .ZN(S3_ALU_sub_116_n25) );
  INV_X1 S3_ALU_sub_116_U19 ( .A(S3_MUX_B_OUT[14]), .ZN(S3_ALU_sub_116_n24) );
  INV_X1 S3_ALU_sub_116_U18 ( .A(S3_MUX_B_OUT[15]), .ZN(S3_ALU_sub_116_n23) );
  INV_X1 S3_ALU_sub_116_U17 ( .A(S3_MUX_B_OUT[16]), .ZN(S3_ALU_sub_116_n22) );
  INV_X1 S3_ALU_sub_116_U16 ( .A(S3_MUX_B_OUT[17]), .ZN(S3_ALU_sub_116_n21) );
  INV_X1 S3_ALU_sub_116_U15 ( .A(S3_MUX_B_OUT[18]), .ZN(S3_ALU_sub_116_n20) );
  INV_X1 S3_ALU_sub_116_U14 ( .A(S3_MUX_B_OUT[19]), .ZN(S3_ALU_sub_116_n19) );
  INV_X1 S3_ALU_sub_116_U13 ( .A(S3_MUX_B_OUT[20]), .ZN(S3_ALU_sub_116_n18) );
  INV_X1 S3_ALU_sub_116_U12 ( .A(S3_MUX_B_OUT[21]), .ZN(S3_ALU_sub_116_n17) );
  INV_X1 S3_ALU_sub_116_U11 ( .A(S3_MUX_B_OUT[22]), .ZN(S3_ALU_sub_116_n16) );
  INV_X1 S3_ALU_sub_116_U10 ( .A(S3_MUX_B_OUT[23]), .ZN(S3_ALU_sub_116_n15) );
  INV_X1 S3_ALU_sub_116_U9 ( .A(S3_MUX_B_OUT[24]), .ZN(S3_ALU_sub_116_n14) );
  INV_X1 S3_ALU_sub_116_U8 ( .A(S3_MUX_B_OUT[25]), .ZN(S3_ALU_sub_116_n13) );
  INV_X1 S3_ALU_sub_116_U7 ( .A(S3_MUX_B_OUT[26]), .ZN(S3_ALU_sub_116_n12) );
  INV_X1 S3_ALU_sub_116_U6 ( .A(S3_MUX_B_OUT[27]), .ZN(S3_ALU_sub_116_n11) );
  INV_X1 S3_ALU_sub_116_U5 ( .A(S3_MUX_B_OUT[28]), .ZN(S3_ALU_sub_116_n10) );
  INV_X1 S3_ALU_sub_116_U4 ( .A(S3_MUX_B_OUT[29]), .ZN(S3_ALU_sub_116_n9) );
  INV_X1 S3_ALU_sub_116_U3 ( .A(S3_MUX_B_OUT[30]), .ZN(S3_ALU_sub_116_n8) );
  INV_X1 S3_ALU_sub_116_U2 ( .A(S3_MUX_A_OUT[0]), .ZN(S3_ALU_sub_116_n1) );
  XNOR2_X1 S3_ALU_sub_116_U1 ( .A(S3_ALU_sub_116_n2), .B(S3_MUX_A_OUT[0]), 
        .ZN(S3_ALU_N357) );
  FA_X1 S3_ALU_sub_116_U2_1 ( .A(S3_MUX_A_OUT[1]), .B(S3_ALU_sub_116_n3), .CI(
        S3_ALU_sub_116_carry[1]), .CO(S3_ALU_sub_116_carry[2]), .S(S3_ALU_N358) );
  FA_X1 S3_ALU_sub_116_U2_2 ( .A(S3_MUX_A_OUT[2]), .B(S3_ALU_sub_116_n4), .CI(
        S3_ALU_sub_116_carry[2]), .CO(S3_ALU_sub_116_carry[3]), .S(S3_ALU_N359) );
  FA_X1 S3_ALU_sub_116_U2_3 ( .A(S3_MUX_A_OUT[3]), .B(S3_ALU_sub_116_n5), .CI(
        S3_ALU_sub_116_carry[3]), .CO(S3_ALU_sub_116_carry[4]), .S(S3_ALU_N360) );
  FA_X1 S3_ALU_sub_116_U2_4 ( .A(S3_MUX_A_OUT[4]), .B(S3_ALU_sub_116_n6), .CI(
        S3_ALU_sub_116_carry[4]), .CO(S3_ALU_sub_116_carry[5]), .S(S3_ALU_N361) );
  FA_X1 S3_ALU_sub_116_U2_5 ( .A(S3_MUX_A_OUT[5]), .B(S3_ALU_sub_116_n33), 
        .CI(S3_ALU_sub_116_carry[5]), .CO(S3_ALU_sub_116_carry[6]), .S(
        S3_ALU_N362) );
  FA_X1 S3_ALU_sub_116_U2_6 ( .A(S3_MUX_A_OUT[6]), .B(S3_ALU_sub_116_n32), 
        .CI(S3_ALU_sub_116_carry[6]), .CO(S3_ALU_sub_116_carry[7]), .S(
        S3_ALU_N363) );
  FA_X1 S3_ALU_sub_116_U2_7 ( .A(S3_MUX_A_OUT[7]), .B(S3_ALU_sub_116_n31), 
        .CI(S3_ALU_sub_116_carry[7]), .CO(S3_ALU_sub_116_carry[8]), .S(
        S3_ALU_N364) );
  FA_X1 S3_ALU_sub_116_U2_8 ( .A(S3_MUX_A_OUT[8]), .B(S3_ALU_sub_116_n30), 
        .CI(S3_ALU_sub_116_carry[8]), .CO(S3_ALU_sub_116_carry[9]), .S(
        S3_ALU_N365) );
  FA_X1 S3_ALU_sub_116_U2_9 ( .A(S3_MUX_A_OUT[9]), .B(S3_ALU_sub_116_n29), 
        .CI(S3_ALU_sub_116_carry[9]), .CO(S3_ALU_sub_116_carry[10]), .S(
        S3_ALU_N366) );
  FA_X1 S3_ALU_sub_116_U2_10 ( .A(S3_MUX_A_OUT[10]), .B(S3_ALU_sub_116_n28), 
        .CI(S3_ALU_sub_116_carry[10]), .CO(S3_ALU_sub_116_carry[11]), .S(
        S3_ALU_N367) );
  FA_X1 S3_ALU_sub_116_U2_11 ( .A(S3_MUX_A_OUT[11]), .B(S3_ALU_sub_116_n27), 
        .CI(S3_ALU_sub_116_carry[11]), .CO(S3_ALU_sub_116_carry[12]), .S(
        S3_ALU_N368) );
  FA_X1 S3_ALU_sub_116_U2_12 ( .A(S3_MUX_A_OUT[12]), .B(S3_ALU_sub_116_n26), 
        .CI(S3_ALU_sub_116_carry[12]), .CO(S3_ALU_sub_116_carry[13]), .S(
        S3_ALU_N369) );
  FA_X1 S3_ALU_sub_116_U2_13 ( .A(S3_MUX_A_OUT[13]), .B(S3_ALU_sub_116_n25), 
        .CI(S3_ALU_sub_116_carry[13]), .CO(S3_ALU_sub_116_carry[14]), .S(
        S3_ALU_N370) );
  FA_X1 S3_ALU_sub_116_U2_14 ( .A(S3_MUX_A_OUT[14]), .B(S3_ALU_sub_116_n24), 
        .CI(S3_ALU_sub_116_carry[14]), .CO(S3_ALU_sub_116_carry[15]), .S(
        S3_ALU_N371) );
  FA_X1 S3_ALU_sub_116_U2_15 ( .A(S3_MUX_A_OUT[15]), .B(S3_ALU_sub_116_n23), 
        .CI(S3_ALU_sub_116_carry[15]), .CO(S3_ALU_sub_116_carry[16]), .S(
        S3_ALU_N372) );
  FA_X1 S3_ALU_sub_116_U2_16 ( .A(S3_MUX_A_OUT[16]), .B(S3_ALU_sub_116_n22), 
        .CI(S3_ALU_sub_116_carry[16]), .CO(S3_ALU_sub_116_carry[17]), .S(
        S3_ALU_N373) );
  FA_X1 S3_ALU_sub_116_U2_17 ( .A(S3_MUX_A_OUT[17]), .B(S3_ALU_sub_116_n21), 
        .CI(S3_ALU_sub_116_carry[17]), .CO(S3_ALU_sub_116_carry[18]), .S(
        S3_ALU_N374) );
  FA_X1 S3_ALU_sub_116_U2_18 ( .A(S3_MUX_A_OUT[18]), .B(S3_ALU_sub_116_n20), 
        .CI(S3_ALU_sub_116_carry[18]), .CO(S3_ALU_sub_116_carry[19]), .S(
        S3_ALU_N375) );
  FA_X1 S3_ALU_sub_116_U2_19 ( .A(S3_MUX_A_OUT[19]), .B(S3_ALU_sub_116_n19), 
        .CI(S3_ALU_sub_116_carry[19]), .CO(S3_ALU_sub_116_carry[20]), .S(
        S3_ALU_N376) );
  FA_X1 S3_ALU_sub_116_U2_20 ( .A(S3_MUX_A_OUT[20]), .B(S3_ALU_sub_116_n18), 
        .CI(S3_ALU_sub_116_carry[20]), .CO(S3_ALU_sub_116_carry[21]), .S(
        S3_ALU_N377) );
  FA_X1 S3_ALU_sub_116_U2_21 ( .A(S3_MUX_A_OUT[21]), .B(S3_ALU_sub_116_n17), 
        .CI(S3_ALU_sub_116_carry[21]), .CO(S3_ALU_sub_116_carry[22]), .S(
        S3_ALU_N378) );
  FA_X1 S3_ALU_sub_116_U2_22 ( .A(S3_MUX_A_OUT[22]), .B(S3_ALU_sub_116_n16), 
        .CI(S3_ALU_sub_116_carry[22]), .CO(S3_ALU_sub_116_carry[23]), .S(
        S3_ALU_N379) );
  FA_X1 S3_ALU_sub_116_U2_23 ( .A(S3_MUX_A_OUT[23]), .B(S3_ALU_sub_116_n15), 
        .CI(S3_ALU_sub_116_carry[23]), .CO(S3_ALU_sub_116_carry[24]), .S(
        S3_ALU_N380) );
  FA_X1 S3_ALU_sub_116_U2_24 ( .A(S3_MUX_A_OUT[24]), .B(S3_ALU_sub_116_n14), 
        .CI(S3_ALU_sub_116_carry[24]), .CO(S3_ALU_sub_116_carry[25]), .S(
        S3_ALU_N381) );
  FA_X1 S3_ALU_sub_116_U2_25 ( .A(S3_MUX_A_OUT[25]), .B(S3_ALU_sub_116_n13), 
        .CI(S3_ALU_sub_116_carry[25]), .CO(S3_ALU_sub_116_carry[26]), .S(
        S3_ALU_N382) );
  FA_X1 S3_ALU_sub_116_U2_26 ( .A(S3_MUX_A_OUT[26]), .B(S3_ALU_sub_116_n12), 
        .CI(S3_ALU_sub_116_carry[26]), .CO(S3_ALU_sub_116_carry[27]), .S(
        S3_ALU_N383) );
  FA_X1 S3_ALU_sub_116_U2_27 ( .A(S3_MUX_A_OUT[27]), .B(S3_ALU_sub_116_n11), 
        .CI(S3_ALU_sub_116_carry[27]), .CO(S3_ALU_sub_116_carry[28]), .S(
        S3_ALU_N384) );
  FA_X1 S3_ALU_sub_116_U2_28 ( .A(S3_MUX_A_OUT[28]), .B(S3_ALU_sub_116_n10), 
        .CI(S3_ALU_sub_116_carry[28]), .CO(S3_ALU_sub_116_carry[29]), .S(
        S3_ALU_N385) );
  FA_X1 S3_ALU_sub_116_U2_29 ( .A(S3_MUX_A_OUT[29]), .B(S3_ALU_sub_116_n9), 
        .CI(S3_ALU_sub_116_carry[29]), .CO(S3_ALU_sub_116_carry[30]), .S(
        S3_ALU_N386) );
  FA_X1 S3_ALU_sub_116_U2_30 ( .A(S3_MUX_A_OUT[30]), .B(S3_ALU_sub_116_n8), 
        .CI(S3_ALU_sub_116_carry[30]), .CO(S3_ALU_sub_116_carry[31]), .S(
        S3_ALU_N387) );
  FA_X1 S3_ALU_sub_116_U2_31 ( .A(S3_MUX_A_OUT[31]), .B(S3_ALU_sub_116_n7), 
        .CI(S3_ALU_sub_116_carry[31]), .S(S3_ALU_N388) );
  AND2_X1 S3_ALU_add_113_U2 ( .A1(S3_ALU_n150), .A2(S3_MUX_A_OUT[0]), .ZN(
        S3_ALU_add_113_n2) );
  XOR2_X1 S3_ALU_add_113_U1 ( .A(S3_ALU_n150), .B(S3_MUX_A_OUT[0]), .Z(
        S3_ALU_N325) );
  FA_X1 S3_ALU_add_113_U1_1 ( .A(S3_MUX_A_OUT[1]), .B(S3_MUX_B_OUT[1]), .CI(
        S3_ALU_add_113_n2), .CO(S3_ALU_add_113_carry[2]), .S(S3_ALU_N326) );
  FA_X1 S3_ALU_add_113_U1_2 ( .A(S3_MUX_A_OUT[2]), .B(S3_MUX_B_OUT[2]), .CI(
        S3_ALU_add_113_carry[2]), .CO(S3_ALU_add_113_carry[3]), .S(S3_ALU_N327) );
  FA_X1 S3_ALU_add_113_U1_3 ( .A(S3_MUX_A_OUT[3]), .B(S3_MUX_B_OUT[3]), .CI(
        S3_ALU_add_113_carry[3]), .CO(S3_ALU_add_113_carry[4]), .S(S3_ALU_N328) );
  FA_X1 S3_ALU_add_113_U1_4 ( .A(S3_MUX_A_OUT[4]), .B(S3_MUX_B_OUT[4]), .CI(
        S3_ALU_add_113_carry[4]), .CO(S3_ALU_add_113_carry[5]), .S(S3_ALU_N329) );
  FA_X1 S3_ALU_add_113_U1_5 ( .A(S3_MUX_A_OUT[5]), .B(S3_MUX_B_OUT[5]), .CI(
        S3_ALU_add_113_carry[5]), .CO(S3_ALU_add_113_carry[6]), .S(S3_ALU_N330) );
  FA_X1 S3_ALU_add_113_U1_6 ( .A(S3_MUX_A_OUT[6]), .B(S3_MUX_B_OUT[6]), .CI(
        S3_ALU_add_113_carry[6]), .CO(S3_ALU_add_113_carry[7]), .S(S3_ALU_N331) );
  FA_X1 S3_ALU_add_113_U1_7 ( .A(S3_MUX_A_OUT[7]), .B(S3_MUX_B_OUT[7]), .CI(
        S3_ALU_add_113_carry[7]), .CO(S3_ALU_add_113_carry[8]), .S(S3_ALU_N332) );
  FA_X1 S3_ALU_add_113_U1_8 ( .A(S3_MUX_A_OUT[8]), .B(S3_MUX_B_OUT[8]), .CI(
        S3_ALU_add_113_carry[8]), .CO(S3_ALU_add_113_carry[9]), .S(S3_ALU_N333) );
  FA_X1 S3_ALU_add_113_U1_9 ( .A(S3_MUX_A_OUT[9]), .B(S3_MUX_B_OUT[9]), .CI(
        S3_ALU_add_113_carry[9]), .CO(S3_ALU_add_113_carry[10]), .S(
        S3_ALU_N334) );
  FA_X1 S3_ALU_add_113_U1_10 ( .A(S3_MUX_A_OUT[10]), .B(S3_MUX_B_OUT[10]), 
        .CI(S3_ALU_add_113_carry[10]), .CO(S3_ALU_add_113_carry[11]), .S(
        S3_ALU_N335) );
  FA_X1 S3_ALU_add_113_U1_11 ( .A(S3_MUX_A_OUT[11]), .B(S3_MUX_B_OUT[11]), 
        .CI(S3_ALU_add_113_carry[11]), .CO(S3_ALU_add_113_carry[12]), .S(
        S3_ALU_N336) );
  FA_X1 S3_ALU_add_113_U1_12 ( .A(S3_MUX_A_OUT[12]), .B(S3_MUX_B_OUT[12]), 
        .CI(S3_ALU_add_113_carry[12]), .CO(S3_ALU_add_113_carry[13]), .S(
        S3_ALU_N337) );
  FA_X1 S3_ALU_add_113_U1_13 ( .A(S3_MUX_A_OUT[13]), .B(S3_MUX_B_OUT[13]), 
        .CI(S3_ALU_add_113_carry[13]), .CO(S3_ALU_add_113_carry[14]), .S(
        S3_ALU_N338) );
  FA_X1 S3_ALU_add_113_U1_14 ( .A(S3_MUX_A_OUT[14]), .B(S3_MUX_B_OUT[14]), 
        .CI(S3_ALU_add_113_carry[14]), .CO(S3_ALU_add_113_carry[15]), .S(
        S3_ALU_N339) );
  FA_X1 S3_ALU_add_113_U1_15 ( .A(S3_MUX_A_OUT[15]), .B(S3_MUX_B_OUT[15]), 
        .CI(S3_ALU_add_113_carry[15]), .CO(S3_ALU_add_113_carry[16]), .S(
        S3_ALU_N340) );
  FA_X1 S3_ALU_add_113_U1_16 ( .A(S3_MUX_A_OUT[16]), .B(S3_MUX_B_OUT[16]), 
        .CI(S3_ALU_add_113_carry[16]), .CO(S3_ALU_add_113_carry[17]), .S(
        S3_ALU_N341) );
  FA_X1 S3_ALU_add_113_U1_17 ( .A(S3_MUX_A_OUT[17]), .B(S3_MUX_B_OUT[17]), 
        .CI(S3_ALU_add_113_carry[17]), .CO(S3_ALU_add_113_carry[18]), .S(
        S3_ALU_N342) );
  FA_X1 S3_ALU_add_113_U1_18 ( .A(S3_MUX_A_OUT[18]), .B(S3_MUX_B_OUT[18]), 
        .CI(S3_ALU_add_113_carry[18]), .CO(S3_ALU_add_113_carry[19]), .S(
        S3_ALU_N343) );
  FA_X1 S3_ALU_add_113_U1_19 ( .A(S3_MUX_A_OUT[19]), .B(S3_MUX_B_OUT[19]), 
        .CI(S3_ALU_add_113_carry[19]), .CO(S3_ALU_add_113_carry[20]), .S(
        S3_ALU_N344) );
  FA_X1 S3_ALU_add_113_U1_20 ( .A(S3_MUX_A_OUT[20]), .B(S3_MUX_B_OUT[20]), 
        .CI(S3_ALU_add_113_carry[20]), .CO(S3_ALU_add_113_carry[21]), .S(
        S3_ALU_N345) );
  FA_X1 S3_ALU_add_113_U1_21 ( .A(S3_MUX_A_OUT[21]), .B(S3_MUX_B_OUT[21]), 
        .CI(S3_ALU_add_113_carry[21]), .CO(S3_ALU_add_113_carry[22]), .S(
        S3_ALU_N346) );
  FA_X1 S3_ALU_add_113_U1_22 ( .A(S3_MUX_A_OUT[22]), .B(S3_MUX_B_OUT[22]), 
        .CI(S3_ALU_add_113_carry[22]), .CO(S3_ALU_add_113_carry[23]), .S(
        S3_ALU_N347) );
  FA_X1 S3_ALU_add_113_U1_23 ( .A(S3_MUX_A_OUT[23]), .B(S3_MUX_B_OUT[23]), 
        .CI(S3_ALU_add_113_carry[23]), .CO(S3_ALU_add_113_carry[24]), .S(
        S3_ALU_N348) );
  FA_X1 S3_ALU_add_113_U1_24 ( .A(S3_MUX_A_OUT[24]), .B(S3_MUX_B_OUT[24]), 
        .CI(S3_ALU_add_113_carry[24]), .CO(S3_ALU_add_113_carry[25]), .S(
        S3_ALU_N349) );
  FA_X1 S3_ALU_add_113_U1_25 ( .A(S3_MUX_A_OUT[25]), .B(S3_MUX_B_OUT[25]), 
        .CI(S3_ALU_add_113_carry[25]), .CO(S3_ALU_add_113_carry[26]), .S(
        S3_ALU_N350) );
  FA_X1 S3_ALU_add_113_U1_26 ( .A(S3_MUX_A_OUT[26]), .B(S3_MUX_B_OUT[26]), 
        .CI(S3_ALU_add_113_carry[26]), .CO(S3_ALU_add_113_carry[27]), .S(
        S3_ALU_N351) );
  FA_X1 S3_ALU_add_113_U1_27 ( .A(S3_MUX_A_OUT[27]), .B(S3_MUX_B_OUT[27]), 
        .CI(S3_ALU_add_113_carry[27]), .CO(S3_ALU_add_113_carry[28]), .S(
        S3_ALU_N352) );
  FA_X1 S3_ALU_add_113_U1_28 ( .A(S3_MUX_A_OUT[28]), .B(S3_MUX_B_OUT[28]), 
        .CI(S3_ALU_add_113_carry[28]), .CO(S3_ALU_add_113_carry[29]), .S(
        S3_ALU_N353) );
  FA_X1 S3_ALU_add_113_U1_29 ( .A(S3_MUX_A_OUT[29]), .B(S3_MUX_B_OUT[29]), 
        .CI(S3_ALU_add_113_carry[29]), .CO(S3_ALU_add_113_carry[30]), .S(
        S3_ALU_N354) );
  FA_X1 S3_ALU_add_113_U1_30 ( .A(S3_MUX_A_OUT[30]), .B(S3_MUX_B_OUT[30]), 
        .CI(S3_ALU_add_113_carry[30]), .CO(S3_ALU_add_113_carry[31]), .S(
        S3_ALU_N355) );
  FA_X1 S3_ALU_add_113_U1_31 ( .A(S3_MUX_A_OUT[31]), .B(S3_MUX_B_OUT[31]), 
        .CI(S3_ALU_add_113_carry[31]), .S(S3_ALU_N356) );
  INV_X1 S3_ALU_sub_73_U35 ( .A(S3_MUX_B_OUT[31]), .ZN(S3_ALU_sub_73_n7) );
  INV_X1 S3_ALU_sub_73_U34 ( .A(S3_ALU_n150), .ZN(S3_ALU_sub_73_n2) );
  NAND2_X1 S3_ALU_sub_73_U33 ( .A1(S3_ALU_n150), .A2(S3_ALU_sub_73_n1), .ZN(
        S3_ALU_sub_73_carry[1]) );
  INV_X1 S3_ALU_sub_73_U32 ( .A(S3_MUX_B_OUT[1]), .ZN(S3_ALU_sub_73_n3) );
  INV_X1 S3_ALU_sub_73_U31 ( .A(S3_MUX_B_OUT[2]), .ZN(S3_ALU_sub_73_n4) );
  INV_X1 S3_ALU_sub_73_U30 ( .A(S3_MUX_B_OUT[3]), .ZN(S3_ALU_sub_73_n5) );
  INV_X1 S3_ALU_sub_73_U29 ( .A(S3_MUX_B_OUT[4]), .ZN(S3_ALU_sub_73_n6) );
  INV_X1 S3_ALU_sub_73_U28 ( .A(S3_MUX_B_OUT[5]), .ZN(S3_ALU_sub_73_n33) );
  INV_X1 S3_ALU_sub_73_U27 ( .A(S3_MUX_B_OUT[6]), .ZN(S3_ALU_sub_73_n32) );
  INV_X1 S3_ALU_sub_73_U26 ( .A(S3_MUX_B_OUT[7]), .ZN(S3_ALU_sub_73_n31) );
  INV_X1 S3_ALU_sub_73_U25 ( .A(S3_MUX_B_OUT[8]), .ZN(S3_ALU_sub_73_n30) );
  INV_X1 S3_ALU_sub_73_U24 ( .A(S3_MUX_B_OUT[9]), .ZN(S3_ALU_sub_73_n29) );
  INV_X1 S3_ALU_sub_73_U23 ( .A(S3_MUX_B_OUT[10]), .ZN(S3_ALU_sub_73_n28) );
  INV_X1 S3_ALU_sub_73_U22 ( .A(S3_MUX_B_OUT[11]), .ZN(S3_ALU_sub_73_n27) );
  INV_X1 S3_ALU_sub_73_U21 ( .A(S3_MUX_B_OUT[12]), .ZN(S3_ALU_sub_73_n26) );
  INV_X1 S3_ALU_sub_73_U20 ( .A(S3_MUX_B_OUT[13]), .ZN(S3_ALU_sub_73_n25) );
  INV_X1 S3_ALU_sub_73_U19 ( .A(S3_MUX_B_OUT[14]), .ZN(S3_ALU_sub_73_n24) );
  INV_X1 S3_ALU_sub_73_U18 ( .A(S3_MUX_B_OUT[15]), .ZN(S3_ALU_sub_73_n23) );
  INV_X1 S3_ALU_sub_73_U17 ( .A(S3_MUX_B_OUT[16]), .ZN(S3_ALU_sub_73_n22) );
  INV_X1 S3_ALU_sub_73_U16 ( .A(S3_MUX_B_OUT[17]), .ZN(S3_ALU_sub_73_n21) );
  INV_X1 S3_ALU_sub_73_U15 ( .A(S3_MUX_B_OUT[18]), .ZN(S3_ALU_sub_73_n20) );
  INV_X1 S3_ALU_sub_73_U14 ( .A(S3_MUX_B_OUT[19]), .ZN(S3_ALU_sub_73_n19) );
  INV_X1 S3_ALU_sub_73_U13 ( .A(S3_MUX_B_OUT[20]), .ZN(S3_ALU_sub_73_n18) );
  INV_X1 S3_ALU_sub_73_U12 ( .A(S3_MUX_B_OUT[21]), .ZN(S3_ALU_sub_73_n17) );
  INV_X1 S3_ALU_sub_73_U11 ( .A(S3_MUX_B_OUT[22]), .ZN(S3_ALU_sub_73_n16) );
  INV_X1 S3_ALU_sub_73_U10 ( .A(S3_MUX_B_OUT[23]), .ZN(S3_ALU_sub_73_n15) );
  INV_X1 S3_ALU_sub_73_U9 ( .A(S3_MUX_B_OUT[24]), .ZN(S3_ALU_sub_73_n14) );
  INV_X1 S3_ALU_sub_73_U8 ( .A(S3_MUX_B_OUT[25]), .ZN(S3_ALU_sub_73_n13) );
  INV_X1 S3_ALU_sub_73_U7 ( .A(S3_MUX_B_OUT[26]), .ZN(S3_ALU_sub_73_n12) );
  INV_X1 S3_ALU_sub_73_U6 ( .A(S3_MUX_B_OUT[27]), .ZN(S3_ALU_sub_73_n11) );
  INV_X1 S3_ALU_sub_73_U5 ( .A(S3_MUX_B_OUT[28]), .ZN(S3_ALU_sub_73_n10) );
  INV_X1 S3_ALU_sub_73_U4 ( .A(S3_MUX_B_OUT[29]), .ZN(S3_ALU_sub_73_n9) );
  INV_X1 S3_ALU_sub_73_U3 ( .A(S3_MUX_B_OUT[30]), .ZN(S3_ALU_sub_73_n8) );
  INV_X1 S3_ALU_sub_73_U2 ( .A(S3_MUX_A_OUT[0]), .ZN(S3_ALU_sub_73_n1) );
  XNOR2_X1 S3_ALU_sub_73_U1 ( .A(S3_ALU_sub_73_n2), .B(S3_MUX_A_OUT[0]), .ZN(
        S3_ALU_N194) );
  FA_X1 S3_ALU_sub_73_U2_1 ( .A(S3_MUX_A_OUT[1]), .B(S3_ALU_sub_73_n3), .CI(
        S3_ALU_sub_73_carry[1]), .CO(S3_ALU_sub_73_carry[2]), .S(S3_ALU_N195)
         );
  FA_X1 S3_ALU_sub_73_U2_2 ( .A(S3_MUX_A_OUT[2]), .B(S3_ALU_sub_73_n4), .CI(
        S3_ALU_sub_73_carry[2]), .CO(S3_ALU_sub_73_carry[3]), .S(S3_ALU_N196)
         );
  FA_X1 S3_ALU_sub_73_U2_3 ( .A(S3_MUX_A_OUT[3]), .B(S3_ALU_sub_73_n5), .CI(
        S3_ALU_sub_73_carry[3]), .CO(S3_ALU_sub_73_carry[4]), .S(S3_ALU_N197)
         );
  FA_X1 S3_ALU_sub_73_U2_4 ( .A(S3_MUX_A_OUT[4]), .B(S3_ALU_sub_73_n6), .CI(
        S3_ALU_sub_73_carry[4]), .CO(S3_ALU_sub_73_carry[5]), .S(S3_ALU_N198)
         );
  FA_X1 S3_ALU_sub_73_U2_5 ( .A(S3_MUX_A_OUT[5]), .B(S3_ALU_sub_73_n33), .CI(
        S3_ALU_sub_73_carry[5]), .CO(S3_ALU_sub_73_carry[6]), .S(S3_ALU_N199)
         );
  FA_X1 S3_ALU_sub_73_U2_6 ( .A(S3_MUX_A_OUT[6]), .B(S3_ALU_sub_73_n32), .CI(
        S3_ALU_sub_73_carry[6]), .CO(S3_ALU_sub_73_carry[7]), .S(S3_ALU_N200)
         );
  FA_X1 S3_ALU_sub_73_U2_7 ( .A(S3_MUX_A_OUT[7]), .B(S3_ALU_sub_73_n31), .CI(
        S3_ALU_sub_73_carry[7]), .CO(S3_ALU_sub_73_carry[8]), .S(S3_ALU_N201)
         );
  FA_X1 S3_ALU_sub_73_U2_8 ( .A(S3_MUX_A_OUT[8]), .B(S3_ALU_sub_73_n30), .CI(
        S3_ALU_sub_73_carry[8]), .CO(S3_ALU_sub_73_carry[9]), .S(S3_ALU_N202)
         );
  FA_X1 S3_ALU_sub_73_U2_9 ( .A(S3_MUX_A_OUT[9]), .B(S3_ALU_sub_73_n29), .CI(
        S3_ALU_sub_73_carry[9]), .CO(S3_ALU_sub_73_carry[10]), .S(S3_ALU_N203)
         );
  FA_X1 S3_ALU_sub_73_U2_10 ( .A(S3_MUX_A_OUT[10]), .B(S3_ALU_sub_73_n28), 
        .CI(S3_ALU_sub_73_carry[10]), .CO(S3_ALU_sub_73_carry[11]), .S(
        S3_ALU_N204) );
  FA_X1 S3_ALU_sub_73_U2_11 ( .A(S3_MUX_A_OUT[11]), .B(S3_ALU_sub_73_n27), 
        .CI(S3_ALU_sub_73_carry[11]), .CO(S3_ALU_sub_73_carry[12]), .S(
        S3_ALU_N205) );
  FA_X1 S3_ALU_sub_73_U2_12 ( .A(S3_MUX_A_OUT[12]), .B(S3_ALU_sub_73_n26), 
        .CI(S3_ALU_sub_73_carry[12]), .CO(S3_ALU_sub_73_carry[13]), .S(
        S3_ALU_N206) );
  FA_X1 S3_ALU_sub_73_U2_13 ( .A(S3_MUX_A_OUT[13]), .B(S3_ALU_sub_73_n25), 
        .CI(S3_ALU_sub_73_carry[13]), .CO(S3_ALU_sub_73_carry[14]), .S(
        S3_ALU_N207) );
  FA_X1 S3_ALU_sub_73_U2_14 ( .A(S3_MUX_A_OUT[14]), .B(S3_ALU_sub_73_n24), 
        .CI(S3_ALU_sub_73_carry[14]), .CO(S3_ALU_sub_73_carry[15]), .S(
        S3_ALU_N208) );
  FA_X1 S3_ALU_sub_73_U2_15 ( .A(S3_MUX_A_OUT[15]), .B(S3_ALU_sub_73_n23), 
        .CI(S3_ALU_sub_73_carry[15]), .CO(S3_ALU_sub_73_carry[16]), .S(
        S3_ALU_N209) );
  FA_X1 S3_ALU_sub_73_U2_16 ( .A(S3_MUX_A_OUT[16]), .B(S3_ALU_sub_73_n22), 
        .CI(S3_ALU_sub_73_carry[16]), .CO(S3_ALU_sub_73_carry[17]), .S(
        S3_ALU_N210) );
  FA_X1 S3_ALU_sub_73_U2_17 ( .A(S3_MUX_A_OUT[17]), .B(S3_ALU_sub_73_n21), 
        .CI(S3_ALU_sub_73_carry[17]), .CO(S3_ALU_sub_73_carry[18]), .S(
        S3_ALU_N211) );
  FA_X1 S3_ALU_sub_73_U2_18 ( .A(S3_MUX_A_OUT[18]), .B(S3_ALU_sub_73_n20), 
        .CI(S3_ALU_sub_73_carry[18]), .CO(S3_ALU_sub_73_carry[19]), .S(
        S3_ALU_N212) );
  FA_X1 S3_ALU_sub_73_U2_19 ( .A(S3_MUX_A_OUT[19]), .B(S3_ALU_sub_73_n19), 
        .CI(S3_ALU_sub_73_carry[19]), .CO(S3_ALU_sub_73_carry[20]), .S(
        S3_ALU_N213) );
  FA_X1 S3_ALU_sub_73_U2_20 ( .A(S3_MUX_A_OUT[20]), .B(S3_ALU_sub_73_n18), 
        .CI(S3_ALU_sub_73_carry[20]), .CO(S3_ALU_sub_73_carry[21]), .S(
        S3_ALU_N214) );
  FA_X1 S3_ALU_sub_73_U2_21 ( .A(S3_MUX_A_OUT[21]), .B(S3_ALU_sub_73_n17), 
        .CI(S3_ALU_sub_73_carry[21]), .CO(S3_ALU_sub_73_carry[22]), .S(
        S3_ALU_N215) );
  FA_X1 S3_ALU_sub_73_U2_22 ( .A(S3_MUX_A_OUT[22]), .B(S3_ALU_sub_73_n16), 
        .CI(S3_ALU_sub_73_carry[22]), .CO(S3_ALU_sub_73_carry[23]), .S(
        S3_ALU_N216) );
  FA_X1 S3_ALU_sub_73_U2_23 ( .A(S3_MUX_A_OUT[23]), .B(S3_ALU_sub_73_n15), 
        .CI(S3_ALU_sub_73_carry[23]), .CO(S3_ALU_sub_73_carry[24]), .S(
        S3_ALU_N217) );
  FA_X1 S3_ALU_sub_73_U2_24 ( .A(S3_MUX_A_OUT[24]), .B(S3_ALU_sub_73_n14), 
        .CI(S3_ALU_sub_73_carry[24]), .CO(S3_ALU_sub_73_carry[25]), .S(
        S3_ALU_N218) );
  FA_X1 S3_ALU_sub_73_U2_25 ( .A(S3_MUX_A_OUT[25]), .B(S3_ALU_sub_73_n13), 
        .CI(S3_ALU_sub_73_carry[25]), .CO(S3_ALU_sub_73_carry[26]), .S(
        S3_ALU_N219) );
  FA_X1 S3_ALU_sub_73_U2_26 ( .A(S3_MUX_A_OUT[26]), .B(S3_ALU_sub_73_n12), 
        .CI(S3_ALU_sub_73_carry[26]), .CO(S3_ALU_sub_73_carry[27]), .S(
        S3_ALU_N220) );
  FA_X1 S3_ALU_sub_73_U2_27 ( .A(S3_MUX_A_OUT[27]), .B(S3_ALU_sub_73_n11), 
        .CI(S3_ALU_sub_73_carry[27]), .CO(S3_ALU_sub_73_carry[28]), .S(
        S3_ALU_N221) );
  FA_X1 S3_ALU_sub_73_U2_28 ( .A(S3_MUX_A_OUT[28]), .B(S3_ALU_sub_73_n10), 
        .CI(S3_ALU_sub_73_carry[28]), .CO(S3_ALU_sub_73_carry[29]), .S(
        S3_ALU_N222) );
  FA_X1 S3_ALU_sub_73_U2_29 ( .A(S3_MUX_A_OUT[29]), .B(S3_ALU_sub_73_n9), .CI(
        S3_ALU_sub_73_carry[29]), .CO(S3_ALU_sub_73_carry[30]), .S(S3_ALU_N223) );
  FA_X1 S3_ALU_sub_73_U2_30 ( .A(S3_MUX_A_OUT[30]), .B(S3_ALU_sub_73_n8), .CI(
        S3_ALU_sub_73_carry[30]), .CO(S3_ALU_sub_73_carry[31]), .S(S3_ALU_N224) );
  FA_X1 S3_ALU_sub_73_U2_31 ( .A(S3_MUX_A_OUT[31]), .B(S3_ALU_sub_73_n7), .CI(
        S3_ALU_sub_73_carry[31]), .S(S3_ALU_N225) );
  AND2_X1 S3_ALU_add_70_U2 ( .A1(S3_ALU_n150), .A2(S3_MUX_A_OUT[0]), .ZN(
        S3_ALU_add_70_n2) );
  XOR2_X1 S3_ALU_add_70_U1 ( .A(S3_ALU_n150), .B(S3_MUX_A_OUT[0]), .Z(
        S3_ALU_N162) );
  FA_X1 S3_ALU_add_70_U1_1 ( .A(S3_MUX_A_OUT[1]), .B(S3_MUX_B_OUT[1]), .CI(
        S3_ALU_add_70_n2), .CO(S3_ALU_add_70_carry[2]), .S(S3_ALU_N163) );
  FA_X1 S3_ALU_add_70_U1_2 ( .A(S3_MUX_A_OUT[2]), .B(S3_MUX_B_OUT[2]), .CI(
        S3_ALU_add_70_carry[2]), .CO(S3_ALU_add_70_carry[3]), .S(S3_ALU_N164)
         );
  FA_X1 S3_ALU_add_70_U1_3 ( .A(S3_MUX_A_OUT[3]), .B(S3_MUX_B_OUT[3]), .CI(
        S3_ALU_add_70_carry[3]), .CO(S3_ALU_add_70_carry[4]), .S(S3_ALU_N165)
         );
  FA_X1 S3_ALU_add_70_U1_4 ( .A(S3_MUX_A_OUT[4]), .B(S3_MUX_B_OUT[4]), .CI(
        S3_ALU_add_70_carry[4]), .CO(S3_ALU_add_70_carry[5]), .S(S3_ALU_N166)
         );
  FA_X1 S3_ALU_add_70_U1_5 ( .A(S3_MUX_A_OUT[5]), .B(S3_MUX_B_OUT[5]), .CI(
        S3_ALU_add_70_carry[5]), .CO(S3_ALU_add_70_carry[6]), .S(S3_ALU_N167)
         );
  FA_X1 S3_ALU_add_70_U1_6 ( .A(S3_MUX_A_OUT[6]), .B(S3_MUX_B_OUT[6]), .CI(
        S3_ALU_add_70_carry[6]), .CO(S3_ALU_add_70_carry[7]), .S(S3_ALU_N168)
         );
  FA_X1 S3_ALU_add_70_U1_7 ( .A(S3_MUX_A_OUT[7]), .B(S3_MUX_B_OUT[7]), .CI(
        S3_ALU_add_70_carry[7]), .CO(S3_ALU_add_70_carry[8]), .S(S3_ALU_N169)
         );
  FA_X1 S3_ALU_add_70_U1_8 ( .A(S3_MUX_A_OUT[8]), .B(S3_MUX_B_OUT[8]), .CI(
        S3_ALU_add_70_carry[8]), .CO(S3_ALU_add_70_carry[9]), .S(S3_ALU_N170)
         );
  FA_X1 S3_ALU_add_70_U1_9 ( .A(S3_MUX_A_OUT[9]), .B(S3_MUX_B_OUT[9]), .CI(
        S3_ALU_add_70_carry[9]), .CO(S3_ALU_add_70_carry[10]), .S(S3_ALU_N171)
         );
  FA_X1 S3_ALU_add_70_U1_10 ( .A(S3_MUX_A_OUT[10]), .B(S3_MUX_B_OUT[10]), .CI(
        S3_ALU_add_70_carry[10]), .CO(S3_ALU_add_70_carry[11]), .S(S3_ALU_N172) );
  FA_X1 S3_ALU_add_70_U1_11 ( .A(S3_MUX_A_OUT[11]), .B(S3_MUX_B_OUT[11]), .CI(
        S3_ALU_add_70_carry[11]), .CO(S3_ALU_add_70_carry[12]), .S(S3_ALU_N173) );
  FA_X1 S3_ALU_add_70_U1_12 ( .A(S3_MUX_A_OUT[12]), .B(S3_MUX_B_OUT[12]), .CI(
        S3_ALU_add_70_carry[12]), .CO(S3_ALU_add_70_carry[13]), .S(S3_ALU_N174) );
  FA_X1 S3_ALU_add_70_U1_13 ( .A(S3_MUX_A_OUT[13]), .B(S3_MUX_B_OUT[13]), .CI(
        S3_ALU_add_70_carry[13]), .CO(S3_ALU_add_70_carry[14]), .S(S3_ALU_N175) );
  FA_X1 S3_ALU_add_70_U1_14 ( .A(S3_MUX_A_OUT[14]), .B(S3_MUX_B_OUT[14]), .CI(
        S3_ALU_add_70_carry[14]), .CO(S3_ALU_add_70_carry[15]), .S(S3_ALU_N176) );
  FA_X1 S3_ALU_add_70_U1_15 ( .A(S3_MUX_A_OUT[15]), .B(S3_MUX_B_OUT[15]), .CI(
        S3_ALU_add_70_carry[15]), .CO(S3_ALU_add_70_carry[16]), .S(S3_ALU_N177) );
  FA_X1 S3_ALU_add_70_U1_16 ( .A(S3_MUX_A_OUT[16]), .B(S3_MUX_B_OUT[16]), .CI(
        S3_ALU_add_70_carry[16]), .CO(S3_ALU_add_70_carry[17]), .S(S3_ALU_N178) );
  FA_X1 S3_ALU_add_70_U1_17 ( .A(S3_MUX_A_OUT[17]), .B(S3_MUX_B_OUT[17]), .CI(
        S3_ALU_add_70_carry[17]), .CO(S3_ALU_add_70_carry[18]), .S(S3_ALU_N179) );
  FA_X1 S3_ALU_add_70_U1_18 ( .A(S3_MUX_A_OUT[18]), .B(S3_MUX_B_OUT[18]), .CI(
        S3_ALU_add_70_carry[18]), .CO(S3_ALU_add_70_carry[19]), .S(S3_ALU_N180) );
  FA_X1 S3_ALU_add_70_U1_19 ( .A(S3_MUX_A_OUT[19]), .B(S3_MUX_B_OUT[19]), .CI(
        S3_ALU_add_70_carry[19]), .CO(S3_ALU_add_70_carry[20]), .S(S3_ALU_N181) );
  FA_X1 S3_ALU_add_70_U1_20 ( .A(S3_MUX_A_OUT[20]), .B(S3_MUX_B_OUT[20]), .CI(
        S3_ALU_add_70_carry[20]), .CO(S3_ALU_add_70_carry[21]), .S(S3_ALU_N182) );
  FA_X1 S3_ALU_add_70_U1_21 ( .A(S3_MUX_A_OUT[21]), .B(S3_MUX_B_OUT[21]), .CI(
        S3_ALU_add_70_carry[21]), .CO(S3_ALU_add_70_carry[22]), .S(S3_ALU_N183) );
  FA_X1 S3_ALU_add_70_U1_22 ( .A(S3_MUX_A_OUT[22]), .B(S3_MUX_B_OUT[22]), .CI(
        S3_ALU_add_70_carry[22]), .CO(S3_ALU_add_70_carry[23]), .S(S3_ALU_N184) );
  FA_X1 S3_ALU_add_70_U1_23 ( .A(S3_MUX_A_OUT[23]), .B(S3_MUX_B_OUT[23]), .CI(
        S3_ALU_add_70_carry[23]), .CO(S3_ALU_add_70_carry[24]), .S(S3_ALU_N185) );
  FA_X1 S3_ALU_add_70_U1_24 ( .A(S3_MUX_A_OUT[24]), .B(S3_MUX_B_OUT[24]), .CI(
        S3_ALU_add_70_carry[24]), .CO(S3_ALU_add_70_carry[25]), .S(S3_ALU_N186) );
  FA_X1 S3_ALU_add_70_U1_25 ( .A(S3_MUX_A_OUT[25]), .B(S3_MUX_B_OUT[25]), .CI(
        S3_ALU_add_70_carry[25]), .CO(S3_ALU_add_70_carry[26]), .S(S3_ALU_N187) );
  FA_X1 S3_ALU_add_70_U1_26 ( .A(S3_MUX_A_OUT[26]), .B(S3_MUX_B_OUT[26]), .CI(
        S3_ALU_add_70_carry[26]), .CO(S3_ALU_add_70_carry[27]), .S(S3_ALU_N188) );
  FA_X1 S3_ALU_add_70_U1_27 ( .A(S3_MUX_A_OUT[27]), .B(S3_MUX_B_OUT[27]), .CI(
        S3_ALU_add_70_carry[27]), .CO(S3_ALU_add_70_carry[28]), .S(S3_ALU_N189) );
  FA_X1 S3_ALU_add_70_U1_28 ( .A(S3_MUX_A_OUT[28]), .B(S3_MUX_B_OUT[28]), .CI(
        S3_ALU_add_70_carry[28]), .CO(S3_ALU_add_70_carry[29]), .S(S3_ALU_N190) );
  FA_X1 S3_ALU_add_70_U1_29 ( .A(S3_MUX_A_OUT[29]), .B(S3_MUX_B_OUT[29]), .CI(
        S3_ALU_add_70_carry[29]), .CO(S3_ALU_add_70_carry[30]), .S(S3_ALU_N191) );
  FA_X1 S3_ALU_add_70_U1_30 ( .A(S3_MUX_A_OUT[30]), .B(S3_MUX_B_OUT[30]), .CI(
        S3_ALU_add_70_carry[30]), .CO(S3_ALU_add_70_carry[31]), .S(S3_ALU_N192) );
  FA_X1 S3_ALU_add_70_U1_31 ( .A(S3_MUX_A_OUT[31]), .B(S3_MUX_B_OUT[31]), .CI(
        S3_ALU_add_70_carry[31]), .S(S3_ALU_N193) );
  NOR2_X1 S3_ALU_r396_U205 ( .A1(S3_ALU_r396_n64), .A2(S3_MUX_A_OUT[31]), .ZN(
        S3_ALU_r396_n67) );
  NOR2_X1 S3_ALU_r396_U204 ( .A1(S3_ALU_r396_n9), .A2(S3_MUX_B_OUT[28]), .ZN(
        S3_ALU_r396_n163) );
  NOR2_X1 S3_ALU_r396_U203 ( .A1(S3_ALU_r396_n8), .A2(S3_MUX_B_OUT[29]), .ZN(
        S3_ALU_r396_n73) );
  NOR2_X1 S3_ALU_r396_U202 ( .A1(S3_ALU_r396_n163), .A2(S3_ALU_r396_n73), .ZN(
        S3_ALU_r396_n159) );
  NOR2_X1 S3_ALU_r396_U201 ( .A1(S3_ALU_r396_n17), .A2(S3_MUX_B_OUT[24]), .ZN(
        S3_ALU_r396_n169) );
  NOR2_X1 S3_ALU_r396_U200 ( .A1(S3_ALU_r396_n16), .A2(S3_MUX_B_OUT[25]), .ZN(
        S3_ALU_r396_n85) );
  NOR2_X1 S3_ALU_r396_U199 ( .A1(S3_ALU_r396_n169), .A2(S3_ALU_r396_n85), .ZN(
        S3_ALU_r396_n165) );
  NOR2_X1 S3_ALU_r396_U198 ( .A1(S3_ALU_r396_n25), .A2(S3_MUX_B_OUT[20]), .ZN(
        S3_ALU_r396_n175) );
  NOR2_X1 S3_ALU_r396_U197 ( .A1(S3_ALU_r396_n24), .A2(S3_MUX_B_OUT[21]), .ZN(
        S3_ALU_r396_n97) );
  NOR2_X1 S3_ALU_r396_U196 ( .A1(S3_ALU_r396_n175), .A2(S3_ALU_r396_n97), .ZN(
        S3_ALU_r396_n171) );
  NOR2_X1 S3_ALU_r396_U195 ( .A1(S3_ALU_r396_n33), .A2(S3_MUX_B_OUT[16]), .ZN(
        S3_ALU_r396_n181) );
  NOR2_X1 S3_ALU_r396_U194 ( .A1(S3_ALU_r396_n32), .A2(S3_MUX_B_OUT[17]), .ZN(
        S3_ALU_r396_n109) );
  NOR2_X1 S3_ALU_r396_U193 ( .A1(S3_ALU_r396_n181), .A2(S3_ALU_r396_n109), 
        .ZN(S3_ALU_r396_n177) );
  NOR2_X1 S3_ALU_r396_U192 ( .A1(S3_ALU_r396_n41), .A2(S3_MUX_B_OUT[12]), .ZN(
        S3_ALU_r396_n187) );
  NOR2_X1 S3_ALU_r396_U191 ( .A1(S3_ALU_r396_n40), .A2(S3_MUX_B_OUT[13]), .ZN(
        S3_ALU_r396_n121) );
  NOR2_X1 S3_ALU_r396_U190 ( .A1(S3_ALU_r396_n187), .A2(S3_ALU_r396_n121), 
        .ZN(S3_ALU_r396_n183) );
  NOR2_X1 S3_ALU_r396_U189 ( .A1(S3_ALU_r396_n49), .A2(S3_MUX_B_OUT[8]), .ZN(
        S3_ALU_r396_n193) );
  NOR2_X1 S3_ALU_r396_U188 ( .A1(S3_ALU_r396_n48), .A2(S3_MUX_B_OUT[9]), .ZN(
        S3_ALU_r396_n133) );
  NOR2_X1 S3_ALU_r396_U187 ( .A1(S3_ALU_r396_n193), .A2(S3_ALU_r396_n133), 
        .ZN(S3_ALU_r396_n189) );
  NOR2_X1 S3_ALU_r396_U186 ( .A1(S3_ALU_r396_n57), .A2(S3_MUX_B_OUT[4]), .ZN(
        S3_ALU_r396_n198) );
  NOR2_X1 S3_ALU_r396_U185 ( .A1(S3_ALU_r396_n56), .A2(S3_MUX_B_OUT[5]), .ZN(
        S3_ALU_r396_n145) );
  NOR2_X1 S3_ALU_r396_U184 ( .A1(S3_ALU_r396_n198), .A2(S3_ALU_r396_n145), 
        .ZN(S3_ALU_r396_n195) );
  NOR2_X1 S3_ALU_r396_U183 ( .A1(S3_ALU_r396_n59), .A2(S3_MUX_B_OUT[3]), .ZN(
        S3_ALU_r396_n151) );
  OR2_X1 S3_ALU_r396_U182 ( .A1(S3_ALU_r396_n61), .A2(S3_MUX_B_OUT[2]), .ZN(
        S3_ALU_r396_n199) );
  NOR2_X1 S3_ALU_r396_U181 ( .A1(S3_ALU_r396_n63), .A2(S3_ALU_n150), .ZN(
        S3_ALU_r396_n201) );
  AOI21_X1 S3_ALU_r396_U180 ( .B1(S3_MUX_A_OUT[1]), .B2(S3_ALU_r396_n201), .A(
        S3_ALU_r396_n1), .ZN(S3_ALU_r396_n202) );
  NAND2_X1 S3_ALU_r396_U179 ( .A1(S3_MUX_B_OUT[2]), .A2(S3_ALU_r396_n61), .ZN(
        S3_ALU_r396_n154) );
  AND2_X1 S3_ALU_r396_U178 ( .A1(S3_ALU_r396_n199), .A2(S3_ALU_r396_n154), 
        .ZN(S3_ALU_r396_n153) );
  OAI211_X1 S3_ALU_r396_U177 ( .C1(S3_MUX_A_OUT[1]), .C2(S3_ALU_r396_n201), 
        .A(S3_ALU_r396_n62), .B(S3_ALU_r396_n153), .ZN(S3_ALU_r396_n200) );
  NAND3_X1 S3_ALU_r396_U176 ( .A1(S3_ALU_r396_n58), .A2(S3_ALU_r396_n199), 
        .A3(S3_ALU_r396_n200), .ZN(S3_ALU_r396_n197) );
  NAND2_X1 S3_ALU_r396_U175 ( .A1(S3_MUX_B_OUT[3]), .A2(S3_ALU_r396_n59), .ZN(
        S3_ALU_r396_n150) );
  AND2_X1 S3_ALU_r396_U174 ( .A1(S3_MUX_B_OUT[4]), .A2(S3_ALU_r396_n57), .ZN(
        S3_ALU_r396_n148) );
  NOR2_X1 S3_ALU_r396_U173 ( .A1(S3_ALU_r396_n198), .A2(S3_ALU_r396_n148), 
        .ZN(S3_ALU_r396_n147) );
  NAND3_X1 S3_ALU_r396_U172 ( .A1(S3_ALU_r396_n197), .A2(S3_ALU_r396_n150), 
        .A3(S3_ALU_r396_n147), .ZN(S3_ALU_r396_n196) );
  OR2_X1 S3_ALU_r396_U171 ( .A1(S3_ALU_r396_n54), .A2(S3_MUX_B_OUT[6]), .ZN(
        S3_ALU_r396_n194) );
  NAND2_X1 S3_ALU_r396_U170 ( .A1(S3_MUX_B_OUT[6]), .A2(S3_ALU_r396_n54), .ZN(
        S3_ALU_r396_n141) );
  NAND2_X1 S3_ALU_r396_U169 ( .A1(S3_ALU_r396_n194), .A2(S3_ALU_r396_n141), 
        .ZN(S3_ALU_r396_n142) );
  NAND2_X1 S3_ALU_r396_U168 ( .A1(S3_MUX_B_OUT[5]), .A2(S3_ALU_r396_n56), .ZN(
        S3_ALU_r396_n144) );
  AOI211_X1 S3_ALU_r396_U167 ( .C1(S3_ALU_r396_n195), .C2(S3_ALU_r396_n196), 
        .A(S3_ALU_r396_n142), .B(S3_ALU_r396_n55), .ZN(S3_ALU_r396_n191) );
  NOR2_X1 S3_ALU_r396_U166 ( .A1(S3_ALU_r396_n51), .A2(S3_MUX_B_OUT[7]), .ZN(
        S3_ALU_r396_n139) );
  NAND2_X1 S3_ALU_r396_U165 ( .A1(S3_ALU_r396_n50), .A2(S3_ALU_r396_n194), 
        .ZN(S3_ALU_r396_n192) );
  NAND2_X1 S3_ALU_r396_U164 ( .A1(S3_MUX_B_OUT[7]), .A2(S3_ALU_r396_n51), .ZN(
        S3_ALU_r396_n138) );
  AND2_X1 S3_ALU_r396_U163 ( .A1(S3_MUX_B_OUT[8]), .A2(S3_ALU_r396_n49), .ZN(
        S3_ALU_r396_n136) );
  NOR2_X1 S3_ALU_r396_U162 ( .A1(S3_ALU_r396_n193), .A2(S3_ALU_r396_n136), 
        .ZN(S3_ALU_r396_n135) );
  OAI211_X1 S3_ALU_r396_U161 ( .C1(S3_ALU_r396_n191), .C2(S3_ALU_r396_n192), 
        .A(S3_ALU_r396_n138), .B(S3_ALU_r396_n135), .ZN(S3_ALU_r396_n190) );
  OR2_X1 S3_ALU_r396_U160 ( .A1(S3_ALU_r396_n46), .A2(S3_MUX_B_OUT[10]), .ZN(
        S3_ALU_r396_n188) );
  NAND2_X1 S3_ALU_r396_U159 ( .A1(S3_MUX_B_OUT[10]), .A2(S3_ALU_r396_n46), 
        .ZN(S3_ALU_r396_n129) );
  NAND2_X1 S3_ALU_r396_U158 ( .A1(S3_ALU_r396_n188), .A2(S3_ALU_r396_n129), 
        .ZN(S3_ALU_r396_n130) );
  NAND2_X1 S3_ALU_r396_U157 ( .A1(S3_MUX_B_OUT[9]), .A2(S3_ALU_r396_n48), .ZN(
        S3_ALU_r396_n132) );
  AOI211_X1 S3_ALU_r396_U156 ( .C1(S3_ALU_r396_n189), .C2(S3_ALU_r396_n190), 
        .A(S3_ALU_r396_n130), .B(S3_ALU_r396_n47), .ZN(S3_ALU_r396_n185) );
  NOR2_X1 S3_ALU_r396_U155 ( .A1(S3_ALU_r396_n43), .A2(S3_MUX_B_OUT[11]), .ZN(
        S3_ALU_r396_n127) );
  NAND2_X1 S3_ALU_r396_U154 ( .A1(S3_ALU_r396_n42), .A2(S3_ALU_r396_n188), 
        .ZN(S3_ALU_r396_n186) );
  NAND2_X1 S3_ALU_r396_U153 ( .A1(S3_MUX_B_OUT[11]), .A2(S3_ALU_r396_n43), 
        .ZN(S3_ALU_r396_n126) );
  AND2_X1 S3_ALU_r396_U152 ( .A1(S3_MUX_B_OUT[12]), .A2(S3_ALU_r396_n41), .ZN(
        S3_ALU_r396_n124) );
  NOR2_X1 S3_ALU_r396_U151 ( .A1(S3_ALU_r396_n187), .A2(S3_ALU_r396_n124), 
        .ZN(S3_ALU_r396_n123) );
  OAI211_X1 S3_ALU_r396_U150 ( .C1(S3_ALU_r396_n185), .C2(S3_ALU_r396_n186), 
        .A(S3_ALU_r396_n126), .B(S3_ALU_r396_n123), .ZN(S3_ALU_r396_n184) );
  OR2_X1 S3_ALU_r396_U149 ( .A1(S3_ALU_r396_n38), .A2(S3_MUX_B_OUT[14]), .ZN(
        S3_ALU_r396_n182) );
  NAND2_X1 S3_ALU_r396_U148 ( .A1(S3_MUX_B_OUT[14]), .A2(S3_ALU_r396_n38), 
        .ZN(S3_ALU_r396_n117) );
  NAND2_X1 S3_ALU_r396_U147 ( .A1(S3_ALU_r396_n182), .A2(S3_ALU_r396_n117), 
        .ZN(S3_ALU_r396_n118) );
  NAND2_X1 S3_ALU_r396_U146 ( .A1(S3_MUX_B_OUT[13]), .A2(S3_ALU_r396_n40), 
        .ZN(S3_ALU_r396_n120) );
  AOI211_X1 S3_ALU_r396_U145 ( .C1(S3_ALU_r396_n183), .C2(S3_ALU_r396_n184), 
        .A(S3_ALU_r396_n118), .B(S3_ALU_r396_n39), .ZN(S3_ALU_r396_n179) );
  NOR2_X1 S3_ALU_r396_U144 ( .A1(S3_ALU_r396_n35), .A2(S3_MUX_B_OUT[15]), .ZN(
        S3_ALU_r396_n115) );
  NAND2_X1 S3_ALU_r396_U143 ( .A1(S3_ALU_r396_n34), .A2(S3_ALU_r396_n182), 
        .ZN(S3_ALU_r396_n180) );
  NAND2_X1 S3_ALU_r396_U142 ( .A1(S3_MUX_B_OUT[15]), .A2(S3_ALU_r396_n35), 
        .ZN(S3_ALU_r396_n114) );
  AND2_X1 S3_ALU_r396_U141 ( .A1(S3_MUX_B_OUT[16]), .A2(S3_ALU_r396_n33), .ZN(
        S3_ALU_r396_n112) );
  NOR2_X1 S3_ALU_r396_U140 ( .A1(S3_ALU_r396_n181), .A2(S3_ALU_r396_n112), 
        .ZN(S3_ALU_r396_n111) );
  OAI211_X1 S3_ALU_r396_U139 ( .C1(S3_ALU_r396_n179), .C2(S3_ALU_r396_n180), 
        .A(S3_ALU_r396_n114), .B(S3_ALU_r396_n111), .ZN(S3_ALU_r396_n178) );
  OR2_X1 S3_ALU_r396_U138 ( .A1(S3_ALU_r396_n30), .A2(S3_MUX_B_OUT[18]), .ZN(
        S3_ALU_r396_n176) );
  NAND2_X1 S3_ALU_r396_U137 ( .A1(S3_MUX_B_OUT[18]), .A2(S3_ALU_r396_n30), 
        .ZN(S3_ALU_r396_n105) );
  NAND2_X1 S3_ALU_r396_U136 ( .A1(S3_ALU_r396_n176), .A2(S3_ALU_r396_n105), 
        .ZN(S3_ALU_r396_n106) );
  NAND2_X1 S3_ALU_r396_U135 ( .A1(S3_MUX_B_OUT[17]), .A2(S3_ALU_r396_n32), 
        .ZN(S3_ALU_r396_n108) );
  AOI211_X1 S3_ALU_r396_U134 ( .C1(S3_ALU_r396_n177), .C2(S3_ALU_r396_n178), 
        .A(S3_ALU_r396_n106), .B(S3_ALU_r396_n31), .ZN(S3_ALU_r396_n173) );
  NOR2_X1 S3_ALU_r396_U133 ( .A1(S3_ALU_r396_n27), .A2(S3_MUX_B_OUT[19]), .ZN(
        S3_ALU_r396_n103) );
  NAND2_X1 S3_ALU_r396_U132 ( .A1(S3_ALU_r396_n26), .A2(S3_ALU_r396_n176), 
        .ZN(S3_ALU_r396_n174) );
  NAND2_X1 S3_ALU_r396_U131 ( .A1(S3_MUX_B_OUT[19]), .A2(S3_ALU_r396_n27), 
        .ZN(S3_ALU_r396_n102) );
  AND2_X1 S3_ALU_r396_U130 ( .A1(S3_MUX_B_OUT[20]), .A2(S3_ALU_r396_n25), .ZN(
        S3_ALU_r396_n100) );
  NOR2_X1 S3_ALU_r396_U129 ( .A1(S3_ALU_r396_n175), .A2(S3_ALU_r396_n100), 
        .ZN(S3_ALU_r396_n99) );
  OAI211_X1 S3_ALU_r396_U128 ( .C1(S3_ALU_r396_n173), .C2(S3_ALU_r396_n174), 
        .A(S3_ALU_r396_n102), .B(S3_ALU_r396_n99), .ZN(S3_ALU_r396_n172) );
  OR2_X1 S3_ALU_r396_U127 ( .A1(S3_ALU_r396_n22), .A2(S3_MUX_B_OUT[22]), .ZN(
        S3_ALU_r396_n170) );
  NAND2_X1 S3_ALU_r396_U126 ( .A1(S3_MUX_B_OUT[22]), .A2(S3_ALU_r396_n22), 
        .ZN(S3_ALU_r396_n93) );
  NAND2_X1 S3_ALU_r396_U125 ( .A1(S3_ALU_r396_n170), .A2(S3_ALU_r396_n93), 
        .ZN(S3_ALU_r396_n94) );
  NAND2_X1 S3_ALU_r396_U124 ( .A1(S3_MUX_B_OUT[21]), .A2(S3_ALU_r396_n24), 
        .ZN(S3_ALU_r396_n96) );
  AOI211_X1 S3_ALU_r396_U123 ( .C1(S3_ALU_r396_n171), .C2(S3_ALU_r396_n172), 
        .A(S3_ALU_r396_n94), .B(S3_ALU_r396_n23), .ZN(S3_ALU_r396_n167) );
  NOR2_X1 S3_ALU_r396_U122 ( .A1(S3_ALU_r396_n19), .A2(S3_MUX_B_OUT[23]), .ZN(
        S3_ALU_r396_n91) );
  NAND2_X1 S3_ALU_r396_U121 ( .A1(S3_ALU_r396_n18), .A2(S3_ALU_r396_n170), 
        .ZN(S3_ALU_r396_n168) );
  NAND2_X1 S3_ALU_r396_U120 ( .A1(S3_MUX_B_OUT[23]), .A2(S3_ALU_r396_n19), 
        .ZN(S3_ALU_r396_n90) );
  AND2_X1 S3_ALU_r396_U119 ( .A1(S3_MUX_B_OUT[24]), .A2(S3_ALU_r396_n17), .ZN(
        S3_ALU_r396_n88) );
  NOR2_X1 S3_ALU_r396_U118 ( .A1(S3_ALU_r396_n169), .A2(S3_ALU_r396_n88), .ZN(
        S3_ALU_r396_n87) );
  OAI211_X1 S3_ALU_r396_U117 ( .C1(S3_ALU_r396_n167), .C2(S3_ALU_r396_n168), 
        .A(S3_ALU_r396_n90), .B(S3_ALU_r396_n87), .ZN(S3_ALU_r396_n166) );
  OR2_X1 S3_ALU_r396_U116 ( .A1(S3_ALU_r396_n14), .A2(S3_MUX_B_OUT[26]), .ZN(
        S3_ALU_r396_n164) );
  NAND2_X1 S3_ALU_r396_U115 ( .A1(S3_MUX_B_OUT[26]), .A2(S3_ALU_r396_n14), 
        .ZN(S3_ALU_r396_n81) );
  NAND2_X1 S3_ALU_r396_U114 ( .A1(S3_ALU_r396_n164), .A2(S3_ALU_r396_n81), 
        .ZN(S3_ALU_r396_n82) );
  NAND2_X1 S3_ALU_r396_U113 ( .A1(S3_MUX_B_OUT[25]), .A2(S3_ALU_r396_n16), 
        .ZN(S3_ALU_r396_n84) );
  AOI211_X1 S3_ALU_r396_U112 ( .C1(S3_ALU_r396_n165), .C2(S3_ALU_r396_n166), 
        .A(S3_ALU_r396_n82), .B(S3_ALU_r396_n15), .ZN(S3_ALU_r396_n161) );
  NOR2_X1 S3_ALU_r396_U111 ( .A1(S3_ALU_r396_n11), .A2(S3_MUX_B_OUT[27]), .ZN(
        S3_ALU_r396_n79) );
  NAND2_X1 S3_ALU_r396_U110 ( .A1(S3_ALU_r396_n10), .A2(S3_ALU_r396_n164), 
        .ZN(S3_ALU_r396_n162) );
  NAND2_X1 S3_ALU_r396_U109 ( .A1(S3_MUX_B_OUT[27]), .A2(S3_ALU_r396_n11), 
        .ZN(S3_ALU_r396_n78) );
  AND2_X1 S3_ALU_r396_U108 ( .A1(S3_MUX_B_OUT[28]), .A2(S3_ALU_r396_n9), .ZN(
        S3_ALU_r396_n76) );
  NOR2_X1 S3_ALU_r396_U107 ( .A1(S3_ALU_r396_n163), .A2(S3_ALU_r396_n76), .ZN(
        S3_ALU_r396_n75) );
  OAI211_X1 S3_ALU_r396_U106 ( .C1(S3_ALU_r396_n161), .C2(S3_ALU_r396_n162), 
        .A(S3_ALU_r396_n78), .B(S3_ALU_r396_n75), .ZN(S3_ALU_r396_n160) );
  NAND2_X1 S3_ALU_r396_U105 ( .A1(S3_MUX_B_OUT[29]), .A2(S3_ALU_r396_n8), .ZN(
        S3_ALU_r396_n72) );
  AOI21_X1 S3_ALU_r396_U104 ( .B1(S3_ALU_r396_n159), .B2(S3_ALU_r396_n160), 
        .A(S3_ALU_r396_n7), .ZN(S3_ALU_r396_n158) );
  XOR2_X1 S3_ALU_r396_U103 ( .A(S3_MUX_A_OUT[30]), .B(S3_ALU_r396_n65), .Z(
        S3_ALU_r396_n70) );
  AOI22_X1 S3_ALU_r396_U102 ( .A1(S3_MUX_A_OUT[30]), .A2(S3_ALU_r396_n65), 
        .B1(S3_ALU_r396_n158), .B2(S3_ALU_r396_n70), .ZN(S3_ALU_r396_n157) );
  NAND2_X1 S3_ALU_r396_U101 ( .A1(S3_MUX_A_OUT[31]), .A2(S3_ALU_r396_n64), 
        .ZN(S3_ALU_r396_n66) );
  OAI21_X1 S3_ALU_r396_U100 ( .B1(S3_ALU_r396_n67), .B2(S3_ALU_r396_n157), .A(
        S3_ALU_r396_n66), .ZN(S3_ALU_N393) );
  NAND2_X1 S3_ALU_r396_U99 ( .A1(S3_ALU_n150), .A2(S3_ALU_r396_n63), .ZN(
        S3_ALU_r396_n156) );
  OR2_X1 S3_ALU_r396_U98 ( .A1(S3_ALU_r396_n156), .A2(S3_MUX_A_OUT[1]), .ZN(
        S3_ALU_r396_n155) );
  AOI22_X1 S3_ALU_r396_U97 ( .A1(S3_ALU_r396_n155), .A2(S3_ALU_r396_n1), .B1(
        S3_MUX_A_OUT[1]), .B2(S3_ALU_r396_n156), .ZN(S3_ALU_r396_n152) );
  AOI21_X1 S3_ALU_r396_U96 ( .B1(S3_ALU_r396_n152), .B2(S3_ALU_r396_n153), .A(
        S3_ALU_r396_n60), .ZN(S3_ALU_r396_n149) );
  AOI21_X1 S3_ALU_r396_U95 ( .B1(S3_ALU_r396_n149), .B2(S3_ALU_r396_n150), .A(
        S3_ALU_r396_n151), .ZN(S3_ALU_r396_n146) );
  AOI21_X1 S3_ALU_r396_U94 ( .B1(S3_ALU_r396_n146), .B2(S3_ALU_r396_n147), .A(
        S3_ALU_r396_n148), .ZN(S3_ALU_r396_n143) );
  AOI21_X1 S3_ALU_r396_U93 ( .B1(S3_ALU_r396_n143), .B2(S3_ALU_r396_n144), .A(
        S3_ALU_r396_n145), .ZN(S3_ALU_r396_n140) );
  AOI21_X1 S3_ALU_r396_U92 ( .B1(S3_ALU_r396_n140), .B2(S3_ALU_r396_n52), .A(
        S3_ALU_r396_n53), .ZN(S3_ALU_r396_n137) );
  AOI21_X1 S3_ALU_r396_U91 ( .B1(S3_ALU_r396_n137), .B2(S3_ALU_r396_n138), .A(
        S3_ALU_r396_n139), .ZN(S3_ALU_r396_n134) );
  AOI21_X1 S3_ALU_r396_U90 ( .B1(S3_ALU_r396_n134), .B2(S3_ALU_r396_n135), .A(
        S3_ALU_r396_n136), .ZN(S3_ALU_r396_n131) );
  AOI21_X1 S3_ALU_r396_U89 ( .B1(S3_ALU_r396_n131), .B2(S3_ALU_r396_n132), .A(
        S3_ALU_r396_n133), .ZN(S3_ALU_r396_n128) );
  AOI21_X1 S3_ALU_r396_U88 ( .B1(S3_ALU_r396_n128), .B2(S3_ALU_r396_n44), .A(
        S3_ALU_r396_n45), .ZN(S3_ALU_r396_n125) );
  AOI21_X1 S3_ALU_r396_U87 ( .B1(S3_ALU_r396_n125), .B2(S3_ALU_r396_n126), .A(
        S3_ALU_r396_n127), .ZN(S3_ALU_r396_n122) );
  AOI21_X1 S3_ALU_r396_U86 ( .B1(S3_ALU_r396_n122), .B2(S3_ALU_r396_n123), .A(
        S3_ALU_r396_n124), .ZN(S3_ALU_r396_n119) );
  AOI21_X1 S3_ALU_r396_U85 ( .B1(S3_ALU_r396_n119), .B2(S3_ALU_r396_n120), .A(
        S3_ALU_r396_n121), .ZN(S3_ALU_r396_n116) );
  AOI21_X1 S3_ALU_r396_U84 ( .B1(S3_ALU_r396_n116), .B2(S3_ALU_r396_n36), .A(
        S3_ALU_r396_n37), .ZN(S3_ALU_r396_n113) );
  AOI21_X1 S3_ALU_r396_U83 ( .B1(S3_ALU_r396_n113), .B2(S3_ALU_r396_n114), .A(
        S3_ALU_r396_n115), .ZN(S3_ALU_r396_n110) );
  AOI21_X1 S3_ALU_r396_U82 ( .B1(S3_ALU_r396_n110), .B2(S3_ALU_r396_n111), .A(
        S3_ALU_r396_n112), .ZN(S3_ALU_r396_n107) );
  AOI21_X1 S3_ALU_r396_U81 ( .B1(S3_ALU_r396_n107), .B2(S3_ALU_r396_n108), .A(
        S3_ALU_r396_n109), .ZN(S3_ALU_r396_n104) );
  AOI21_X1 S3_ALU_r396_U80 ( .B1(S3_ALU_r396_n104), .B2(S3_ALU_r396_n28), .A(
        S3_ALU_r396_n29), .ZN(S3_ALU_r396_n101) );
  AOI21_X1 S3_ALU_r396_U79 ( .B1(S3_ALU_r396_n101), .B2(S3_ALU_r396_n102), .A(
        S3_ALU_r396_n103), .ZN(S3_ALU_r396_n98) );
  AOI21_X1 S3_ALU_r396_U78 ( .B1(S3_ALU_r396_n98), .B2(S3_ALU_r396_n99), .A(
        S3_ALU_r396_n100), .ZN(S3_ALU_r396_n95) );
  AOI21_X1 S3_ALU_r396_U77 ( .B1(S3_ALU_r396_n95), .B2(S3_ALU_r396_n96), .A(
        S3_ALU_r396_n97), .ZN(S3_ALU_r396_n92) );
  AOI21_X1 S3_ALU_r396_U76 ( .B1(S3_ALU_r396_n92), .B2(S3_ALU_r396_n20), .A(
        S3_ALU_r396_n21), .ZN(S3_ALU_r396_n89) );
  AOI21_X1 S3_ALU_r396_U75 ( .B1(S3_ALU_r396_n89), .B2(S3_ALU_r396_n90), .A(
        S3_ALU_r396_n91), .ZN(S3_ALU_r396_n86) );
  AOI21_X1 S3_ALU_r396_U74 ( .B1(S3_ALU_r396_n86), .B2(S3_ALU_r396_n87), .A(
        S3_ALU_r396_n88), .ZN(S3_ALU_r396_n83) );
  AOI21_X1 S3_ALU_r396_U73 ( .B1(S3_ALU_r396_n83), .B2(S3_ALU_r396_n84), .A(
        S3_ALU_r396_n85), .ZN(S3_ALU_r396_n80) );
  AOI21_X1 S3_ALU_r396_U72 ( .B1(S3_ALU_r396_n80), .B2(S3_ALU_r396_n12), .A(
        S3_ALU_r396_n13), .ZN(S3_ALU_r396_n77) );
  AOI21_X1 S3_ALU_r396_U71 ( .B1(S3_ALU_r396_n77), .B2(S3_ALU_r396_n78), .A(
        S3_ALU_r396_n79), .ZN(S3_ALU_r396_n74) );
  AOI21_X1 S3_ALU_r396_U70 ( .B1(S3_ALU_r396_n74), .B2(S3_ALU_r396_n75), .A(
        S3_ALU_r396_n76), .ZN(S3_ALU_r396_n71) );
  AOI21_X1 S3_ALU_r396_U69 ( .B1(S3_ALU_r396_n71), .B2(S3_ALU_r396_n72), .A(
        S3_ALU_r396_n73), .ZN(S3_ALU_r396_n69) );
  AOI22_X1 S3_ALU_r396_U68 ( .A1(S3_MUX_B_OUT[30]), .A2(S3_ALU_r396_n6), .B1(
        S3_ALU_r396_n69), .B2(S3_ALU_r396_n70), .ZN(S3_ALU_r396_n68) );
  AOI21_X1 S3_ALU_r396_U67 ( .B1(S3_ALU_r396_n66), .B2(S3_ALU_r396_n5), .A(
        S3_ALU_r396_n67), .ZN(S3_ALU_N395) );
  NAND2_X1 S3_ALU_r396_U66 ( .A1(S3_ALU_N394), .A2(S3_ALU_N395), .ZN(
        S3_ALU_N324) );
  INV_X1 S3_ALU_r396_U65 ( .A(S3_MUX_B_OUT[1]), .ZN(S3_ALU_r396_n1) );
  INV_X1 S3_ALU_r396_U64 ( .A(S3_ALU_r396_n202), .ZN(S3_ALU_r396_n62) );
  INV_X1 S3_ALU_r396_U63 ( .A(S3_MUX_B_OUT[31]), .ZN(S3_ALU_r396_n64) );
  INV_X1 S3_ALU_r396_U62 ( .A(S3_MUX_B_OUT[30]), .ZN(S3_ALU_r396_n65) );
  INV_X1 S3_ALU_r396_U61 ( .A(S3_MUX_A_OUT[26]), .ZN(S3_ALU_r396_n14) );
  INV_X1 S3_ALU_r396_U60 ( .A(S3_MUX_A_OUT[22]), .ZN(S3_ALU_r396_n22) );
  INV_X1 S3_ALU_r396_U59 ( .A(S3_MUX_A_OUT[18]), .ZN(S3_ALU_r396_n30) );
  INV_X1 S3_ALU_r396_U58 ( .A(S3_MUX_A_OUT[10]), .ZN(S3_ALU_r396_n46) );
  INV_X1 S3_ALU_r396_U57 ( .A(S3_MUX_A_OUT[6]), .ZN(S3_ALU_r396_n54) );
  INV_X1 S3_ALU_r396_U56 ( .A(S3_MUX_A_OUT[2]), .ZN(S3_ALU_r396_n61) );
  INV_X1 S3_ALU_r396_U55 ( .A(S3_MUX_A_OUT[28]), .ZN(S3_ALU_r396_n9) );
  INV_X1 S3_ALU_r396_U54 ( .A(S3_MUX_A_OUT[24]), .ZN(S3_ALU_r396_n17) );
  INV_X1 S3_ALU_r396_U53 ( .A(S3_MUX_A_OUT[20]), .ZN(S3_ALU_r396_n25) );
  INV_X1 S3_ALU_r396_U52 ( .A(S3_MUX_A_OUT[8]), .ZN(S3_ALU_r396_n49) );
  INV_X1 S3_ALU_r396_U51 ( .A(S3_MUX_A_OUT[4]), .ZN(S3_ALU_r396_n57) );
  INV_X1 S3_ALU_r396_U50 ( .A(S3_MUX_A_OUT[14]), .ZN(S3_ALU_r396_n38) );
  INV_X1 S3_ALU_r396_U49 ( .A(S3_MUX_A_OUT[16]), .ZN(S3_ALU_r396_n33) );
  INV_X1 S3_ALU_r396_U48 ( .A(S3_ALU_r396_n151), .ZN(S3_ALU_r396_n58) );
  INV_X1 S3_ALU_r396_U47 ( .A(S3_MUX_A_OUT[12]), .ZN(S3_ALU_r396_n41) );
  INV_X1 S3_ALU_r396_U46 ( .A(S3_MUX_A_OUT[29]), .ZN(S3_ALU_r396_n8) );
  INV_X1 S3_ALU_r396_U45 ( .A(S3_MUX_A_OUT[27]), .ZN(S3_ALU_r396_n11) );
  INV_X1 S3_ALU_r396_U44 ( .A(S3_MUX_A_OUT[25]), .ZN(S3_ALU_r396_n16) );
  INV_X1 S3_ALU_r396_U43 ( .A(S3_MUX_A_OUT[23]), .ZN(S3_ALU_r396_n19) );
  INV_X1 S3_ALU_r396_U42 ( .A(S3_MUX_A_OUT[21]), .ZN(S3_ALU_r396_n24) );
  INV_X1 S3_ALU_r396_U41 ( .A(S3_MUX_A_OUT[19]), .ZN(S3_ALU_r396_n27) );
  INV_X1 S3_ALU_r396_U40 ( .A(S3_MUX_A_OUT[11]), .ZN(S3_ALU_r396_n43) );
  INV_X1 S3_ALU_r396_U39 ( .A(S3_MUX_A_OUT[9]), .ZN(S3_ALU_r396_n48) );
  INV_X1 S3_ALU_r396_U38 ( .A(S3_MUX_A_OUT[7]), .ZN(S3_ALU_r396_n51) );
  INV_X1 S3_ALU_r396_U37 ( .A(S3_MUX_A_OUT[5]), .ZN(S3_ALU_r396_n56) );
  INV_X1 S3_ALU_r396_U36 ( .A(S3_MUX_A_OUT[3]), .ZN(S3_ALU_r396_n59) );
  INV_X1 S3_ALU_r396_U35 ( .A(S3_MUX_A_OUT[15]), .ZN(S3_ALU_r396_n35) );
  INV_X1 S3_ALU_r396_U34 ( .A(S3_MUX_A_OUT[13]), .ZN(S3_ALU_r396_n40) );
  INV_X1 S3_ALU_r396_U33 ( .A(S3_MUX_A_OUT[17]), .ZN(S3_ALU_r396_n32) );
  INV_X1 S3_ALU_r396_U32 ( .A(S3_MUX_A_OUT[0]), .ZN(S3_ALU_r396_n63) );
  INV_X1 S3_ALU_r396_U31 ( .A(S3_ALU_r396_n72), .ZN(S3_ALU_r396_n7) );
  INV_X1 S3_ALU_r396_U30 ( .A(S3_MUX_A_OUT[30]), .ZN(S3_ALU_r396_n6) );
  INV_X1 S3_ALU_r396_U29 ( .A(S3_ALU_r396_n68), .ZN(S3_ALU_r396_n5) );
  INV_X1 S3_ALU_r396_U28 ( .A(S3_ALU_r396_n154), .ZN(S3_ALU_r396_n60) );
  INV_X1 S3_ALU_r396_U27 ( .A(S3_ALU_r396_n81), .ZN(S3_ALU_r396_n13) );
  INV_X1 S3_ALU_r396_U26 ( .A(S3_ALU_r396_n93), .ZN(S3_ALU_r396_n21) );
  INV_X1 S3_ALU_r396_U25 ( .A(S3_ALU_r396_n105), .ZN(S3_ALU_r396_n29) );
  INV_X1 S3_ALU_r396_U24 ( .A(S3_ALU_r396_n117), .ZN(S3_ALU_r396_n37) );
  INV_X1 S3_ALU_r396_U23 ( .A(S3_ALU_r396_n129), .ZN(S3_ALU_r396_n45) );
  INV_X1 S3_ALU_r396_U22 ( .A(S3_ALU_r396_n141), .ZN(S3_ALU_r396_n53) );
  INV_X1 S3_ALU_r396_U21 ( .A(S3_ALU_r396_n84), .ZN(S3_ALU_r396_n15) );
  INV_X1 S3_ALU_r396_U20 ( .A(S3_ALU_r396_n96), .ZN(S3_ALU_r396_n23) );
  INV_X1 S3_ALU_r396_U19 ( .A(S3_ALU_r396_n108), .ZN(S3_ALU_r396_n31) );
  INV_X1 S3_ALU_r396_U18 ( .A(S3_ALU_r396_n120), .ZN(S3_ALU_r396_n39) );
  INV_X1 S3_ALU_r396_U17 ( .A(S3_ALU_r396_n132), .ZN(S3_ALU_r396_n47) );
  INV_X1 S3_ALU_r396_U16 ( .A(S3_ALU_r396_n144), .ZN(S3_ALU_r396_n55) );
  INV_X1 S3_ALU_r396_U15 ( .A(S3_ALU_N393), .ZN(S3_ALU_N394) );
  INV_X1 S3_ALU_r396_U14 ( .A(S3_ALU_N395), .ZN(S3_ALU_N392) );
  INV_X1 S3_ALU_r396_U13 ( .A(S3_ALU_r396_n79), .ZN(S3_ALU_r396_n10) );
  INV_X1 S3_ALU_r396_U12 ( .A(S3_ALU_r396_n91), .ZN(S3_ALU_r396_n18) );
  INV_X1 S3_ALU_r396_U11 ( .A(S3_ALU_r396_n103), .ZN(S3_ALU_r396_n26) );
  INV_X1 S3_ALU_r396_U10 ( .A(S3_ALU_r396_n115), .ZN(S3_ALU_r396_n34) );
  INV_X1 S3_ALU_r396_U9 ( .A(S3_ALU_r396_n127), .ZN(S3_ALU_r396_n42) );
  INV_X1 S3_ALU_r396_U8 ( .A(S3_ALU_r396_n139), .ZN(S3_ALU_r396_n50) );
  INV_X1 S3_ALU_r396_U7 ( .A(S3_ALU_r396_n82), .ZN(S3_ALU_r396_n12) );
  INV_X1 S3_ALU_r396_U6 ( .A(S3_ALU_r396_n94), .ZN(S3_ALU_r396_n20) );
  INV_X1 S3_ALU_r396_U5 ( .A(S3_ALU_r396_n106), .ZN(S3_ALU_r396_n28) );
  INV_X1 S3_ALU_r396_U4 ( .A(S3_ALU_r396_n118), .ZN(S3_ALU_r396_n36) );
  INV_X1 S3_ALU_r396_U3 ( .A(S3_ALU_r396_n130), .ZN(S3_ALU_r396_n44) );
  INV_X1 S3_ALU_r396_U2 ( .A(S3_ALU_r396_n142), .ZN(S3_ALU_r396_n52) );
  INV_X1 S3_ALU_r396_U1 ( .A(S3_ALU_N324), .ZN(S3_ALU_N389) );
  NOR2_X1 S3_ALU_r395_U205 ( .A1(S3_ALU_r395_n5), .A2(S3_MUX_B_OUT[31]), .ZN(
        S3_ALU_r395_n68) );
  NOR2_X1 S3_ALU_r395_U204 ( .A1(S3_ALU_r395_n65), .A2(S3_ALU_n150), .ZN(
        S3_ALU_r395_n203) );
  AND2_X1 S3_ALU_r395_U203 ( .A1(S3_ALU_r395_n203), .A2(S3_ALU_r395_n2), .ZN(
        S3_ALU_r395_n202) );
  OAI22_X1 S3_ALU_r395_U202 ( .A1(S3_ALU_r395_n202), .A2(S3_MUX_A_OUT[1]), 
        .B1(S3_ALU_r395_n2), .B2(S3_ALU_r395_n203), .ZN(S3_ALU_r395_n201) );
  NOR2_X1 S3_ALU_r395_U201 ( .A1(S3_ALU_r395_n62), .A2(S3_MUX_B_OUT[2]), .ZN(
        S3_ALU_r395_n200) );
  NAND2_X1 S3_ALU_r395_U200 ( .A1(S3_MUX_B_OUT[2]), .A2(S3_ALU_r395_n62), .ZN(
        S3_ALU_r395_n139) );
  NOR2_X1 S3_ALU_r395_U199 ( .A1(S3_ALU_r395_n200), .A2(S3_ALU_r395_n61), .ZN(
        S3_ALU_r395_n142) );
  AOI21_X1 S3_ALU_r395_U198 ( .B1(S3_ALU_r395_n63), .B2(S3_ALU_r395_n142), .A(
        S3_ALU_r395_n200), .ZN(S3_ALU_r395_n199) );
  OR2_X1 S3_ALU_r395_U197 ( .A1(S3_ALU_r395_n60), .A2(S3_MUX_B_OUT[3]), .ZN(
        S3_ALU_r395_n136) );
  NAND2_X1 S3_ALU_r395_U196 ( .A1(S3_MUX_B_OUT[3]), .A2(S3_ALU_r395_n60), .ZN(
        S3_ALU_r395_n138) );
  AOI21_X1 S3_ALU_r395_U195 ( .B1(S3_ALU_r395_n199), .B2(S3_ALU_r395_n136), 
        .A(S3_ALU_r395_n59), .ZN(S3_ALU_r395_n197) );
  NOR2_X1 S3_ALU_r395_U194 ( .A1(S3_ALU_r395_n58), .A2(S3_MUX_B_OUT[4]), .ZN(
        S3_ALU_r395_n198) );
  AND2_X1 S3_ALU_r395_U193 ( .A1(S3_MUX_B_OUT[4]), .A2(S3_ALU_r395_n58), .ZN(
        S3_ALU_r395_n144) );
  NOR2_X1 S3_ALU_r395_U192 ( .A1(S3_ALU_r395_n198), .A2(S3_ALU_r395_n144), 
        .ZN(S3_ALU_r395_n137) );
  AOI21_X1 S3_ALU_r395_U191 ( .B1(S3_ALU_r395_n197), .B2(S3_ALU_r395_n137), 
        .A(S3_ALU_r395_n198), .ZN(S3_ALU_r395_n196) );
  NOR2_X1 S3_ALU_r395_U190 ( .A1(S3_ALU_r395_n57), .A2(S3_MUX_B_OUT[5]), .ZN(
        S3_ALU_r395_n134) );
  AND2_X1 S3_ALU_r395_U189 ( .A1(S3_MUX_B_OUT[5]), .A2(S3_ALU_r395_n57), .ZN(
        S3_ALU_r395_n145) );
  AOI21_X1 S3_ALU_r395_U188 ( .B1(S3_ALU_r395_n196), .B2(S3_ALU_r395_n56), .A(
        S3_ALU_r395_n145), .ZN(S3_ALU_r395_n194) );
  NOR2_X1 S3_ALU_r395_U187 ( .A1(S3_ALU_r395_n55), .A2(S3_MUX_B_OUT[6]), .ZN(
        S3_ALU_r395_n195) );
  NAND2_X1 S3_ALU_r395_U186 ( .A1(S3_MUX_B_OUT[6]), .A2(S3_ALU_r395_n55), .ZN(
        S3_ALU_r395_n130) );
  NAND2_X1 S3_ALU_r395_U185 ( .A1(S3_ALU_r395_n54), .A2(S3_ALU_r395_n130), 
        .ZN(S3_ALU_r395_n133) );
  AOI21_X1 S3_ALU_r395_U184 ( .B1(S3_ALU_r395_n194), .B2(S3_ALU_r395_n53), .A(
        S3_ALU_r395_n195), .ZN(S3_ALU_r395_n193) );
  OR2_X1 S3_ALU_r395_U183 ( .A1(S3_ALU_r395_n52), .A2(S3_MUX_B_OUT[7]), .ZN(
        S3_ALU_r395_n127) );
  NAND2_X1 S3_ALU_r395_U182 ( .A1(S3_MUX_B_OUT[7]), .A2(S3_ALU_r395_n52), .ZN(
        S3_ALU_r395_n129) );
  AOI21_X1 S3_ALU_r395_U181 ( .B1(S3_ALU_r395_n193), .B2(S3_ALU_r395_n127), 
        .A(S3_ALU_r395_n51), .ZN(S3_ALU_r395_n191) );
  NOR2_X1 S3_ALU_r395_U180 ( .A1(S3_ALU_r395_n50), .A2(S3_MUX_B_OUT[8]), .ZN(
        S3_ALU_r395_n192) );
  AND2_X1 S3_ALU_r395_U179 ( .A1(S3_MUX_B_OUT[8]), .A2(S3_ALU_r395_n50), .ZN(
        S3_ALU_r395_n146) );
  NOR2_X1 S3_ALU_r395_U178 ( .A1(S3_ALU_r395_n192), .A2(S3_ALU_r395_n146), 
        .ZN(S3_ALU_r395_n128) );
  AOI21_X1 S3_ALU_r395_U177 ( .B1(S3_ALU_r395_n191), .B2(S3_ALU_r395_n128), 
        .A(S3_ALU_r395_n192), .ZN(S3_ALU_r395_n190) );
  NOR2_X1 S3_ALU_r395_U176 ( .A1(S3_ALU_r395_n49), .A2(S3_MUX_B_OUT[9]), .ZN(
        S3_ALU_r395_n124) );
  AND2_X1 S3_ALU_r395_U175 ( .A1(S3_MUX_B_OUT[9]), .A2(S3_ALU_r395_n49), .ZN(
        S3_ALU_r395_n147) );
  AOI21_X1 S3_ALU_r395_U174 ( .B1(S3_ALU_r395_n190), .B2(S3_ALU_r395_n48), .A(
        S3_ALU_r395_n147), .ZN(S3_ALU_r395_n188) );
  NOR2_X1 S3_ALU_r395_U173 ( .A1(S3_ALU_r395_n47), .A2(S3_MUX_B_OUT[10]), .ZN(
        S3_ALU_r395_n189) );
  NAND2_X1 S3_ALU_r395_U172 ( .A1(S3_MUX_B_OUT[10]), .A2(S3_ALU_r395_n47), 
        .ZN(S3_ALU_r395_n120) );
  NAND2_X1 S3_ALU_r395_U171 ( .A1(S3_ALU_r395_n46), .A2(S3_ALU_r395_n120), 
        .ZN(S3_ALU_r395_n123) );
  AOI21_X1 S3_ALU_r395_U170 ( .B1(S3_ALU_r395_n188), .B2(S3_ALU_r395_n45), .A(
        S3_ALU_r395_n189), .ZN(S3_ALU_r395_n187) );
  OR2_X1 S3_ALU_r395_U169 ( .A1(S3_ALU_r395_n44), .A2(S3_MUX_B_OUT[11]), .ZN(
        S3_ALU_r395_n117) );
  NAND2_X1 S3_ALU_r395_U168 ( .A1(S3_MUX_B_OUT[11]), .A2(S3_ALU_r395_n44), 
        .ZN(S3_ALU_r395_n119) );
  AOI21_X1 S3_ALU_r395_U167 ( .B1(S3_ALU_r395_n187), .B2(S3_ALU_r395_n117), 
        .A(S3_ALU_r395_n43), .ZN(S3_ALU_r395_n185) );
  NOR2_X1 S3_ALU_r395_U166 ( .A1(S3_ALU_r395_n42), .A2(S3_MUX_B_OUT[12]), .ZN(
        S3_ALU_r395_n186) );
  AND2_X1 S3_ALU_r395_U165 ( .A1(S3_MUX_B_OUT[12]), .A2(S3_ALU_r395_n42), .ZN(
        S3_ALU_r395_n148) );
  NOR2_X1 S3_ALU_r395_U164 ( .A1(S3_ALU_r395_n186), .A2(S3_ALU_r395_n148), 
        .ZN(S3_ALU_r395_n118) );
  AOI21_X1 S3_ALU_r395_U163 ( .B1(S3_ALU_r395_n185), .B2(S3_ALU_r395_n118), 
        .A(S3_ALU_r395_n186), .ZN(S3_ALU_r395_n184) );
  NOR2_X1 S3_ALU_r395_U162 ( .A1(S3_ALU_r395_n41), .A2(S3_MUX_B_OUT[13]), .ZN(
        S3_ALU_r395_n114) );
  AND2_X1 S3_ALU_r395_U161 ( .A1(S3_MUX_B_OUT[13]), .A2(S3_ALU_r395_n41), .ZN(
        S3_ALU_r395_n149) );
  AOI21_X1 S3_ALU_r395_U160 ( .B1(S3_ALU_r395_n184), .B2(S3_ALU_r395_n40), .A(
        S3_ALU_r395_n149), .ZN(S3_ALU_r395_n182) );
  NOR2_X1 S3_ALU_r395_U159 ( .A1(S3_ALU_r395_n39), .A2(S3_MUX_B_OUT[14]), .ZN(
        S3_ALU_r395_n183) );
  NAND2_X1 S3_ALU_r395_U158 ( .A1(S3_MUX_B_OUT[14]), .A2(S3_ALU_r395_n39), 
        .ZN(S3_ALU_r395_n110) );
  NAND2_X1 S3_ALU_r395_U157 ( .A1(S3_ALU_r395_n38), .A2(S3_ALU_r395_n110), 
        .ZN(S3_ALU_r395_n113) );
  AOI21_X1 S3_ALU_r395_U156 ( .B1(S3_ALU_r395_n182), .B2(S3_ALU_r395_n37), .A(
        S3_ALU_r395_n183), .ZN(S3_ALU_r395_n181) );
  OR2_X1 S3_ALU_r395_U155 ( .A1(S3_ALU_r395_n36), .A2(S3_MUX_B_OUT[15]), .ZN(
        S3_ALU_r395_n107) );
  NAND2_X1 S3_ALU_r395_U154 ( .A1(S3_MUX_B_OUT[15]), .A2(S3_ALU_r395_n36), 
        .ZN(S3_ALU_r395_n109) );
  AOI21_X1 S3_ALU_r395_U153 ( .B1(S3_ALU_r395_n181), .B2(S3_ALU_r395_n107), 
        .A(S3_ALU_r395_n35), .ZN(S3_ALU_r395_n179) );
  NOR2_X1 S3_ALU_r395_U152 ( .A1(S3_ALU_r395_n34), .A2(S3_MUX_B_OUT[16]), .ZN(
        S3_ALU_r395_n180) );
  AND2_X1 S3_ALU_r395_U151 ( .A1(S3_MUX_B_OUT[16]), .A2(S3_ALU_r395_n34), .ZN(
        S3_ALU_r395_n150) );
  NOR2_X1 S3_ALU_r395_U150 ( .A1(S3_ALU_r395_n180), .A2(S3_ALU_r395_n150), 
        .ZN(S3_ALU_r395_n108) );
  AOI21_X1 S3_ALU_r395_U149 ( .B1(S3_ALU_r395_n179), .B2(S3_ALU_r395_n108), 
        .A(S3_ALU_r395_n180), .ZN(S3_ALU_r395_n178) );
  NOR2_X1 S3_ALU_r395_U148 ( .A1(S3_ALU_r395_n33), .A2(S3_MUX_B_OUT[17]), .ZN(
        S3_ALU_r395_n104) );
  AND2_X1 S3_ALU_r395_U147 ( .A1(S3_MUX_B_OUT[17]), .A2(S3_ALU_r395_n33), .ZN(
        S3_ALU_r395_n151) );
  AOI21_X1 S3_ALU_r395_U146 ( .B1(S3_ALU_r395_n178), .B2(S3_ALU_r395_n32), .A(
        S3_ALU_r395_n151), .ZN(S3_ALU_r395_n176) );
  NOR2_X1 S3_ALU_r395_U145 ( .A1(S3_ALU_r395_n31), .A2(S3_MUX_B_OUT[18]), .ZN(
        S3_ALU_r395_n177) );
  NAND2_X1 S3_ALU_r395_U144 ( .A1(S3_MUX_B_OUT[18]), .A2(S3_ALU_r395_n31), 
        .ZN(S3_ALU_r395_n100) );
  NAND2_X1 S3_ALU_r395_U143 ( .A1(S3_ALU_r395_n30), .A2(S3_ALU_r395_n100), 
        .ZN(S3_ALU_r395_n103) );
  AOI21_X1 S3_ALU_r395_U142 ( .B1(S3_ALU_r395_n176), .B2(S3_ALU_r395_n29), .A(
        S3_ALU_r395_n177), .ZN(S3_ALU_r395_n175) );
  OR2_X1 S3_ALU_r395_U141 ( .A1(S3_ALU_r395_n28), .A2(S3_MUX_B_OUT[19]), .ZN(
        S3_ALU_r395_n97) );
  NAND2_X1 S3_ALU_r395_U140 ( .A1(S3_MUX_B_OUT[19]), .A2(S3_ALU_r395_n28), 
        .ZN(S3_ALU_r395_n99) );
  AOI21_X1 S3_ALU_r395_U139 ( .B1(S3_ALU_r395_n175), .B2(S3_ALU_r395_n97), .A(
        S3_ALU_r395_n27), .ZN(S3_ALU_r395_n173) );
  NOR2_X1 S3_ALU_r395_U138 ( .A1(S3_ALU_r395_n26), .A2(S3_MUX_B_OUT[20]), .ZN(
        S3_ALU_r395_n174) );
  AND2_X1 S3_ALU_r395_U137 ( .A1(S3_MUX_B_OUT[20]), .A2(S3_ALU_r395_n26), .ZN(
        S3_ALU_r395_n152) );
  NOR2_X1 S3_ALU_r395_U136 ( .A1(S3_ALU_r395_n174), .A2(S3_ALU_r395_n152), 
        .ZN(S3_ALU_r395_n98) );
  AOI21_X1 S3_ALU_r395_U135 ( .B1(S3_ALU_r395_n173), .B2(S3_ALU_r395_n98), .A(
        S3_ALU_r395_n174), .ZN(S3_ALU_r395_n172) );
  NOR2_X1 S3_ALU_r395_U134 ( .A1(S3_ALU_r395_n25), .A2(S3_MUX_B_OUT[21]), .ZN(
        S3_ALU_r395_n94) );
  AND2_X1 S3_ALU_r395_U133 ( .A1(S3_MUX_B_OUT[21]), .A2(S3_ALU_r395_n25), .ZN(
        S3_ALU_r395_n153) );
  AOI21_X1 S3_ALU_r395_U132 ( .B1(S3_ALU_r395_n172), .B2(S3_ALU_r395_n24), .A(
        S3_ALU_r395_n153), .ZN(S3_ALU_r395_n170) );
  NOR2_X1 S3_ALU_r395_U131 ( .A1(S3_ALU_r395_n23), .A2(S3_MUX_B_OUT[22]), .ZN(
        S3_ALU_r395_n171) );
  NAND2_X1 S3_ALU_r395_U130 ( .A1(S3_MUX_B_OUT[22]), .A2(S3_ALU_r395_n23), 
        .ZN(S3_ALU_r395_n90) );
  NAND2_X1 S3_ALU_r395_U129 ( .A1(S3_ALU_r395_n22), .A2(S3_ALU_r395_n90), .ZN(
        S3_ALU_r395_n93) );
  AOI21_X1 S3_ALU_r395_U128 ( .B1(S3_ALU_r395_n170), .B2(S3_ALU_r395_n21), .A(
        S3_ALU_r395_n171), .ZN(S3_ALU_r395_n169) );
  OR2_X1 S3_ALU_r395_U127 ( .A1(S3_ALU_r395_n20), .A2(S3_MUX_B_OUT[23]), .ZN(
        S3_ALU_r395_n87) );
  NAND2_X1 S3_ALU_r395_U126 ( .A1(S3_MUX_B_OUT[23]), .A2(S3_ALU_r395_n20), 
        .ZN(S3_ALU_r395_n89) );
  AOI21_X1 S3_ALU_r395_U125 ( .B1(S3_ALU_r395_n169), .B2(S3_ALU_r395_n87), .A(
        S3_ALU_r395_n19), .ZN(S3_ALU_r395_n167) );
  NOR2_X1 S3_ALU_r395_U124 ( .A1(S3_ALU_r395_n18), .A2(S3_MUX_B_OUT[24]), .ZN(
        S3_ALU_r395_n168) );
  AND2_X1 S3_ALU_r395_U123 ( .A1(S3_MUX_B_OUT[24]), .A2(S3_ALU_r395_n18), .ZN(
        S3_ALU_r395_n154) );
  NOR2_X1 S3_ALU_r395_U122 ( .A1(S3_ALU_r395_n168), .A2(S3_ALU_r395_n154), 
        .ZN(S3_ALU_r395_n88) );
  AOI21_X1 S3_ALU_r395_U121 ( .B1(S3_ALU_r395_n167), .B2(S3_ALU_r395_n88), .A(
        S3_ALU_r395_n168), .ZN(S3_ALU_r395_n166) );
  NOR2_X1 S3_ALU_r395_U120 ( .A1(S3_ALU_r395_n17), .A2(S3_MUX_B_OUT[25]), .ZN(
        S3_ALU_r395_n84) );
  AND2_X1 S3_ALU_r395_U119 ( .A1(S3_MUX_B_OUT[25]), .A2(S3_ALU_r395_n17), .ZN(
        S3_ALU_r395_n155) );
  AOI21_X1 S3_ALU_r395_U118 ( .B1(S3_ALU_r395_n166), .B2(S3_ALU_r395_n16), .A(
        S3_ALU_r395_n155), .ZN(S3_ALU_r395_n164) );
  NOR2_X1 S3_ALU_r395_U117 ( .A1(S3_ALU_r395_n15), .A2(S3_MUX_B_OUT[26]), .ZN(
        S3_ALU_r395_n165) );
  NAND2_X1 S3_ALU_r395_U116 ( .A1(S3_MUX_B_OUT[26]), .A2(S3_ALU_r395_n15), 
        .ZN(S3_ALU_r395_n80) );
  NAND2_X1 S3_ALU_r395_U115 ( .A1(S3_ALU_r395_n14), .A2(S3_ALU_r395_n80), .ZN(
        S3_ALU_r395_n83) );
  AOI21_X1 S3_ALU_r395_U114 ( .B1(S3_ALU_r395_n164), .B2(S3_ALU_r395_n13), .A(
        S3_ALU_r395_n165), .ZN(S3_ALU_r395_n163) );
  OR2_X1 S3_ALU_r395_U113 ( .A1(S3_ALU_r395_n12), .A2(S3_MUX_B_OUT[27]), .ZN(
        S3_ALU_r395_n77) );
  NAND2_X1 S3_ALU_r395_U112 ( .A1(S3_MUX_B_OUT[27]), .A2(S3_ALU_r395_n12), 
        .ZN(S3_ALU_r395_n79) );
  AOI21_X1 S3_ALU_r395_U111 ( .B1(S3_ALU_r395_n163), .B2(S3_ALU_r395_n77), .A(
        S3_ALU_r395_n11), .ZN(S3_ALU_r395_n161) );
  NOR2_X1 S3_ALU_r395_U110 ( .A1(S3_ALU_r395_n10), .A2(S3_MUX_B_OUT[28]), .ZN(
        S3_ALU_r395_n162) );
  AND2_X1 S3_ALU_r395_U109 ( .A1(S3_MUX_B_OUT[28]), .A2(S3_ALU_r395_n10), .ZN(
        S3_ALU_r395_n156) );
  NOR2_X1 S3_ALU_r395_U108 ( .A1(S3_ALU_r395_n162), .A2(S3_ALU_r395_n156), 
        .ZN(S3_ALU_r395_n78) );
  AOI21_X1 S3_ALU_r395_U107 ( .B1(S3_ALU_r395_n161), .B2(S3_ALU_r395_n78), .A(
        S3_ALU_r395_n162), .ZN(S3_ALU_r395_n160) );
  NOR2_X1 S3_ALU_r395_U106 ( .A1(S3_ALU_r395_n9), .A2(S3_MUX_B_OUT[29]), .ZN(
        S3_ALU_r395_n74) );
  AND2_X1 S3_ALU_r395_U105 ( .A1(S3_MUX_B_OUT[29]), .A2(S3_ALU_r395_n9), .ZN(
        S3_ALU_r395_n157) );
  AOI21_X1 S3_ALU_r395_U104 ( .B1(S3_ALU_r395_n160), .B2(S3_ALU_r395_n8), .A(
        S3_ALU_r395_n157), .ZN(S3_ALU_r395_n159) );
  XOR2_X1 S3_ALU_r395_U103 ( .A(S3_ALU_r395_n66), .B(S3_MUX_A_OUT[30]), .Z(
        S3_ALU_r395_n71) );
  AOI22_X1 S3_ALU_r395_U102 ( .A1(S3_MUX_A_OUT[30]), .A2(S3_ALU_r395_n66), 
        .B1(S3_ALU_r395_n159), .B2(S3_ALU_r395_n71), .ZN(S3_ALU_r395_n158) );
  NAND2_X1 S3_ALU_r395_U101 ( .A1(S3_MUX_B_OUT[31]), .A2(S3_ALU_r395_n5), .ZN(
        S3_ALU_r395_n67) );
  OAI21_X1 S3_ALU_r395_U100 ( .B1(S3_ALU_r395_n68), .B2(S3_ALU_r395_n158), .A(
        S3_ALU_r395_n67), .ZN(S3_ALU_N391) );
  NOR2_X1 S3_ALU_r395_U99 ( .A1(S3_ALU_r395_n156), .A2(S3_ALU_r395_n157), .ZN(
        S3_ALU_r395_n72) );
  NOR2_X1 S3_ALU_r395_U98 ( .A1(S3_ALU_r395_n154), .A2(S3_ALU_r395_n155), .ZN(
        S3_ALU_r395_n81) );
  NOR2_X1 S3_ALU_r395_U97 ( .A1(S3_ALU_r395_n152), .A2(S3_ALU_r395_n153), .ZN(
        S3_ALU_r395_n91) );
  NOR2_X1 S3_ALU_r395_U96 ( .A1(S3_ALU_r395_n150), .A2(S3_ALU_r395_n151), .ZN(
        S3_ALU_r395_n101) );
  NOR2_X1 S3_ALU_r395_U95 ( .A1(S3_ALU_r395_n148), .A2(S3_ALU_r395_n149), .ZN(
        S3_ALU_r395_n111) );
  NOR2_X1 S3_ALU_r395_U94 ( .A1(S3_ALU_r395_n146), .A2(S3_ALU_r395_n147), .ZN(
        S3_ALU_r395_n121) );
  NOR2_X1 S3_ALU_r395_U93 ( .A1(S3_ALU_r395_n144), .A2(S3_ALU_r395_n145), .ZN(
        S3_ALU_r395_n131) );
  NAND2_X1 S3_ALU_r395_U92 ( .A1(S3_ALU_n150), .A2(S3_ALU_r395_n65), .ZN(
        S3_ALU_r395_n143) );
  OAI21_X1 S3_ALU_r395_U91 ( .B1(S3_ALU_r395_n2), .B2(S3_ALU_r395_n143), .A(
        S3_MUX_A_OUT[1]), .ZN(S3_ALU_r395_n141) );
  OAI211_X1 S3_ALU_r395_U90 ( .C1(S3_ALU_r395_n1), .C2(S3_ALU_r395_n64), .A(
        S3_ALU_r395_n141), .B(S3_ALU_r395_n142), .ZN(S3_ALU_r395_n140) );
  NAND3_X1 S3_ALU_r395_U89 ( .A1(S3_ALU_r395_n138), .A2(S3_ALU_r395_n139), 
        .A3(S3_ALU_r395_n140), .ZN(S3_ALU_r395_n135) );
  NAND3_X1 S3_ALU_r395_U88 ( .A1(S3_ALU_r395_n135), .A2(S3_ALU_r395_n136), 
        .A3(S3_ALU_r395_n137), .ZN(S3_ALU_r395_n132) );
  AOI211_X1 S3_ALU_r395_U87 ( .C1(S3_ALU_r395_n131), .C2(S3_ALU_r395_n132), 
        .A(S3_ALU_r395_n133), .B(S3_ALU_r395_n134), .ZN(S3_ALU_r395_n125) );
  NAND2_X1 S3_ALU_r395_U86 ( .A1(S3_ALU_r395_n129), .A2(S3_ALU_r395_n130), 
        .ZN(S3_ALU_r395_n126) );
  OAI211_X1 S3_ALU_r395_U85 ( .C1(S3_ALU_r395_n125), .C2(S3_ALU_r395_n126), 
        .A(S3_ALU_r395_n127), .B(S3_ALU_r395_n128), .ZN(S3_ALU_r395_n122) );
  AOI211_X1 S3_ALU_r395_U84 ( .C1(S3_ALU_r395_n121), .C2(S3_ALU_r395_n122), 
        .A(S3_ALU_r395_n123), .B(S3_ALU_r395_n124), .ZN(S3_ALU_r395_n115) );
  NAND2_X1 S3_ALU_r395_U83 ( .A1(S3_ALU_r395_n119), .A2(S3_ALU_r395_n120), 
        .ZN(S3_ALU_r395_n116) );
  OAI211_X1 S3_ALU_r395_U82 ( .C1(S3_ALU_r395_n115), .C2(S3_ALU_r395_n116), 
        .A(S3_ALU_r395_n117), .B(S3_ALU_r395_n118), .ZN(S3_ALU_r395_n112) );
  AOI211_X1 S3_ALU_r395_U81 ( .C1(S3_ALU_r395_n111), .C2(S3_ALU_r395_n112), 
        .A(S3_ALU_r395_n113), .B(S3_ALU_r395_n114), .ZN(S3_ALU_r395_n105) );
  NAND2_X1 S3_ALU_r395_U80 ( .A1(S3_ALU_r395_n109), .A2(S3_ALU_r395_n110), 
        .ZN(S3_ALU_r395_n106) );
  OAI211_X1 S3_ALU_r395_U79 ( .C1(S3_ALU_r395_n105), .C2(S3_ALU_r395_n106), 
        .A(S3_ALU_r395_n107), .B(S3_ALU_r395_n108), .ZN(S3_ALU_r395_n102) );
  AOI211_X1 S3_ALU_r395_U78 ( .C1(S3_ALU_r395_n101), .C2(S3_ALU_r395_n102), 
        .A(S3_ALU_r395_n103), .B(S3_ALU_r395_n104), .ZN(S3_ALU_r395_n95) );
  NAND2_X1 S3_ALU_r395_U77 ( .A1(S3_ALU_r395_n99), .A2(S3_ALU_r395_n100), .ZN(
        S3_ALU_r395_n96) );
  OAI211_X1 S3_ALU_r395_U76 ( .C1(S3_ALU_r395_n95), .C2(S3_ALU_r395_n96), .A(
        S3_ALU_r395_n97), .B(S3_ALU_r395_n98), .ZN(S3_ALU_r395_n92) );
  AOI211_X1 S3_ALU_r395_U75 ( .C1(S3_ALU_r395_n91), .C2(S3_ALU_r395_n92), .A(
        S3_ALU_r395_n93), .B(S3_ALU_r395_n94), .ZN(S3_ALU_r395_n85) );
  NAND2_X1 S3_ALU_r395_U74 ( .A1(S3_ALU_r395_n89), .A2(S3_ALU_r395_n90), .ZN(
        S3_ALU_r395_n86) );
  OAI211_X1 S3_ALU_r395_U73 ( .C1(S3_ALU_r395_n85), .C2(S3_ALU_r395_n86), .A(
        S3_ALU_r395_n87), .B(S3_ALU_r395_n88), .ZN(S3_ALU_r395_n82) );
  AOI211_X1 S3_ALU_r395_U72 ( .C1(S3_ALU_r395_n81), .C2(S3_ALU_r395_n82), .A(
        S3_ALU_r395_n83), .B(S3_ALU_r395_n84), .ZN(S3_ALU_r395_n75) );
  NAND2_X1 S3_ALU_r395_U71 ( .A1(S3_ALU_r395_n79), .A2(S3_ALU_r395_n80), .ZN(
        S3_ALU_r395_n76) );
  OAI211_X1 S3_ALU_r395_U70 ( .C1(S3_ALU_r395_n75), .C2(S3_ALU_r395_n76), .A(
        S3_ALU_r395_n77), .B(S3_ALU_r395_n78), .ZN(S3_ALU_r395_n73) );
  AOI21_X1 S3_ALU_r395_U69 ( .B1(S3_ALU_r395_n72), .B2(S3_ALU_r395_n73), .A(
        S3_ALU_r395_n74), .ZN(S3_ALU_r395_n70) );
  AOI22_X1 S3_ALU_r395_U68 ( .A1(S3_MUX_B_OUT[30]), .A2(S3_ALU_r395_n7), .B1(
        S3_ALU_r395_n70), .B2(S3_ALU_r395_n71), .ZN(S3_ALU_r395_n69) );
  AOI21_X1 S3_ALU_r395_U67 ( .B1(S3_ALU_r395_n67), .B2(S3_ALU_r395_n6), .A(
        S3_ALU_r395_n68), .ZN(S3_ALU_N322) );
  INV_X1 S3_ALU_r395_U66 ( .A(S3_ALU_N322), .ZN(S3_ALU_N390) );
  BUF_X1 S3_ALU_r395_U65 ( .A(S3_MUX_B_OUT[1]), .Z(S3_ALU_r395_n1) );
  INV_X1 S3_ALU_r395_U64 ( .A(S3_ALU_r395_n201), .ZN(S3_ALU_r395_n63) );
  INV_X1 S3_ALU_r395_U63 ( .A(S3_MUX_B_OUT[30]), .ZN(S3_ALU_r395_n66) );
  INV_X1 S3_ALU_r395_U62 ( .A(S3_MUX_A_OUT[27]), .ZN(S3_ALU_r395_n12) );
  INV_X1 S3_ALU_r395_U61 ( .A(S3_MUX_A_OUT[23]), .ZN(S3_ALU_r395_n20) );
  INV_X1 S3_ALU_r395_U60 ( .A(S3_MUX_A_OUT[19]), .ZN(S3_ALU_r395_n28) );
  INV_X1 S3_ALU_r395_U59 ( .A(S3_MUX_A_OUT[11]), .ZN(S3_ALU_r395_n44) );
  INV_X1 S3_ALU_r395_U58 ( .A(S3_MUX_A_OUT[7]), .ZN(S3_ALU_r395_n52) );
  INV_X1 S3_ALU_r395_U57 ( .A(S3_MUX_A_OUT[3]), .ZN(S3_ALU_r395_n60) );
  INV_X1 S3_ALU_r395_U56 ( .A(S3_MUX_A_OUT[29]), .ZN(S3_ALU_r395_n9) );
  INV_X1 S3_ALU_r395_U55 ( .A(S3_MUX_A_OUT[28]), .ZN(S3_ALU_r395_n10) );
  INV_X1 S3_ALU_r395_U54 ( .A(S3_MUX_A_OUT[25]), .ZN(S3_ALU_r395_n17) );
  INV_X1 S3_ALU_r395_U53 ( .A(S3_MUX_A_OUT[24]), .ZN(S3_ALU_r395_n18) );
  INV_X1 S3_ALU_r395_U52 ( .A(S3_MUX_A_OUT[21]), .ZN(S3_ALU_r395_n25) );
  INV_X1 S3_ALU_r395_U51 ( .A(S3_MUX_A_OUT[20]), .ZN(S3_ALU_r395_n26) );
  INV_X1 S3_ALU_r395_U50 ( .A(S3_MUX_A_OUT[9]), .ZN(S3_ALU_r395_n49) );
  INV_X1 S3_ALU_r395_U49 ( .A(S3_MUX_A_OUT[8]), .ZN(S3_ALU_r395_n50) );
  INV_X1 S3_ALU_r395_U48 ( .A(S3_MUX_A_OUT[5]), .ZN(S3_ALU_r395_n57) );
  INV_X1 S3_ALU_r395_U47 ( .A(S3_MUX_A_OUT[4]), .ZN(S3_ALU_r395_n58) );
  INV_X1 S3_ALU_r395_U46 ( .A(S3_MUX_A_OUT[15]), .ZN(S3_ALU_r395_n36) );
  INV_X1 S3_ALU_r395_U45 ( .A(S3_MUX_A_OUT[16]), .ZN(S3_ALU_r395_n34) );
  INV_X1 S3_ALU_r395_U44 ( .A(S3_MUX_A_OUT[13]), .ZN(S3_ALU_r395_n41) );
  INV_X1 S3_ALU_r395_U43 ( .A(S3_MUX_A_OUT[17]), .ZN(S3_ALU_r395_n33) );
  INV_X1 S3_ALU_r395_U42 ( .A(S3_MUX_A_OUT[12]), .ZN(S3_ALU_r395_n42) );
  INV_X1 S3_ALU_r395_U41 ( .A(S3_MUX_A_OUT[26]), .ZN(S3_ALU_r395_n15) );
  INV_X1 S3_ALU_r395_U40 ( .A(S3_MUX_A_OUT[22]), .ZN(S3_ALU_r395_n23) );
  INV_X1 S3_ALU_r395_U39 ( .A(S3_MUX_A_OUT[18]), .ZN(S3_ALU_r395_n31) );
  INV_X1 S3_ALU_r395_U38 ( .A(S3_MUX_A_OUT[10]), .ZN(S3_ALU_r395_n47) );
  INV_X1 S3_ALU_r395_U37 ( .A(S3_MUX_A_OUT[6]), .ZN(S3_ALU_r395_n55) );
  INV_X1 S3_ALU_r395_U36 ( .A(S3_MUX_A_OUT[2]), .ZN(S3_ALU_r395_n62) );
  INV_X1 S3_ALU_r395_U35 ( .A(S3_MUX_A_OUT[14]), .ZN(S3_ALU_r395_n39) );
  INV_X1 S3_ALU_r395_U34 ( .A(S3_MUX_A_OUT[31]), .ZN(S3_ALU_r395_n5) );
  INV_X1 S3_ALU_r395_U33 ( .A(S3_MUX_A_OUT[0]), .ZN(S3_ALU_r395_n65) );
  INV_X1 S3_ALU_r395_U32 ( .A(S3_ALU_r395_n143), .ZN(S3_ALU_r395_n64) );
  INV_X1 S3_ALU_r395_U31 ( .A(S3_ALU_r395_n74), .ZN(S3_ALU_r395_n8) );
  INV_X1 S3_ALU_r395_U30 ( .A(S3_MUX_A_OUT[30]), .ZN(S3_ALU_r395_n7) );
  INV_X1 S3_ALU_r395_U29 ( .A(S3_ALU_r395_n69), .ZN(S3_ALU_r395_n6) );
  INV_X1 S3_ALU_r395_U28 ( .A(S3_ALU_r395_n1), .ZN(S3_ALU_r395_n2) );
  INV_X1 S3_ALU_r395_U27 ( .A(S3_ALU_r395_n89), .ZN(S3_ALU_r395_n19) );
  INV_X1 S3_ALU_r395_U26 ( .A(S3_ALU_r395_n109), .ZN(S3_ALU_r395_n35) );
  INV_X1 S3_ALU_r395_U25 ( .A(S3_ALU_r395_n129), .ZN(S3_ALU_r395_n51) );
  INV_X1 S3_ALU_r395_U24 ( .A(S3_ALU_N391), .ZN(S3_ALU_N323) );
  INV_X1 S3_ALU_r395_U23 ( .A(S3_ALU_r395_n165), .ZN(S3_ALU_r395_n14) );
  INV_X1 S3_ALU_r395_U22 ( .A(S3_ALU_r395_n171), .ZN(S3_ALU_r395_n22) );
  INV_X1 S3_ALU_r395_U21 ( .A(S3_ALU_r395_n177), .ZN(S3_ALU_r395_n30) );
  INV_X1 S3_ALU_r395_U20 ( .A(S3_ALU_r395_n183), .ZN(S3_ALU_r395_n38) );
  INV_X1 S3_ALU_r395_U19 ( .A(S3_ALU_r395_n189), .ZN(S3_ALU_r395_n46) );
  INV_X1 S3_ALU_r395_U18 ( .A(S3_ALU_r395_n195), .ZN(S3_ALU_r395_n54) );
  INV_X1 S3_ALU_r395_U17 ( .A(S3_ALU_r395_n79), .ZN(S3_ALU_r395_n11) );
  INV_X1 S3_ALU_r395_U16 ( .A(S3_ALU_r395_n84), .ZN(S3_ALU_r395_n16) );
  INV_X1 S3_ALU_r395_U15 ( .A(S3_ALU_r395_n94), .ZN(S3_ALU_r395_n24) );
  INV_X1 S3_ALU_r395_U14 ( .A(S3_ALU_r395_n93), .ZN(S3_ALU_r395_n21) );
  INV_X1 S3_ALU_r395_U13 ( .A(S3_ALU_r395_n99), .ZN(S3_ALU_r395_n27) );
  INV_X1 S3_ALU_r395_U12 ( .A(S3_ALU_r395_n104), .ZN(S3_ALU_r395_n32) );
  INV_X1 S3_ALU_r395_U11 ( .A(S3_ALU_r395_n114), .ZN(S3_ALU_r395_n40) );
  INV_X1 S3_ALU_r395_U10 ( .A(S3_ALU_r395_n113), .ZN(S3_ALU_r395_n37) );
  INV_X1 S3_ALU_r395_U9 ( .A(S3_ALU_r395_n119), .ZN(S3_ALU_r395_n43) );
  INV_X1 S3_ALU_r395_U8 ( .A(S3_ALU_r395_n124), .ZN(S3_ALU_r395_n48) );
  INV_X1 S3_ALU_r395_U7 ( .A(S3_ALU_r395_n134), .ZN(S3_ALU_r395_n56) );
  INV_X1 S3_ALU_r395_U6 ( .A(S3_ALU_r395_n133), .ZN(S3_ALU_r395_n53) );
  INV_X1 S3_ALU_r395_U5 ( .A(S3_ALU_r395_n138), .ZN(S3_ALU_r395_n59) );
  INV_X1 S3_ALU_r395_U4 ( .A(S3_ALU_r395_n139), .ZN(S3_ALU_r395_n61) );
  INV_X1 S3_ALU_r395_U3 ( .A(S3_ALU_r395_n83), .ZN(S3_ALU_r395_n13) );
  INV_X1 S3_ALU_r395_U2 ( .A(S3_ALU_r395_n103), .ZN(S3_ALU_r395_n29) );
  INV_X1 S3_ALU_r395_U1 ( .A(S3_ALU_r395_n123), .ZN(S3_ALU_r395_n45) );
  INV_X1 S3_REG_ALU_U77 ( .A(nRST), .ZN(S3_REG_ALU_n75) );
  NOR2_X1 S3_REG_ALU_U76 ( .A1(ALU_OUTREG_EN), .A2(S3_REG_ALU_n75), .ZN(
        S3_REG_ALU_n36) );
  AOI22_X1 S3_REG_ALU_U75 ( .A1(S3_ALU_OUT[31]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[31]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n67) );
  INV_X1 S3_REG_ALU_U74 ( .A(S3_REG_ALU_n67), .ZN(S3_REG_ALU_n9) );
  AOI22_X1 S3_REG_ALU_U73 ( .A1(S3_ALU_OUT[30]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[30]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n66) );
  INV_X1 S3_REG_ALU_U72 ( .A(S3_REG_ALU_n66), .ZN(S3_REG_ALU_n10) );
  AOI22_X1 S3_REG_ALU_U71 ( .A1(S3_ALU_OUT[29]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[29]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n65) );
  INV_X1 S3_REG_ALU_U70 ( .A(S3_REG_ALU_n65), .ZN(S3_REG_ALU_n11) );
  AOI22_X1 S3_REG_ALU_U69 ( .A1(S3_ALU_OUT[28]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[28]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n64) );
  INV_X1 S3_REG_ALU_U68 ( .A(S3_REG_ALU_n64), .ZN(S3_REG_ALU_n12) );
  AOI22_X1 S3_REG_ALU_U67 ( .A1(S3_ALU_OUT[27]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[27]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n63) );
  INV_X1 S3_REG_ALU_U66 ( .A(S3_REG_ALU_n63), .ZN(S3_REG_ALU_n13) );
  AOI22_X1 S3_REG_ALU_U65 ( .A1(S3_ALU_OUT[26]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[26]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n62) );
  INV_X1 S3_REG_ALU_U64 ( .A(S3_REG_ALU_n62), .ZN(S3_REG_ALU_n14) );
  AOI22_X1 S3_REG_ALU_U63 ( .A1(S3_ALU_OUT[25]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[25]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n61) );
  INV_X1 S3_REG_ALU_U62 ( .A(S3_REG_ALU_n61), .ZN(S3_REG_ALU_n15) );
  AOI22_X1 S3_REG_ALU_U61 ( .A1(S3_ALU_OUT[24]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[24]), .B2(S3_REG_ALU_n3), .ZN(S3_REG_ALU_n60) );
  INV_X1 S3_REG_ALU_U60 ( .A(S3_REG_ALU_n60), .ZN(S3_REG_ALU_n16) );
  AOI22_X1 S3_REG_ALU_U59 ( .A1(S3_ALU_OUT[23]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[23]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n59) );
  INV_X1 S3_REG_ALU_U58 ( .A(S3_REG_ALU_n59), .ZN(S3_REG_ALU_n17) );
  AOI22_X1 S3_REG_ALU_U57 ( .A1(S3_ALU_OUT[22]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[22]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n58) );
  INV_X1 S3_REG_ALU_U56 ( .A(S3_REG_ALU_n58), .ZN(S3_REG_ALU_n18) );
  AOI22_X1 S3_REG_ALU_U55 ( .A1(S3_ALU_OUT[21]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[21]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n57) );
  INV_X1 S3_REG_ALU_U54 ( .A(S3_REG_ALU_n57), .ZN(S3_REG_ALU_n19) );
  AOI22_X1 S3_REG_ALU_U53 ( .A1(S3_ALU_OUT[20]), .A2(S3_REG_ALU_n5), .B1(
        S3_REG_ALU_OUT[20]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n56) );
  INV_X1 S3_REG_ALU_U52 ( .A(S3_REG_ALU_n56), .ZN(S3_REG_ALU_n20) );
  AOI22_X1 S3_REG_ALU_U51 ( .A1(S3_ALU_OUT[19]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[19]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n55) );
  INV_X1 S3_REG_ALU_U50 ( .A(S3_REG_ALU_n55), .ZN(S3_REG_ALU_n21) );
  AOI22_X1 S3_REG_ALU_U49 ( .A1(S3_ALU_OUT[18]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[18]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n54) );
  INV_X1 S3_REG_ALU_U48 ( .A(S3_REG_ALU_n54), .ZN(S3_REG_ALU_n22) );
  AOI22_X1 S3_REG_ALU_U47 ( .A1(S3_ALU_OUT[17]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[17]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n53) );
  INV_X1 S3_REG_ALU_U46 ( .A(S3_REG_ALU_n53), .ZN(S3_REG_ALU_n23) );
  AOI22_X1 S3_REG_ALU_U45 ( .A1(S3_ALU_OUT[16]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[16]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n52) );
  INV_X1 S3_REG_ALU_U44 ( .A(S3_REG_ALU_n52), .ZN(S3_REG_ALU_n24) );
  AOI22_X1 S3_REG_ALU_U43 ( .A1(S3_ALU_OUT[15]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[15]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n51) );
  INV_X1 S3_REG_ALU_U42 ( .A(S3_REG_ALU_n51), .ZN(S3_REG_ALU_n25) );
  AOI22_X1 S3_REG_ALU_U41 ( .A1(S3_ALU_OUT[14]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[14]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n50) );
  INV_X1 S3_REG_ALU_U40 ( .A(S3_REG_ALU_n50), .ZN(S3_REG_ALU_n26) );
  AOI22_X1 S3_REG_ALU_U39 ( .A1(S3_ALU_OUT[13]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[13]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n49) );
  INV_X1 S3_REG_ALU_U38 ( .A(S3_REG_ALU_n49), .ZN(S3_REG_ALU_n27) );
  AOI22_X1 S3_REG_ALU_U37 ( .A1(S3_ALU_OUT[12]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[12]), .B2(S3_REG_ALU_n2), .ZN(S3_REG_ALU_n48) );
  INV_X1 S3_REG_ALU_U36 ( .A(S3_REG_ALU_n48), .ZN(S3_REG_ALU_n28) );
  AOI22_X1 S3_REG_ALU_U35 ( .A1(S3_ALU_OUT[11]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[11]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n47) );
  INV_X1 S3_REG_ALU_U34 ( .A(S3_REG_ALU_n47), .ZN(S3_REG_ALU_n29) );
  AOI22_X1 S3_REG_ALU_U33 ( .A1(S3_ALU_OUT[10]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[10]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n46) );
  INV_X1 S3_REG_ALU_U32 ( .A(S3_REG_ALU_n46), .ZN(S3_REG_ALU_n30) );
  AOI22_X1 S3_REG_ALU_U31 ( .A1(S3_ALU_OUT[9]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[9]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n45) );
  INV_X1 S3_REG_ALU_U30 ( .A(S3_REG_ALU_n45), .ZN(S3_REG_ALU_n31) );
  AOI22_X1 S3_REG_ALU_U29 ( .A1(S3_ALU_OUT[8]), .A2(S3_REG_ALU_n6), .B1(
        S3_REG_ALU_OUT[8]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n44) );
  INV_X1 S3_REG_ALU_U28 ( .A(S3_REG_ALU_n44), .ZN(S3_REG_ALU_n32) );
  AOI22_X1 S3_REG_ALU_U27 ( .A1(S3_ALU_OUT[7]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[7]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n43) );
  INV_X1 S3_REG_ALU_U26 ( .A(S3_REG_ALU_n43), .ZN(S3_REG_ALU_n33) );
  AOI22_X1 S3_REG_ALU_U25 ( .A1(S3_ALU_OUT[6]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[6]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n42) );
  INV_X1 S3_REG_ALU_U24 ( .A(S3_REG_ALU_n42), .ZN(S3_REG_ALU_n68) );
  AOI22_X1 S3_REG_ALU_U23 ( .A1(S3_ALU_OUT[5]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[5]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n41) );
  INV_X1 S3_REG_ALU_U22 ( .A(S3_REG_ALU_n41), .ZN(S3_REG_ALU_n69) );
  AOI22_X1 S3_REG_ALU_U21 ( .A1(S3_ALU_OUT[4]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[4]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n40) );
  INV_X1 S3_REG_ALU_U20 ( .A(S3_REG_ALU_n40), .ZN(S3_REG_ALU_n70) );
  AOI22_X1 S3_REG_ALU_U19 ( .A1(S3_ALU_OUT[3]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[3]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n39) );
  INV_X1 S3_REG_ALU_U18 ( .A(S3_REG_ALU_n39), .ZN(S3_REG_ALU_n71) );
  AOI22_X1 S3_REG_ALU_U17 ( .A1(S3_ALU_OUT[2]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[2]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n38) );
  INV_X1 S3_REG_ALU_U16 ( .A(S3_REG_ALU_n38), .ZN(S3_REG_ALU_n72) );
  AOI22_X1 S3_REG_ALU_U15 ( .A1(S3_ALU_OUT[1]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[1]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n37) );
  INV_X1 S3_REG_ALU_U14 ( .A(S3_REG_ALU_n37), .ZN(S3_REG_ALU_n73) );
  AOI22_X1 S3_REG_ALU_U13 ( .A1(S3_ALU_OUT[0]), .A2(S3_REG_ALU_n7), .B1(
        S3_REG_ALU_OUT[0]), .B2(S3_REG_ALU_n1), .ZN(S3_REG_ALU_n34) );
  INV_X1 S3_REG_ALU_U12 ( .A(S3_REG_ALU_n34), .ZN(S3_REG_ALU_n74) );
  BUF_X1 S3_REG_ALU_U11 ( .A(S3_REG_ALU_n4), .Z(S3_REG_ALU_n3) );
  BUF_X1 S3_REG_ALU_U10 ( .A(S3_REG_ALU_n4), .Z(S3_REG_ALU_n2) );
  BUF_X1 S3_REG_ALU_U9 ( .A(S3_REG_ALU_n4), .Z(S3_REG_ALU_n1) );
  NOR2_X1 S3_REG_ALU_U8 ( .A1(S3_REG_ALU_n75), .A2(S3_REG_ALU_n3), .ZN(
        S3_REG_ALU_n35) );
  BUF_X1 S3_REG_ALU_U7 ( .A(S3_REG_ALU_n8), .Z(S3_REG_ALU_n7) );
  BUF_X1 S3_REG_ALU_U6 ( .A(S3_REG_ALU_n8), .Z(S3_REG_ALU_n5) );
  BUF_X1 S3_REG_ALU_U5 ( .A(S3_REG_ALU_n8), .Z(S3_REG_ALU_n6) );
  BUF_X1 S3_REG_ALU_U4 ( .A(S3_REG_ALU_n36), .Z(S3_REG_ALU_n4) );
  BUF_X1 S3_REG_ALU_U3 ( .A(S3_REG_ALU_n35), .Z(S3_REG_ALU_n8) );
  DFF_X1 S3_REG_ALU_Q_reg_0_ ( .D(S3_REG_ALU_n74), .CK(CLK), .Q(
        S3_REG_ALU_OUT[0]) );
  DFF_X1 S3_REG_ALU_Q_reg_1_ ( .D(S3_REG_ALU_n73), .CK(CLK), .Q(
        S3_REG_ALU_OUT[1]) );
  DFF_X1 S3_REG_ALU_Q_reg_2_ ( .D(S3_REG_ALU_n72), .CK(CLK), .Q(
        S3_REG_ALU_OUT[2]) );
  DFF_X1 S3_REG_ALU_Q_reg_3_ ( .D(S3_REG_ALU_n71), .CK(CLK), .Q(
        S3_REG_ALU_OUT[3]) );
  DFF_X1 S3_REG_ALU_Q_reg_4_ ( .D(S3_REG_ALU_n70), .CK(CLK), .Q(
        S3_REG_ALU_OUT[4]) );
  DFF_X1 S3_REG_ALU_Q_reg_5_ ( .D(S3_REG_ALU_n69), .CK(CLK), .Q(
        S3_REG_ALU_OUT[5]) );
  DFF_X1 S3_REG_ALU_Q_reg_6_ ( .D(S3_REG_ALU_n68), .CK(CLK), .Q(
        S3_REG_ALU_OUT[6]) );
  DFF_X1 S3_REG_ALU_Q_reg_7_ ( .D(S3_REG_ALU_n33), .CK(CLK), .Q(
        S3_REG_ALU_OUT[7]) );
  DFF_X1 S3_REG_ALU_Q_reg_8_ ( .D(S3_REG_ALU_n32), .CK(CLK), .Q(
        S3_REG_ALU_OUT[8]) );
  DFF_X1 S3_REG_ALU_Q_reg_9_ ( .D(S3_REG_ALU_n31), .CK(CLK), .Q(
        S3_REG_ALU_OUT[9]) );
  DFF_X1 S3_REG_ALU_Q_reg_10_ ( .D(S3_REG_ALU_n30), .CK(CLK), .Q(
        S3_REG_ALU_OUT[10]) );
  DFF_X1 S3_REG_ALU_Q_reg_11_ ( .D(S3_REG_ALU_n29), .CK(CLK), .Q(
        S3_REG_ALU_OUT[11]) );
  DFF_X1 S3_REG_ALU_Q_reg_12_ ( .D(S3_REG_ALU_n28), .CK(CLK), .Q(
        S3_REG_ALU_OUT[12]) );
  DFF_X1 S3_REG_ALU_Q_reg_13_ ( .D(S3_REG_ALU_n27), .CK(CLK), .Q(
        S3_REG_ALU_OUT[13]) );
  DFF_X1 S3_REG_ALU_Q_reg_14_ ( .D(S3_REG_ALU_n26), .CK(CLK), .Q(
        S3_REG_ALU_OUT[14]) );
  DFF_X1 S3_REG_ALU_Q_reg_15_ ( .D(S3_REG_ALU_n25), .CK(CLK), .Q(
        S3_REG_ALU_OUT[15]) );
  DFF_X1 S3_REG_ALU_Q_reg_16_ ( .D(S3_REG_ALU_n24), .CK(CLK), .Q(
        S3_REG_ALU_OUT[16]) );
  DFF_X1 S3_REG_ALU_Q_reg_17_ ( .D(S3_REG_ALU_n23), .CK(CLK), .Q(
        S3_REG_ALU_OUT[17]) );
  DFF_X1 S3_REG_ALU_Q_reg_18_ ( .D(S3_REG_ALU_n22), .CK(CLK), .Q(
        S3_REG_ALU_OUT[18]) );
  DFF_X1 S3_REG_ALU_Q_reg_19_ ( .D(S3_REG_ALU_n21), .CK(CLK), .Q(
        S3_REG_ALU_OUT[19]) );
  DFF_X1 S3_REG_ALU_Q_reg_20_ ( .D(S3_REG_ALU_n20), .CK(CLK), .Q(
        S3_REG_ALU_OUT[20]) );
  DFF_X1 S3_REG_ALU_Q_reg_21_ ( .D(S3_REG_ALU_n19), .CK(CLK), .Q(
        S3_REG_ALU_OUT[21]) );
  DFF_X1 S3_REG_ALU_Q_reg_22_ ( .D(S3_REG_ALU_n18), .CK(CLK), .Q(
        S3_REG_ALU_OUT[22]) );
  DFF_X1 S3_REG_ALU_Q_reg_23_ ( .D(S3_REG_ALU_n17), .CK(CLK), .Q(
        S3_REG_ALU_OUT[23]) );
  DFF_X1 S3_REG_ALU_Q_reg_24_ ( .D(S3_REG_ALU_n16), .CK(CLK), .Q(
        S3_REG_ALU_OUT[24]) );
  DFF_X1 S3_REG_ALU_Q_reg_25_ ( .D(S3_REG_ALU_n15), .CK(CLK), .Q(
        S3_REG_ALU_OUT[25]) );
  DFF_X1 S3_REG_ALU_Q_reg_26_ ( .D(S3_REG_ALU_n14), .CK(CLK), .Q(
        S3_REG_ALU_OUT[26]) );
  DFF_X1 S3_REG_ALU_Q_reg_27_ ( .D(S3_REG_ALU_n13), .CK(CLK), .Q(
        S3_REG_ALU_OUT[27]) );
  DFF_X1 S3_REG_ALU_Q_reg_28_ ( .D(S3_REG_ALU_n12), .CK(CLK), .Q(
        S3_REG_ALU_OUT[28]) );
  DFF_X1 S3_REG_ALU_Q_reg_29_ ( .D(S3_REG_ALU_n11), .CK(CLK), .Q(
        S3_REG_ALU_OUT[29]) );
  DFF_X1 S3_REG_ALU_Q_reg_30_ ( .D(S3_REG_ALU_n10), .CK(CLK), .Q(
        S3_REG_ALU_OUT[30]) );
  DFF_X1 S3_REG_ALU_Q_reg_31_ ( .D(S3_REG_ALU_n9), .CK(CLK), .Q(
        S3_REG_ALU_OUT[31]) );
  AOI22_X1 S3_REG_DATA_U77 ( .A1(S2_RFILE_B_OUT[31]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[31]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n76) );
  INV_X1 S3_REG_DATA_U76 ( .A(S3_REG_DATA_n76), .ZN(S3_REG_DATA_n9) );
  AOI22_X1 S3_REG_DATA_U75 ( .A1(S2_RFILE_B_OUT[30]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[30]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n77) );
  INV_X1 S3_REG_DATA_U74 ( .A(S3_REG_DATA_n77), .ZN(S3_REG_DATA_n10) );
  AOI22_X1 S3_REG_DATA_U73 ( .A1(S2_RFILE_B_OUT[29]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[29]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n78) );
  INV_X1 S3_REG_DATA_U72 ( .A(S3_REG_DATA_n78), .ZN(S3_REG_DATA_n11) );
  AOI22_X1 S3_REG_DATA_U71 ( .A1(S2_RFILE_B_OUT[28]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[28]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n79) );
  INV_X1 S3_REG_DATA_U70 ( .A(S3_REG_DATA_n79), .ZN(S3_REG_DATA_n12) );
  AOI22_X1 S3_REG_DATA_U69 ( .A1(S2_RFILE_B_OUT[27]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[27]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n80) );
  INV_X1 S3_REG_DATA_U68 ( .A(S3_REG_DATA_n80), .ZN(S3_REG_DATA_n13) );
  AOI22_X1 S3_REG_DATA_U67 ( .A1(S2_RFILE_B_OUT[26]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[26]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n81) );
  INV_X1 S3_REG_DATA_U66 ( .A(S3_REG_DATA_n81), .ZN(S3_REG_DATA_n14) );
  AOI22_X1 S3_REG_DATA_U65 ( .A1(S2_RFILE_B_OUT[25]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[25]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n82) );
  INV_X1 S3_REG_DATA_U64 ( .A(S3_REG_DATA_n82), .ZN(S3_REG_DATA_n15) );
  AOI22_X1 S3_REG_DATA_U63 ( .A1(S2_RFILE_B_OUT[24]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[24]), .B2(S3_REG_DATA_n3), .ZN(S3_REG_DATA_n83) );
  INV_X1 S3_REG_DATA_U62 ( .A(S3_REG_DATA_n83), .ZN(S3_REG_DATA_n16) );
  AOI22_X1 S3_REG_DATA_U61 ( .A1(S2_RFILE_B_OUT[23]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[23]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n84) );
  INV_X1 S3_REG_DATA_U60 ( .A(S3_REG_DATA_n84), .ZN(S3_REG_DATA_n17) );
  AOI22_X1 S3_REG_DATA_U59 ( .A1(S2_RFILE_B_OUT[22]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[22]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n85) );
  INV_X1 S3_REG_DATA_U58 ( .A(S3_REG_DATA_n85), .ZN(S3_REG_DATA_n18) );
  AOI22_X1 S3_REG_DATA_U57 ( .A1(S2_RFILE_B_OUT[21]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[21]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n86) );
  INV_X1 S3_REG_DATA_U56 ( .A(S3_REG_DATA_n86), .ZN(S3_REG_DATA_n19) );
  AOI22_X1 S3_REG_DATA_U55 ( .A1(S2_RFILE_B_OUT[20]), .A2(S3_REG_DATA_n5), 
        .B1(S3_REG_DATA_OUT[20]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n87) );
  INV_X1 S3_REG_DATA_U54 ( .A(S3_REG_DATA_n87), .ZN(S3_REG_DATA_n20) );
  AOI22_X1 S3_REG_DATA_U53 ( .A1(S2_RFILE_B_OUT[19]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[19]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n88) );
  INV_X1 S3_REG_DATA_U52 ( .A(S3_REG_DATA_n88), .ZN(S3_REG_DATA_n21) );
  AOI22_X1 S3_REG_DATA_U51 ( .A1(S2_RFILE_B_OUT[18]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[18]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n89) );
  INV_X1 S3_REG_DATA_U50 ( .A(S3_REG_DATA_n89), .ZN(S3_REG_DATA_n22) );
  AOI22_X1 S3_REG_DATA_U49 ( .A1(S2_RFILE_B_OUT[17]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[17]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n90) );
  INV_X1 S3_REG_DATA_U48 ( .A(S3_REG_DATA_n90), .ZN(S3_REG_DATA_n23) );
  AOI22_X1 S3_REG_DATA_U47 ( .A1(S2_RFILE_B_OUT[16]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[16]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n91) );
  INV_X1 S3_REG_DATA_U46 ( .A(S3_REG_DATA_n91), .ZN(S3_REG_DATA_n24) );
  AOI22_X1 S3_REG_DATA_U45 ( .A1(S2_RFILE_B_OUT[15]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[15]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n92) );
  INV_X1 S3_REG_DATA_U44 ( .A(S3_REG_DATA_n92), .ZN(S3_REG_DATA_n25) );
  AOI22_X1 S3_REG_DATA_U43 ( .A1(S2_RFILE_B_OUT[14]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[14]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n93) );
  INV_X1 S3_REG_DATA_U42 ( .A(S3_REG_DATA_n93), .ZN(S3_REG_DATA_n26) );
  AOI22_X1 S3_REG_DATA_U41 ( .A1(S2_RFILE_B_OUT[13]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[13]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n94) );
  INV_X1 S3_REG_DATA_U40 ( .A(S3_REG_DATA_n94), .ZN(S3_REG_DATA_n27) );
  AOI22_X1 S3_REG_DATA_U39 ( .A1(S2_RFILE_B_OUT[12]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[12]), .B2(S3_REG_DATA_n2), .ZN(S3_REG_DATA_n95) );
  INV_X1 S3_REG_DATA_U38 ( .A(S3_REG_DATA_n95), .ZN(S3_REG_DATA_n28) );
  AOI22_X1 S3_REG_DATA_U37 ( .A1(S2_RFILE_B_OUT[11]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[11]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n96) );
  INV_X1 S3_REG_DATA_U36 ( .A(S3_REG_DATA_n96), .ZN(S3_REG_DATA_n29) );
  AOI22_X1 S3_REG_DATA_U35 ( .A1(S2_RFILE_B_OUT[10]), .A2(S3_REG_DATA_n6), 
        .B1(S3_REG_DATA_OUT[10]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n97) );
  INV_X1 S3_REG_DATA_U34 ( .A(S3_REG_DATA_n97), .ZN(S3_REG_DATA_n30) );
  AOI22_X1 S3_REG_DATA_U33 ( .A1(S2_RFILE_B_OUT[9]), .A2(S3_REG_DATA_n6), .B1(
        S3_REG_DATA_OUT[9]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n98) );
  INV_X1 S3_REG_DATA_U32 ( .A(S3_REG_DATA_n98), .ZN(S3_REG_DATA_n31) );
  AOI22_X1 S3_REG_DATA_U31 ( .A1(S2_RFILE_B_OUT[8]), .A2(S3_REG_DATA_n6), .B1(
        S3_REG_DATA_OUT[8]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n99) );
  INV_X1 S3_REG_DATA_U30 ( .A(S3_REG_DATA_n99), .ZN(S3_REG_DATA_n32) );
  AOI22_X1 S3_REG_DATA_U29 ( .A1(S2_RFILE_B_OUT[7]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[7]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n100) );
  INV_X1 S3_REG_DATA_U28 ( .A(S3_REG_DATA_n100), .ZN(S3_REG_DATA_n33) );
  AOI22_X1 S3_REG_DATA_U27 ( .A1(S2_RFILE_B_OUT[6]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[6]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n101) );
  INV_X1 S3_REG_DATA_U26 ( .A(S3_REG_DATA_n101), .ZN(S3_REG_DATA_n68) );
  AOI22_X1 S3_REG_DATA_U25 ( .A1(S2_RFILE_B_OUT[5]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[5]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n102) );
  INV_X1 S3_REG_DATA_U24 ( .A(S3_REG_DATA_n102), .ZN(S3_REG_DATA_n69) );
  AOI22_X1 S3_REG_DATA_U23 ( .A1(S2_RFILE_B_OUT[4]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[4]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n103) );
  INV_X1 S3_REG_DATA_U22 ( .A(S3_REG_DATA_n103), .ZN(S3_REG_DATA_n70) );
  AOI22_X1 S3_REG_DATA_U21 ( .A1(S2_RFILE_B_OUT[3]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[3]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n104) );
  INV_X1 S3_REG_DATA_U20 ( .A(S3_REG_DATA_n104), .ZN(S3_REG_DATA_n71) );
  AOI22_X1 S3_REG_DATA_U19 ( .A1(S2_RFILE_B_OUT[2]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[2]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n105) );
  INV_X1 S3_REG_DATA_U18 ( .A(S3_REG_DATA_n105), .ZN(S3_REG_DATA_n72) );
  AOI22_X1 S3_REG_DATA_U17 ( .A1(S2_RFILE_B_OUT[1]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[1]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n106) );
  INV_X1 S3_REG_DATA_U16 ( .A(S3_REG_DATA_n106), .ZN(S3_REG_DATA_n73) );
  AOI22_X1 S3_REG_DATA_U15 ( .A1(S2_RFILE_B_OUT[0]), .A2(S3_REG_DATA_n7), .B1(
        S3_REG_DATA_OUT[0]), .B2(S3_REG_DATA_n1), .ZN(S3_REG_DATA_n109) );
  INV_X1 S3_REG_DATA_U14 ( .A(S3_REG_DATA_n109), .ZN(S3_REG_DATA_n74) );
  INV_X1 S3_REG_DATA_U13 ( .A(nRST), .ZN(S3_REG_DATA_n75) );
  NOR2_X1 S3_REG_DATA_U12 ( .A1(1'b1), .A2(S3_REG_DATA_n75), .ZN(
        S3_REG_DATA_n107) );
  BUF_X1 S3_REG_DATA_U11 ( .A(S3_REG_DATA_n4), .Z(S3_REG_DATA_n3) );
  BUF_X1 S3_REG_DATA_U10 ( .A(S3_REG_DATA_n4), .Z(S3_REG_DATA_n2) );
  BUF_X1 S3_REG_DATA_U9 ( .A(S3_REG_DATA_n4), .Z(S3_REG_DATA_n1) );
  NOR2_X1 S3_REG_DATA_U8 ( .A1(S3_REG_DATA_n75), .A2(S3_REG_DATA_n3), .ZN(
        S3_REG_DATA_n108) );
  BUF_X1 S3_REG_DATA_U7 ( .A(S3_REG_DATA_n8), .Z(S3_REG_DATA_n7) );
  BUF_X1 S3_REG_DATA_U6 ( .A(S3_REG_DATA_n8), .Z(S3_REG_DATA_n5) );
  BUF_X1 S3_REG_DATA_U5 ( .A(S3_REG_DATA_n8), .Z(S3_REG_DATA_n6) );
  BUF_X1 S3_REG_DATA_U4 ( .A(S3_REG_DATA_n107), .Z(S3_REG_DATA_n4) );
  BUF_X1 S3_REG_DATA_U3 ( .A(S3_REG_DATA_n108), .Z(S3_REG_DATA_n8) );
  DFF_X1 S3_REG_DATA_Q_reg_0_ ( .D(S3_REG_DATA_n74), .CK(CLK), .Q(
        S3_REG_DATA_OUT[0]) );
  DFF_X1 S3_REG_DATA_Q_reg_1_ ( .D(S3_REG_DATA_n73), .CK(CLK), .Q(
        S3_REG_DATA_OUT[1]) );
  DFF_X1 S3_REG_DATA_Q_reg_2_ ( .D(S3_REG_DATA_n72), .CK(CLK), .Q(
        S3_REG_DATA_OUT[2]) );
  DFF_X1 S3_REG_DATA_Q_reg_3_ ( .D(S3_REG_DATA_n71), .CK(CLK), .Q(
        S3_REG_DATA_OUT[3]) );
  DFF_X1 S3_REG_DATA_Q_reg_4_ ( .D(S3_REG_DATA_n70), .CK(CLK), .Q(
        S3_REG_DATA_OUT[4]) );
  DFF_X1 S3_REG_DATA_Q_reg_5_ ( .D(S3_REG_DATA_n69), .CK(CLK), .Q(
        S3_REG_DATA_OUT[5]) );
  DFF_X1 S3_REG_DATA_Q_reg_6_ ( .D(S3_REG_DATA_n68), .CK(CLK), .Q(
        S3_REG_DATA_OUT[6]) );
  DFF_X1 S3_REG_DATA_Q_reg_7_ ( .D(S3_REG_DATA_n33), .CK(CLK), .Q(
        S3_REG_DATA_OUT[7]) );
  DFF_X1 S3_REG_DATA_Q_reg_8_ ( .D(S3_REG_DATA_n32), .CK(CLK), .Q(
        S3_REG_DATA_OUT[8]) );
  DFF_X1 S3_REG_DATA_Q_reg_9_ ( .D(S3_REG_DATA_n31), .CK(CLK), .Q(
        S3_REG_DATA_OUT[9]) );
  DFF_X1 S3_REG_DATA_Q_reg_10_ ( .D(S3_REG_DATA_n30), .CK(CLK), .Q(
        S3_REG_DATA_OUT[10]) );
  DFF_X1 S3_REG_DATA_Q_reg_11_ ( .D(S3_REG_DATA_n29), .CK(CLK), .Q(
        S3_REG_DATA_OUT[11]) );
  DFF_X1 S3_REG_DATA_Q_reg_12_ ( .D(S3_REG_DATA_n28), .CK(CLK), .Q(
        S3_REG_DATA_OUT[12]) );
  DFF_X1 S3_REG_DATA_Q_reg_13_ ( .D(S3_REG_DATA_n27), .CK(CLK), .Q(
        S3_REG_DATA_OUT[13]) );
  DFF_X1 S3_REG_DATA_Q_reg_14_ ( .D(S3_REG_DATA_n26), .CK(CLK), .Q(
        S3_REG_DATA_OUT[14]) );
  DFF_X1 S3_REG_DATA_Q_reg_15_ ( .D(S3_REG_DATA_n25), .CK(CLK), .Q(
        S3_REG_DATA_OUT[15]) );
  DFF_X1 S3_REG_DATA_Q_reg_16_ ( .D(S3_REG_DATA_n24), .CK(CLK), .Q(
        S3_REG_DATA_OUT[16]) );
  DFF_X1 S3_REG_DATA_Q_reg_17_ ( .D(S3_REG_DATA_n23), .CK(CLK), .Q(
        S3_REG_DATA_OUT[17]) );
  DFF_X1 S3_REG_DATA_Q_reg_18_ ( .D(S3_REG_DATA_n22), .CK(CLK), .Q(
        S3_REG_DATA_OUT[18]) );
  DFF_X1 S3_REG_DATA_Q_reg_19_ ( .D(S3_REG_DATA_n21), .CK(CLK), .Q(
        S3_REG_DATA_OUT[19]) );
  DFF_X1 S3_REG_DATA_Q_reg_20_ ( .D(S3_REG_DATA_n20), .CK(CLK), .Q(
        S3_REG_DATA_OUT[20]) );
  DFF_X1 S3_REG_DATA_Q_reg_21_ ( .D(S3_REG_DATA_n19), .CK(CLK), .Q(
        S3_REG_DATA_OUT[21]) );
  DFF_X1 S3_REG_DATA_Q_reg_22_ ( .D(S3_REG_DATA_n18), .CK(CLK), .Q(
        S3_REG_DATA_OUT[22]) );
  DFF_X1 S3_REG_DATA_Q_reg_23_ ( .D(S3_REG_DATA_n17), .CK(CLK), .Q(
        S3_REG_DATA_OUT[23]) );
  DFF_X1 S3_REG_DATA_Q_reg_24_ ( .D(S3_REG_DATA_n16), .CK(CLK), .Q(
        S3_REG_DATA_OUT[24]) );
  DFF_X1 S3_REG_DATA_Q_reg_25_ ( .D(S3_REG_DATA_n15), .CK(CLK), .Q(
        S3_REG_DATA_OUT[25]) );
  DFF_X1 S3_REG_DATA_Q_reg_26_ ( .D(S3_REG_DATA_n14), .CK(CLK), .Q(
        S3_REG_DATA_OUT[26]) );
  DFF_X1 S3_REG_DATA_Q_reg_27_ ( .D(S3_REG_DATA_n13), .CK(CLK), .Q(
        S3_REG_DATA_OUT[27]) );
  DFF_X1 S3_REG_DATA_Q_reg_28_ ( .D(S3_REG_DATA_n12), .CK(CLK), .Q(
        S3_REG_DATA_OUT[28]) );
  DFF_X1 S3_REG_DATA_Q_reg_29_ ( .D(S3_REG_DATA_n11), .CK(CLK), .Q(
        S3_REG_DATA_OUT[29]) );
  DFF_X1 S3_REG_DATA_Q_reg_30_ ( .D(S3_REG_DATA_n10), .CK(CLK), .Q(
        S3_REG_DATA_OUT[30]) );
  DFF_X1 S3_REG_DATA_Q_reg_31_ ( .D(S3_REG_DATA_n9), .CK(CLK), .Q(
        S3_REG_DATA_OUT[31]) );
  INV_X1 S3_REG_COND_U6 ( .A(EQ_COND), .ZN(S3_REG_COND_n2) );
  AOI22_X1 S3_REG_COND_U5 ( .A1(EQ_COND), .A2(S3_BranchTaken), .B1(
        S3_FF_COND_OUT), .B2(S3_REG_COND_n2), .ZN(S3_REG_COND_n3) );
  INV_X1 S3_REG_COND_U4 ( .A(nRST), .ZN(S3_REG_COND_n1) );
  NOR2_X1 S3_REG_COND_U3 ( .A1(S3_REG_COND_n3), .A2(S3_REG_COND_n1), .ZN(
        S3_REG_COND_n4) );
  DFF_X1 S3_REG_COND_Q_reg_0_ ( .D(S3_REG_COND_n4), .CK(CLK), .Q(
        S3_FF_COND_OUT) );
  NAND4_X1 S3_ZeroCompa_U14 ( .A1(S3_ZeroCompa_n9), .A2(S3_ZeroCompa_n10), 
        .A3(S3_ZeroCompa_n11), .A4(S3_ZeroCompa_n12), .ZN(S3_ZeroCompa_n3) );
  NOR2_X1 S3_ZeroCompa_U13 ( .A1(S3_ZeroCompa_n3), .A2(S3_ZeroCompa_n4), .ZN(
        S3_ZeroCompa_n2) );
  XNOR2_X1 S3_ZeroCompa_U12 ( .A(EQZ_NEQZ), .B(S3_ZeroCompa_n2), .ZN(
        S3_ZeroCompa_n1) );
  OR2_X1 S3_ZeroCompa_U11 ( .A1(JMP), .A2(S3_ZeroCompa_n1), .ZN(S3_BranchTaken) );
  NOR4_X1 S3_ZeroCompa_U10 ( .A1(S2_RFILE_A_OUT[1]), .A2(S2_RFILE_A_OUT[19]), 
        .A3(S2_RFILE_A_OUT[18]), .A4(S2_RFILE_A_OUT[17]), .ZN(S3_ZeroCompa_n7)
         );
  NOR4_X1 S3_ZeroCompa_U9 ( .A1(S2_RFILE_A_OUT[16]), .A2(S2_RFILE_A_OUT[15]), 
        .A3(S2_RFILE_A_OUT[14]), .A4(S2_RFILE_A_OUT[13]), .ZN(S3_ZeroCompa_n6)
         );
  NOR4_X1 S3_ZeroCompa_U8 ( .A1(S2_RFILE_A_OUT[12]), .A2(S2_RFILE_A_OUT[11]), 
        .A3(S2_RFILE_A_OUT[10]), .A4(S2_RFILE_A_OUT[0]), .ZN(S3_ZeroCompa_n5)
         );
  NAND4_X1 S3_ZeroCompa_U7 ( .A1(S3_ZeroCompa_n5), .A2(S3_ZeroCompa_n6), .A3(
        S3_ZeroCompa_n7), .A4(S3_ZeroCompa_n8), .ZN(S3_ZeroCompa_n4) );
  NOR4_X1 S3_ZeroCompa_U6 ( .A1(S2_RFILE_A_OUT[27]), .A2(S2_RFILE_A_OUT[26]), 
        .A3(S2_RFILE_A_OUT[25]), .A4(S2_RFILE_A_OUT[24]), .ZN(S3_ZeroCompa_n9)
         );
  NOR4_X1 S3_ZeroCompa_U5 ( .A1(S2_RFILE_A_OUT[30]), .A2(S2_RFILE_A_OUT[2]), 
        .A3(S2_RFILE_A_OUT[29]), .A4(S2_RFILE_A_OUT[28]), .ZN(S3_ZeroCompa_n10) );
  NOR4_X1 S3_ZeroCompa_U4 ( .A1(S2_RFILE_A_OUT[5]), .A2(S2_RFILE_A_OUT[4]), 
        .A3(S2_RFILE_A_OUT[3]), .A4(S2_RFILE_A_OUT[31]), .ZN(S3_ZeroCompa_n11)
         );
  NOR4_X1 S3_ZeroCompa_U3 ( .A1(S2_RFILE_A_OUT[9]), .A2(S2_RFILE_A_OUT[8]), 
        .A3(S2_RFILE_A_OUT[7]), .A4(S2_RFILE_A_OUT[6]), .ZN(S3_ZeroCompa_n12)
         );
  NOR4_X1 S3_ZeroCompa_U2 ( .A1(S2_RFILE_A_OUT[23]), .A2(S2_RFILE_A_OUT[22]), 
        .A3(S2_RFILE_A_OUT[21]), .A4(S2_RFILE_A_OUT[20]), .ZN(S3_ZeroCompa_n8)
         );
  INV_X1 S3_FF_JAL_EN_U6 ( .A(1'b1), .ZN(S3_FF_JAL_EN_n1) );
  AOI22_X1 S3_FF_JAL_EN_U5 ( .A1(1'b1), .A2(S2_FF_JAL_EN_OUT), .B1(
        S3_FF_JAL_EN_OUT), .B2(S3_FF_JAL_EN_n1), .ZN(S3_FF_JAL_EN_n6) );
  INV_X1 S3_FF_JAL_EN_U4 ( .A(nRST), .ZN(S3_FF_JAL_EN_n2) );
  NOR2_X1 S3_FF_JAL_EN_U3 ( .A1(S3_FF_JAL_EN_n6), .A2(S3_FF_JAL_EN_n2), .ZN(
        S3_FF_JAL_EN_n5) );
  DFF_X1 S3_FF_JAL_EN_Q_reg_0_ ( .D(S3_FF_JAL_EN_n5), .CK(CLK), .Q(
        S3_FF_JAL_EN_OUT) );
  AOI22_X1 S3_REG_NPC_U77 ( .A1(S2_REG_NPC_OUT[31]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[31]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n76) );
  INV_X1 S3_REG_NPC_U76 ( .A(S3_REG_NPC_n76), .ZN(S3_REG_NPC_n9) );
  AOI22_X1 S3_REG_NPC_U75 ( .A1(S2_REG_NPC_OUT[30]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[30]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n77) );
  INV_X1 S3_REG_NPC_U74 ( .A(S3_REG_NPC_n77), .ZN(S3_REG_NPC_n10) );
  AOI22_X1 S3_REG_NPC_U73 ( .A1(S2_REG_NPC_OUT[29]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[29]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n78) );
  INV_X1 S3_REG_NPC_U72 ( .A(S3_REG_NPC_n78), .ZN(S3_REG_NPC_n11) );
  AOI22_X1 S3_REG_NPC_U71 ( .A1(S2_REG_NPC_OUT[28]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[28]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n79) );
  INV_X1 S3_REG_NPC_U70 ( .A(S3_REG_NPC_n79), .ZN(S3_REG_NPC_n12) );
  AOI22_X1 S3_REG_NPC_U69 ( .A1(S2_REG_NPC_OUT[27]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[27]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n80) );
  INV_X1 S3_REG_NPC_U68 ( .A(S3_REG_NPC_n80), .ZN(S3_REG_NPC_n13) );
  AOI22_X1 S3_REG_NPC_U67 ( .A1(S2_REG_NPC_OUT[26]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[26]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n81) );
  INV_X1 S3_REG_NPC_U66 ( .A(S3_REG_NPC_n81), .ZN(S3_REG_NPC_n14) );
  AOI22_X1 S3_REG_NPC_U65 ( .A1(S2_REG_NPC_OUT[25]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[25]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n82) );
  INV_X1 S3_REG_NPC_U64 ( .A(S3_REG_NPC_n82), .ZN(S3_REG_NPC_n15) );
  AOI22_X1 S3_REG_NPC_U63 ( .A1(S2_REG_NPC_OUT[24]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[24]), .B2(S3_REG_NPC_n3), .ZN(S3_REG_NPC_n83) );
  INV_X1 S3_REG_NPC_U62 ( .A(S3_REG_NPC_n83), .ZN(S3_REG_NPC_n16) );
  AOI22_X1 S3_REG_NPC_U61 ( .A1(S2_REG_NPC_OUT[23]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[23]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n84) );
  INV_X1 S3_REG_NPC_U60 ( .A(S3_REG_NPC_n84), .ZN(S3_REG_NPC_n17) );
  AOI22_X1 S3_REG_NPC_U59 ( .A1(S2_REG_NPC_OUT[22]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[22]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n85) );
  INV_X1 S3_REG_NPC_U58 ( .A(S3_REG_NPC_n85), .ZN(S3_REG_NPC_n18) );
  AOI22_X1 S3_REG_NPC_U57 ( .A1(S2_REG_NPC_OUT[21]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[21]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n86) );
  INV_X1 S3_REG_NPC_U56 ( .A(S3_REG_NPC_n86), .ZN(S3_REG_NPC_n19) );
  AOI22_X1 S3_REG_NPC_U55 ( .A1(S2_REG_NPC_OUT[20]), .A2(S3_REG_NPC_n5), .B1(
        S3_REG_NPC_OUT[20]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n87) );
  INV_X1 S3_REG_NPC_U54 ( .A(S3_REG_NPC_n87), .ZN(S3_REG_NPC_n20) );
  AOI22_X1 S3_REG_NPC_U53 ( .A1(S2_REG_NPC_OUT[19]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[19]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n88) );
  INV_X1 S3_REG_NPC_U52 ( .A(S3_REG_NPC_n88), .ZN(S3_REG_NPC_n21) );
  AOI22_X1 S3_REG_NPC_U51 ( .A1(S2_REG_NPC_OUT[18]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[18]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n89) );
  INV_X1 S3_REG_NPC_U50 ( .A(S3_REG_NPC_n89), .ZN(S3_REG_NPC_n22) );
  AOI22_X1 S3_REG_NPC_U49 ( .A1(S2_REG_NPC_OUT[17]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[17]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n90) );
  INV_X1 S3_REG_NPC_U48 ( .A(S3_REG_NPC_n90), .ZN(S3_REG_NPC_n23) );
  AOI22_X1 S3_REG_NPC_U47 ( .A1(S2_REG_NPC_OUT[16]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[16]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n91) );
  INV_X1 S3_REG_NPC_U46 ( .A(S3_REG_NPC_n91), .ZN(S3_REG_NPC_n24) );
  AOI22_X1 S3_REG_NPC_U45 ( .A1(S2_REG_NPC_OUT[15]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[15]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n92) );
  INV_X1 S3_REG_NPC_U44 ( .A(S3_REG_NPC_n92), .ZN(S3_REG_NPC_n25) );
  AOI22_X1 S3_REG_NPC_U43 ( .A1(S2_REG_NPC_OUT[14]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[14]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n93) );
  INV_X1 S3_REG_NPC_U42 ( .A(S3_REG_NPC_n93), .ZN(S3_REG_NPC_n26) );
  AOI22_X1 S3_REG_NPC_U41 ( .A1(S2_REG_NPC_OUT[13]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[13]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n94) );
  INV_X1 S3_REG_NPC_U40 ( .A(S3_REG_NPC_n94), .ZN(S3_REG_NPC_n27) );
  AOI22_X1 S3_REG_NPC_U39 ( .A1(S2_REG_NPC_OUT[12]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[12]), .B2(S3_REG_NPC_n2), .ZN(S3_REG_NPC_n95) );
  INV_X1 S3_REG_NPC_U38 ( .A(S3_REG_NPC_n95), .ZN(S3_REG_NPC_n28) );
  AOI22_X1 S3_REG_NPC_U37 ( .A1(S2_REG_NPC_OUT[11]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[11]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n96) );
  INV_X1 S3_REG_NPC_U36 ( .A(S3_REG_NPC_n96), .ZN(S3_REG_NPC_n29) );
  AOI22_X1 S3_REG_NPC_U35 ( .A1(S2_REG_NPC_OUT[10]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[10]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n97) );
  INV_X1 S3_REG_NPC_U34 ( .A(S3_REG_NPC_n97), .ZN(S3_REG_NPC_n30) );
  AOI22_X1 S3_REG_NPC_U33 ( .A1(S2_REG_NPC_OUT[9]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[9]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n98) );
  INV_X1 S3_REG_NPC_U32 ( .A(S3_REG_NPC_n98), .ZN(S3_REG_NPC_n31) );
  AOI22_X1 S3_REG_NPC_U31 ( .A1(S2_REG_NPC_OUT[8]), .A2(S3_REG_NPC_n6), .B1(
        S3_REG_NPC_OUT[8]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n99) );
  INV_X1 S3_REG_NPC_U30 ( .A(S3_REG_NPC_n99), .ZN(S3_REG_NPC_n32) );
  AOI22_X1 S3_REG_NPC_U29 ( .A1(S2_REG_NPC_OUT[7]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[7]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n100) );
  INV_X1 S3_REG_NPC_U28 ( .A(S3_REG_NPC_n100), .ZN(S3_REG_NPC_n33) );
  AOI22_X1 S3_REG_NPC_U27 ( .A1(S2_REG_NPC_OUT[6]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[6]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n101) );
  INV_X1 S3_REG_NPC_U26 ( .A(S3_REG_NPC_n101), .ZN(S3_REG_NPC_n68) );
  AOI22_X1 S3_REG_NPC_U25 ( .A1(S2_REG_NPC_OUT[5]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[5]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n102) );
  INV_X1 S3_REG_NPC_U24 ( .A(S3_REG_NPC_n102), .ZN(S3_REG_NPC_n69) );
  AOI22_X1 S3_REG_NPC_U23 ( .A1(S2_REG_NPC_OUT[4]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[4]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n103) );
  INV_X1 S3_REG_NPC_U22 ( .A(S3_REG_NPC_n103), .ZN(S3_REG_NPC_n70) );
  AOI22_X1 S3_REG_NPC_U21 ( .A1(S2_REG_NPC_OUT[3]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[3]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n104) );
  INV_X1 S3_REG_NPC_U20 ( .A(S3_REG_NPC_n104), .ZN(S3_REG_NPC_n71) );
  AOI22_X1 S3_REG_NPC_U19 ( .A1(S2_REG_NPC_OUT[2]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[2]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n105) );
  INV_X1 S3_REG_NPC_U18 ( .A(S3_REG_NPC_n105), .ZN(S3_REG_NPC_n72) );
  AOI22_X1 S3_REG_NPC_U17 ( .A1(S2_REG_NPC_OUT[1]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[1]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n106) );
  INV_X1 S3_REG_NPC_U16 ( .A(S3_REG_NPC_n106), .ZN(S3_REG_NPC_n73) );
  AOI22_X1 S3_REG_NPC_U15 ( .A1(S2_REG_NPC_OUT[0]), .A2(S3_REG_NPC_n7), .B1(
        S3_REG_NPC_OUT[0]), .B2(S3_REG_NPC_n1), .ZN(S3_REG_NPC_n109) );
  INV_X1 S3_REG_NPC_U14 ( .A(S3_REG_NPC_n109), .ZN(S3_REG_NPC_n74) );
  INV_X1 S3_REG_NPC_U13 ( .A(nRST), .ZN(S3_REG_NPC_n75) );
  NOR2_X1 S3_REG_NPC_U12 ( .A1(1'b1), .A2(S3_REG_NPC_n75), .ZN(S3_REG_NPC_n107) );
  BUF_X1 S3_REG_NPC_U11 ( .A(S3_REG_NPC_n4), .Z(S3_REG_NPC_n3) );
  BUF_X1 S3_REG_NPC_U10 ( .A(S3_REG_NPC_n4), .Z(S3_REG_NPC_n2) );
  BUF_X1 S3_REG_NPC_U9 ( .A(S3_REG_NPC_n4), .Z(S3_REG_NPC_n1) );
  NOR2_X1 S3_REG_NPC_U8 ( .A1(S3_REG_NPC_n75), .A2(S3_REG_NPC_n3), .ZN(
        S3_REG_NPC_n108) );
  BUF_X1 S3_REG_NPC_U7 ( .A(S3_REG_NPC_n8), .Z(S3_REG_NPC_n7) );
  BUF_X1 S3_REG_NPC_U6 ( .A(S3_REG_NPC_n8), .Z(S3_REG_NPC_n5) );
  BUF_X1 S3_REG_NPC_U5 ( .A(S3_REG_NPC_n8), .Z(S3_REG_NPC_n6) );
  BUF_X1 S3_REG_NPC_U4 ( .A(S3_REG_NPC_n107), .Z(S3_REG_NPC_n4) );
  BUF_X1 S3_REG_NPC_U3 ( .A(S3_REG_NPC_n108), .Z(S3_REG_NPC_n8) );
  DFF_X1 S3_REG_NPC_Q_reg_0_ ( .D(S3_REG_NPC_n74), .CK(CLK), .Q(
        S3_REG_NPC_OUT[0]) );
  DFF_X1 S3_REG_NPC_Q_reg_1_ ( .D(S3_REG_NPC_n73), .CK(CLK), .Q(
        S3_REG_NPC_OUT[1]) );
  DFF_X1 S3_REG_NPC_Q_reg_2_ ( .D(S3_REG_NPC_n72), .CK(CLK), .Q(
        S3_REG_NPC_OUT[2]) );
  DFF_X1 S3_REG_NPC_Q_reg_3_ ( .D(S3_REG_NPC_n71), .CK(CLK), .Q(
        S3_REG_NPC_OUT[3]) );
  DFF_X1 S3_REG_NPC_Q_reg_4_ ( .D(S3_REG_NPC_n70), .CK(CLK), .Q(
        S3_REG_NPC_OUT[4]) );
  DFF_X1 S3_REG_NPC_Q_reg_5_ ( .D(S3_REG_NPC_n69), .CK(CLK), .Q(
        S3_REG_NPC_OUT[5]) );
  DFF_X1 S3_REG_NPC_Q_reg_6_ ( .D(S3_REG_NPC_n68), .CK(CLK), .Q(
        S3_REG_NPC_OUT[6]) );
  DFF_X1 S3_REG_NPC_Q_reg_7_ ( .D(S3_REG_NPC_n33), .CK(CLK), .Q(
        S3_REG_NPC_OUT[7]) );
  DFF_X1 S3_REG_NPC_Q_reg_8_ ( .D(S3_REG_NPC_n32), .CK(CLK), .Q(
        S3_REG_NPC_OUT[8]) );
  DFF_X1 S3_REG_NPC_Q_reg_9_ ( .D(S3_REG_NPC_n31), .CK(CLK), .Q(
        S3_REG_NPC_OUT[9]) );
  DFF_X1 S3_REG_NPC_Q_reg_10_ ( .D(S3_REG_NPC_n30), .CK(CLK), .Q(
        S3_REG_NPC_OUT[10]) );
  DFF_X1 S3_REG_NPC_Q_reg_11_ ( .D(S3_REG_NPC_n29), .CK(CLK), .Q(
        S3_REG_NPC_OUT[11]) );
  DFF_X1 S3_REG_NPC_Q_reg_12_ ( .D(S3_REG_NPC_n28), .CK(CLK), .Q(
        S3_REG_NPC_OUT[12]) );
  DFF_X1 S3_REG_NPC_Q_reg_13_ ( .D(S3_REG_NPC_n27), .CK(CLK), .Q(
        S3_REG_NPC_OUT[13]) );
  DFF_X1 S3_REG_NPC_Q_reg_14_ ( .D(S3_REG_NPC_n26), .CK(CLK), .Q(
        S3_REG_NPC_OUT[14]) );
  DFF_X1 S3_REG_NPC_Q_reg_15_ ( .D(S3_REG_NPC_n25), .CK(CLK), .Q(
        S3_REG_NPC_OUT[15]) );
  DFF_X1 S3_REG_NPC_Q_reg_16_ ( .D(S3_REG_NPC_n24), .CK(CLK), .Q(
        S3_REG_NPC_OUT[16]) );
  DFF_X1 S3_REG_NPC_Q_reg_17_ ( .D(S3_REG_NPC_n23), .CK(CLK), .Q(
        S3_REG_NPC_OUT[17]) );
  DFF_X1 S3_REG_NPC_Q_reg_18_ ( .D(S3_REG_NPC_n22), .CK(CLK), .Q(
        S3_REG_NPC_OUT[18]) );
  DFF_X1 S3_REG_NPC_Q_reg_19_ ( .D(S3_REG_NPC_n21), .CK(CLK), .Q(
        S3_REG_NPC_OUT[19]) );
  DFF_X1 S3_REG_NPC_Q_reg_20_ ( .D(S3_REG_NPC_n20), .CK(CLK), .Q(
        S3_REG_NPC_OUT[20]) );
  DFF_X1 S3_REG_NPC_Q_reg_21_ ( .D(S3_REG_NPC_n19), .CK(CLK), .Q(
        S3_REG_NPC_OUT[21]) );
  DFF_X1 S3_REG_NPC_Q_reg_22_ ( .D(S3_REG_NPC_n18), .CK(CLK), .Q(
        S3_REG_NPC_OUT[22]) );
  DFF_X1 S3_REG_NPC_Q_reg_23_ ( .D(S3_REG_NPC_n17), .CK(CLK), .Q(
        S3_REG_NPC_OUT[23]) );
  DFF_X1 S3_REG_NPC_Q_reg_24_ ( .D(S3_REG_NPC_n16), .CK(CLK), .Q(
        S3_REG_NPC_OUT[24]) );
  DFF_X1 S3_REG_NPC_Q_reg_25_ ( .D(S3_REG_NPC_n15), .CK(CLK), .Q(
        S3_REG_NPC_OUT[25]) );
  DFF_X1 S3_REG_NPC_Q_reg_26_ ( .D(S3_REG_NPC_n14), .CK(CLK), .Q(
        S3_REG_NPC_OUT[26]) );
  DFF_X1 S3_REG_NPC_Q_reg_27_ ( .D(S3_REG_NPC_n13), .CK(CLK), .Q(
        S3_REG_NPC_OUT[27]) );
  DFF_X1 S3_REG_NPC_Q_reg_28_ ( .D(S3_REG_NPC_n12), .CK(CLK), .Q(
        S3_REG_NPC_OUT[28]) );
  DFF_X1 S3_REG_NPC_Q_reg_29_ ( .D(S3_REG_NPC_n11), .CK(CLK), .Q(
        S3_REG_NPC_OUT[29]) );
  DFF_X1 S3_REG_NPC_Q_reg_30_ ( .D(S3_REG_NPC_n10), .CK(CLK), .Q(
        S3_REG_NPC_OUT[30]) );
  DFF_X1 S3_REG_NPC_Q_reg_31_ ( .D(S3_REG_NPC_n9), .CK(CLK), .Q(
        S3_REG_NPC_OUT[31]) );
  AOI22_X1 S3_REG_ADD_WR_U15 ( .A1(S2_REG_ADD_WR_OUT[4]), .A2(S3_REG_ADD_WR_n8), .B1(S3_REG_ADD_WR_OUT[4]), .B2(S3_REG_ADD_WR_n9), .ZN(S3_REG_ADD_WR_n13) );
  INV_X1 S3_REG_ADD_WR_U14 ( .A(S3_REG_ADD_WR_n13), .ZN(S3_REG_ADD_WR_n1) );
  AOI22_X1 S3_REG_ADD_WR_U13 ( .A1(S2_REG_ADD_WR_OUT[3]), .A2(S3_REG_ADD_WR_n8), .B1(S3_REG_ADD_WR_OUT[3]), .B2(S3_REG_ADD_WR_n9), .ZN(S3_REG_ADD_WR_n12) );
  INV_X1 S3_REG_ADD_WR_U12 ( .A(S3_REG_ADD_WR_n12), .ZN(S3_REG_ADD_WR_n2) );
  AOI22_X1 S3_REG_ADD_WR_U11 ( .A1(S2_REG_ADD_WR_OUT[2]), .A2(S3_REG_ADD_WR_n8), .B1(S3_REG_ADD_WR_OUT[2]), .B2(S3_REG_ADD_WR_n9), .ZN(S3_REG_ADD_WR_n11) );
  INV_X1 S3_REG_ADD_WR_U10 ( .A(S3_REG_ADD_WR_n11), .ZN(S3_REG_ADD_WR_n3) );
  AOI22_X1 S3_REG_ADD_WR_U9 ( .A1(S2_REG_ADD_WR_OUT[1]), .A2(S3_REG_ADD_WR_n8), 
        .B1(S3_REG_ADD_WR_OUT[1]), .B2(S3_REG_ADD_WR_n9), .ZN(
        S3_REG_ADD_WR_n10) );
  INV_X1 S3_REG_ADD_WR_U8 ( .A(S3_REG_ADD_WR_n10), .ZN(S3_REG_ADD_WR_n4) );
  AOI22_X1 S3_REG_ADD_WR_U7 ( .A1(S2_REG_ADD_WR_OUT[0]), .A2(S3_REG_ADD_WR_n8), 
        .B1(S3_REG_ADD_WR_OUT[0]), .B2(S3_REG_ADD_WR_n9), .ZN(S3_REG_ADD_WR_n7) );
  INV_X1 S3_REG_ADD_WR_U6 ( .A(S3_REG_ADD_WR_n7), .ZN(S3_REG_ADD_WR_n5) );
  INV_X1 S3_REG_ADD_WR_U5 ( .A(nRST), .ZN(S3_REG_ADD_WR_n6) );
  NOR2_X1 S3_REG_ADD_WR_U4 ( .A1(1'b1), .A2(S3_REG_ADD_WR_n6), .ZN(
        S3_REG_ADD_WR_n9) );
  NOR2_X1 S3_REG_ADD_WR_U3 ( .A1(S3_REG_ADD_WR_n6), .A2(S3_REG_ADD_WR_n9), 
        .ZN(S3_REG_ADD_WR_n8) );
  DFF_X1 S3_REG_ADD_WR_Q_reg_0_ ( .D(S3_REG_ADD_WR_n5), .CK(CLK), .Q(
        S3_REG_ADD_WR_OUT[0]) );
  DFF_X1 S3_REG_ADD_WR_Q_reg_1_ ( .D(S3_REG_ADD_WR_n4), .CK(CLK), .Q(
        S3_REG_ADD_WR_OUT[1]) );
  DFF_X1 S3_REG_ADD_WR_Q_reg_2_ ( .D(S3_REG_ADD_WR_n3), .CK(CLK), .Q(
        S3_REG_ADD_WR_OUT[2]) );
  DFF_X1 S3_REG_ADD_WR_Q_reg_3_ ( .D(S3_REG_ADD_WR_n2), .CK(CLK), .Q(
        S3_REG_ADD_WR_OUT[3]) );
  DFF_X1 S3_REG_ADD_WR_Q_reg_4_ ( .D(S3_REG_ADD_WR_n1), .CK(CLK), .Q(
        S3_REG_ADD_WR_OUT[4]) );
endmodule

