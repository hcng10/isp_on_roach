`include "RemoveNoise.v"

module main;
reg [127:0] PeriodData;
reg signed [7:0] PeriodDataSlice[15:0];

reg [255:0] BgNoise;
reg signed[15:0] BgNoiseSlice [15:0];

wire [127:0] DataNoNoise;
reg signed[7:0] DataNoNoiseSlice [15:0];

RemoveNoise test(PeriodData,BgNoise,DataNoNoise);

integer i;

initial
begin
    $display("Remove Background Noise Module test bench:");
    $display("initial data");
    for(i=0;i<16;i++) begin
        PeriodDataSlice[i]=5*i;
        BgNoiseSlice[i]=-i;
    end

    for(i=0;i<16;i++) begin
        PeriodData[8*i +: 8]=PeriodDataSlice[i];
        BgNoise[16*i +: 16]=BgNoiseSlice[i];
    end

    #10 $display("compute");
    for(i=0;i<16;i++) begin
        DataNoNoiseSlice[i]=DataNoNoise[8*i +: 8];
    end

    #10 $display("result:");
    for(i=0;i<16;i++) begin
        $display("%d : %d - %d = %d",i,PeriodDataSlice[i],BgNoiseSlice[i],DataNoNoiseSlice[i]);
    end
end

endmodule
