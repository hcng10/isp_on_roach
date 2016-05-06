clear;
clc;

%generate the data needed in simulink model 
%{
%droplets without beads, from plot8 to plot30
input_prefix='/home/data/roach/circle_data/plot';
output_prefix='./roach/circle_droplets/';
P=344.4086; 
%skip 13 31 34, they are bad data
circle_dataset=[9:12 14:30 32 33 35 36];

%droplets with beads, from plot8 to plot36
input_prefix='/home/data/roach/bead_data/plot';
output_prefix='./roach/bead_droplets/';
P=344.403135;
%8 to 15 have been done
bead_dataset= [20:30];
%}

input_prefix='/media/maolin/Share/data/roach/titan3/plot';
output_prefix='./';
P=338.834;
%8 to 15 have been done
bead_dataset= [0:6];

%read data
for dataset=bead_dataset
    fprintf('reading plot %d\n',dataset);
    fid = fopen(strcat(input_prefix,num2str(dataset)));
    tmp = fscanf(fid,'%x');
    fclose(fid);
    fprintf('finish reading plot %d\n',dataset);
    vals = double(typecast(uint8(tmp),'int8'));

    batch_size=344*1000;%shouled be multiply of 16
    batch_num=length(vals)/batch_size;

    for i=1:batch_num
        fprintf('plot %d |batch  %d / %d|\n',dataset,i,batch_num);
        adcvals=-vals(((i-1)*batch_size+1):(i*batch_size));
        adcvals16b=vec2mat(adcvals,16);
        [loff,imgrgb,imgB,numObj,objs] = hbplot(adcvals16b,P);
        image(imgB);
        while 1
            P_shift=input('adjust P and shift:(b for break, q for quit, s for save, sa for save the tinyvals variable)\n');
            if isempty(P_shift)
                break;     
            elseif P_shift=='q'
                return;
            elseif P_shift=='s'
                tinyvals16b=adcvals16b;
                T=[1:size(tinyvals16b,1)]';
                save(strcat(output_prefix,'plot_',num2str(dataset),'_batch_',num2str(i),'_simulink','.mat'),'tinyvals16b','T','imgrgb','imgB');
                break;
            elseif size(P_shift,2)==1
                adcvals=-vals(((i-1)*batch_size+1):(i*batch_size));
                adcvals16b=vec2mat(adcvals,16);
                [loff,imgrgb,imgB,numObj,objs] = hbplot(adcvals16b,P_shift(1));
                image(imgB);
            elseif size(P_shift,2)==2
                adcvals=-vals(((i-1)*batch_size+1+344*P_shift(2)):(i*batch_size)+344*P_shift(2));
                adcvals16b=vec2mat(adcvals,16);
                [loff,imgrgb,imgB,numObj,objs] = hbplot(adcvals16b,P);
                image(imgB);
            else
                break;
            end
        end
    end
end
