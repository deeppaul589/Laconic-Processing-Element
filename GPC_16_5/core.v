module core(input [15:0] A, output [4:0] out);

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
            .INIT(64'h6996_9669_9669_6996)
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
            .INIT(64'h177e_7ee8_e8e8_e8e8)
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