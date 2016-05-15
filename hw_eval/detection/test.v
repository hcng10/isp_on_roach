module main;

reg [7:0] ud[1:0];
reg [15:0] concat;
integer i;

initial
begin
    $display("test bench:");
    ud[0]=8'd200;
    ud[1]=ud[0]/9;
    $display("%d,%d",ud[0],ud[1]);
end

endmodule
