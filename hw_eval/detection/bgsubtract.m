function imgsub = bgsubtract(img)
% background substraction
% Method 1:
% On matlab, the simplest way is to
% subtract mean (or median) from each column to reduce noise
% imgsub = bsxfun(@minus,img, median(img));

% Method 2:
% On hardware, use an average of 8 sampled lines
bg = img(1,:);
for i=2:7
    bg = bg + img(i,:);
end
bg = bg / 8;
imgsub = bsxfun(@minus,img, bg);

%{
%scale to color map
minV = min(min(imgsub));
maxV = max(max(imgsub));
rangeV = maxV - minV;
thismap = colormap();
maxcol = size(thismap, 1) - 1;
scaledimg = uint8(floor((imgsub - minV) ./ rangeV .* maxcol));
img= ind2rgb(scaledimg, gray);
%}
end
