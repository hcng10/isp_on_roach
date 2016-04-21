function img=blktoimage(blkword,blk_ready)
%this function read the block image output and display it
%first convert the 128bit word array to pixel array
blk_per_line=21;
blkword_filter=fi(zeros(sum(blk_ready==1),1),0,128,0);
index=1;
for i=1:size(blk_ready,1)
    if blk_ready(i)==1
        blkword_filter(index)=blkword(i);
        index=index+1;
    end
end

blkbyte=zeros(size(blkword_filter,1)*16,1);
blkbin=blkword_filter.bin;
for i=1:size(blkword_filter,1)
    for j=1:16
        k=16-j+1;
        blkbyte((i-1)*16+k)=bin2dec(blkbin(i,((j-1)*8+1):j*8));
    end
end
%strip_index=floor(size(blkbyte)/(16*blk_per_line))*16*blk_per_line;
%blkbyte=blkbyte(1:strip_index);
img=vec2mat(blkbyte,16*blk_per_line);
