`timescale 1ns / 1ps

module tb();

    reg [15:0]applied_input;
    wire [4:0]out1;
    
    core uut(applied_input, out1);

    initial begin
    
        
        
        #5 applied_input = 16'b1110_1110_0100_0000;
        #5 applied_input = 16'b1110_1110_0100_0000;
        #5 applied_input = 16'b1110_1110_0100_0000;
        #5 applied_input = 16'b1010_1110_0100_0000;
        #5 applied_input = 16'b0110_1110_0100_0000;
        #5 applied_input = 16'b1110_1110_0100_0000;
        #5 applied_input = 16'b0010_1110_0100_0000;
        #5 applied_input = 16'b1110_1111_1111_1111;
        #5 applied_input = 16'b1111_1111_1111_1111;
        #5 applied_input = 16'b1111_1111_1111_1000;
        #5 applied_input = 16'b1111_1111_0000_1111;
        #5 applied_input = 16'b1110_1110_0100_0010;
        #5 applied_input = 16'b1010_1110_0100_0100;
        
        
    end
    
    
endmodule
