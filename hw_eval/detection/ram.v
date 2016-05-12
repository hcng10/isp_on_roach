`timescale 1ns/1ps

module RAM (clk,rw,addr,rdata,wdata);

parameter Lock=0,Read=1,Write=2;
input clk;
input [1:0] rw;
input [7:0] addr;
output reg [7:0] rdata;
input [127:0] wdata;

reg [127:0] ramdata=128'd0;

always@(posedge clk)
    case (rw) 
        Write:ramdata<=wdata;
        Read:
            case(addr) 
                0:rdata<=ramdata[7:0];
                1:rdata<=ramdata[15:8];
                2:rdata<=ramdata[23:16];
                3:rdata<=ramdata[31:24];
                4:rdata<=ramdata[39:32];
                5:rdata<=ramdata[47:40];
                6:rdata<=ramdata[55:48];
                7:rdata<=ramdata[63:56];
                8:rdata<=ramdata[71:64];
                9:rdata<=ramdata[79:72];
                10:rdata<=ramdata[87:80];
                11:rdata<=ramdata[95:88];
                12:rdata<=ramdata[103:96];
                13:rdata<=ramdata[111:104];
                14:rdata<=ramdata[119:112];
                15:rdata<=ramdata[127:120];
                default:rdata<=8'd0;
            endcase
        default: ramdata<= ramdata;
    endcase
endmodule
