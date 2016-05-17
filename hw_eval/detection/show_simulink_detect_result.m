%this script plot the detection simulink output 
graph_num=3;
graph_range=1:100000;

graph_index=1;

subplot(graph_num,1,graph_index);
stairs(state.Data(graph_range))
title('state');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(windowsum.Data(graph_range))
title('windowsum');
graph_index=graph_index+1;

detect_img=align2image(detect_data.Data,data_empty.Data);
subplot(graph_num,1,graph_index);
image(detect_img);
title('detect object');
graph_index=graph_index+1;


%{

subplot(graph_num,1,graph_index);
stairs(linecounter.Data(graph_range))
title('linecount');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(periodcounter.Data(graph_range))
title('periodcount');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(fifoout.Data(graph_range));
title('');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(mulud.Data(graph_range))
title('data in');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(romin.Data(graph_range))
title('rom in');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
romout_convert=fi(romout.Data,1,32,16);
romout_convert.hex=dec2hex(romout.Data);
stairs(romout_convert(graph_range));
title('weight');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
acc_convert=fi(acc.Data,1,32,16);
acc_convert.hex=dec2hex(acc.Data);
stairs(acc_convert(graph_range));
title('acc');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(typeready.Data(graph_range))
title('type ready');
graph_index=graph_index+1;
%}
