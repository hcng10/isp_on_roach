`timescale 1ns / 1ps

module svm(
    input clk,
    input ce,
    input [127:0]rddata, 
    input rdempty,
    input reset,
    output reg rdfifo=1'd0,
    output reg objecttype=1'd0,
    output reg objecttypeready=1'd0,
    //use for debug,output 
    output wire stateoutput,
    output wire [15:0] periodcounteroutput,
    output wire [7:0] localcounteroutput,
    output wire signed [63:0] accumulatoroutput
);

parameter WaitState=0 ,ReadState=1, ComputeState=2, JudgeState=3;
parameter PeriodNum=16'd512;
parameter PeriodLength=8'd16;

reg[3:0] state=WaitState;
reg[15:0] PeriodCounter=16'd0;
reg[7:0] LocalCounter=8'd0;

reg signed [63:0] accumulator=64'd0;
reg signed [15:0] DataBuf[15:0];

//`include "./coef.dat"
assign stateoutput=state;
assign periodcounteroutput=PeriodCounter;
assign localcounteroutput=LocalCounter;
assign accumulatoroutput=accumulator;

always @(posedge clk or negedge reset) begin
    if (~reset) begin
        state <= WaitState;
    end else begin
        case (state) 
            WaitState:begin
                if (rdempty== 1'b1) begin
                    state<=WaitState;
                end else begin
                    rdfifo<=1'd1;
                    state<=ReadState;
                end	
            end
            ReadState: begin          //read from fifo and compute mul
            //read 128 bits(16 byte)
            PeriodCounter<= PeriodCounter+16'd16;
            DataBuf[0]<=rddata[7:0];
            DataBuf[1]<=rddata[15:8];
            DataBuf[2]<=rddata[23:16];				
            DataBuf[3]<=rddata[31:24];
            DataBuf[4]<=rddata[39:32];
            DataBuf[5]<=rddata[47:40];
            DataBuf[6]<=rddata[55:48];                
            DataBuf[7]<=rddata[63:56];
            DataBuf[8]<=rddata[71:64];
            DataBuf[9]<=rddata[79:72];
            DataBuf[10]<=rddata[87:80];                
            DataBuf[11]<=rddata[95:88];
            DataBuf[12]<=rddata[103:96];
            DataBuf[13]<=rddata[111:104];
            DataBuf[14]<=rddata[119:112];                
            DataBuf[15]<=rddata[127:120];
            state<=ComputeState;
            rdfifo<=1'd0;
        end
        ComputeState: begin   //compute the sum
        accumulator<= accumulator   
        +DataBuf[0]
        +DataBuf[1]
        +DataBuf[2]
        +DataBuf[3]
        +DataBuf[4]
        +DataBuf[5]
        +DataBuf[6]
        +DataBuf[7]
        +DataBuf[8]
        +DataBuf[9]
        +DataBuf[10]
        +DataBuf[11]
        +DataBuf[12]
        +DataBuf[13]
        +DataBuf[14]
        +DataBuf[15];

        if (PeriodCounter >=PeriodNum) begin
            state <= JudgeState;
        end else begin
            state <= WaitState;
        end
    end
    JudgeState: begin //do the classification based on the sum
    if (accumulator>64'd8192) begin
        objecttype<=1'b1;
    end else begin
        objecttype<=1'b0;
    end
    objecttypeready<=1'b1;
    state<=WaitState;
    accumulator<=64'd0;
    PeriodCounter<=16'd0;
end
    endcase				
end
end 

endmodule
