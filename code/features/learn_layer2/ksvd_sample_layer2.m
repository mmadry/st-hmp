function feasample = ksvd_sample_layer2(dic_second, omplayer1, normalizeMagnitude)
% randomly sample pooled sparse codes from the whole pooled sparse code images in the second layer
% written by Liefeng Bo at Intel Corporation on August 2012
% modified by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    added functionality: handling the tactile data format, different types of sampling (uniform, random)

count = 0;
for i = 1:length(omplayer1.omp_pooling) 
    
    omp_pooling=omplayer1.omp_pooling{i};
    omp_pooling.pooling = full(omp_pooling.pooling)';
    omp_pooling.pooling = reshape(omp_pooling.pooling,omp_pooling.height,omp_pooling.width,size(omp_pooling.pooling,2));
    omp_fea = omp_patchfea_layer2(omp_pooling.pooling, dic_second.patchsize, normalizeMagnitude);
    
    if i == 1
      feasample = zeros(size(omp_fea.fea,1), dic_second.samplenum*length(omplayer1.omp_pooling));
    end
  
    feanum = size(omp_fea.fea,2);
    if strcmp(dic_second.samplingType,'uniform') 
      if dic_second.samplenum > feanum 
	itsamp=1:1:feanum;
      else
	itsamp=1:dic_second.windowstep:feanum;
      end
      num=length(itsamp);
    elseif strcmp(dic_second.samplingType,'random') 
      num = min(feanum, dic_second.samplenum);
      itsamp = randsample(feanum, num);
    end
    feasample(:,count+(1:num)) = omp_fea.fea(:,itsamp);

    count = count + num;
end
feasample(:,count+1:end) = [];

