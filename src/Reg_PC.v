module Reg_PC (
    input clk,
    input rst,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);

always@(posedge clk or posedge rst)
begin
    if(rst) //reset==0
        current_pc <= 0;
    else 
        current_pc <= next_pc;
end

endmodule