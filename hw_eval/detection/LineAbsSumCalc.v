module LineAbsSumCalc(
    input [127:0] PeriodData,
    input signed [31:0] CurAbsSum,
    output reg signed [31:0] UpdatedAbsSum
);
//use accumulation tree to compute the abs sum of 16 input data
reg signed [31:0] AccTreeL1 [7:0];
reg signed [31:0] AccTreeL2 [3:0];
reg signed [31:0] AccTreeL3 [1:0];
reg signed [31:0] AccTreeResult;
reg signed [7:0] Data [15:0];

integer i;

always @(*) begin
    //input slicing
    for(i=0;i<16;i=i+1) begin
       Data[i] = PeriodData[8*i +: 8];
    end
    //acc level 1
    for (i=0;i<8;i=i+1) begin
        AccTreeL1[i]=(Data[2*i]>0?Data[2*i]:-Data[2*i])+
                     (Data[2*i+1]>0?Data[2*i+1]:-Data[2*i+1]);
    end
    //acc level 2
    for (i=0;i<4;i=i+1) begin
        AccTreeL2[i]=AccTreeL1[2*i]+AccTreeL1[2*i+1];
    end
    //acc level 3
    for (i=0;i<2;i=i+1) begin
        AccTreeL3[i]=AccTreeL2[2*i]+AccTreeL2[2*i+1];
    end
    AccTreeResult=AccTreeL3[0]+AccTreeL3[1];
    UpdatedAbsSum=(CurAbsSum>0?CurAbsSum:-CurAbsSum)+AccTreeResult;
end

endmodule
