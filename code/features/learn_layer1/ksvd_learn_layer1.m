function [dic, data] = ksvd_learn_layer1(fea_first, dic_first, iternum)
% K-SVD dictionary learning in the first layer 
% written by Liefeng Bo at Intel Corporation on August 2012

p = 2; % two-dimensional images
params.blocksize = dic_first.patchsize;
params.dictsize = dic_first.dicsize;
params.Tdata = 4; % sparsity level
% params.Edata = 1;
% params.exact = 1;
params.iternum = iternum; %300; % 50
params.memusage = 'high';
[data, channel] = ksvd_sample_layer1(fea_first, dic_first);
if isfield(dic_first,'dct')
   if channel == 1
      data = dic_first.dct'*data;
   else
      clen = size(data,1)/3;
      cind = 1:clen;
      data = [dic_first.dct'*data(cind,:); dic_first.dct'*data(clen+cind,:); dic_first.dct'*data(2*clen+cind,:)];
   end
else
   params.initdict = odctndict_multi(params.blocksize, params.dictsize, p, channel);
end
params.data = data;
params.trainnum = size(params.data,2);

% K-SVD
disp('K-SVD training...');
dic = ksvd(params);

