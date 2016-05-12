module main;

reg [7:0] ud[1:0];
reg [15:0] concat;
integer i;

initial
begin
    $display("test bench:");
    ud[0]=8'hf0;
    ud[1]=8'h0f;
    concat={ud[1],ud[0]};
    $display("%h:",concat);
end

endmodule
