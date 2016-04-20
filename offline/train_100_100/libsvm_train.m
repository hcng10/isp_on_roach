% this script read the cell image then train the SVM used for classification
clear;
clc;

%before run this script set up the libsvm env
%for linux env, run setup_libsvm_env.m;
%for windows env, run  setup_win_libsvm_env.m;

%read data from files

fprintf('reading data...\n');
[bead_label,bead_data]=libsvmread('./beads.libsvm');
[circle_label,circle_data]=libsvmread('./no_beads.libsvm');
%there is a stupid mistake here!!! 
%you shouldn't normlize the the data in the following way, this way change the whole data set!!!
%the correct why is to divide by the largest norm in the dataset for all data in the data set!!
%{

fprintf('normalizing data...\n');
for i=1:100
    bead_data(i,:)=bead_raw_data(i,:)/norm(bead_raw_data(i,:));
    circle_data(i,:)=circle_raw_data(i,:)/norm(circle_raw_data(i,:));
end
%}
% but it's strange here, using "the wrong normlized" data I can get a
% better result, maybe that's because I use different kernel to train.

%5 fold validation
for j=1:5

    train_range=[1:80;1:60 81:100;1:40 61:100;1:20 41:100;21:100];
    test_range=[81:100;61:80;41:60;21:40;1:20];

    train_data=[bead_data(train_range(j,:),:) ; circle_data(train_range(j,:),:)];
    train_label=[bead_label(train_range(j,:)) ; circle_label(train_range(j,:))];
    test_data=[bead_data(test_range(j,:),:) ; circle_data(test_range(j,:),:)];
    test_label=[bead_label(test_range(j,:)) ; circle_label(test_range(j,:))];

    %train
    fprintf('training...\n');
    svm_arg='-c 100 -g 8 -b 1 -t 0 -s 0';
    model = svmtrain(train_label,train_data,svm_arg); 
    %predict
    fprintf('predicting...\n');
    %[predict_label, accuracy,prob_values] = svmpredict(train_label, train_data, model,'-b 1');
    [predict_label, accuracy,prob_values] = svmpredict(test_label, test_data, model,'-b 1');
    result(j)=accuracy(1);
end
fprintf('test done, 5 fold validation mean accuracy:%f%%\n',mean(result));
%save the trained model
save('svm_model.mat','model');
