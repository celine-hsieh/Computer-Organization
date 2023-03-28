module Mux (
    input [31:0] rs1_data_out,
    input [31:0] PC,
    input alu_op1_sel,
    input jb_op1_sel,

    input [31:0] rs2_data_out,
    input [31:0] imm_ext_out,
    input alu_op2_sel,

    input [31:0] ld_data_f,
    input [31:0] alu_out,
    input wb_sel,

    input [31:0] PCPlus4,
    input [31:0] jb_out,
    input next_pc_sel,

    output [31:0] alu_operand1,
    output [31:0] alu_operand2,
    output [31:0] jb_operand1,
    output [31:0] wb_data,
    output [31:0] next_pc
);

assign alu_operand1 = (alu_op1_sel) ? rs1_data_out : PC;
assign alu_operand2 = (alu_op2_sel) ? rs2_data_out : imm_ext_out;
assign jb_operand1 = (jb_op1_sel) ? rs1_data_out : PC;
assign wb_data = (wb_sel) ? ld_data_f : alu_out;
assign next_pc = (next_pc_sel) ? PCPlus4 : jb_out;

endmodule