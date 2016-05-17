`timescale 1ns / 1ps
//this module detect the boarders of the droplet
//then re-sample to fixed size and output to a FIFO

/*
`include "WindowSumCalc.v"
`include "LineAbsSumCalc.v"
`include "PeriodAbsSumCalc.v"
`include "BgNoiseCalc.v"
`include "RemoveNoise.v"
*/

module detectobj(
    input clk,
    input ce,
    input [127:0] rddata,
    input rdempty,
    input reset,

    //module output
    //need to generate config.m without initialization
    //after generate config.m use this code with initial, or simulink will report error
    /*
    output reg rdfifo,
    output reg writedata,
    output reg writesize,
    */
    output reg rdfifo=1'd0,
    output reg writedata=1'd0,
    output reg writesize=1'd0,

    output reg [127:0] detectdata,
    output reg [31:0] detectsize,

    //output use for debug
    output wire signed [31:0] windowsum,
    output wire signed [31:0] bgabssumoutput,
    output wire [7:0] abovebgtimesoutput,
    output wire [7:0] belowinobjtimesoutput,
    output wire [4:0] stateoutput,
    output wire [7:0] periodcounteroutput,
    output wire [7:0] linecounteroutput
    );

//FSM : 4 stages
//1. Bg: background Noise Calculation for further subtraction
//2. init: Initialize the detection threshold
//3. InObj: in droplet processing
//4. OutObj: out of droplet processing
localparam BgWait=0, BgRead=1, BgCompute=2;
localparam InitWait=3, InitRead=4, InitBgRm=5, InitCompute=6;
localparam OutObjWait=7, OutObjRead=8, OutObjBgRm=9, OutObjCompute=10, OutObjJudge=11;
localparam InObjWait=12, InObjRead=13, InObjBgRm=14, InObjCompute=15, InObjJudge=16;

reg[4:0] state;

//each line have 21 period
parameter PeriodNum=8'd21;
reg[7:0] PeriodCounter=8'd0;
//reg to store the data read from FIFO
reg [127:0] PeriodData;

//used to store and compute the background information
//then used for background subtraction and determine background threshold

//Use Average of 8 lines to compute BgNoise of each column
//absolute sum of 8 lines in background
reg signed [15:0] BgNoise [335:0];
reg [255:0] CurNoise;
wire [255:0] UpdatedNoise;
BgNoiseCalc bgnoise(PeriodData,CurNoise,UpdatedNoise);

wire [127:0] DataNoNoise;
reg [255:0] PeriodNoise;
RemoveNoise removenoise(PeriodData,PeriodNoise,DataNoNoise);

reg signed [31:0] BgAbsSum;
//current line absolute sum
reg signed [31:0] CurAbsSum;
wire signed [31:0] UpdatedAbsSum;
LineAbsSumCalc lineabssum(DataNoNoise,CurAbsSum,UpdatedAbsSum);
//current period absolute sum
wire signed [31:0] PeriodAbsSum;
PeriodAbsSumCalc periodabssum(DataNoNoise,PeriodAbsSum);

//absolute sum difference between current line and Background
reg signed [31:0] AbsError;

//absolute sum difference threshold between current line and Background
reg signed [31:0] AbsErrThres=1000;
reg [7:0] AboveBgTimes=8'd0;
reg [7:0] OutObjTimesThres=8'd3;

reg [7:0] BelowInObjTimes=8'd0;
reg [7:0] InObjTimesThres=8'd3;

//a slide window, use to smooth the abs sum of a line
//aim to decrease the sensitivity of threshold method
//window size : 8
reg signed [31:0] LineAbsSum [7:0];
WindowSumCalc WindowSum(
    {   LineAbsSum[7],
        LineAbsSum[6],
        LineAbsSum[5],
        LineAbsSum[4],
        LineAbsSum[3],
        LineAbsSum[2],
        LineAbsSum[1],
        LineAbsSum[0]},
    windowsum
);

parameter InitLineNum=16'd8;
parameter BgLineNum=16'd8;
reg [31:0] LineCounter=31'd0;

assign stateoutput=state;
assign periodcounteroutput=PeriodCounter;
assign linecounteroutput=LineCounter;
assign bgabssumoutput=BgAbsSum;
assign abovebgtimesoutput=AboveBgTimes;
assign belowinobjtimesoutput=BelowInObjTimes;

integer i;

