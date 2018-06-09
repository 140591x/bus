`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2018 08:59:16 PM
// Design Name: 
// Module Name: control_mux_n_decoder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_mux_n_decoder_tb();
    reg [46:0] master1_reg,master2_reg;
    wire [11:0] address_out;
    wire [31:0] data_out;
    reg select_reg,rst_reg,clk;
    wire ws1_wire,rs1_wire,ws2_wire,rs2_wire,ws3_wire,rs3_wire;
    
    always #1 clk <= ~clk;
    
    control_mux_n_decoder #(
    .input_data_width(47),
    .address_length(12),
    .data_length(32)
     )
     uut(
    .master1(master1_reg), 
    .master2(master2_reg), 
    .master_select(select_reg), 
    .clk(clk),
    .rst(rst_reg),
    .address_slave(address_out),
    .data(data_out),
    .wen_s1(ws1_wire),       
    .ren_s1(rs1_wire),       
    .wen_s2(ws2_wire),      
    .ren_s2(rs2_wire),      
    .wen_s3(ws3_wire),       
    .ren_s3(rs3_wire)       
    );
    
    initial begin
        clk <= 'b0;
        rst_reg <= 'b1;
        #50
        rst_reg <= 'b0;
        master1_reg <= 'h3_100_10101010;
        master2_reg <= 'h7_001_01010101;
        select_reg <= 'b1;
        #50
        select_reg <= 'b0;
        master1_reg <= 'h0_000_00000000;
        #50
        select_reg <= 'b1;
        master2_reg <= 'h1_111_11111111;
        #50
        select_reg <= 'b0;
        master1_reg <= 'h2_001_00000001; 
        #50
        select_reg <= 'b1;
        master1_reg <= 'h2_110_11111110; 
           
    end
endmodule
