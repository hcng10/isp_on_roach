`timescale 1ns / 1ps

module svm(
    input clk,
    input ce,
    input [127:0]rddata, 
    input rdempty,
    input reset,

    //need to generate config.m without initialization
    /*
    output reg rdfifo,
    output reg objecttype,
    output reg objecttypeready,
    */

    //after generate config.m use this code with initial, or simulink report
    //error
    output reg rdfifo=1'd0,
    output reg objecttype=1'd0,
    output reg objecttypeready=1'd0,

    //use for debug,output 
    output wire [3:0] stateoutput,
    output wire [15:0] periodcounteroutput,
    output wire [7:0] localcounteroutput,
    output wire [12:0] rom_in_output,
    output wire signed [31:0] rom_out,
    output wire [7:0] mul_ud_in_output,
    output wire signed[31:0] mul_result_out,
    output wire signed [31:0] accumulatoroutput
);

parameter WaitState=0 ,ReadState=1, InputState=2, ComputeState=3, OutputState=4, JudgeState=5;
parameter PeriodNum=16'd512;
parameter PeriodLength=8'd16;
parameter LocalNum=8'd16;

reg[3:0] state=WaitState;
reg[15:0] PeriodCounter=16'd0;
reg[7:0] LocalCounter=8'd0;

reg signed [31:0] accumulator=32'd0;
reg signed [31:0] bias=32'H00111af9;

reg [12:0] rom_in;
ROM rom(rom_in,rom_out);

wire [7:0] ram_out;
reg [1:0] ramrw=2'd0;//lock ram
RAM ram(clk,ramrw,LocalCounter,ram_out,rddata);

//reg [7:0] mul_ud_in;
mul_sfx_ufx multiplier(rom_out,ram_out,mul_result_out);

assign stateoutput=state;
assign rom_in_output=rom_in;
assign mul_ud_in_output=ram_out;
assign periodcounteroutput=PeriodCounter;
assign localcounteroutput=LocalCounter;
assign accumulatoroutput=accumulator;

always @(posedge clk or negedge reset) begin
    if (~reset) begin
        state <= WaitState;
    end 
    else begin
        case (state) 
            WaitState:begin
                if (rdempty== 1'b1) begin
                    state<=WaitState;
                    objecttypeready<=1'b0;
                end 
                else begin
                    rdfifo<=1'd1;
                    state<=ReadState;
                end	
            end
            ReadState:begin
                //read from fifo 128 bits(16 byte)
                PeriodCounter<= PeriodCounter+16'd1;
                state<=InputState;
                ramrw<=2'd2;//write ram
                rdfifo<=1'd0;
                LocalCounter<=8'd0;
            end
            InputState:begin
                //compute the sum
                if (LocalCounter>=LocalNum) begin
                    LocalCounter<=8'd0;
                    if (PeriodCounter >=PeriodNum) begin
                        accumulator <= accumulator+bias;
                        state <= JudgeState;
                    end
                    else begin
                        state <= WaitState;
                    end
                end
                else begin
                    rom_in <= (PeriodCounter-1)*16+LocalCounter;
                    ramrw<=2'd1;//read ram
                    state <= ComputeState;
                end
            end
            ComputeState:begin
                state <= OutputState;
            end
            OutputState:begin
                accumulator <= accumulator+mul_result_out;
                LocalCounter <= LocalCounter+1;
                state <= InputState;
            end
            JudgeState:begin
                //do the classification based on the sum
                if (accumulator>32'd0) begin
                    objecttype<=1'b1;
                end else begin
                    objecttype<=1'b0;
                end
                objecttypeready<=1'b1;
                state<=WaitState;
                //accumulator<=64'd0;
                PeriodCounter<=16'd0;
            end
        endcase
    end
end

endmodule
