function img=blktoimage(blkword,blk_empty)
%this function read the block image output and display it
%first convert the 128bit word array to pixel array
blk_per_line=21;
blkword_filter=fi(zeros(sum(blk_empty==0),1),0,128,0);
index=1;
for i=1:size(blk_empty,1)
    if blk_empty(i)==0
        blkword_filter(index)=blkword(i);
        index=index+1;
    end
end

%use to transfer the data from uint8 to signed int 8
%the original data is signed int 8
%innput into simulink become uint 8
%so finial need to transfer it back to signed int 8 
%then it's the same 
unsign2sign_tmp=fi(0,1,8,0);

blkbyte=zeros(size(blkword_filter,1)*16,1);
blkbin=blkword_filter.bin;
for i=1:size(blkword_filter,1)
    for j=1:16
        k=16-j+1;
        %re-interpret the data from uint8 to signed int 8
        unsign2sign_tmp.bin=blkbin(i,((j-1)*8+1):j*8);
        blkbyte((i-1)*16+k)=unsign2sign_tmp;
    end
end
strip_index=floor(size(blkbyte)/(16*blk_per_line))*16*blk_per_line;
blkbyte=blkbyte(1:strip_index);
img=vec2mat(blkbyte,16*blk_per_line);
