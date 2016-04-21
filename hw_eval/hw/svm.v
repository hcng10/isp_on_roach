`timescale 1ns / 1ps

module svm( input clk,
            input [127:0]rd_data, 
            input rd_empty,
            input reset,
            output rd_fifo,
            output label,
            output label_ready
    );

parameter wait_state =0 ,read_state=1, compute_state=2, judge_state=3;

reg[3:0] state;
reg[15:0] sum_count;
reg signed [63:0] sum_dot;
reg label;
reg label_ready;
reg signed [15:0] tmp[15:0];
reg rd_fifo;
`include "./coef.dat"

always @(posedge clk ) begin
	if (reset ==1'b1) begin
		
		state <= wait_state;
		sum_count <= 16'd0;
        sum_dot <=64'd0;
        
		label <= 1'd0;
		label_ready <=1'd0;
		rd_fifo<=1'd0;
		
	end else begin
		case (state) 
			wait_state:begin
				if (rd_empty == 1'b1) begin
					state<=wait_state;
				end else begin
					rd_fifo<=1'd1;
					state<=read_state;
				end	
			end
			read_state: begin          //read from fifo and compute mul
				//read 128 bits(16 byte)
				sum_count <= sum_count +16'd16;
				tmp[0]<=rd_data[7:0];
                tmp[1]<=rd_data[15:8];
                tmp[2]<=rd_data[23:16];				
                tmp[3]<=rd_data[31:24];
                tmp[4]<=rd_data[39:32];
                tmp[5]<=rd_data[47:40];
                tmp[6]<=rd_data[55:48];                
                tmp[7]<=rd_data[63:56];
                tmp[8]<=rd_data[71:64];
                tmp[9]<=rd_data[79:72];
                tmp[10]<=rd_data[87:80];                
                tmp[11]<=rd_data[95:88];
                tmp[12]<=rd_data[103:96];
                tmp[13]<=rd_data[111:104];
                tmp[14]<=rd_data[119:112];                
                tmp[15]<=rd_data[127:120];
                state<=compute_state;
                rd_fifo<=1'd0;
			end
			compute_state: begin   //compute the sum
				sum_dot<= sum_dot   
				            +tmp[0]*coef[sum_count-16'd16]
				            +tmp[1]*coef[sum_count-16'd15]
				            +tmp[2]*coef[sum_count-16'd14]
				            +tmp[3]*coef[sum_count-16'd13]
				            +tmp[4]*coef[sum_count-16'd12]
				            +tmp[5]*coef[sum_count-16'd11]
				            +tmp[6]*coef[sum_count-16'd10]
				            +tmp[7]*coef[sum_count-16'd9]
				            +tmp[8]*coef[sum_count-16'd8]
				            +tmp[9]*coef[sum_count-16'd7]
				            +tmp[10]*coef[sum_count-16'd6]
				            +tmp[11]*coef[sum_count-16'd5]
				            +tmp[12]*coef[sum_count-16'd4]
				            +tmp[13]*coef[sum_count-16'd3]
				            +tmp[14]*coef[sum_count-16'd2]
				            +tmp[15]*coef[sum_count-16'd1];	
				            			            
				if (sum_count >=16'd8192 ) begin
				    state <= judge_state;
				end else begin
				    state <= wait_state;
				end
			end
			judge_state: begin //do the classification based on the sum
				if (sum_dot>64'd8192) begin
					label<=1'b1;
				end else begin
				    label<=1'b0;
				end
				label_ready<=1'b1;
				state<=wait_state;
				sum_dot<=64'd0;
				sum_count<=16'd0;
			end
	endcase				
end
end 

endmodule
