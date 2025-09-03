`timescale 1ns/1ps

module timer_input 
    #(parameter N = 4)
(
    input clk , rstn , enable,
    input [N-1 : 0] FINAL_VALUE,
    output done
);

reg [N-1 : 0] Q_reg , Q_next;

always @(posedge clk or negedge rstn) begin
    if(~rstn)
        Q_reg <= 0;
    else if (enable)         //only works with enable
        Q_reg <= Q_next;
    else
        Q_reg <= Q_reg;     //stay at the same value if enable is 0 and rstn is 1 and this line isn't necessary
end

//Next state logic
assign done = Q_reg == FINAL_VALUE;    //done signal will be 1 when the counter reaches the final_value input 

always @(*) begin
    Q_next = done ? 'b0 : Q_reg + 1;            //if done signal is 1 the counter will reset to zero but if it's still 0 the counter will continue counting up       
end

endmodule //timer_input