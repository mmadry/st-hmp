function dic = ksvd_learn_layer2(dic_second, omplayer1, normalizeMagnitude)
% K-SVD dictionary learning in the second layer 
% written by Liefeng Bo at Intel Corporation on August 2012

disp('Sampling matrix patches - layer 2 ......');
feasample = ksvd_sample_layer2(dic_second, omplayer1, normalizeMagnitude);

%params.data = feasample.*(dic_second.feacorr*ones(1,size(feasample,2)));
params.data = feasample;
params.Tdata = 1;
params.dictsize = dic_second.dicsize;
params.iternum = 50; %25;
params.memusage = 'high';
dic = ksvd(params,'');


