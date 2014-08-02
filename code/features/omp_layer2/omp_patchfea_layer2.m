function omp_fea = omp_patchfea_layer2(omp_pooling, patchsize, normalizeMagnitude);
% generate features on small patches
% written by Liefeng Bo at Intel Corporation on August 2012
% modified by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    added functionality: optional magnitude normalization

py = size(omp_pooling,1);
px = size(omp_pooling,2);
 
% patch size
feay = py + 1 - patchsize;
feax = px + 1 - patchsize;
threshold = 0.1;

if sum(patchsize > size(omp_pooling))>0
  error(['Too large value of L2.patchsize. Max possible value for the given input matrices is L2.patchsize = ',num2str(min(size(omp_pooling)))]);
end

if size(omp_pooling,3) > 1
   codes = im2colstep(omp_pooling, [patchsize patchsize size(omp_pooling,3)], [1 1 1]);
else
   codes = im2colstep(omp_pooling, [patchsize patchsize], [1 1]);
end 

% Normalization of the signal magnitude
if normalizeMagnitude
  codes = codes./repmat( max( sqrt(sum(codes.^2,1)), threshold ),  size(codes,1), 1);
end
omp_fea.fea = codes;
omp_fea.height = feay;
omp_fea.width = feax;

