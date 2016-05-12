`include "AbsSumCalc.v"

module main;
reg [127:0] PeriodData;
reg signed[31:0] CurAbsSum;
wire signed[31:0] UpdatedAbsSum;

AbsSumCalc test(PeriodData,CurAbsSum,UpdatedAbsSum);

initial
begin
    $display("Absolute Sum Module test bench:");
    PeriodData={16{8'Hff}};
    CurAbsSum=-32'd1000;
    #10 $display("result : %d",UpdatedAbsSum);
end

endmodule
