abssumimg=zeros(size(align_img,1),size(align_img,2));
for i=1:size(align_img,1)
    for j=1:21
        abssumimg(i,1+(j-1)*16:j*16)=sum(abs(align_img(i,1+(j-1)*16:j*16)));
    end
end
subplot(2,1,1);
image(align_img);
subplot(2,1,2);
image(abssumimg);
