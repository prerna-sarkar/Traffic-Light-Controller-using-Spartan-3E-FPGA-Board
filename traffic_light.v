`timescale 1ns / 1ps
module traffic_light(light_main, light_cross, C, clk, rst_n, mr, my, mg, cr, cy, cg);
parameter MGRE_CRED=2'b00, // main green and cross red
 MYEL_CRED = 2'b01,// main yellow and cross red
 MRED_CGRE=2'b10,// main red and cross green
 MRED_CYEL=2'b11;// main red and cross yellow
input C, // sensor
 clk, // clock = 50 MHz
 rst_n; // reset active low
output reg[2:0] light_main, light_cross; // output of lights
output reg mr, my, mg, cr, cy, cg;
reg[27:0] count=0,count_delay=0;
reg delay10s=0, 
delay3s1=0,delay3s2=0,RED_count_en=0,YELLOW_count_en1=0,YELLOW_count_en2=0;
wire clk_enable; // clock enable signal for 1s
reg[1:0] state, next_state;
// next state
always @(posedge clk or negedge rst_n)
begin
if(~rst_n)
state <= 2'b00;
else 
state <= next_state; 
end
// FSM
always @(*)
begin
case(state)
MGRE_CRED: begin // Green on main and red on cross way
RED_count_en=0;
YELLOW_count_en1=0;
YELLOW_count_en2=0;
light_main = 3'b001;
light_cross = 3'b100;
mr = 1'b0;
my = 1'b0;
mg = 1'b1;
cr = 1'b1;
cy = 1'b0;
cg = 1'b0;
if(C) next_state = MYEL_CRED; 
// if sensor detects vehicles on cross road, 
// turn main to yellow -> green
else next_state =MGRE_CRED;
end
MYEL_CRED: begin// yellow on main and red on cross way
 light_main = 3'b010;
 light_cross = 3'b100;
 RED_count_en=0;
YELLOW_count_en1=1;
YELLOW_count_en2=0;
mr = 1'b0;
my = 1'b1;
mg = 1'b0;
cr = 1'b1;
cy = 1'b0;
cg = 1'b0;
 if(delay3s1) next_state = MRED_CGRE;
 // yellow for 3s, then red
 else next_state = MYEL_CRED;
end
MRED_CGRE: begin// red on main and green on cross way
light_main = 3'b100;
light_cross = 3'b001;
RED_count_en=1;
YELLOW_count_en1=0;
YELLOW_count_en2=0;
 mr = 1'b1;
my = 1'b0;
mg = 1'b0;
cr = 1'b0;
cy = 1'b0;
cg = 1'b1;
if(delay10s) next_state = MRED_CYEL;
// red in 10s then turn to yello -> green again for high way
else next_state =MRED_CGRE;
end
MRED_CYEL:begin// red on main and yellow on cross way
light_main = 3'b100;
light_cross = 3'b010;
RED_count_en=0;
YELLOW_count_en1=0;
YELLOW_count_en2=1;
 mr = 1'b1;
 my = 1'b0;
 mg = 1'b0;
 cr = 1'b0;
 cy = 1'b1;
 cg = 1'b0;
if(delay3s2) next_state = MGRE_CRED;
// turn green for main, red for cross road
else next_state =MRED_CYEL;
end
default: next_state = MGRE_CRED;
endcase
end
// create red and yellow delay counts
always @(posedge clk)
begin
if(clk_enable==1) begin
if(RED_count_en||YELLOW_count_en1||YELLOW_count_en2)
 count_delay <=count_delay + 1;
 if((count_delay == 9)&&RED_count_en) 
 begin
 delay10s=1;
 delay3s1=0;
 delay3s2=0;
 count_delay<=0;
 end
 else if((count_delay == 2)&&YELLOW_count_en1) 
 begin
 delay10s=0;
 delay3s1=1;
 delay3s2=0;
 count_delay<=0;
 end
 else if((count_delay == 2)&&YELLOW_count_en2) 
 begin
 delay10s=0;
 delay3s1=0;
 delay3s2=1;
 count_delay<=0;
 end
 else
 begin
 delay10s=0;
 delay3s1=0;
 delay3s2=0;
 end 
end
end
// create 1s clock enable 
always @(posedge clk)
begin
count <=count + 1;
//if(count == 50000000) // 50,000,000 for 50 MHz clock running on real FPGA
if(count == 3) // for testbench
 count <= 0;
end
assign clk_enable = count==3 ? 1: 0; // 50,000,000 for 50MHz running on FPGA
endmodule