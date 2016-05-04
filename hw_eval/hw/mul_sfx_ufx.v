//this module multiply a signed data and an unsigned data to get a result
module mul_sfx_ufx(
    sdata,
    udata,
    result
);
input signed[31:0] sdata;
input [7:0] udata;
output signed[31:0] result;

wire signed[8:0] sdata_from_udata;
wire signed[39:0] result_buf;

assign sdata_from_udata=udata;
assign result_buf=sdata_from_udata*sdata;
assign result=result_buf[39:8];

endmodule
