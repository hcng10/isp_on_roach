%this script plot the classifier simulink output 
acc_convert=fi(acc.Data,1,32,16);
acc_convert.hex=dec2hex(acc.Data);
plot(acc_convert);
