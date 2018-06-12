`timescale 1ns / 1ps

module ahb_master(HBUSREQ,HLOCK,HTRANS,HADDR,HWRITE,HSIZE,HBURST,HWDATA,HSEL,HRESETn,HCLK,HGRANT,HREADY,HRESP,HRDATA,BUSREQ,ADDREQ,WRITE,ADDR,SIZE,BURST,SEL,TRANS,WDATA); 
 
output HBUSREQ,HLOCK,HWRITE; 
output [1:0]HTRANS,HSEL; 
output [31:0]HADDR,HWDATA; 
output [2:0]HSIZE,HBURST; 
 
input HGRANT,HREADY,HCLK,HRESETn,BUSREQ,ADDREQ,WRITE; 
input [31:0]ADDR,WDATA; 
input [2:0]SIZE,BURST; 
input [1:0]HRESP,SEL,TRANS; 
input [31:0]HRDATA; 
 
reg HBUSREQ,HLOCK,HWRITE,hcount; 
reg [1:0]HTRANS,HSEL; 
reg [31:0]HADDR,HWDATA; 
reg [2:0]HSIZE,HBURST; 
 
wire HGRANT,HREADY,HCLK,HRESETn,WRITE; 
wire [31:0]ADDR,WDATA; 
wire [2:0]SIZE,BURST; 
wire [1:0]HRESP,SEL,TRANS; 
wire [31:0]HRDATA; 
 
reg bus_reg,addr_reg,new_hready,old_hready; 
reg [31:0] RDATA; 
reg [31:0] h_addr; 
 
parameter OKAY = 2'b00, 
          ERROR = 2'b01, 
          RETRY =2'b10, 
          SPLIT =2'b11; 
           
always @(posedge HCLK) 
begin 
   if(!HRESETn)              //Master reset 
   begin 
      HBUSREQ = 0; 
      HLOCK = 0; 
      HWRITE = 0; 
      HTRANS = 2'b00; 
      HSEL = 2'b00; 
      HADDR = 32'h00000000; 
      HWDATA = 32'h00000000; 
      HSIZE = 2'b00; 
      HBURST = 2'b00; 
      bus_reg = 0; 
      addr_reg = 0; 
      new_hready = 0; 
      old_hready = 0; 
      hcount = 0; 
   end 
end 
 
always @(posedge HCLK)       //Master sending the request signal to the arbiter 
begin 
   if(!bus_reg) 
   begin 
      if(BUSREQ) 
      begin 
        HBUSREQ = 1'b1; 
        bus_reg = 1; 
      end 
     else if(!BUSREQ) 
        HLOCK = 1'b0;  
   end 
    
   else if(bus_reg) 
      begin 
      HBUSREQ = 1'b0; 
      bus_reg = 0; 
      if(HGRANT) 
        HLOCK = 1'b1; 
      end 
    
end 
 
always@(posedge HCLK)      
begin  
  if(HRESETn) 
  begin  
    if(HGRANT) 
    begin 
      if(!addr_reg) 
      begin 
         if(ADDREQ)        //Master sending the address and the control signals once the bus is granted 
         begin 
          HADDR = ADDR; 
          h_addr = ADDR; 
          HWRITE = WRITE; 
          HSIZE = SIZE; 
          HBURST = BURST; 
          HSEL = SEL; 
          HTRANS = TRANS; 
          addr_reg = 1'b1; 
          HWDATA = 32'h00000000; 
         end 
      end 
     else if(addr_reg) 
      begin 
          HADDR = 32'h00000000; 
          HWRITE = 1'b0; 
          HSIZE = 3'b000; 
          HBURST = 3'b000; 
          HTRANS = 2'b00; 
          addr_reg = 1'b0; 
      end 
     
     
    if(!ADDREQ)              // DATA TRANSFER 
    begin 
      if(WRITE) 
      begin 
            hcount = 0; 
        case ({TRANS}) 
         
             2'b00 : begin  //NON SEQUENTIAL  
                     HWDATA = WDATA ; 
                     if(HREADY && !new_hready && HRESP == OKAY) 
                         new_hready = 1; 
                     else if (new_hready != old_hready) 
                         HWDATA = 32'h00000000; 
                     end 
             2'b01 : begin  // SEQUENTIAL  
                     hcount = hcount + 1; 
                     new_hready = 0; 
                     HWDATA = WDATA ; 
                     if(HREADY && !new_hready && HRESP == ERROR) 
                         new_hready = 1; 
                     else if (new_hready != old_hready) 
                         HWDATA = 32'h00000000; 
                     end                      
             2'b10 : begin  // IDLE  
                     HWDATA = 32'h00000000; 
                     end  
             2'b11 : begin // BUSY 
                     hcount = hcount + 1; 
                     HWDATA = WDATA ; 
                     if(HREADY && HRESP == OKAY) 
                     begin 
                         if(!new_hready) 
                            new_hready = 1;                          
                     end     
                     else if (new_hready != old_hready) 
                     begin  
                         HWDATA = WDATA; 
                         new_hready = 0; 
                     end 
                     else if (HREADY && HRESP == ERROR) 
                     begin 
                        HWDATA = 32'h00000000; 
                     end 
                     end 
      endcase                   
    end 
      else if(!WRITE) 
      begin 
        case ({TRANS}) 
         
             2'b00 : begin  //NON SEQUENTIAL  
                     if(!HREADY) 
                       RDATA = HRDATA; 
                     else if(HREADY) 
                       RDATA = 32'h00000000;                          
                     end 
             2'b01 : begin  // SEQUENTIAL  
                     if(!HREADY) 
                     begin 
                        RDATA = HRDATA; 
                        if(HBURST == 000) 
                           h_addr = h_addr + 1; 
                        else 
                           h_addr = h_addr - 1;  
                     end 
                     else if(HREADY) 
                       RDATA = 32'h00000000;        
                     end                      
             2'b10 : begin  // IDLE  
                     RDATA = 32'h00000000;   
                     end  
             2'b11 : begin // BUSY 
                     if(!HREADY) 
                     begin 
                        RDATA = HRDATA; 
                        if(HBURST == 000) 
                           h_addr = h_addr + 1; 
                        else 
                           h_addr = h_addr - 1;  
                     end       
                     else if(HREADY) 
                         RDATA = HRDATA;  
                     end 
      endcase                   
    end 
    
    
   end        
   end  
     
  end 
  end 
 
endmodule 
       