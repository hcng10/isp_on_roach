`timescale 1ns / 1ps
//this module detect the boarders of the droplet
//then re-sample to fixed size and output to a FIFO

module detectobj(
    input clk,
    input ce,
    input [127:0] rddata,
    input rdempty,
    input reset,

    //need to generate config.m without initialization
    output reg rdfifo,
    //after generate config.m use this code with initial, or simulink report
    //error
    //output reg rdfifo=1'd0,

    //use for debug
    output wire [4:0] stateoutput,
    output wire [7:0] periodcounteroutput,
    output wire [7:0] linecounteroutput
    );

//FSM : 4 stages
//1. Bg: background subtraction and abs sum
//2. InObj: in droplet processing
//3. OutObj: out of droplet processing
//4. ResOut: resample and output 
parameter BgWait=0, BgRead=1, BgCompute=2,
          OutObjWait=3, OutObjRead=4,
          InObjWait=5;
reg[4:0] state=BgWait;

//each line have 21 period
parameter PeriodNum=8'd21;
reg[7:0] PeriodCounter=8'd0;
//reg to store the data read from FIFO
reg [127:0] PeriodData;

//used to store and compute the background information
//then used for background subtraction and determine background threshold

//Use Average of 8 lines to compute BgNoise of each column
reg signed [7:0] BgNoise [335:0];
//absolute sum of 8 lines in background
reg signed [31:0] BgAbsSum;

//current line absolute sum
reg signed [31:0] CurAbsSum;
wire signed [31:0] UpdatedAbsSum;
AbsSumCalc abssum(PeriodData,CurAbsSum,UpdatedAbsSum);

//absolute sum difference between current line and Background
reg signed [31:0] AbsError;

//absolute sum difference threshold between current line and Background
reg signed [31:0] AbsErrThres;

reg [7:0] AboveBgTimes=8'd0;
reg [7:0] OutObjTimesThres=8'd3;

reg [7:0] EqualBgObjTimes=8'd0;
reg [7:0] InObjTimesThres=8'd3;

//a slide window, use to smooth the abs sum of a line
//aim to decrease the sensitivity of threshold method
//window size : 8
reg signed [31:0] LineAbsSum [7:0];

parameter BgLineNum=16'd8;
reg [15:0] LineCounter=16'd0;

assign stateoutput=state;
assign periodcounteroutput=PeriodCounter;
assign linecounteroutput=LineCounter;

integer i;

always @(posedge clk or negedge reset) begin
    if (~reset) begin
        state <= BgWait;
    end 
    else begin
        case (state) 
            //1. Stage Background Processing
            BgWait:begin
                if (LineCounter>=BgLineNum) begin
                    state <= OutObjWait;
                end
                else begin
                    if (rdempty== 1'b1) begin
                        state<=BgWait;
                    end
                    else begin
                        rdfifo<=1'd1;
                        state<=BgRead;
                    end
                end
            end
            BgRead:begin
                //read from fifo 128 bits(16 byte)
                rdfifo<=1'd0;
                PeriodData<=rddata;
                CurAbsSum<=LineAbsSum[LineCounter[2:0]];
                PeriodCounter<= PeriodCounter+16'd1;
                state<=BgCompute;
            end
            BgCompute:begin
                LineAbsSum[LineCounter[2:0]]<=UpdatedAbsSum;
                if(PeriodCounter==PeriodNum) begin
                    LineCounter<=LineCounter+1;
                end
                state<=BgWait;
            end

            //2. Out Object Processing
            OutObjWait:begin
                if (AboveBgTimes>=OutObjTimesThres) begin
                    state<=InObjWait;
                end
                else begin
                    if (rdempty== 1'b1) begin
                        state<=OutObjWait;
                    end
                    else begin
                        rdfifo<=1'd1;
                        state<=OutObjRead;
                    end
                end
            end
            OutObjRead:begin

            end

            //3. In Object Processing
            InObjWait:begin
            end

            //4. Resample and output
            
            default:state<=BgWait;
        endcase
    end
end

endmodule
