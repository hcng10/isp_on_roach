module RemoveNoise(
    input [127:0] PeriodData,
    input [255:0] BgNoise,
    output reg [127:0] DataNoNoise
);

reg signed [7:0] PeriodDataSlice [15:0];
reg signed [15:0] BgNoiseSlice [15:0];

integer i;

always @(*) begin
    for(i=0;i<16;i=i+1) begin
        PeriodDataSlice[i] = PeriodData[8*i +: 8];
        BgNoiseSlice[i] = BgNoise[16*i +: 16];
    end
    for(i=0;i<16;i=i+1) begin
        DataNoNoise[8*i +: 8] = PeriodDataSlice[i] - BgNoiseSlice[i];
    end
end
endmodule
