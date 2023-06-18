timescale 1ns / 1ps
//`timescale 10 ns/ 1 ps 
`define DELAY 1
//`include "counter_define.h"
module tb_traffic_light;
parameter ENDTIME = 400000;
//integer count, count1, a;
reg clk;
reg rst_n;
reg C;
wire [2:0] light_cross;
wire [2:0] light_main; 
traffic_light tb(light_main, light_cross, C, clk, rst_n);
initial
begin
clk = 1'b0;
rst_n = 1'b0;
C = 1'b0;
//count = 0;
//count1=0;
//a=0;
end
initial
begin
main;
end 
task main;
fork
clock_gen;
reset_gen;
operation_flow;
debug_output;
endsimulation;
join
endtask
task clock_gen;
begin
forever #`DELAY clk = !clk;
end
endtask
task reset_gen;
begin
rst_n = 0;
# 20
rst_n = 1;
end
endtask
task operation_flow;
begin
# 19
C = 0;
# 17
C = 1;
# 16
C = 0; 
# 19 
C = 1;
end 
endtask
task debug_output;
begin
$monitor("TIME = %d, reset = %b, C = %b, light of main = %h, light of cross road = 
%h",$time,rst_n ,C,light_main,light_cross );
end
endtask
task endsimulation;
begin
#ENDTIME
$display("-------------- THE SIMULATION END ------------");
$finish;
end
endtask
 
endmodule