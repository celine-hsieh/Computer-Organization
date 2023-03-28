`include "./src/Adder.v"
`include "./src/ALU.v"
`include "./src/Controller.v"
`include "./src/Decoder.v"
`include "./src/Imme_Ext.v"
`include "./src/JB_Unit.v"
`include "./src/LD_Filter.v"
`include "./src/Mux.v"
`include "./src/Reg_PC.v"
`include "./src/RegFile.v"
`include "./src/SRAM.v"


module Top (
    input clk,
    input rst
);

//ALU Wires
wire [31:0]alu_operand1, alu_operand2;
wire [31:0]alu_out;

//Controller Wires
wire [4:0]opcode;
wire [2:0]func3;
wire func7; 
wire next_pc_sel, wb_en, alu_op1_sel, alu_op2_sel, jb_op1_sel, wb_sel;
wire [3:0]im_w_en,  dm_w_en;

//Decoder Wires
wire [31:0]inst;
wire [4:0]dc_out_opcode, dc_out_rs1_index, dc_out_rs2_index, dc_out_rd_index;
wire [2:0]dc_out_func3;
wire dc_out_func7;

//Imm_Ext Wires
wire [31:0]imm_ext_out;

//JB_Unit Wires
wire [31:0]jb_operand1, jb_out;

//LD_Filter Wires
wire [31:0]ld_data, ld_data_f;

//Mux Wires
wire [31:0]rs1_data_out, rs2_data_out, wb_data;

//Reg_PC Wires
wire [31:0]next_pc, current_pc;

//Adder Wires
wire [31:0]PCPlus4;


Adder adder(
    .PC(current_pc),
    .PCPlus4(PCPlus4)
);

ALU alu(
    .opcode(opcode),
    .func3(func3),
    .func7(func7),
    .operand1(alu_operand1),
    .operand2(alu_operand2),
    .alu_out(alu_out)
);

Controller controller(
    .opcode(dc_out_opcode),
    .func3(dc_out_func3),
    .func7(dc_out_func7),
    .current_pc(current_pc),
    .alu_out(alu_out),
    .next_pc_sel(next_pc_sel),
    .im_w_en(im_w_en),
    .wb_en(wb_en),
    .alu_op1_sel(alu_op1_sel),
    .alu_op2_sel(alu_op2_sel),
    .jb_op1_sel(jb_op1_sel),
    .ctrl_opcode(opcode),
    .ctrl_func3(func3),
    .ctrl_func7(func7),
    .dm_w_en(dm_w_en),
    .wb_sel(wb_sel)
);

Decoder decoder(
    .inst(inst),
    .dc_out_opcode(dc_out_opcode),
    .dc_out_func3(dc_out_func3),
    .dc_out_func7(dc_out_func7),
    .dc_out_rs1_index(dc_out_rs1_index),
    .dc_out_rs2_index(dc_out_rs2_index),
    .dc_out_rd_index(dc_out_rd_index)
);

Imm_Ext imm_ext(
    .inst(inst),
    .imm_ext_out(imm_ext_out)
);

JB_Unit jb_unit(
    .operand1(jb_operand1),
    .operand2(imm_ext_out),
    .jb_out(jb_out)
);

LD_Filter ld_filter(
    .func3(func3),
    .ld_data(ld_data),
    .ld_data_f(ld_data_f)
);

Mux mux(
    .rs1_data_out(rs1_data_out),
    .PC(current_pc),
    .alu_op1_sel(alu_op1_sel),
    .jb_op1_sel(jb_op1_sel),
    .rs2_data_out(rs2_data_out),
    .imm_ext_out(imm_ext_out),
    .alu_op2_sel(alu_op2_sel),
    .ld_data_f(ld_data_f),
    .alu_out(alu_out),
    .wb_sel(wb_sel),
    .PCPlus4(PCPlus4),
    .jb_out(jb_out),
    .next_pc_sel(next_pc_sel),
    .alu_operand1(alu_operand1),
    .alu_operand2(alu_operand2),
    .jb_operand1(jb_operand1),
    .wb_data(wb_data),
    .next_pc(next_pc)
);

Reg_PC reg_pc(
    .clk(clk),
    .rst(rst),
    .next_pc(next_pc),
    .current_pc(current_pc)
);

RegFile regfile(
    .clk(clk),
    .wb_en(wb_en),
    .wb_data(wb_data),
    .rd_index(dc_out_rd_index),
    .rs1_index(dc_out_rs1_index),
    .rs2_index(dc_out_rs2_index),
    .rs1_data_out(rs1_data_out),
    .rs2_data_out(rs2_data_out)
);

SRAM im (
    .clk(clk),
    .w_en(im_w_en),
    .address(current_pc[15:0]),
    .write_data(rs2_data_out),
    .read_data(inst)
);

SRAM dm (
    .clk(clk),
    .w_en(dm_w_en),
    .address(alu_out[15:0]),
    .write_data(rs2_data_out),
    .read_data(ld_data)
);

endmodule