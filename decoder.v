`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UOM-ENTC sl
// Engineer: Anushka Siriweera
//////////////////////////////////////////////////////////////////////////////////


module decoder#(
    parameter slave_sel_len = 2
    )
    (
    input HRESETn,
    input [slave_sel_len-1:0]HADDR_SLAVE_SEL_BITS, 
    output HSEL_s1,
    output HSEL_s2,
    output HSEL_s3
    );
    assign HSEL_s1 = (HADDR_SLAVE_SEL_BITS == 2'b00 || HADDR_SLAVE_SEL_BITS == 2'b11 || HRESETn == 'b1)? 1: 0;
    assign HSEL_s2 = (HADDR_SLAVE_SEL_BITS == 2'b01)? 1: 0;
    assign HSEL_s3 = (HADDR_SLAVE_SEL_BITS == 2'b10)? 1: 0;
    
endmodule
