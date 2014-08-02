function omplayer2 = omp_pooling_layer2_batch(dic_second, encoder_second, omplayer1, normalizeMagnitude)
% batch orthogonal matching pursuit and spatial pyramid max pooling in the second layer
% written by Liefeng Bo at Intel Corporation on August 2012
% modified by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    added functionality: optional magnitude normalization 

disp('Batch orthogonal matching pursuit  - layer 2 ...');
nfea_second = length(omplayer1.omp_pooling);

% set the parameters
datasize = nfea_second; 
wordsnum = size(dic_second.dic, 2);
pgrid = encoder_second.pooling.^2;
sgrid = sum(pgrid);
dic_second.G = dic_second.dic'*dic_second.dic;

% for each matrix path
for i = 1:nfea_second 
    omp_pooling=omplayer1.omp_pooling{i};
    omp_pooling.pooling = full(omp_pooling.pooling)';
    omp_pooling.pooling = reshape(omp_pooling.pooling,omp_pooling.height,omp_pooling.width,size(omp_pooling.pooling,2));
    omp_fea = omp_patchfea_layer2(omp_pooling.pooling, dic_second.patchsize,normalizeMagnitude);
    omp_codes = omp_coding_layer2(omp_fea, dic_second, encoder_second);
    omplayer2.omp_pooling{i}(:,:,:) = omp_pooling_layer2(omp_codes, encoder_second); 
end


