%this script show the output of software svm output
load input.mat;
load svm_wb.mat;

sw_acc_history=zeros(size(weight,2)+1,1);
sw_acc=0;

for i=1:size(weight,2)
    sw_acc=sw_acc+weight(i)*detect_obj(i);
    sw_acc_history(i)=sw_acc;
end
sw_acc=sw_acc+bias;
sw_acc_history(i+1)=sw_acc;

stairs(sw_acc_history);
title('software dot result');

fprintf('correct label: %d\n',obj_label);
fprintf('dot product: %f\n',sw_acc);
if(sw_acc>0)
    fprintf('predict label: 1\n');
else
    fprintf('predict label: 0\n');
end
