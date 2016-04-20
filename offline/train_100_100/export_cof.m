% this script read the cell image then train the SVM used for classification
clear;
clc;
setup_libsvm_env;
out_name ='coef.dat';
%read data from files
fprintf('reading data...\n');
[bead_label,bead_raw_data]=libsvmread('./roach/libsvmdata/bead.libsvm');
[circle_label,circle_raw_data]=libsvmread('./roach/libsvmdata/circle.libsvm');

fprintf('normalizing data...\n');
for i=1:100
    bead_data(i,:)=bead_raw_data(i,:)/norm(bead_raw_data(i,:));
    circle_data(i,:)=circle_raw_data(i,:)/norm(circle_raw_data(i,:));
end

train_data=[bead_data(1:80,:) ; circle_data(1:80,:)];
train_label=[bead_label(1:80) ; circle_label(1:80)];
test_data=[bead_data(1:80,:) ; circle_data(1:80,:)];
test_label=[bead_label(1:80) ; circle_label(1:80)];

%train
fprintf('training...\n');
model = svmtrain(train_label, train_data, '-c 1 -g .1 -b 1');

%predict
fprintf('predicting...\n');
[predict_label, accuracy, prob_values] = svmpredict(test_label, test_data, model, '-b 1');

coef=(model.sv_coef)'*model.SVs;
fcoef=fopen(out_name,'w');
fprintf(fcoef,'reg signed [7:0] coef[8191:0]={\n');

for i=1:size(coef,2)
    write_value=coef(i)*128;
    if(write_value>127)
        write_value=127;
    elseif write_value<-128;
        write_value=-128
    end
    write_value=int8(write_value);
    if(write_value<0)
        fprintf(fcoef,strcat('-8''d',num2str(-write_value)));
    else
        fprintf(fcoef,strcat('8''d',num2str(write_value)));
    end
    if i == size(coef,2)
        fprintf(fcoef,'\n};');
    else
        fprintf(fcoef,',\n');
    end
end

fclose(fcoef);
