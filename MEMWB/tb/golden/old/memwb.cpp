#include <systemc>
#define IR_SIZE 32
using namespace sc_core;
using namespace sc_dt;

SC_MODULE(MemStage) {
    //sc_in<bool>              clk;
    //sc_in<bool>              rst_n;

    sc_in<sc_uint<IR_SIZE>>     s3_reg_npc_out;
    sc_in<bool>                 s3_ff_jal_en_out;
    sc_in<sc_uint<5>>           s3_reg_add_wr_out;
    sc_in<bool>                 s3_reg_cond_out;
    sc_in<bool>                 jump_en;
    sc_in<sc_uint<IR_SIZE>>     s1_add_out; //??
    sc_in<sc_uint<IR_SIZE>>     s3_reg_alu_out;
    sc_in<sc_uint<IR_SIZE>>     dram_out;
    sc_in<bool>                 lmd_latch_en;

    sc_out<sc_uint<IR_SIZE>>    s4_reg_npc_out;
    sc_out<bool>                s4_ff_jal_en_out;
    sc_out<sc_uint<IR_SIZE>>    dp_to_dlx_pc;
    sc_out<sc_uint<5>>          s4_reg_add_wr_out;
    sc_out<sc_uint<IR_SIZE>>    s4_reg_alu_out;
    sc_out<sc_uint<IR_SIZE>>    s4_reg_lmd_out;

    SC_CTOR(MemStage) {
        SC_METHOD(s4_reg_npc);
        sensitive << s3_reg_npc_out;

        SC_METHOD(s4_ff_jal_en);
        sensitive << s3_ff_jal_en_out;

        SC_METHOD(s4_reg_add_wr);
        sensitive << s3_reg_add_wr_out;

        SC_METHOD(s4_mux_jmp);
        sensitive << s3_reg_cond_out
                  << jump_en
                  << s1_add_out
                  << s3_reg_alu_out;

        SC_METHOD(s4_reg_alu);
        sensitive << s3_reg_alu_out;

        SC_METHOD(s4_reg_lmd);
        sensitive << dram_out;
    }

    void s4_reg_npc() {
        s4_reg_npc_out = s3_reg_npc_out;
    }

    void s4_ff_jal_en() {
        s4_ff_jal_en_out = s3_ff_jal_en_out;
    }

    void s4_reg_add_wr() {
        s4_reg_add_wr_out = s3_reg_add_wr_out;
    }

    void s4_mux_jmp() {
        dp_to_dlx_pc = s3_reg_alu_out;
    }

    void s4_reg_alu() {
        s4_reg_alu_out = s3_reg_alu_out;
    }

    void s4_reg_lmd() {
        s4_reg_lmd_out = dram_out;
    }
};

SC_MODULE(WBStage) {
    //sc_in<bool>              clk;
    //sc_in<bool>              rst_n;

    sc_signal<sc_uint<IR_SIZE>> s5_mux_wb_out;

    sc_in<sc_uint<IR_SIZE>>     s4_reg_npc_out;
    sc_in<bool>                 s4_ff_jal_en_out;
    sc_in<sc_uint<IR_SIZE>>     s4_reg_alu_out;
    sc_in<sc_uint<IR_SIZE>>     s4_reg_lmd_out;
    sc_in<bool>                 wb_mux_sel;

    sc_out<sc_uint<IR_SIZE>>    s5_mux_datain_out;

    SC_CTOR(WBStage) {
        SC_METHOD(s5_mux_wb);
        sensitive << s4_reg_alu_out << s4_reg_lmd_out << wb_mux_sel;

        SC_METHOD(s5_mux_datain);
        sensitive << s4_ff_jal_en_out << s4_reg_npc_out << s5_mux_wb_out;
    }

    void s5_mux_wb() {
        if (wb_mux_sel)
            s5_mux_wb_out = s4_reg_alu_out;
        else
            s5_mux_wb_out = s4_reg_lmd_out;
    }

    void s5_mux_datain() {
        if (s4_ff_jal_en_out)
            s5_mux_datain_out = s4_reg_npc_out;
        else
            s5_mux_datain_out = s5_mux_wb_out;
    }
};

/* toplevel module */
SC_MODULE(MemWBStage) {
    /* Signal declarations */
    //sc_clock                          clk;
    //sc_in<bool>                       rst_n;

    sc_in<sc_uint<IR_SIZE>>             s3_reg_npc_out;
    sc_in<bool>                         s3_ff_jal_en_out;
    sc_in<sc_uint<5>>                   s3_reg_add_wr_out;
    sc_in<bool>                         s3_reg_cond_out;
    sc_in<bool>                         jump_en;
    sc_in<sc_uint<IR_SIZE>>             s1_add_out; //??
    sc_in<sc_uint<IR_SIZE>>             s3_reg_alu_out;
    sc_in<sc_uint<IR_SIZE>>             dram_out;
    sc_in<bool>                         lmd_latch_en;

    sc_in<bool>                         wb_mux_sel;

    sc_signal<sc_uint<IR_SIZE>>         s4_reg_npc_out;
    sc_signal<bool>                     s4_ff_jal_en_out;
    sc_signal<sc_uint<IR_SIZE>>         s4_reg_alu_out;
    sc_signal<sc_uint<IR_SIZE>>         s4_reg_lmd_out;

    /* Output signal declarations */
    sc_out<sc_uint<5>>                  s4_reg_add_wr_out;
    sc_out<sc_uint<IR_SIZE>>            dp_to_dlx_pc;
    sc_out<sc_uint<IR_SIZE>>            s5_mux_datain_out;

    /* Submodule declaration */
    MemStage    mem;
    WBStage     wb;

    SC_CTOR(MemWBStage) : mem("Mem Stage")
                        , wb("Writeback Stage")
    {
        /* Mem stage input signals */
        //mem.clk(clk);
        //mem.rst_n(rst_n);

        mem.s3_reg_npc_out(s3_reg_npc_out);
        mem.s3_ff_jal_en_out(s3_ff_jal_en_out);
        mem.s3_reg_add_wr_out(s3_reg_add_wr_out);
        mem.s3_reg_cond_out(s3_reg_cond_out);
        mem.jump_en(jump_en);
        mem.s1_add_out(s1_add_out);
        mem.s3_reg_alu_out(s3_reg_alu_out);
        mem.dram_out(dram_out);
        mem.lmd_latch_en(lmd_latch_en);
        
        /* Mem stage output signals */
        mem.s4_reg_npc_out(s4_reg_npc_out);
        mem.s4_ff_jal_en_out(s4_ff_jal_en_out);
        mem.dp_to_dlx_pc(dp_to_dlx_pc);
        mem.s4_reg_add_wr_out(s4_reg_add_wr_out);
        mem.s4_reg_alu_out(s4_reg_alu_out);
        mem.s4_reg_lmd_out(s4_reg_lmd_out);

        /* Wb stage input signals */
        wb.s4_reg_npc_out(s4_reg_npc_out);
        wb.s4_ff_jal_en_out(s4_ff_jal_en_out);
        wb.s4_reg_alu_out(s4_reg_alu_out);
        wb.s4_reg_lmd_out(s4_reg_lmd_out);
        wb.wb_mux_sel(wb_mux_sel);

        /* Wb stage output signals */
        wb.s5_mux_datain_out(s5_mux_datain_out);
    }
};
SC_MODULE_EXPORT(MemWBStage);

