if exist('align_img')==0
    align_img=blktoimage(align_blk,blk_ready);
end
align_width=size(align_img,2);
align_height=size(align_img,1);
img_buf1=align_img(2:align_height-1,:);
img_buf2=align_img(1:align_height-2,:);
align_img_diff=img_buf1-img_buf2;
line_err_sum=sum(align_img_diff,2);
