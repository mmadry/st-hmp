function omp_pooling = omp_pooling_layer1(omp_codes, encoder_first)
% compute pooled sparse codes by spatial pyramid max pooling in the first layer
% written by Liefeng Bo at Intel Corporation on August 2012

if encoder_first.pooling == 1
   omp_pooling.pooling = omp_codes.codes; 
   omp_pooling.height = omp_codes.height;
   omp_pooling.width = omp_codes.width;
else

   py = floor(omp_codes.height/encoder_first.pooling); 
   px = floor(omp_codes.width/encoder_first.pooling); 

   ind_b = []; 
   for i = 1:encoder_first.pooling
       ind_b = [ind_b; (1:encoder_first.pooling)'+(i-1)*omp_codes.height]; 
   end

   % pooling for the smallest
   pooling = sparse(zeros(size(omp_codes.codes,1),px*py)); 

   for i = 1:px
       for j = 1:py
           ind_s = encoder_first.pooling*(j-1)+(i-1)*encoder_first.pooling*omp_codes.height;
           ind_p = ind_b + ind_s;
           pooling(:,(i-1)*py+j) = max(omp_codes.codes(:,ind_p(:)),[],2); 
           % omp_pooling((i-1)*py+j,:) = sqrt(mean(abs(codes).^2, 2));
       end
   end
   omp_pooling.pooling = pooling;
   omp_pooling.height = py;
   omp_pooling.width = px;
end

