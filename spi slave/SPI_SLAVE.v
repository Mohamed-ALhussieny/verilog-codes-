module SPI_SLAVE(clk,rstn,MOSI,SS_n,tx_data,tx_valid,MISO, rx_valid,rx_data);
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADDR=3'b011;
parameter READ_DATA=3'b100;
/*--------------------------------*/
input clk;
input rstn;
input MOSI;
input SS_n;
input [7:0] tx_data;
input tx_valid;
/*--------------------------------*/
output reg MISO;
output reg rx_valid;
output reg [9:0] rx_data;
/*--------------------------------*/
reg [2:0] CS ,NS;
reg flag_read_addr;
reg [3:0] i;
reg [3:0] j;
reg [3:0] k;
reg [3:0] l;
/*---------------FSM-----------------*/
(*fsm_encoding="one_hot"*)
always @(*) begin
case(CS)
IDLE: begin
 i=9;
 j=9;
 k=9;
 l=7; 
 if(SS_n==0) begin
 NS=CHK_CMD;
 end
 end 
CHK_CMD: begin
 if( MOSI==0)
 NS=WRITE;
 else if( MOSI==1 && flag_read_addr==0)
 NS=READ_ADDR;
 else if( MOSI==1 )
 NS=READ_DATA;
 else if(SS_n==1)
 NS=IDLE;
 end
WRITE: begin
 if(SS_n==1) begin
 NS=IDLE; 
 end
 end
READ_ADDR: begin 
 if(SS_n==1) begin
 NS=IDLE;
 end
 end
READ_DATA: begin
 if(SS_n==1) begin
 NS=IDLE;
 end
 end
endcase 
end
/*----------------state memory----------------*/
always@(posedge clk or negedge rstn) begin
 if(~rstn)
 CS=IDLE;
 else
 CS=NS;
end
/*----------------output logic----------------*/
always@(posedge clk) begin
 if(CS==WRITE ) begin 
 rx_data[i]<=MOSI;
 i<=i-1; 
 rx_valid<=1; 
 end
 else if(CS==READ_ADDR) begin 
 rx_data[j]<=MOSI;
 j<=j-1;
 rx_valid<=1;
 flag_read_addr<=1;
 end
 else if(CS==READ_DATA) begin
 rx_data[k]<=MOSI;
 k<=k-1; 
 rx_valid<=1; 
 end
 else rx_valid=0; 
end
/*----------------output logic----------------*/
always@(posedge clk) begin
 if(tx_valid==1) begin
 MISO<=tx_data[l]; 
 l=l-1;
 end
 else MISO=0; 
end
endmodule