module main;

reg [2:0] ud;
integer i;

initial
begin
    $display("test bench:");
    ud=8'd8;
    $display("%d:",ud);
end

endmodule
