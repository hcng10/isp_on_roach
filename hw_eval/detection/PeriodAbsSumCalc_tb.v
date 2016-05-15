`include "PeriodAbsSumCalc.v"

module main;
reg [127:0] PeriodData;
wire signed[31:0] AbsSum;

PeriodAbsSumCalc test(PeriodData,AbsSum);

initial
begin
    $display("Period Abs Sum Calculate Absolute Sum Module test bench:");
    PeriodData={16{-8'd3}};
    #10 $display("result : %d",AbsSum);
end

endmodule
