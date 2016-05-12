module WindowSumCalc(
    input [255:0] windowdata,
    output reg signed [31:0] windowsum
);

reg signed [31:0] AccTreeL1 [7:0];
reg signed [31:0] AccTreeL2 [3:0];
reg signed [31:0] AccTreeL3 [1:0];

integer i;

always @(*) begin
    //acc level 1, input slicing
    for(i=0;i<8;i++) begin
        AccTreeL1[i] = windowdata[32*i +: 32];
    end
    //acc level 2
    for (i=0;i<4;i=i+1) begin
        AccTreeL2[i]=AccTreeL1[2*i]+AccTreeL1[2*i+1];
    end
    //acc level 3
    for (i=0;i<2;i=i+1) begin
        AccTreeL3[i]=AccTreeL2[2*i]+AccTreeL2[2*i+1];
    end
    windowsum=AccTreeL3[1]+AccTreeL3[0];
end

endmodule
