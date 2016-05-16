module BgNoiseCalc(
    input [127:0] PeriodData,
    input [255:0] CurNoise,
    output reg [255:0] UpdatedNoise
);

reg signed [7:0] Data [15:0];
reg signed [15:0] CurBgData [15:0];

integer i;

always @(*) begin
    for(i=0;i<16;i=i+1) begin
        Data[i] = PeriodData[8*i +: 8];
        CurBgData[i] = CurNoise[16*i +: 16];
    end
    for(i=0;i<16;i=i+1) begin
        UpdatedNoise[16*i +: 16] = Data[i] + CurBgData[i];
    end
end
endmodule
