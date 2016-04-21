function img = hbplot_align(adcvals16b,P)
% Process ADC data from ROACH.
% This is a full streaming version of hbplot.m.  Supposedly it should go
% directly into Simulink design.
%
% Returns @lineoffset a column vector describing how much offset each line presents
%  @img the image matrix

% The period @P is not necesarily integer.  So scan line has to be formed
% with a bit of hack
%
% data input are in 16 byte blocks, just like the one on ROACH
periodResample = floor(P);
% The magic number P for our 4GSPS experiment seems to be around 344.403135

numObjs = 0;
objs(1,:)=[0 0 0 0];


%% Quick hack to center the channel info
% by finding one like in threshold, and then skipping periodResample - 1 blocks
startBlk = 1;
while (startBlk < length(adcvals16b))
    b = adcvals16b(startBlk,:);
    th = 10;
    b_th = bsxfun(@gt,b,th);
    if (sum(b_th) > 5)
        startBlk = startBlk + floor(periodResample / 2);
        break;
    end
    startBlk = startBlk + 1;
end
startBlk = max(startBlk - 5,0);
fprintf('Start block at %d\n', startBlk);

%% Resample input into lines.
% Each line will contain b_per_line 16 data blocks.  But since
% periodResample is not necessarily a multiple of 16, there will be
% misaligned blocks at the end.  To handle that, the remaining data of a
% line is dropped.  Also, the fractional ratio between signal period and
% resample preriod will be handled here using similar logic as method 4 in
% hplot.m.
blk_per_line = floor(periodResample / 16);

% The following is mimicking the work of a pipelined hardware
% Each cycle: 1 new block from input (blk)
% Depending on the previous line, blk has to be shifted by an amount blksft
% The input blk is connected to 2 sets of ping-poing block registers.
% (Ping-pong of a ping-pong) A+B, and C+D
% Start with A+B, 
% Even number of block blk is shifted by blksft and write to TAIL of B and HEAD
% of A.  Then on next cycle (odd blk), blk is written to TAIL of A and HEAD of
% B.
% At the end of line, the blk is written to TAIL of (A or B), and also
% shifted by a new amount (the new blksft for next line) and write to HEAD of
% C.

% index adcvals16b.  In hw, it will be shifted in.  
%idxblk=1;
idxblk = startBlk;

imgline=1; % index to output image.  In hw, it will simple be shifted out

blksft = 0; % first line block shift = 0
pp_prev = zeros(1,16);
pp_cur = zeros(1,16);
pp_nextcur = zeros(1,16);
blkgap = false;
pre=0; % for fraction calc.  Needed in hw.
numLineSinceLastHack = 0;
while (idxblk + blk_per_line < length(adcvals16b))
    %fprintf('Processig line %d\n', imgline);
    %
    % Begin each line
    %
    % HHH: Hack alert!  We'll never be able to get the exact value of P.
    % As a result, the image will always drift given enough image lines.
    % So hack here:  Let's reset all sub-sample and sub-block alignment
    % after 20000 lines
    if (numLineSinceLastHack > 20000)
        pre=0;
        numLineSinceLastHack = 0;
        disp('Reseting alignment after 20000 lines');
    else
        numLineSinceLastHack = numLineSinceLastHack + 1;
    end
    
    lineoffset(imgline,1) = pre;
    
    % Calculate  block shift of next line, taking into account fractional period of input signal
    % This should be done early in the line even in hardware so that it is
    % ready by the time we reach the end of this line
    % Standard next_blksft
    next_blksft = blksft + (periodResample - (16 * blk_per_line));
    post = P - pre - periodResample;
    if (post > 0)
        % skip 1 more
        next_blksft = next_blksft + 1;
        pre = 1 - post;
    else
        % no need to skip
        pre = - post;
    end
    
    % have extra breathing space
    % e.g. gap of 5, block 16, then next_blkgap if next_blksft = 12, ... 16
    %next_blkgap = (next_blksft > (16 - (periodResample - (16 * blk_per_line))) || blksft == 0);
    next_blkgap = (next_blksft > 16 || blksft == 0);
    next_blksft = mod(next_blksft, 16);
    
    % The following code are mimicking the work of hardware
    blk_offset = 0; % reset blk_offset idx into each block of 1 line, HW counter
    while (blk_offset < blk_per_line)
        blk = adcvals16b(idxblk,:);
        idxblk = idxblk + 1;
        
        pp_nextcur(1:end-next_blksft) = blk(next_blksft+1:end);
        
        % During blkgap, no need to write to output img.  Also, imgline doesn't
        % increase as no new blk is output.
        if (blkgap)
            %fprintf('Processig block gap!\n');
            pp_cur(1:end-blksft) = blk(blksft+1:end);
            pp_prev = zeros(1,16);
            blkgap = false;
        else
            % normal blocks
            if (blksft == 0) % special case, mostly at beginning, or if no fraction
                pp_cur = zeros(1,16);
                pp_prev = blk;
            else
                pp_cur(1:end-blksft) = blk(blksft+1:end);
                pp_prev(end-blksft+1:end) = blk(1:blksft);
            end
            % At this point, each _prev is done, and the _{,next}cur has the
            % HEAD already filled with some materials.
            % In hardware, we probably need another cycle before writing to
            % img
            img(imgline,(blk_offset * 16 + 1):(blk_offset * 16 + 16)) = pp_prev;

            blk_offset = blk_offset + 1;
        end % end if (blkgap)
        % Last block needs to point to pp_nextcur instead
        if (blk_offset == blk_per_line)
            pp_prev = pp_nextcur;
        else
            pp_prev = pp_cur;
        end
    end % end foreach blk_offset

    % update for next line.
    imgline = imgline + 1;
    blksft = next_blksft;
    blkgap = next_blkgap;
end %end of all blocks

end
