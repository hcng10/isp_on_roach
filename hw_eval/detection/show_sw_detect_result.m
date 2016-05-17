sw_align_img_afterbs=bgsubtract(sw_align_img);
sw_window_size=8;
sw_abssum=zeros(1,size(sw_align_img_afterbs,1)-sw_window_size);
for i=1:size(sw_abssum,2)
    sw_abssum(i)=sum(sum(abs(sw_align_img_afterbs(i:i+7,:))));
end
%this script plot the detection simulink output
graph_range=1:2000;
stairs(sw_abssum);
title('windowsum');

