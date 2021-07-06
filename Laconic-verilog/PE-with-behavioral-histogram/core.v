`timescale 1ns / 1ps

module core(

    input [15:0] in_applied,
    input [47:0] t0,
    input [47:0] t1,
    input [15:0] s0,
    input [15:0] s1,
    input rst,
    input clk,
    
    output signed [21:0] out_value
    
    );
    
    parameter N = 16;
    
    reg [3:0] exp_add [0:15];
    reg [15:0] exp_sign;
    wire [15:0] decoder_output [0:15];
    wire [15:0] histogram_input [0:15];
    wire signed [5:0] histogram_output[0:15];
    
    
    
    wire signed  [5:0] alignment_output_0;
	wire signed  [6:0] alignment_output_1;
	wire signed  [7:0] alignment_output_2;
	wire signed  [8:0] alignment_output_3;
	wire signed  [9:0] alignment_output_4;
	wire signed  [10:0] alignment_output_5;
	wire signed  [11:0] alignment_output_6;
	wire signed  [12:0] alignment_output_7;
	wire signed  [13:0] alignment_output_8;
	wire signed  [14:0] alignment_output_9;
	wire signed  [15:0] alignment_output_10;
	wire signed  [16:0] alignment_output_11;
	wire signed  [17:0] alignment_output_12;
	wire signed  [18:0] alignment_output_13;
	wire signed  [19:0] alignment_output_14;
	wire signed  [20:0] alignment_output_15;
    

    genvar i;
        

    generate for (i = 0; i < N ; i = i + 1) begin: adder_xor
            always @(*) begin
        
                  exp_add[i] = t0[(3*i + 2) : 3*i] + t1[(3*i + 2) : 3*i];
                  exp_sign[i] = in_applied[i] ? (s0[i] ^ s1[i]) : 0;

            end
        end
    endgenerate
    
    
    generate for (i = 0; i < N ; i = i + 1) begin: decoder
         
            decoder decoder_inst(in_applied[i], exp_add[i], decoder_output[i]);
            
        end
    endgenerate
    

    generate for (i = 0; i < N ; i = i + 1) begin: align
           
         assign  histogram_input[i] = {decoder_output[0][i],
                                            decoder_output[1][i],
                                            decoder_output[2][i],
                                            decoder_output[3][i],
                                            decoder_output[4][i],
                                            decoder_output[5][i],
                                            decoder_output[6][i],
                                            decoder_output[7][i],
                                            decoder_output[8][i],
                                            decoder_output[9][i],
                                            decoder_output[10][i],
                                            decoder_output[11][i],
                                            decoder_output[12][i],
                                            decoder_output[13][i],
                                            decoder_output[14][i],
                                            decoder_output[15][i]};
            
        end
    endgenerate
    
    
    generate for (i = 0; i < N ; i = i + 1) begin: hist
         
            // histogram histogram_inst(.histogram_input(histogram_input[i]), .exp_sign(exp_sign), .out(histogram_output[i]), .clk(clk), .rst(rst));
            
            hist_adder_tree  hist_adder_tree_inst(
                
                {(decoder_output[0][i] == 1 ? exp_sign[0] : 0), decoder_output[0][i]},
                {(decoder_output[1][i] == 1 ? exp_sign[1] : 0), decoder_output[1][i]},
                {(decoder_output[2][i] == 1 ? exp_sign[2] : 0), decoder_output[2][i]},
                {(decoder_output[3][i] == 1 ? exp_sign[3] : 0), decoder_output[3][i]},
                {(decoder_output[4][i] == 1 ? exp_sign[4] : 0), decoder_output[4][i]},
                {(decoder_output[5][i] == 1 ? exp_sign[5] : 0), decoder_output[5][i]},
                {(decoder_output[6][i] == 1 ? exp_sign[6] : 0), decoder_output[6][i]},
                {(decoder_output[7][i] == 1 ? exp_sign[7] : 0), decoder_output[7][i]},
                {(decoder_output[8][i] == 1 ? exp_sign[8] : 0), decoder_output[8][i]},
                {(decoder_output[9][i] == 1 ? exp_sign[9] : 0), decoder_output[9][i]},
                {(decoder_output[10][i] == 1 ? exp_sign[10] : 0), decoder_output[10][i]},
                {(decoder_output[11][i] == 1 ? exp_sign[11] : 0), decoder_output[11][i]},
                {(decoder_output[12][i] == 1 ? exp_sign[12] : 0), decoder_output[12][i]},
                {(decoder_output[13][i] == 1 ? exp_sign[13] : 0), decoder_output[13][i]},
                {(decoder_output[14][i] == 1 ? exp_sign[14] : 0), decoder_output[14][i]},
                {(decoder_output[15][i] == 1 ? exp_sign[15] : 0), decoder_output[15][i]},
                
                histogram_output[i]
                
                );
            
        end
    endgenerate
    
    
    assign alignment_output_0 = histogram_output[0];
    assign alignment_output_1 = {histogram_output[1], 1'b0} ;
    assign alignment_output_2 = {histogram_output[2], 2'b0} ;
    assign alignment_output_3 = {histogram_output[3], 3'b0} ;
    assign alignment_output_4 = {histogram_output[4], 4'b0} ;
    assign alignment_output_5 = {histogram_output[5], 5'b0} ;
    assign alignment_output_6 = {histogram_output[6], 6'b0} ;
    assign alignment_output_7 = {histogram_output[7], 7'b0} ;
    assign alignment_output_8 = {histogram_output[8], 8'b0} ;
    assign alignment_output_9 = {histogram_output[9], 9'b0} ;
    assign alignment_output_10 = {histogram_output[10], 10'b0} ;
    assign alignment_output_11 = {histogram_output[11], 11'b0} ;
    assign alignment_output_12 = {histogram_output[12], 12'b0} ;
    assign alignment_output_13 = {histogram_output[13], 13'b0} ;
    assign alignment_output_14 = {histogram_output[14], 14'b0} ;
    assign alignment_output_15 = {histogram_output[15], 15'b0} ;
    
    
    wire signed  [7:0] partial_add_00;
	wire signed  [9:0] partial_add_01;
	wire signed  [11:0] partial_add_02;
	wire signed  [13:0] partial_add_03;
	wire signed  [15:0] partial_add_04;
	wire signed  [17:0] partial_add_05;
	wire signed  [19:0] partial_add_06;
	wire signed  [21:0] partial_add_07;
	
	wire signed  [9:0] partial_add_10;
	wire signed  [13:0] partial_add_11;
	wire signed  [17:0] partial_add_12;
	wire signed  [21:0] partial_add_13;
	
	
	assign partial_add_00 = alignment_output_0 + alignment_output_1;
	assign partial_add_01 = alignment_output_2 + alignment_output_3;
	assign partial_add_02 = alignment_output_4 + alignment_output_5;
    assign partial_add_03 = alignment_output_6 + alignment_output_7;
	assign partial_add_04 = alignment_output_8 + alignment_output_9;
	assign partial_add_05 = alignment_output_10 + alignment_output_11;
	assign partial_add_06 = alignment_output_12 + alignment_output_13;
	assign partial_add_07 = alignment_output_14 + alignment_output_15;
	
	assign partial_add_10 = partial_add_00 + partial_add_01;
	assign partial_add_11 = partial_add_02 + partial_add_03;
	assign partial_add_12 = partial_add_04 + partial_add_05;
    assign partial_add_13 = partial_add_06 + partial_add_07;
	
	
	 assign out_value = partial_add_10 + partial_add_11 + partial_add_12 + partial_add_13;
	
    /*
    assign out_value = alignment_output_0 +
                        alignment_output_1 +
                        alignment_output_2 +
                        alignment_output_3 +
                        alignment_output_4 +
                        alignment_output_5 +
                        alignment_output_6 +
                        alignment_output_7 +
                        alignment_output_8 +
                        alignment_output_9 +
                        alignment_output_10 +
                        alignment_output_11 +
                        alignment_output_12 +
                        alignment_output_13 +
                        alignment_output_14 +
                        alignment_output_15 ;
  */
   
endmodule


module decoder(input in_applied, input [3:0] value, output reg [15:0] out);

    always @(*) begin
        
        out = 16'd0;
    
        if (in_applied) begin
            out[value] = 1;
        end  
           
    end

endmodule



module histogram(input [15:0] histogram_input, input [15:0] exp_sign, output signed [5:0] out, input clk, input rst);
    
    reg [4:0] tracking;
    reg signed [5:0] out_internal;
    
    always @(posedge clk or negedge rst) begin
        
        if (rst == 0) begin
            tracking <= 0;
            out_internal <= 0;
        end
        
        else if (clk == 1) begin
            
            tracking <= tracking + 1;
            
            if ((tracking <= 15) && histogram_input[tracking]) begin
            
                    if (exp_sign[tracking] == 0) begin
                        out_internal <= out_internal + 1;
                    end
                    else begin
                        out_internal <= out_internal - 1;
                    end
            
            end
            
        end
        
    end
    
    assign out = out_internal;

endmodule

module hist_adder_tree(input signed [1:0]a0, 
                        input signed [1:0]a1,
                        input signed [1:0]a2,
                        input signed [1:0]a3,
                        input signed [1:0]a4,
                        input signed [1:0]a5,
                        input signed [1:0]a6,
                        input signed [1:0]a7,
                        input signed [1:0]a8,
                        input signed [1:0]a9,
                        input signed [1:0]a10,
                        input signed [1:0]a11,
                        input signed [1:0]a12,
                        input signed [1:0]a13,
                        input signed [1:0]a14,
                        input signed [1:0]a15,

                        output reg signed [5:0] res
);

reg signed [2:0] b0;
reg signed [2:0] b1;
reg signed [2:0] b2;
reg signed [2:0] b3;
reg signed [2:0] b4;
reg signed [2:0] b5;
reg signed [2:0] b6;
reg signed [2:0] b7;

reg signed [4:0] c0;
reg signed [4:0] c1;
reg signed [4:0] c2;
reg signed [4:0] c3;




    
    always @(*) begin
        
        b0 = a0 + a1;
        b1 = a2 + a3;
        b2 = a4 + a5;
        b3 = a6 + a7;
        b4 = a8 + a9;
        b5 = a10 + a11;
        b6 = a12 + a13;
        b7 = a14 + a15;
        
        c0 = b0 + b1;
        c1 = b2 + b3;
        c2 = b4 + b5;
        c3 = b6 + b7;
        
        res = c0 + c1 + c2 + c3;
    
    end
    


endmodule 
