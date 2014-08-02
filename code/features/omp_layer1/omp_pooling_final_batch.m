function imfea = omp_pooling_final_batch(fea_final, encoder_final)
% generate image-level features via spatial pyramid max pooling and contrast normalization
% written by Liefeng Bo at Intel Corporation on August 2012
% modified by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    added functionality: handling the tactile data format

datasize = length(fea_final.mat{1}.im);

if size(encoder_final.pooling,1) == 1
   encoder_final.pooling = [encoder_final.pooling; encoder_final.pooling];
end
pgrid = encoder_final.pooling(1,:).*encoder_final.pooling(2,:);
sgrid = sum(pgrid);

% generate image-level features
for i = 1:datasize 
    omp_pooling=omplayer1.omp_pooling{i};
    omp_pooling.pooling = full(omp_pooling.pooling)';
    omp_pooling.pooling = reshape(omp_pooling.pooling,omp_pooling.height,omp_pooling.width,size(omp_pooling.pooling,2));
    omp_fea = omp_patchfea(omp_pooling.pooling, encoder_final.patchsize);
    if i == 1
       imfea = zeros(sgrid*size(omp_fea.fea,1),datasize);
    end
    imfea(:,i) = omp_pooling_final(omp_fea, encoder_final);
end

