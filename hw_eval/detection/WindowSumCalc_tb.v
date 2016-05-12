`include "WindowSumCalc.v"

module main;
reg [255:0] windowdata;
wire signed [31:0] windowsum;
reg signed [31:0] linesum[7:0];

WindowSumCalc test(windowdata,windowsum);
integer i;
initial
begin
    $display("window Sum Module test bench:");
    for(i=0;i<8;i++) begin
        linesum[i]=10;
    end

    for(i=0;i<8;i++) begin
        windowdata[32*i +: 32]=linesum[i];
    end
    #10 $display("sum: %d",windowsum);
end

endmodule
