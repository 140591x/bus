`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Anushka Siriweera
//////////////////////////////////////////////////////////////////////////////////


module master_to_slave_mult_tb();
    reg clk,hready,runner;
    reg [1:0]hmaster;
    reg HRESETn;
    
    reg [13:0]HADDR1;
    reg HWRITE1;
    reg [1:0]HTRANS1;
    reg [2:0]HSIZE1;
    reg [2:0]HBURST1;
    reg [31:0]HWDATA1;
    
    reg [13:0]HADDR2;
    reg HWRITE2;
    reg [1:0]HTRANS2;
    reg [2:0]HSIZE2;
    reg [2:0]HBURST2;
    reg [31:0]HWDATA2;
    
    wire [13:0]HADDR;
    wire HWRITE;
    wire [1:0]HTRANS;    
    wire [2:0]HSIZE;
    wire [2:0]HBURST;
    wire [31:0] HWDATA;
    
    reg [55:0] one;
    reg [55:0] two;
    reg [4:0] counter;
    wire hsel_s1,hsel_s2,hsel_s3;
    initial begin
        hmaster = 2'b10;
        hready = 1'b1;
        HRESETn = 1'b0;
        clk = 1'b1;
        runner = 1'b1;
        counter = 1'b0;
        one = 55'h11111111111111;
        two = 55'h22222222222222;
    end

   
    
    always #1 clk <= ~clk;
    always #10 runner <= ~runner;
    
    always @ (posedge runner)begin
        hmaster <= ~hmaster ;
        //hready <= #3 ~hready;
        counter <= counter +1;
        one <= one + 33;
        two <= two + 44;
        {HADDR1,HWRITE1,HTRANS1,HSIZE1,HBURST1,HWDATA1} <= one;
        {HADDR2,HWRITE2,HTRANS2,HSIZE2,HBURST2,HWDATA2} <= two;
        if (counter > 25) HRESETn <= 1;
        else HRESETn <= 0;
    end
    
    master_to_slave_mult uut(
        .HCLK(clk),
        .HRESETn(HRESETn),
        .HMASTER(hmaster),
        .HREADY(hready),
    
        .HADDR1(HADDR1),
        .HWRITE1(HWRITE1),
        .HTRANS1(HTRANS1),
        .HSIZE1(HSIZE1),
        .HBURST1(HBURST1),
        .HWDATA1(HWDATA1),
        
        .HADDR2(HADDR2),
        .HWRITE2(HWRITE2),
        .HTRANS2(HTRANS2),
        .HSIZE2(HSIZE2),
        .HBURST2(HBURST2),
        .HWDATA2(HWDATA2),
           
        .HADDR(HADDR),
        .HTRANS(HTRANS),
        .HWRITE(HWRITE),
        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HWDATA(HWDATA)
        );
    decoder uut_decoder(
    .HRESETn(HRESETn),
    .HADDR_SLAVE_SEL_BITS(HADDR[13:12]), 
    .HSEL_s1(hsel_s1),
    .HSEL_s2(hsel_s2),
    .HSEL_s3(hsel_s3)
    );
endmodule
