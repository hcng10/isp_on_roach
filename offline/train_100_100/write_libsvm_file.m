close all;
clear; 

for out_loop=1:2
    if out_loop==1
        libsvmfile = fopen('./beads.libsvm', 'w');
        inprefix='./beads/';
        label='0 ';
    else
        libsvmfile = fopen('./no_beads.libsvm', 'w');
        inprefix='./no_beads/';
        label='1 ';
    end

    list=dir(inprefix);
    name={list.name ''};
    cnt=0;
    for n=3:size(name,2)-1
        image_name=strjoin(name(n));
        if ~isempty(findstr(image_name,'.mat'))
            cnt=cnt+1;
            load(strcat(inprefix,image_name));
            cell_image=imresize(ori_img,[128 64]);
            fprintf(libsvmfile, label);    
            for i = 1 : size(cell_image,2) 
                for j = 1 : size(cell_image,1) 
                    fprintf(libsvmfile, '%d:', (i-1)*size(cell_image,1)+j);
                    fprintf(libsvmfile, '%f ', cell_image(j,i));
                end
            end
            fprintf(libsvmfile, '\n');
        end
    end
    fprintf(strcat('finishing writing %d label_',label,' data\n'),cnt);
    fclose(libsvmfile);
end
