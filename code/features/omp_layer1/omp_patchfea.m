function omp_fea = omp_patchfea(omp_pooling, patchsize)
% generate features on axa patches
% written by Liefeng Bo at Intel Corporation on August 2012

py = size(omp_pooling,1);
px = size(omp_pooling,2);

% patch size
feay = py + 1 - patchsize;
feax = px + 1 - patchsize;
%threshold = 0.0001;

if size(omp_pooling,3) > 1
   codes = im2colstep(omp_pooling, [patchsize patchsize size(omp_pooling,3)], [1 1 1]); 
else
   codes = im2colstep(omp_pooling, [patchsize patchsize], [1 1]); %extracting patches of size patchsize x patchsize and aligning them as vectors
end
%codes = codes./repmat( max( sqrt(sum(codes.^2,1)), threshold ),  size(codes,1), 1);
omp_fea.fea = codes;
omp_fea.height = feay;
omp_fea.width = feax;

