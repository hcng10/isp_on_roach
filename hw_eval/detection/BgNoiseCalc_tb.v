`include "BgNoiseCalc.v"

module main;
reg [127:0] PeriodData;
reg signed [7:0] PeriodDataSlice[15:0];

reg [255:0] CurNoise;
reg signed[15:0] CurNoiseSlice [15:0];

wire [255:0] UpdatedNoise;
reg signed[15:0] UpdatedNoiseSlice [15:0];

BgNoiseCalc test(PeriodData,CurNoise,UpdatedNoise);

integer i;

initial
begin
    $display("Background Noise Module test bench:");
    $display("initial data");
    for(i=0;i<16;i++) begin
        PeriodDataSlice[i]=-i;
        CurNoiseSlice[i]=i*100;
    end
    for(i=0;i<16;i++) begin
        PeriodData[8*i +: 8]=PeriodDataSlice[i];
        CurNoise[16*i +: 16]=CurNoiseSlice[i];
    end
    #10 $display("compute");
    for(i=0;i<16;i++) begin
        UpdatedNoiseSlice[i]=UpdatedNoise[16*i +: 16];
    end
    #10 $display("result:");
    for(i=0;i<16;i++) begin
        $display("%d : %d + %d = %d",i,PeriodDataSlice[i],CurNoiseSlice[i],UpdatedNoiseSlice[i]);
    end
end

endmodule
