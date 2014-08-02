function imfea = omp_pooling_final_batch_float_single(encoder_final, omplayer) 
% function imfea = omp_pooling_final_batch_float_single(fea_final, encoder_final, omplayer) 
% generate image-level features via spatial pyramid max pooling and contrast normalization
% written by Liefeng Bo on August 2012

datasize = length(omplayer.omp_pooling);

if size(encoder_final.pooling,1) == 1
   encoder_final.pooling = [encoder_final.pooling; encoder_final.pooling]; 
end
pgrid = encoder_final.pooling(1,:).*encoder_final.pooling(2,:); 
sgrid = sum(pgrid); 

% each image path
for i = 1:datasize 
    omp_pooling=omplayer.omp_pooling{i}; 
    omp_pooling.pooling = full(omp_pooling.pooling)'; 
    omp_pooling.pooling = reshape(omp_pooling.pooling,omp_pooling.height,omp_pooling.width,size(omp_pooling.pooling,2));
    omp_fea = omp_patchfea(omp_pooling.pooling, encoder_final.patchsize); 
        
    if i == 1
       imfea = zeros(sgrid*size(omp_fea.fea,1),datasize,'single');
    end
    imfea_one = omp_pooling_final(omp_fea, encoder_final);
    imfea(:,i) = single(imfea_one);
end

