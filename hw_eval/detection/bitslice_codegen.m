fid = fopen('slicecode.v','w');

for i=1:16
    fprintf(fid,'BgNoise[(PeriodCounter-1)*16+');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'] <= UpdatedNoise[');
    fprintf(fid,num2str(16*i-1));
    fprintf(fid,':');
    fprintf(fid,num2str(16*(i-1)));

    fprintf(fid,'];\n');
end
%PeriodNoise[16*i +: 16] <= BgNoise[(PeriodCounter-1)*16+i];
%CurNoise[16*i +: 16] <= BgNoise[(PeriodCounter-1)*16+i];
%BgNoise[(PeriodCounter-1)*16+i] <= UpdatedNoise[16*i +: 16];
fclose(fid);
