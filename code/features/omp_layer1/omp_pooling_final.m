function imfea = omp_pooling_final(omp_fea, encoder_final)
% spatial pyramid max pooling and contrast normalization over the whole images
% written by Liefeng Bo at Intel Corporation on August 2012

% initialize the parameters
feadim = size(omp_fea.fea,1); 
pgrid = encoder_final.pooling(1,:).*encoder_final.pooling(2,:); 
sgrid = sum(pgrid); 

% generate spatial pyramids
[fea_x, fea_y] =  meshgrid(1:omp_fea.width, 1:omp_fea.height); 
fea_x = fea_x(:); 
fea_y = fea_y(:);
ind_sp = logical(zeros(sgrid,omp_fea.width*omp_fea.height)); 
it = 0;

for s = 1:size(encoder_final.pooling,2) 
    wleng = omp_fea.width/encoder_final.pooling(2,s); 
    hleng = omp_fea.height/encoder_final.pooling(1,s); 
    xgrid = ceil(fea_x/wleng);
    ygrid = ceil(fea_y/hleng); 
    allgrid = (ygrid -1 )*encoder_final.pooling(2,s) + xgrid; 
    for t = 1:pgrid(s)
        % finding features localized in the corresponding pyramid grid
        it = it+1;
        ind_sp(it,:) = (allgrid == t);
    end
end

% perform spatial pyramid max pooling
imfea = zeros(sgrid*feadim,1);
for i = 1:size(ind_sp,1)
    ind = ind_sp(i,:);
    if sum(ind)
       imfea((i-1)*feadim+(1:feadim)) = max(omp_fea.fea(:, ind), [], 2);
    else
       imfea((i-1)*feadim+(1:feadim)) = 0;
    end
end
imfea = imfea./(sqrt(sum(imfea.^2))+eps); %normalization

