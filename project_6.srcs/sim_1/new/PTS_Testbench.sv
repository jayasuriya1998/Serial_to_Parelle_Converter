`timescale 1ns / 1ps

module PTS_Testbench();
timeunit 1ns;
timeprecision 1ps;

logic clk=0;
localparam CLK_PERIOD=10;
initial begin
    forever begin
        #(CLK_PERIOD/2);
        clk<=~clk;
    end
end

parameter N=8;
logic [N-1:0] p_data  ;
logic         p_valid ;
logic         p_ready ;
logic         s_data  ;
logic         s_valid ;
logic         s_ready ;

PTS #(.N(N)) dut (.*);

initial begin
    @(posedge clk)
    p_data  <=8'd7;
    p_valid <=0;
    s_ready <=1;
    
    #(CLK_PERIOD*2);
    @(posedge clk)
    p_data  <=8'd124;
//    p_data  <=8'd128;
    p_valid <=1;
    
    @(posedge clk);
    p_valid <=0;
    
    #(CLK_PERIOD*10);
    @(posedge clk)
    p_data  <=8'd44;
    p_valid <=1;
    
    @(posedge clk);
    p_valid <=0;
    
    @(posedge clk);
    s_ready <=0;
    
    #(CLK_PERIOD*3);
    @(posedge clk)
    s_ready <=1;
end
endmodule
