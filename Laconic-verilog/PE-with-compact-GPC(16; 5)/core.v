`timescale 1ns / 1ps

module core(

    input [15:0] in_applied,
    input [47:0] t0,
    input [47:0] t1,
    input [15:0] s0,
    input [15:0] s1,
    
    output signed [21:0] out_value
    
    );
    
    parameter N = 16;
    
    reg [3:0] exp_add [0:15];
    reg [15:0] exp_sign;
    wire [15:0] decoder_output [0:15];
	wire [15:0] histogram_input_pos [0:15];
	wire [15:0] histogram_input_neg [0:15];
    wire [15:0] histogram_input [0:15];

    wire [4:0] gpc_pos[0:15];
    wire [4:0] gpc_neg[0:15];

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
                    
                    
                    if (in_applied[i] == 1'b1) begin
                        exp_add[i] = (t0[(3*i + 2) : 3*i] + t1[(3*i + 2) : 3*i]);
                        exp_sign[i] = (s0[i] ^ s1[i]);
                    end
                    else begin
                        exp_add[i] = 0;
                        exp_sign[i] = 0;
                    end
                    
                  //exp_add[i] = in_applied[i] ? (t0[(3*i + 2) : 3*i] + t1[(3*i + 2) : 3*i]) : 0;
                  //exp_sign[i] = in_applied[i] ? (s0[i] ^ s1[i]) : 0;

            end
        end
    endgenerate
    
    
    generate for (i = 0; i < N ; i = i + 1) begin: decoder
         
            decoder decoder_inst(in_applied[i], exp_add[i], decoder_output[i]);
            
        end
    endgenerate
	
    
    generate for (i = 0; i < 15 ; i = i + 1) begin: align
           
         assign  histogram_input_pos[i] = {decoder_output[0][i] & ~exp_sign[0],
                                            decoder_output[1][i] & ~exp_sign[1],
                                            decoder_output[2][i] & ~exp_sign[2],
                                            decoder_output[3][i] & ~exp_sign[3],
                                            decoder_output[4][i] & ~exp_sign[4],
                                            decoder_output[5][i] & ~exp_sign[5],
                                            decoder_output[6][i] & ~exp_sign[6],
                                            decoder_output[7][i] & ~exp_sign[7],
                                            decoder_output[8][i] & ~exp_sign[8],
                                            decoder_output[9][i] & ~exp_sign[9],
                                            decoder_output[10][i] & ~exp_sign[10],
                                            decoder_output[11][i] & ~exp_sign[11],
                                            decoder_output[12][i] & ~exp_sign[12],
                                            decoder_output[13][i] & ~exp_sign[13],
                                            decoder_output[14][i] & ~exp_sign[14],
                                            decoder_output[15][i] & ~exp_sign[15]};
										
		assign  histogram_input_neg[i] = {decoder_output[0][i] & exp_sign[0],
                                            decoder_output[1][i] & exp_sign[1],
                                            decoder_output[2][i] & exp_sign[2],
                                            decoder_output[3][i] & exp_sign[3],
                                            decoder_output[4][i] & exp_sign[4],
                                            decoder_output[5][i] & exp_sign[5],
                                            decoder_output[6][i] & exp_sign[6],
                                            decoder_output[7][i] & exp_sign[7],
                                            decoder_output[8][i] & exp_sign[8],
                                            decoder_output[9][i] & exp_sign[9],
                                            decoder_output[10][i] & exp_sign[10],
                                            decoder_output[11][i] & exp_sign[11],
                                            decoder_output[12][i] & exp_sign[12],
                                            decoder_output[13][i] & exp_sign[13],
                                            decoder_output[14][i] & exp_sign[14],
                                            decoder_output[15][i] & exp_sign[15]};
            
        end
    endgenerate
	
	
	generate for (i = 0; i < 15 ; i = i + 1) begin: hist_inp
			
			GPC_16_5 gpc_0(histogram_input_pos[i][15:0], gpc_pos[i]);
			GPC_16_5 gpc_1(histogram_input_neg[i][15:0], gpc_neg[i]);
			
			assign histogram_output[i] = gpc_pos[i] - gpc_neg[i];
			
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
    //assign alignment_output_15 = {histogram_output[15], 15'b0} ;
    
    
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
	assign partial_add_07 = alignment_output_14;
	
	assign partial_add_10 = partial_add_00 + partial_add_01;
	assign partial_add_11 = partial_add_02 + partial_add_03;
	assign partial_add_12 = partial_add_04 + partial_add_05;
    assign partial_add_13 = partial_add_06 + partial_add_07;
	
	assign out_value = partial_add_10 + partial_add_11 + partial_add_12 + partial_add_13;
	

   
endmodule


module decoder(input in_applied, input [3:0] value, output reg [15:0] out);

    always @(*) begin
        
        out = 16'd0;
    
        if (in_applied) begin
            out[value] = 1;
        end  
           
    end

endmodule

module GPC_16_5(input [15:0] A, output [4:0] out);

    wire [2:0] out_0, out_1;
    
    GPC_7_3 gpc0 (A[6:0], out_0);
    GPC_7_3 gpc1 (A[13:7], out_1);
    
    
    wire lut_06_3, lut_06_2, lut_06_1, lut_06_0;
    wire lut_05_3, lut_05_2, lut_05_1, lut_05_0;
    
    wire [3:0] cco;
    wire [3:0] cso;
    
    LUT6_2 #(
            .INIT(64'hf00f_0ff0_ffff_0000)
    )   LUT6_2_inst_0 (
            .O6(lut_o6_0),
            .O5(lut_o5_0),
            .I0(0),
            .I1(0),
            .I2(out_0[0]),
            .I3(out_1[0]),
            .I4(A[14]),
            .I5(1)
    );
    
    LUT6_2 #(
            .INIT(64'hc03f_3fc0_00ff_ff00)
    )   LUT6_2_inst_1 (
            .O6(lut_o6_1),
            .O5(lut_o5_1),
            .I0(0),
            .I1(out_1[0]),
            .I2(out_0[0]),
            .I3(out_1[1]),
            .I4(out_0[1]),
            .I5(1)
    );
    
    LUT6_2 #(
            .INIT(64'hc03f_3fc0_00ff_ff00)
    )   LUT6_2_inst_2 (
            .O6(lut_o6_2),
            .O5(lut_o5_2),
            .I0(0),
            .I1(out_1[1]),
            .I2(out_0[1]),
            .I3(out_1[2]),
            .I4(out_0[2]),
            .I5(1)
    );
    
    LUT6_2 #(
            .INIT(64'hff00_0000_0000_0000)
    )   LUT6_2_inst_3 (
            .O6(lut_o6_3),
            .O5(lut_o5_3),
            .I0(0),
            .I1(0),
            .I2(0),
            .I3(out_0[2]),
            .I4(out_1[2]),
            .I5(1)
    );
    
    
    
    CARRY4 carry_block(
                        .CYINIT(A[15]),
                        .S({lut_o6_3, lut_o6_2, lut_o6_1, lut_o6_0}),
                        .DI({lut_o5_3, lut_o5_2, lut_o5_1, lut_o5_0}),
                        .O(cso),
                        .CO(cco)
                        
                        );
                        
     assign out[4] = cco[3];
     assign out[3] = cso[3];
     assign out[2] = cso[2];
     assign out[1] = cso[1];
     assign out[0] = cso[0];

endmodule

module GPC_7_3(input [6:0] A, output [2:0] out);
    
    wire [1:0] cco;
    wire [1:0] cso;
    
    wire [1:0] lut_o6;
    wire [1:0] lut_o5;
    
    LUT6_2 #(
            .INIT(64'h6996966996696996)
    )   LUT6_2_inst_1 (
            .O6(lut_o6[0]),
            .O5(lut_o5[0]),
            .I0(A[1]),
            .I1(A[2]),
            .I2(A[3]),
            .I3(A[4]),
            .I4(A[5]),
            .I5(A[6])
    );
    
    LUT6_2 #(
            .INIT(64'h177e7ee8e8e8e8e8)
    )   LUT6_2_inst_2 (
            .O6(lut_o6[1]),
            .O5(lut_o5[1]),
            .I0(A[1]),
            .I1(A[2]),
            .I2(A[3]),
            .I3(A[4]),
            .I4(A[5]),
            .I5(1)
    );
    
    
    CARRY4 carry_block(
                        .CYINIT(A[0]),
                        .S({0, 0, lut_o6[1], lut_o6[0]}),
                        .DI({0, 0, lut_o5[1], lut_o5[0]}),
                        .O(cso),
                        .CO(cco)
                                        
    );
    

    assign out[0] = cso[0];
    assign out[1] = cso[1];
    assign out[2] = cco[1];
    

endmodule
