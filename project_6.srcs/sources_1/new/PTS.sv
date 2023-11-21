`timescale 1ns / 1ps

module PTS #(parameter N=8)
(
  input logic clk,
  input logic [N-1:0] p_data,
  input logic         p_valid,
  output logic        p_ready,
  output logic        s_data,
  output logic        s_valid,
  input logic         s_ready
  
);
typedef enum logic [0:0]{
    RX =1'b0,
    TX =1'b1
}states_t;

localparam N_BITS =$clog2(N);

//initial values
//when fpga powers up

logic [N_BITS-1:0] count=0;
states_t           state=RX;

//Next State Decorder Logic
states_t next_state;
always_comb begin
    unique case(state)
        RX:begin
            if(p_valid) next_state=TX;
            else        next_state=RX;
           end
        TX:begin
            if(count==N-1 && s_ready) 
                next_state=RX;
            else
                next_state=TX;    
           end
    endcase
end

//State Sequencer Logic

always_ff @(posedge clk) begin
    state<=next_state;
end

//output decode logic
logic [N-1:0] shift_reg;
assign s_data=shift_reg[0];

assign p_ready=(state==RX);
assign s_valid=(state==TX);

always_ff @(posedge clk)begin
    unique case(state)
        RX:shift_reg<=p_data;
        TX:begin
            if(s_ready)begin
                //shift_reg=shift_reg >>1;
                shift_reg<={1'd0,shift_reg[N-1:1]};
                count    <=count+1'd1; 
            end
            else begin
                shift_reg<=shift_reg;
                count    <=count;
            end
        end
    endcase 
end

endmodule
