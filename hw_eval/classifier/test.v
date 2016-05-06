`include "mul_sfx_ufx.v"
module main;

reg signed [31:0] sd1;
reg signed [7:0] sd2;
reg unsigned [7:0] ud1;
wire signed [31:0] result;
reg signed [7:0][1:0] array={8'd0,8'd0};

mul_sfx_ufx multiplier(sd1,ud1,result);

initial
begin
    $display("test bench:");
    assign sd1=-32'd200;
    assign ud1=8'd200;
    assign sd2=8'h82;
    $display("sd1: %d",sd1);
    $display("sd1: %d",sd2);
    $display("ud1: %d",ud1);
    $display("array0: %d",array[0]);
    $display("array1: %d",array[1]);
    $display("result: %d",result);
end

endmodule
