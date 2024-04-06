module RAM(clk,rstn,rx_valid,tx_valid,tx_data,rx_data);
parameter MEM_DEPTH=256;
parameter MEM_WIDTH=8;
input [9:0] rx_data;
input   clk,rstn,rx_valid;
output  reg [MEM_WIDTH-1:0] tx_data;
output  reg tx_valid;
 reg [7:0] din;
 reg [7:0] addr;

reg  [MEM_WIDTH-1:0] RAM [MEM_DEPTH-1:0];

always @(posedge clk) begin

if(rx_valid==1) begin 

    if(rx_data[9:8]==2'b00)  begin  
         addr<=rx_data[7:0];
         
    end 

    else if(rx_data[9:8]==2'b01) begin  
         din<=rx_data[7:0];
         
    end 
    else if(rx_data[9:8]==2'b10) begin
          addr<=rx_data[7:0];
              
    end
    else if(rx_data[9:8]==2'b11) begin
          tx_valid=1;
              
   end

   
end

end


//RAM BLOCK;
always@(posedge clk or negedge rstn) begin
    if(~rstn) 
      tx_data=0;
    else begin
                if(rx_valid==1)
                    RAM[addr]<=din;
                else if(tx_valid==1)
                    tx_data<=RAM[addr];
                    
    end 
     
end 
endmodule 