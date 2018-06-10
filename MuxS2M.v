/*
This module is for the Slave to master multiplexor

*/
module MuxS2M(
	input wire HCLK,
	input wire HRESETn,
	input wire HSEL[2:0],
	input wire HRDATA1[31:0],
	input wire HREADY1,
	input wire HRESP1[1:0],
	input wire HRDATA2[31:0],
	input wire HREADY2,
	input wire HRESP2[1:0],
	input wire HRDATA3[31:0],
	input wire HREADY3,
	input wire HRESP3[1:0],
	output wire HRDATA[31:0],
	output wire HREADY,
	output wire HRESP[1:0])
	
	reg HselReg[2:0] <= 0b'001;
	
	always@(posedge HREADY)
	begin
		HselReg <= HSEL;
	end
	
	always @(posedge HCLK, negedge HRESETn)
	begin
		if(~HRESETn)
		begin
			HselReg[2:0] <= 0b'001;
		end
		else
		begin
			case(HselReg)
				0'b001: 
				begin
					HRDATA <= HRDATA1;
					HREADY <= HREADY1;
					HRESP <= HRESP1;
				end
				0'b010: 
				begin
					HRDATA <= HRDATA2;
					HREADY <= HREADY2;
					HRESP <= HRESP2;
				end
				0'b100: 
				begin
					HRDATA <= HRDATA3;
					HREADY <= HREADY3;
					HRESP <= HRESP3;
				end
				default:
				begin
					HRDATA <= 0d'0;
					HREADY <= 0b'0;
					HRESP <= 0b'00;
				end 
			endcase
		end 
	end

endmodule