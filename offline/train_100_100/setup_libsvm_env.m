%path for SVM Matlab library
function setup_libsvm_env(hostname)
if strcmp(hostname,'kona')
    addpath('/vol/tools/Mathworks/Matlab/R2012b/toolbox/libsvm-3.20/matlab');
elseif strcmp(hostname,'labpc')
    addpath('D:\program\libsvm\matlab');
else
    fprintf('unknown host name %s\n',hostname)
end
