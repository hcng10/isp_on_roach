%read the svm model weights and bias
%then output them as fixed point data
clear;
clc;
setup_libsvm_env('kona');
out_name ='/home/maolin/Projects/isp_on_roach/hw_eval/hw/rom.v';
%read data from files
fprintf('reading data...\n');
load svm_model.mat;

weight=(model.sv_coef)'*model.SVs;
bias = -model.rho;

%export the weight and bias in fixed point format
fcoef=fopen(out_name,'w');
fprintf(fcoef,'module ROM (addr,data);\n');
fprintf(fcoef,'input [12:0] addr;\n');
fprintf(fcoef,'output reg signed [31:0] data;\n');
fprintf(fcoef,'always@(*)\n');
fprintf(fcoef,'case(addr)\n');

for i=1:size(weight,2)
    write_value=fi(weight(i),1,32,16);
    fprintf(fcoef,strcat(int2str(i),': data <= 32''H',write_value.hex,';\n'));
end
fprintf(fcoef,'default: data <= 32''d0;\n');
fprintf(fcoef,'endcase\n');
fprintf(fcoef,'endmodule\n');

fclose(fcoef);
