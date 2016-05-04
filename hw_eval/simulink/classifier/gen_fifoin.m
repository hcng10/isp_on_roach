% this script read the cell image then translate to fifo input for further SVM classification
function gen_fifoin(droplet_type,sample_num)
setup_libsvm_env('kona');
simulation_time=30000;
fifo_byte_width=16;

input_prefix='../../../offline/train_100_100';
if strcmp(droplet_type,'bead')==1
    [bead_label,bead_data]=libsvmread([input_prefix '/beads.libsvm']);
    bead_data=round(bead_data);
    detect_obj=bead_data(sample_num,:);
    obj_label=bead_label(sample_num);
elseif strcmp(droplet_type,'circle')==1
    [circle_label,circle_data]=libsvmread([input_prefix '/no_beads.libsvm']);
    circle_data=round(circle_data);
    detect_obj=circle_data(sample_num,:);
    obj_label=circle_label(sample_num);
else 
    fprintf('wrong type!\n');
    return;
end

%because of the operation of the background substraction, 
%there are negative values of the input
detect_obj=detect_obj-min(detect_obj);
period=size(detect_obj,2)/fifo_byte_width;

tinyvals16b=zeros(simulation_time,16);
for i=1:period
    for j=1:fifo_byte_width
        tinyvals16b(i,j)=detect_obj((i-1)*fifo_byte_width+j);
    end
end
write_enable=[ones(period,1) ; zeros(simulation_time-period,1)];
T=[0:simulation_time-1]';

save('input.mat','detect_obj','obj_label','tinyvals16b','T','write_enable');
