module Controller(
        input [4:0] opcode,
        input [2:0] func3,
        input func7,
        input [31:0]current_pc,
        input [31:0] alu_out,


        //pc control 
        output reg next_pc_sel,
        
        //instruction mem control
        output reg [3:0]im_w_en,
        
        //reg control
        output reg wb_en,

        //mux control
        output reg alu_op1_sel,
        output reg alu_op2_sel,
        output reg jb_op1_sel, 

        //alu control
        output [4:0] ctrl_opcode,
        output [2:0] ctrl_func3,
        output ctrl_func7, 
        
        // data mem control
        output reg [3:0]dm_w_en,
        
        //wb control 
        output reg wb_sel
        
    );

    assign ctrl_opcode = opcode;
    assign ctrl_func3 = func3;
    assign ctrl_func7 = func7;

    always @(*)
    begin
        case(opcode)
            5'b00000: /*I-type load*/
            begin
                wb_en = 1'b1;
                alu_op1_sel = 1'b1;    //rs1
                alu_op2_sel = 1'b0;    //imm
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b1;
                next_pc_sel = 1'b1;
            end
            5'b00100: /*I-type addi*/
            begin
                wb_en = 1'b1;
                alu_op1_sel = 1'b1;    //rs1
                alu_op2_sel = 1'b0;    //imm
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b0;
                next_pc_sel = 1'b1;
            end
            5'b01000: /*S-type store*/
            begin
                wb_en = 1'b0;
                alu_op1_sel = 1'b1;    //rs1
                alu_op2_sel = 1'b0;    //imm
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                wb_sel = 1'b0;
                next_pc_sel = 1'b1;
                case(func3)
                    3'b000:  /*sb*/
                        dm_w_en = 4'b0001;
                    3'b001:  /*sh*/
                        dm_w_en = 4'b0011;
                    3'b010:  /*sw*/
                        dm_w_en = 4'b1111;
                    default:
                        dm_w_en = 4'b1111;
                endcase
            end
            5'b11000: /*B-type branch*/ 
            begin
                wb_en = 1'b0;
                alu_op1_sel = 1'b1;    //rs1
                alu_op2_sel = 1'b1;    //rs2
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b0;
                case(alu_out)
                    32'd1:  /*sb*/
                        next_pc_sel = 1'b0;
                    32'd0:
                        next_pc_sel = 1'b1;
                    default:
                        next_pc_sel = 1'b1;
                endcase
            end
            5'b11001: /*I-type jalr*/
            begin
                wb_en = 1'b1;
                alu_op1_sel = 1'b0;    //pc
                alu_op2_sel = 1'b0;    //-
                jb_op1_sel = 1'b1;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b0;
                next_pc_sel = 1'b0;
            end
            5'b00101: /*U-type auipc*/
            begin
                wb_en = 1'b1;
                alu_op1_sel = 1'b0;    //pc
                alu_op2_sel = 1'b0;    //imm
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b0;
                next_pc_sel = 1'b1;
            end
            5'b01101: /*U-type lui*/
            begin
                wb_en = 1'b1;
                alu_op1_sel = 1'b0;    //pc
                alu_op2_sel = 1'b0;    //imm
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b0;
                next_pc_sel = 1'b1;
            end
            5'b11011: /*J-type jal*/
            begin
                wb_en = 1'b1;
                alu_op1_sel = 1'b0;    //pc
                alu_op2_sel = 1'b0;    //-
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b0;
                next_pc_sel = 1'b0;
            end
            5'b01100: /*R-type*/
            begin
                wb_en = 1'b1;
                alu_op1_sel = 1'b1;    //rs1
                alu_op2_sel = 1'b1;    //rs2
                jb_op1_sel = 1'b0;
                im_w_en = 4'b0000;
                dm_w_en = 4'b0000;
                wb_sel = 1'b0;
                next_pc_sel = 1'b1;
            end
            default:
            begin
                wb_en = 1'b1; //1'b1;
                alu_op1_sel = 1'b0; //1'b0; 
                alu_op2_sel = 1'b0; //1'b0;    
                jb_op1_sel = 1'b0; //1'b0;
                im_w_en = 4'b0000; //4'b0000;
                dm_w_en = 4'b0000; //4'b0000;
                wb_sel = 1'b0;  //1'b0;
                next_pc_sel = 1'b1;  //1'b1;
            end
        endcase
    end
    endmodule