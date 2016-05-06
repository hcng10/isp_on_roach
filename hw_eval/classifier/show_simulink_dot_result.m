%this script plot the classifier simulink output 
graph_num=2;
graph_range=1:30000;
graph_index=1;
%{
subplot(graph_num,1,graph_index);
stairs(state.Data(graph_range))
title('state');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(rdfifo.Data(graph_range))
title('read fifo control');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(fifoout.Data(graph_range));
title('fifoout');
graph_index=graph_index+1;

subplot(graph_num,1,graph_index);
stairs(localcount.Data(graph_range))
title('localcount');
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
%}

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
