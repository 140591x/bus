`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENTC-UOM SL
// Engineer: Anushka Dilruk Siriweera
// 
// Create Date: 06/07/2018 07:17:00 PM
// Design Name: control_mux_n_decoder
// Module Name: control_mux_n_decoder
// Project Name: ADS_bus 
// Target Devices: vc709 
// Tool Versions: 
// Description: Module will incurr a maximum of 2 clock cycle delay from input to output
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_mux_n_decoder#(
    parameter input_data_width = 9      //override the parameter  at instantiation as desired
    )
    (
    input [input_data_width:0] master1, //from master 1 -> [9:8]-slave select bits , [7:7]-read/write
    input [input_data_width:0] master2, //from master 2 -> [9:8]-slave select bits , [7:7]-read/write
    input master_select, //from arbitrator
    input clk,
    input rst,
    output reg[6:0] address_slave,
    output reg wen_s1,       //write enable to slave 1
    output reg ren_s1,       //read enable to slave 1
    output reg wen_s2,       //write enable to slave 2
    output reg ren_s2,       //read enable to slave 2
    output reg wen_s3,       //write enable to slave 3
    output reg ren_s3        //read enable to slave 3
    );
    reg [input_data_width:0] mux_out;
    
    
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst==1)
        begin
            wen_s1 <= 0;
            ren_s1 <= 0; 
            wen_s2 <= 0;
            ren_s2 <= 0;
            wen_s3 <= 0;
            ren_s3 <= 0;
            mux_out <= master1;                    
        end
        else if (clk==1) 
        begin
            if(master_select==1) 
                mux_out <= master1;
            else                 
                mux_out <= master2;
            case(mux_out[9:7])
                3'b111 :            ////// [9:8]-slave select bits [7:7]-read/write
                begin
                    wen_s1 <= 1;
                    ren_s1 <= 0; 
                    wen_s2 <= 0;
                    ren_s2 <= 0;
                    wen_s3 <= 0;
                    ren_s3 <= 0;                    
                end
                3'b110 : 
                begin
                    wen_s1 <= 0;
                    ren_s1 <= 1; 
                    wen_s2 <= 0;
                    ren_s2 <= 0;
                    wen_s3 <= 0;
                    ren_s3 <= 0;                    
                end
                3'b101 : 
                begin
                    wen_s1 <= 0;
                    ren_s1 <= 0; 
                    wen_s2 <= 1;
                    ren_s2 <= 0;
                    wen_s3 <= 0;
                    ren_s3 <= 0;                    
                end
                3'b100 : 
                begin
                    wen_s1 <= 0;
                    ren_s1 <= 0; 
                    wen_s2 <= 0;
                    ren_s2 <= 1;
                    wen_s3 <= 0;
                    ren_s3 <= 0;                    
                end
                3'b011 : 
                begin
                    wen_s1 <= 0;
                    ren_s1 <= 0; 
                    wen_s2 <= 0;
                    ren_s2 <= 0;
                    wen_s3 <= 1;
                    ren_s3 <= 0;                    
                end
                3'b010 : 
                begin
                    wen_s1 <= 0;
                    ren_s1 <= 0; 
                    wen_s2 <= 0;
                    ren_s2 <= 0;
                    wen_s3 <= 0;
                    ren_s3 <= 1;                    
                end
                default : 
                begin
                    wen_s1 <= 0;
                    ren_s1 <= 0; 
                    wen_s2 <= 0;
                    ren_s2 <= 0;
                    wen_s3 <= 0;
                    ren_s3 <= 0;                    
                end                                                                                                
            endcase
            address_slave <= mux_out[input_data_width-3:0];
        end
    end
endmodule
