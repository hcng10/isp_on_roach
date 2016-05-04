function [q15, q14, q13, q12, q11, q10, q09, q08, ...
          q07, q06, q05, q04, q03, q02, q01, q00] ...
        = pingpongpang(...
            d15, d14, d13, d12, d11, d10, d09, d08, d07, d06, d05, ...
            d04, d03, d02, d01, d00, ...
            shft, next_shft, eol, blkgap)
    proto = {xlUnsigned, 8, 0};
    persistent ping_i, ping_i = xl_state(zeros(1,16), proto, 16);
    persistent pong_i, pong_i = xl_state(zeros(1,16), proto, 16);
    persistent pang_i, pang_i = xl_state(zeros(1,16), proto, 16);
    persistent eol_p1, eol_p1 = xl_state(false, {xlBoolean});
    persistent pingpong, pingpong = xl_state(true, {xlBoolean});
    % output
    if (pingpong)
        % from ping
        q15 = ping_i(15);
        q14 = ping_i(14);
        q13 = ping_i(13);
        q12 = ping_i(12);
        q11 = ping_i(11);
        q10 = ping_i(10);
        q09 = ping_i( 9);
        q08 = ping_i( 8);
        q07 = ping_i( 7);
        q06 = ping_i( 6);
        q05 = ping_i( 5);
        q04 = ping_i( 4);
        q03 = ping_i( 3);
        q02 = ping_i( 2);
        q01 = ping_i( 1);
        q00 = ping_i( 0);
    else
        % from pong
        q15 = pong_i(15);
        q14 = pong_i(14);
        q13 = pong_i(13);
        q12 = pong_i(12);
        q11 = pong_i(11);
        q10 = pong_i(10);
        q09 = pong_i( 9);
        q08 = pong_i( 8);
        q07 = pong_i( 7);
        q06 = pong_i( 6);
        q05 = pong_i( 5);
        q04 = pong_i( 4);
        q03 = pong_i( 3);
        q02 = pong_i( 2);
        q01 = pong_i( 1);
        q00 = pong_i( 0);
    end
    
    needPang = eol_p1 & ~blkgap;
    
    
    % store input to ping pong
    % special case during eol: the tail of the input should be shifted by
    % next_shft and store to head of the next ping/pong.
    if (pingpong)
        % pong tail, ping head
        switch (double(shft))
          % case 0 is special case.  Instead of sending all to ping, we
          % send all the pong, essentially saying it is shift by 16.
          case 0
            pong_i( 0) = d00;
            pong_i( 1) = d01;
            pong_i( 2) = d02;
            pong_i( 3) = d03;
            pong_i( 4) = d04;
            pong_i( 5) = d05;
            pong_i( 6) = d06;
            pong_i( 7) = d07;
            pong_i( 8) = d08;
            pong_i( 9) = d09;
            pong_i(10) = d10;
            pong_i(11) = d11;
            pong_i(12) = d12;
            pong_i(13) = d13;
            pong_i(14) = d14;
            pong_i(15) = d15;
          case 1
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
                pong_i( 8) = pang_i( 8);
                pong_i( 9) = pang_i( 9);
                pong_i(10) = pang_i(10);
                pong_i(11) = pang_i(11);
                pong_i(12) = pang_i(12);
                pong_i(13) = pang_i(13);
                pong_i(14) = pang_i(14);
            end
            pong_i(15) = d00;
            ping_i( 0) = d01;
            ping_i( 1) = d02;
            ping_i( 2) = d03;
            ping_i( 3) = d04;
            ping_i( 4) = d05;
            ping_i( 5) = d06;
            ping_i( 6) = d07;
            ping_i( 7) = d08;
            ping_i( 8) = d09;
            ping_i( 9) = d10;
            ping_i(10) = d11;
            ping_i(11) = d12;
            ping_i(12) = d13;
            ping_i(13) = d14;
            ping_i(14) = d15;
          case 2
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
                pong_i( 8) = pang_i( 8);
                pong_i( 9) = pang_i( 9);
                pong_i(10) = pang_i(10);
                pong_i(11) = pang_i(11);
                pong_i(12) = pang_i(12);
                pong_i(13) = pang_i(13);
            end
            pong_i(14) = d00;
            pong_i(15) = d01;
            ping_i( 0) = d02;
            ping_i( 1) = d03;
            ping_i( 2) = d04;
            ping_i( 3) = d05;
            ping_i( 4) = d06;
            ping_i( 5) = d07;
            ping_i( 6) = d08;
            ping_i( 7) = d09;
            ping_i( 8) = d10;
            ping_i( 9) = d11;
            ping_i(10) = d12;
            ping_i(11) = d13;
            ping_i(12) = d14;
            ping_i(13) = d15;
          case 3
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
                pong_i( 8) = pang_i( 8);
                pong_i( 9) = pang_i( 9);
                pong_i(10) = pang_i(10);
                pong_i(11) = pang_i(11);
                pong_i(12) = pang_i(12);
            end
            pong_i(13) = d00;
            pong_i(14) = d01;
            pong_i(15) = d02;
            ping_i( 0) = d03;
            ping_i( 1) = d04;
            ping_i( 2) = d05;
            ping_i( 3) = d06;
            ping_i( 4) = d07;
            ping_i( 5) = d08;
            ping_i( 6) = d09;
            ping_i( 7) = d10;
            ping_i( 8) = d11;
            ping_i( 9) = d12;
            ping_i(10) = d13;
            ping_i(11) = d14;
            ping_i(12) = d15;
          case 4
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
                pong_i( 8) = pang_i( 8);
                pong_i( 9) = pang_i( 9);
                pong_i(10) = pang_i(10);
                pong_i(11) = pang_i(11);
            end
            pong_i(12) = d00;
            pong_i(13) = d01;
            pong_i(14) = d02;
            pong_i(15) = d03;
            ping_i( 0) = d04;
            ping_i( 1) = d05;
            ping_i( 2) = d06;
            ping_i( 3) = d07;
            ping_i( 4) = d08;
            ping_i( 5) = d09;
            ping_i( 6) = d10;
            ping_i( 7) = d11;
            ping_i( 8) = d12;
            ping_i( 9) = d13;
            ping_i(10) = d14;
            ping_i(11) = d15;
          case 5  
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
                pong_i( 8) = pang_i( 8);
                pong_i( 9) = pang_i( 9);
                pong_i(10) = pang_i(10);
            end
            pong_i(11) = d00;
            pong_i(12) = d01;
            pong_i(13) = d02;
            pong_i(14) = d03;
            pong_i(15) = d04;
            ping_i( 0) = d05;
            ping_i( 1) = d06;
            ping_i( 2) = d07;
            ping_i( 3) = d08;
            ping_i( 4) = d09;
            ping_i( 5) = d10;
            ping_i( 6) = d11;
            ping_i( 7) = d12;
            ping_i( 8) = d13;
            ping_i( 9) = d14;
            ping_i(10) = d15;
          case 6
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
                pong_i( 8) = pang_i( 8);
                pong_i( 9) = pang_i( 9);
            end
            pong_i(10) = d00;
            pong_i(11) = d01;
            pong_i(12) = d02;
            pong_i(13) = d03;
            pong_i(14) = d04;
            pong_i(15) = d05;
            ping_i( 0) = d06;
            ping_i( 1) = d07;
            ping_i( 2) = d08;
            ping_i( 3) = d09;
            ping_i( 4) = d10;
            ping_i( 5) = d11;
            ping_i( 6) = d12;
            ping_i( 7) = d13;
            ping_i( 8) = d14;
            ping_i( 9) = d15;
          case 7
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
                pong_i( 8) = pang_i( 8);
            end
            pong_i( 9) = d00;
            pong_i(10) = d01;
            pong_i(11) = d02;
            pong_i(12) = d03;
            pong_i(13) = d04;
            pong_i(14) = d05;
            pong_i(15) = d06;
            ping_i( 0) = d07;
            ping_i( 1) = d08;
            ping_i( 2) = d09;
            ping_i( 3) = d10;
            ping_i( 4) = d11;
            ping_i( 5) = d12;
            ping_i( 6) = d13;
            ping_i( 7) = d14;
            ping_i( 8) = d15;
          case 8
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
                pong_i( 7) = pang_i( 7);
            end
            pong_i( 8) = d00;
            pong_i( 9) = d01;
            pong_i(10) = d02;
            pong_i(11) = d03;
            pong_i(12) = d04;
            pong_i(13) = d05;
            pong_i(14) = d06;
            pong_i(15) = d07;
            ping_i( 0) = d08;
            ping_i( 1) = d09;
            ping_i( 2) = d10;
            ping_i( 3) = d11;
            ping_i( 4) = d12;
            ping_i( 5) = d13;
            ping_i( 6) = d14;
            ping_i( 7) = d15;
          case 9
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
                pong_i( 6) = pang_i( 6);
            end
            pong_i( 7) = d00;
            pong_i( 8) = d01;
            pong_i( 9) = d02;
            pong_i(10) = d03;
            pong_i(11) = d04;
            pong_i(12) = d05;
            pong_i(13) = d06;
            pong_i(14) = d07;
            pong_i(15) = d08;
            ping_i( 0) = d09;
            ping_i( 1) = d10;
            ping_i( 2) = d11;
            ping_i( 3) = d12;
            ping_i( 4) = d13;
            ping_i( 5) = d14;
            ping_i( 6) = d15;
          case 10
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
                pong_i( 5) = pang_i( 5);
            end
            pong_i( 6) = d00;
            pong_i( 7) = d01;
            pong_i( 8) = d02;
            pong_i( 9) = d03;
            pong_i(10) = d04;
            pong_i(11) = d05;
            pong_i(12) = d06;
            pong_i(13) = d07;
            pong_i(14) = d08;
            pong_i(15) = d09;
            ping_i( 0) = d10;
            ping_i( 1) = d11;
            ping_i( 2) = d12;
            ping_i( 3) = d13;
            ping_i( 4) = d14;
            ping_i( 5) = d15;
          case 11
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
                pong_i( 4) = pang_i( 4);
            end
            pong_i( 5) = d00;
            pong_i( 6) = d01;
            pong_i( 7) = d02;
            pong_i( 8) = d03;
            pong_i( 9) = d04;
            pong_i(10) = d05;
            pong_i(11) = d06;
            pong_i(12) = d07;
            pong_i(13) = d08;
            pong_i(14) = d09;
            pong_i(15) = d10;
            ping_i( 0) = d11;
            ping_i( 1) = d12;
            ping_i( 2) = d13;
            ping_i( 3) = d14;
            ping_i( 4) = d15;
          case 12
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
                pong_i( 3) = pang_i( 3);
            end
            pong_i( 4) = d00;
            pong_i( 5) = d01;
            pong_i( 6) = d02;
            pong_i( 7) = d03;
            pong_i( 8) = d04;
            pong_i( 9) = d05;
            pong_i(10) = d06;
            pong_i(11) = d07;
            pong_i(12) = d08;
            pong_i(13) = d09;
            pong_i(14) = d10;
            pong_i(15) = d11;
            ping_i( 0) = d12;
            ping_i( 1) = d13;
            ping_i( 2) = d14;
            ping_i( 3) = d15;
          case 13
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
                pong_i( 2) = pang_i( 2);
            end
            pong_i( 3) = d00;
            pong_i( 4) = d01;
            pong_i( 5) = d02;
            pong_i( 6) = d03;
            pong_i( 7) = d04;
            pong_i( 8) = d05;
            pong_i( 9) = d06;
            pong_i(10) = d07;
            pong_i(11) = d08;
            pong_i(12) = d09;
            pong_i(13) = d10;
            pong_i(14) = d11;
            pong_i(15) = d12;
            ping_i( 0) = d13;
            ping_i( 1) = d14;
            ping_i( 2) = d15;
          case 14
            if (needPang)
                pong_i( 0) = pang_i( 0);
                pong_i( 1) = pang_i( 1);
            end
            pong_i( 2) = d00;
            pong_i( 3) = d01;
            pong_i( 4) = d02;
            pong_i( 5) = d03;
            pong_i( 6) = d04;
            pong_i( 7) = d05;
            pong_i( 8) = d06;
            pong_i( 9) = d07;
            pong_i(10) = d08;
            pong_i(11) = d09;
            pong_i(12) = d10;
            pong_i(13) = d11;
            pong_i(14) = d12;
            pong_i(15) = d13;
            ping_i( 0) = d14;
            ping_i( 1) = d15;
          case 15
            if (needPang)
                pong_i( 0) = pang_i( 0);
            end
            pong_i( 1) = d00;
            pong_i( 2) = d01;
            pong_i( 3) = d02;
            pong_i( 4) = d03;
            pong_i( 5) = d04;
            pong_i( 6) = d05;
            pong_i( 7) = d06;
            pong_i( 8) = d07;
            pong_i( 9) = d08;
            pong_i(10) = d09;
            pong_i(11) = d10;
            pong_i(12) = d11;
            pong_i(13) = d12;
            pong_i(14) = d13;
            pong_i(15) = d14;
            ping_i( 0) = d15;
        end
    else
        % is pong now, so write to tail of ping, head of pong
        switch (double(shft))
          % case 0 is special case.  Instead of sending all to ping, we
          % send all the pong, essentially saying it is shift by 16.
          case 0
            ping_i( 0) = d00;
            ping_i( 1) = d01;
            ping_i( 2) = d02;
            ping_i( 3) = d03;
            ping_i( 4) = d04;
            ping_i( 5) = d05;
            ping_i( 6) = d06;
            ping_i( 7) = d07;
            ping_i( 8) = d08;
            ping_i( 9) = d09;
            ping_i(10) = d10;
            ping_i(11) = d11;
            ping_i(12) = d12;
            ping_i(13) = d13;
            ping_i(14) = d14;
            ping_i(15) = d15;
          case 1
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
                ping_i( 8) = pang_i( 8);
                ping_i( 9) = pang_i( 9);
                ping_i(10) = pang_i(10);
                ping_i(11) = pang_i(11);
                ping_i(12) = pang_i(12);
                ping_i(13) = pang_i(13);
                ping_i(14) = pang_i(14);
            end
            ping_i(15) = d00;
            pong_i( 0) = d01;
            pong_i( 1) = d02;
            pong_i( 2) = d03;
            pong_i( 3) = d04;
            pong_i( 4) = d05;
            pong_i( 5) = d06;
            pong_i( 6) = d07;
            pong_i( 7) = d08;
            pong_i( 8) = d09;
            pong_i( 9) = d10;
            pong_i(10) = d11;
            pong_i(11) = d12;
            pong_i(12) = d13;
            pong_i(13) = d14;
            pong_i(14) = d15;
          case 2
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
                ping_i( 8) = pang_i( 8);
                ping_i( 9) = pang_i( 9);
                ping_i(10) = pang_i(10);
                ping_i(11) = pang_i(11);
                ping_i(12) = pang_i(12);
                ping_i(13) = pang_i(13);
            end
            ping_i(14) = d00;
            ping_i(15) = d01;
            pong_i( 0) = d02;
            pong_i( 1) = d03;
            pong_i( 2) = d04;
            pong_i( 3) = d05;
            pong_i( 4) = d06;
            pong_i( 5) = d07;
            pong_i( 6) = d08;
            pong_i( 7) = d09;
            pong_i( 8) = d10;
            pong_i( 9) = d11;
            pong_i(10) = d12;
            pong_i(11) = d13;
            pong_i(12) = d14;
            pong_i(13) = d15;
          case 3
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
                ping_i( 8) = pang_i( 8);
                ping_i( 9) = pang_i( 9);
                ping_i(10) = pang_i(10);
                ping_i(11) = pang_i(11);
                ping_i(12) = pang_i(12);
            end
            ping_i(13) = d00;
            ping_i(14) = d01;
            ping_i(15) = d02;
            pong_i( 0) = d03;
            pong_i( 1) = d04;
            pong_i( 2) = d05;
            pong_i( 3) = d06;
            pong_i( 4) = d07;
            pong_i( 5) = d08;
            pong_i( 6) = d09;
            pong_i( 7) = d10;
            pong_i( 8) = d11;
            pong_i( 9) = d12;
            pong_i(10) = d13;
            pong_i(11) = d14;
            pong_i(12) = d15;
          case 4
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
                ping_i( 8) = pang_i( 8);
                ping_i( 9) = pang_i( 9);
                ping_i(10) = pang_i(10);
                ping_i(11) = pang_i(11);
            end
            ping_i(12) = d00;
            ping_i(13) = d01;
            ping_i(14) = d02;
            ping_i(15) = d03;
            pong_i( 0) = d04;
            pong_i( 1) = d05;
            pong_i( 2) = d06;
            pong_i( 3) = d07;
            pong_i( 4) = d08;
            pong_i( 5) = d09;
            pong_i( 6) = d10;
            pong_i( 7) = d11;
            pong_i( 8) = d12;
            pong_i( 9) = d13;
            pong_i(10) = d14;
            pong_i(11) = d15;
          case 5  
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
                ping_i( 8) = pang_i( 8);
                ping_i( 9) = pang_i( 9);
                ping_i(10) = pang_i(10);
            end
            ping_i(11) = d00;
            ping_i(12) = d01;
            ping_i(13) = d02;
            ping_i(14) = d03;
            ping_i(15) = d04;
            pong_i( 0) = d05;
            pong_i( 1) = d06;
            pong_i( 2) = d07;
            pong_i( 3) = d08;
            pong_i( 4) = d09;
            pong_i( 5) = d10;
            pong_i( 6) = d11;
            pong_i( 7) = d12;
            pong_i( 8) = d13;
            pong_i( 9) = d14;
            pong_i(10) = d15;
          case 6
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
                ping_i( 8) = pang_i( 8);
                ping_i( 9) = pang_i( 9);
            end
            ping_i(10) = d00;
            ping_i(11) = d01;
            ping_i(12) = d02;
            ping_i(13) = d03;
            ping_i(14) = d04;
            ping_i(15) = d05;
            pong_i( 0) = d06;
            pong_i( 1) = d07;
            pong_i( 2) = d08;
            pong_i( 3) = d09;
            pong_i( 4) = d10;
            pong_i( 5) = d11;
            pong_i( 6) = d12;
            pong_i( 7) = d13;
            pong_i( 8) = d14;
            pong_i( 9) = d15;
          case 7
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
                ping_i( 8) = pang_i( 8);
            end
            ping_i( 9) = d00;
            ping_i(10) = d01;
            ping_i(11) = d02;
            ping_i(12) = d03;
            ping_i(13) = d04;
            ping_i(14) = d05;
            ping_i(15) = d06;
            pong_i( 0) = d07;
            pong_i( 1) = d08;
            pong_i( 2) = d09;
            pong_i( 3) = d10;
            pong_i( 4) = d11;
            pong_i( 5) = d12;
            pong_i( 6) = d13;
            pong_i( 7) = d14;
            pong_i( 8) = d15;
          case 8
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
                ping_i( 7) = pang_i( 7);
            end
            ping_i( 8) = d00;
            ping_i( 9) = d01;
            ping_i(10) = d02;
            ping_i(11) = d03;
            ping_i(12) = d04;
            ping_i(13) = d05;
            ping_i(14) = d06;
            ping_i(15) = d07;
            pong_i( 0) = d08;
            pong_i( 1) = d09;
            pong_i( 2) = d10;
            pong_i( 3) = d11;
            pong_i( 4) = d12;
            pong_i( 5) = d13;
            pong_i( 6) = d14;
            pong_i( 7) = d15;
          case 9
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
                ping_i( 6) = pang_i( 6);
            end
            ping_i( 7) = d00;
            ping_i( 8) = d01;
            ping_i( 9) = d02;
            ping_i(10) = d03;
            ping_i(11) = d04;
            ping_i(12) = d05;
            ping_i(13) = d06;
            ping_i(14) = d07;
            ping_i(15) = d08;
            pong_i( 0) = d09;
            pong_i( 1) = d10;
            pong_i( 2) = d11;
            pong_i( 3) = d12;
            pong_i( 4) = d13;
            pong_i( 5) = d14;
            pong_i( 6) = d15;
          case 10
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
                ping_i( 5) = pang_i( 5);
            end
            ping_i( 6) = d00;
            ping_i( 7) = d01;
            ping_i( 8) = d02;
            ping_i( 9) = d03;
            ping_i(10) = d04;
            ping_i(11) = d05;
            ping_i(12) = d06;
            ping_i(13) = d07;
            ping_i(14) = d08;
            ping_i(15) = d09;
            pong_i( 0) = d10;
            pong_i( 1) = d11;
            pong_i( 2) = d12;
            pong_i( 3) = d13;
            pong_i( 4) = d14;
            pong_i( 5) = d15;
          case 11
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
                ping_i( 4) = pang_i( 4);
            end
            ping_i( 5) = d00;
            ping_i( 6) = d01;
            ping_i( 7) = d02;
            ping_i( 8) = d03;
            ping_i( 9) = d04;
            ping_i(10) = d05;
            ping_i(11) = d06;
            ping_i(12) = d07;
            ping_i(13) = d08;
            ping_i(14) = d09;
            ping_i(15) = d10;
            pong_i( 0) = d11;
            pong_i( 1) = d12;
            pong_i( 2) = d13;
            pong_i( 3) = d14;
            pong_i( 4) = d15;
          case 12
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
                ping_i( 3) = pang_i( 3);
            end
            ping_i( 4) = d00;
            ping_i( 5) = d01;
            ping_i( 6) = d02;
            ping_i( 7) = d03;
            ping_i( 8) = d04;
            ping_i( 9) = d05;
            ping_i(10) = d06;
            ping_i(11) = d07;
            ping_i(12) = d08;
            ping_i(13) = d09;
            ping_i(14) = d10;
            ping_i(15) = d11;
            pong_i( 0) = d12;
            pong_i( 1) = d13;
            pong_i( 2) = d14;
            pong_i( 3) = d15;
          case 13
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
                ping_i( 2) = pang_i( 2);
            end
            ping_i( 3) = d00;
            ping_i( 4) = d01;
            ping_i( 5) = d02;
            ping_i( 6) = d03;
            ping_i( 7) = d04;
            ping_i( 8) = d05;
            ping_i( 9) = d06;
            ping_i(10) = d07;
            ping_i(11) = d08;
            ping_i(12) = d09;
            ping_i(13) = d10;
            ping_i(14) = d11;
            ping_i(15) = d12;
            pong_i( 0) = d13;
            pong_i( 1) = d14;
            pong_i( 2) = d15;
          case 14
            if (needPang)
                ping_i( 0) = pang_i( 0);
                ping_i( 1) = pang_i( 1);
            end
            ping_i( 2) = d00;
            ping_i( 3) = d01;
            ping_i( 4) = d02;
            ping_i( 5) = d03;
            ping_i( 6) = d04;
            ping_i( 7) = d05;
            ping_i( 8) = d06;
            ping_i( 9) = d07;
            ping_i(10) = d08;
            ping_i(11) = d09;
            ping_i(12) = d10;
            ping_i(13) = d11;
            ping_i(14) = d12;
            ping_i(15) = d13;
            pong_i( 0) = d14;
            pong_i( 1) = d15;
          case 15
            if (needPang)
                ping_i( 0) = pang_i( 0);
            end
            ping_i( 1) = d00;
            ping_i( 2) = d01;
            ping_i( 3) = d02;
            ping_i( 4) = d03;
            ping_i( 5) = d04;
            ping_i( 6) = d05;
            ping_i( 7) = d06;
            ping_i( 8) = d07;
            ping_i( 9) = d08;
            ping_i(10) = d09;
            ping_i(11) = d10;
            ping_i(12) = d11;
            ping_i(13) = d12;
            ping_i(14) = d13;
            ping_i(15) = d14;
            pong_i( 0) = d15;
        end
    end
    
    % save eol, we always act on eol plus 1 cycle (needPang)
    eol_p1 = eol;
    
    % store addition pang buffer, which depends solely on next_shft
    switch (double(next_shft))
      case 0
        pang_i( 0) = d00;
        pang_i( 1) = d01;
        pang_i( 2) = d02;
        pang_i( 3) = d03;
        pang_i( 4) = d04;
        pang_i( 5) = d05;
        pang_i( 6) = d06;
        pang_i( 7) = d07;
        pang_i( 8) = d08;
        pang_i( 9) = d09;
        pang_i(10) = d10;
        pang_i(11) = d11;
        pang_i(12) = d12;
        pang_i(13) = d13;
        pang_i(14) = d14;
        pang_i(15) = d15;
      case 1
        pang_i( 0) = d01;
        pang_i( 1) = d02;
        pang_i( 2) = d03;
        pang_i( 3) = d04;
        pang_i( 4) = d05;
        pang_i( 5) = d06;
        pang_i( 6) = d07;
        pang_i( 7) = d08;
        pang_i( 8) = d09;
        pang_i( 9) = d10;
        pang_i(10) = d11;
        pang_i(11) = d12;
        pang_i(12) = d13;
        pang_i(13) = d14;
        pang_i(14) = d15;
      case 2
        pang_i( 0) = d02;
        pang_i( 1) = d03;
        pang_i( 2) = d04;
        pang_i( 3) = d05;
        pang_i( 4) = d06;
        pang_i( 5) = d07;
        pang_i( 6) = d08;
        pang_i( 7) = d09;
        pang_i( 8) = d10;
        pang_i( 9) = d11;
        pang_i(10) = d12;
        pang_i(11) = d13;
        pang_i(12) = d14;
        pang_i(13) = d15;
      case 3
        pang_i( 0) = d03;
        pang_i( 1) = d04;
        pang_i( 2) = d05;
        pang_i( 3) = d06;
        pang_i( 4) = d07;
        pang_i( 5) = d08;
        pang_i( 6) = d09;
        pang_i( 7) = d10;
        pang_i( 8) = d11;
        pang_i( 9) = d12;
        pang_i(10) = d13;
        pang_i(11) = d14;
        pang_i(12) = d15;
      case 4
        pang_i( 0) = d04;
        pang_i( 1) = d05;
        pang_i( 2) = d06;
        pang_i( 3) = d07;
        pang_i( 4) = d08;
        pang_i( 5) = d09;
        pang_i( 6) = d10;
        pang_i( 7) = d11;
        pang_i( 8) = d12;
        pang_i( 9) = d13;
        pang_i(10) = d14;
        pang_i(11) = d15;
      case 5
        pang_i( 0) = d05;
        pang_i( 1) = d06;
        pang_i( 2) = d07;
        pang_i( 3) = d08;
        pang_i( 4) = d09;
        pang_i( 5) = d10;
        pang_i( 6) = d11;
        pang_i( 7) = d12;
        pang_i( 8) = d13;
        pang_i( 9) = d14;
        pang_i(10) = d15;
      case 6
        pang_i( 0) = d06;
        pang_i( 1) = d07;
        pang_i( 2) = d08;
        pang_i( 3) = d09;
        pang_i( 4) = d10;
        pang_i( 5) = d11;
        pang_i( 6) = d12;
        pang_i( 7) = d13;
        pang_i( 8) = d14;
        pang_i( 9) = d15;
      case 7
        pang_i( 0) = d07;
        pang_i( 1) = d08;
        pang_i( 2) = d09;
        pang_i( 3) = d10;
        pang_i( 4) = d11;
        pang_i( 5) = d12;
        pang_i( 6) = d13;
        pang_i( 7) = d14;
        pang_i( 8) = d15;
      case 8
        pang_i( 0) = d08;
        pang_i( 1) = d09;
        pang_i( 2) = d10;
        pang_i( 3) = d11;
        pang_i( 4) = d12;
        pang_i( 5) = d13;
        pang_i( 6) = d14;
        pang_i( 7) = d15;
      case 9
        pang_i( 0) = d09;
        pang_i( 1) = d10;
        pang_i( 2) = d11;
        pang_i( 3) = d12;
        pang_i( 4) = d13;
        pang_i( 5) = d14;
        pang_i( 6) = d15;
      case 10
        pang_i( 0) = d10;
        pang_i( 1) = d11;
        pang_i( 2) = d12;
        pang_i( 3) = d13;
        pang_i( 4) = d14;
        pang_i( 5) = d15;
      case 11
        pang_i( 0) = d11;
        pang_i( 1) = d12;
        pang_i( 2) = d13;
        pang_i( 3) = d14;
        pang_i( 4) = d15;
      case 12
        pang_i( 0) = d12;
        pang_i( 1) = d13;
        pang_i( 2) = d14;
        pang_i( 3) = d15;
      case 13
        pang_i( 0) = d13;
        pang_i( 1) = d14;
        pang_i( 2) = d15;
      case 14
        pang_i( 0) = d14;
        pang_i( 1) = d15;
      case 15
        pang_i( 0) = d15;
    end


% 
%     disp('pingpong =');
%     disp(pingpong);
%     disp('ping_i is:');
%     disp(ping_i);
%     disp('pong_i is:');
%     disp(pong_i);
    
    % update ping pong
    pingpong = ~pingpong;
end