always @(posedge clk or negedge reset) begin
    if (~reset) begin
        state <= BgWait;
        //Initialize other state varaible like all kinds of counters
    end
    else begin
        case (state)
            //1. Calculate Background Noise
            BgWait:begin
                if (LineCounter>=BgLineNum) begin
                    //compute average background noise
                    for(i=0;i<336;i=i+1) begin
                        BgNoise[i] <= BgNoise[i]/BgLineNum;
                    end
                    LineCounter<=0;
                    state <= InitWait;
                end
                else begin
                    if (rdempty== 1'b1) begin
                        state<=BgWait;
                    end
                    else begin
                        rdfifo <= 1'd1;
                        PeriodCounter<= PeriodCounter+16'd1;
                        state <= BgRead;
                    end
                end
            end
            BgRead:begin
                rdfifo<=1'd0;
                //read from fifo 128 bits(16 byte)
                PeriodData<=rddata;
                //input background noise compute module
                if(LineCounter == 1) begin
                    //first line need to initialize the background noise reg
                    for(i=0;i<16;i=i+1) begin
                        CurNoise[16*i +: 16] <= 0;
                    end
                end
                else begin
                    for(i=0;i<16;i=i+1) begin
                        CurNoise[16*i +: 16] <= BgNoise[(PeriodCounter-1)*16+i];
                    end
                end
                state<=BgCompute;
            end
            BgCompute:begin
                //get background noise
                for(i=0;i<16;i=i+1) begin
                    BgNoise[(PeriodCounter-1)*16+i] <= UpdatedNoise[16*i +: 16];
                end
                if(PeriodCounter==PeriodNum) begin
                    PeriodCounter <= 0;
                    LineCounter<=LineCounter+1;
                end
                state<=BgWait;
            end

            //2. initialize detection threshold
            InitWait:begin
                if (LineCounter>=InitLineNum) begin
                    BgAbsSum <= windowsum;
                    LineCounter<=0;
                    state <= OutObjWait;
                end
                else begin
                    if (rdempty== 1'b1) begin
                        state<=InitWait;
                    end
                    else begin
                        rdfifo <= 1'd1;
                        PeriodCounter<= PeriodCounter+16'd1;
                        state <= InitRead;
                    end
                end
            end
            InitRead:begin
                rdfifo<=1'd0;
                //read from fifo 128 bits(16 byte)
                PeriodData<=rddata;
                //remove background noise
                for(i=0;i<16;i=i+1) begin
                    PeriodNoise[16*i +: 16] <= BgNoise[(PeriodCounter-1)*16+i];
                end
                state<=InitBgRm;
            end
            InitBgRm:begin
                //input abs sum compute module
                if(PeriodCounter==1) begin
                    CurAbsSum <= 0;
                end
                else begin
                    CurAbsSum <= LineAbsSum[LineCounter[2:0]];
                end
                state<=InitCompute;
            end
            InitCompute:begin
                //get abs result
                LineAbsSum[LineCounter[2:0]] <= UpdatedAbsSum;
                if(PeriodCounter==PeriodNum) begin
                    PeriodCounter <= 0;
                    LineCounter<=LineCounter+1;
                end
                state <= InitWait;
            end

            //3. Out Object Processing
            OutObjWait:begin
                writesize <= 0;
                if (AboveBgTimes>=OutObjTimesThres) begin
                    LineCounter <= 0;
                    state<=InObjWait;
                end
                else begin
                    if (rdempty== 1'b1) begin
                        state<=OutObjWait;
                    end
                    else begin
                        rdfifo<=1'd1;
                        PeriodCounter<= PeriodCounter+16'd1;
                        state<=OutObjRead;
                    end
                end
            end
            OutObjRead:begin
                rdfifo<=1'd0;
                //read from fifo 128 bits(16 byte)
                PeriodData<=rddata;
                //remove background noise
                for(i=0;i<16;i=i+1) begin
                    PeriodNoise[16*i +: 16] <= BgNoise[(PeriodCounter-1)*16+i];
                end
                state<=OutObjBgRm;
            end
            OutObjBgRm:begin
                //input abs sum compute module
                if(PeriodCounter==1) begin
                    CurAbsSum <= 0;
                end
                else begin
                    CurAbsSum <= LineAbsSum[LineCounter[2:0]];
                end
                state<=OutObjCompute;
            end
            OutObjCompute:begin
                //get abs result
                LineAbsSum[LineCounter[2:0]] <= UpdatedAbsSum;
                if(PeriodCounter==PeriodNum) begin
                    PeriodCounter <= 0;
                    LineCounter<=LineCounter+1;
                    state <= OutObjJudge;
                end
                else begin
                    state<=OutObjWait;
                end
            end
            OutObjJudge:begin
                if(windowsum-BgAbsSum>AbsErrThres) begin
                    AboveBgTimes <= AboveBgTimes+1;
                end
                state<=OutObjWait;
            end

            //4. In Object Processing
            InObjWait:begin
                if (BelowInObjTimes>=InObjTimesThres) begin
                    detectsize <= LineCounter;
                    writesize <= 1;
                    LineCounter <= 0;
                    state<=OutObjWait;
                end
                else begin
                    if (rdempty== 1'b1) begin
                        state<=InObjWait;
                    end
                    else begin
                        rdfifo<=1'd1;
                        PeriodCounter<= PeriodCounter+16'd1;
                        state<=InObjRead;
                    end
                end
            end
            InObjRead:begin
                rdfifo<=1'd0;
                //read from fifo 128 bits(16 byte)
                PeriodData<=rddata;
                //remove background noise
                for(i=0;i<16;i=i+1) begin
                    PeriodNoise[16*i +: 16] <= BgNoise[(PeriodCounter-1)*16+i];
                end
                state<=InObjBgRm;
            end
            InObjBgRm:begin
                //output detected Background-removed data into fifo
                detectdata <= DataNoNoise;
                writedata <= 1;
                //input abs sum compute module
                if(PeriodCounter==1) begin
                    CurAbsSum <= 0;
                end
                else begin
                    CurAbsSum <= LineAbsSum[LineCounter[2:0]];
                end
                state<=InObjCompute;
            end
            InObjCompute:begin
                writedata <= 0;
                //get abs result
                LineAbsSum[LineCounter[2:0]] <= UpdatedAbsSum;
                if(PeriodCounter==PeriodNum) begin
                    PeriodCounter <= 0;
                    LineCounter<=LineCounter+1;
                    state <= InObjJudge;
                end
                else begin
                    state<=InObjWait;
                end
            end
            InObjJudge:begin
                if(windowsum-BgAbsSum<AbsErrThres) begin
                    BelowInObjTimes <= BelowInObjTimes+1;
                end
                state<=InObjWait;
            end

            default:state<=BgWait;
        endcase
    end
end

endmodule
