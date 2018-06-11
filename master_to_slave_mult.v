`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENTC-uom sl
// Engineer: Anushka Siriweera
//////////////////////////////////////////////////////////////////////////////////


module master_to_slave_mult#(
    parameter add_len = 32+2,
    parameter data_len = 32
    )(
    input HCLK,
    input HRESETn,
    input wire [1:0]HMASTER,
    input HREADY,

    input [add_len-1:0]HADDR1,
    input HWRITE1,
    input [1:0]HTRANS1,
    input [2:0]HSIZE1,
    input [2:0]HBURST1,
    input [data_len-1:0]HWDATA1,
    
    input [add_len-1:0]HADDR2,
    input HWRITE2,
    input [1:0]HTRANS2,
    input [2:0]HSIZE2,
    input [2:0]HBURST2,
    input [data_len-1:0]HWDATA2,
       
    output reg [add_len-1:0]HADDR,
    output reg [1:0]HTRANS,
    output reg HWRITE,
    output reg [2:0]HSIZE,
    output reg [2:0]HBURST,
    output reg [data_len-1:0] HWDATA
    );
    
    reg [1:0] hmaster_buf;
    always @ (posedge HCLK or posedge HRESETn  )
    begin
        if(HRESETn == 1) 
        begin
            HADDR  <= HADDR1;
            HTRANS <= HTRANS1;
            HWRITE <= HWRITE1;
            HSIZE  <= HSIZE1;
            HBURST <= HBURST1;
            HWDATA <= HWDATA1;
        end
        else
        begin
            if (HREADY==1)hmaster_buf <= HMASTER; 
            case (HMASTER)
                2'b10 :
                begin
                    HADDR  <= HADDR1;
                    HTRANS <= HTRANS1;
                    HWRITE <= HWRITE1;
                    HSIZE  <= HSIZE1;
                    HBURST <= HBURST1;
                    //HWDATA <= HWDATA1;
                end
                2'b01 :
                begin
                    HADDR  <= HADDR2;
                    HTRANS <= HTRANS2;
                    HWRITE <= HWRITE2;
                    HSIZE  <= HSIZE2;
                    HBURST <= HBURST2;
                    //HWDATA <= HWDATA2;
                end
                default :
                begin
                    HADDR  <= 0;
                    HTRANS <= HTRANS2;
                    HWRITE <= HWRITE2;
                    HSIZE  <= HSIZE2;
                    HBURST <= HBURST2;
                   // HWDATA <= 0;
                end
           endcase
           
            case (hmaster_buf)
              2'b10 : HWDATA <= HWDATA1;
              2'b01 :HWDATA <= HWDATA2;
              default :HWDATA <= 0;
            endcase          
        end      
    end
    
    
    
    
endmodule
