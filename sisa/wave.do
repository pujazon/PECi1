onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/clk
add wave -noupdate -radix hexadecimal /test_sisa/soc/pro0/c0/c0/ir
add wave -noupdate /test_sisa/soc/pro0/c0/m0/estado
add wave -noupdate -radix hexadecimal /test_sisa/soc/pro0/c0/c0/tknbr
add wave -noupdate /test_sisa/soc/pro0/c0/pc
add wave -noupdate /test_sisa/soc/pro0/c0/reti_pc
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/clk
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/boot
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/datard_m
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/rd_io
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/addr_m
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/data_wr
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/wr_m
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/word_byte
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/wr_io
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/addr_io
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/rd_in
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/wr_out
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_rd_in
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_in_op_mux
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_wrd
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_ins_dad
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_immed_x2
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_wr_m
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_word_byte
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_br_n
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_z
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_addr_a
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_addr_b
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_addr_d
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_op
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_immed
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_pc
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_aluout
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_reti_pc
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_f
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_in_d
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_addr_io
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_ei
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_di
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_reti
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_a_sys
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/t_wrd_rsys
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/rds_bit_t
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/wrs_bit_t
add wave -noupdate -group PROC_TOP -radix hexadecimal /test_sisa/soc/pro0/getiid_bit_t
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/ei
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/di
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/reti
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/wrd_rsys
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/system
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/a_sys
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/rds_bit
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/wrs_bit
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/getiid_bit
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group SYS_UCL -radix hexadecimal /test_sisa/soc/pro0/c0/c0/f_sys
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/op
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/z
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/f
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/ldpc
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/wrd
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/addr_a
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/addr_b
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/addr_d
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/immed
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/wr_m
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/in_d
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/immed_x2
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/br_n
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/word_byte
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/addr_io
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/rd_in
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/wr_out
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/in_op_mux
add wave -noupdate -group {UNIDAD CONTROL} -expand -group UC_L -group OTROS -radix hexadecimal /test_sisa/soc/pro0/c0/c0/opcode
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/system
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/boot
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wrout_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/ldpc_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wrd_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wr_m_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/w_b
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/ei_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/di_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/reti_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wrd_rsys_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/a_sys_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/rds_bit_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wrs_bit_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/getiid_bit_l
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/ldpc
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wrd
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wr_m
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/ldir
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/ins_dad
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wr_out
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/word_byte
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/ei
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/di
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/reti
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wrd_rsys
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/a_sys
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/rds_bit
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/wrs_bit
add wave -noupdate -group {UNIDAD CONTROL} -group MULTI -radix hexadecimal /test_sisa/soc/pro0/c0/m0/getiid_bit
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/op
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/f
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/wrd
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/ei
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/di
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reti
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/wrd_rsys
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/a_sys
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/rds_bit
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/wrs_bit
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/getiid_bit
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reti_pc
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/in_op_mux
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/addr_a
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/addr_b
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/addr_d
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/rd_io
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/immed
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/immed_x2
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/datard_m
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/ins_dad
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/pc
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/in_d
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/br_n
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/addr_m
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/data_wr
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/z
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/aluout
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/wr_io
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/alu_out
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reg_a_gen
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reg_a
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reg_a_sys
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reg_b
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/d_in_s
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reg_in
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/reg_in_t
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/immed_out
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/y_alu
add wave -noupdate -group DATAPTH -group OTROS -radix hexadecimal /test_sisa/soc/pro0/e0/bit_d_in_s
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/wrd
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/d
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/addr_a
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/addr_b
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/addr_d
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/a
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/b
add wave -noupdate -group DATAPTH -expand -group REG0 -radix hexadecimal /test_sisa/soc/pro0/e0/reg0/br
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/wrd
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/ei
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/di
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/reti
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/d
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/addr_a
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/addr_d
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/a
add wave -noupdate -group DATAPTH -group REGS -radix hexadecimal /test_sisa/soc/pro0/e0/regs/bs
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/x
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/y
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/op
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/f
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/z
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/w
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/sortida_memory
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/sortida_arith
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/sortida_cmp
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/sortida_mul
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/memory_alu0/x
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/memory_alu0/y
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/memory_alu0/f
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/memory_alu0/w
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/arith_alu0/x
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/arith_alu0/y
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/arith_alu0/f
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/arith_alu0/w
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/arith_alu0/shiftamount
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/cmp_alu0/x
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/cmp_alu0/y
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/cmp_alu0/f
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/cmp_alu0/w
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/cmp_alu0/res
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/mul_alu0/x
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/mul_alu0/y
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/mul_alu0/f
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/mul_alu0/w
add wave -noupdate -group DATAPTH -group ALU -radix hexadecimal /test_sisa/soc/pro0/e0/alu0/mul_alu0/res
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 285
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {839 ps}
