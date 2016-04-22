% this script read the cell image then translate to fifo input for further SVM classification
clear;
clc;

%before run this script set up the libsvm env
%for linux env, run setup_libsvm_env.m;
%for windows env, run  setup_win_libsvm_env.m;

%read data from files

fprintf('reading data...\n');
input_prefix='../../offline/train_100_100';
[bead_label,bead_data]=libsvmread([input_prefix '/beads.libsvm']);
bead_data=floor(bead_data);

[circle_label,circle_data]=libsvmread([input_prefix '/no_beads.libsvm']);
circle_data=floor(circle_data);

fifo_byte_width=16;
period=size(bead_data,2)/fifo_byte_width;

detect_obj=bead_data(1,:);
%because of the operation of the background substraction, 
%there are negative values of the input
detect_obj=detect_obj-min(detect_obj);

fifoin=fi(zeros(period,1),0,128,0);
for i=1:period
    for j=1:fifo_byte_width
        %if i==1
        %    fprintf('%s\n',dec2bin(detect_obj((i-1)*fifo_byte_width+j),8));
        %end
        fifoin(i)=bitshift(fifoin(i),8)+detect_obj((i-1)*fifo_byte_width+j);
    end
end
fifoin=double(fifoin);
T=[0:size(fifoin,1)-1]';
