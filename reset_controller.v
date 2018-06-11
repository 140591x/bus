/*
This module is for for generating the initial reset
signal. 
*/
module reset_controller(
	input wire HCLK,
	input wire POReset,
	output reg HRESETn)
	
	reg SyncPOR;
	reg currentSt;
	reg nextSt;
	
	always@(posedge HCLK)
	begin
		SyncPOR <= POReset;
		if(~SyncPOR)
		begin
			nextSt <= 0'b00;
		end
		else
		begin
			case(currentSt)
			0'b00: nextSt <= 0'b01;
			0'b01: nextSt <= 0'b10;
			0'b10: nextSt <= 0'b11;
			0'b11: nextSt <= 0'b11; 
			endcase
			state <= and(currentSt);
		end 
	end
	
	always@()
	begin
		HRESETn <= and(state, POReset);
		currentSt <= nextSt;
	end 

endmodule