function show_line_sum(align_img)
row_sum=sum(abs(align_img),2);
row_sum=flipud(row_sum);
column_sum=sum(abs(align_img),1);

subplot(2,2,1);
image(align_img);

subplot(2,2,2);
plot(row_sum);
view(-90,90);
xlim([0 size(align_img,1)]);

subplot(2,2,3);
plot(column_sum);
xlim([0 size(align_img,2)]);
