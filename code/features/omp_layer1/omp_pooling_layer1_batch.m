function omplayer1=omp_pooling_layer1_batch(fea_first, dic_first, encoder_first)
% batch orthogonal matching pursuit and spatial pyramid max pooling in the first layer
% written by Liefeng Bo at Intel Corporation on August 2012
% modified by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    added functionality: handling the tactile data format

datasize = length(fea_first.mat{1}.im);

disp('Batch orthogonal matching pursuit  - layer 1 ...');
dic_first.G = dic_first.dic'*dic_first.dic;
for i = 1:datasize 
    
    im = fea_first.mat{fea_first.type}.im{i};
        
    % resize matrices
    im_h = size(im,1);
    im_w = size(im,2);
    if isfield(fea_first,'maxsize')
       if fea_first.maxsize <= 0
          ;
       else
          im = imresize(im, fea_first.maxsize/max(im_h, im_w), 'bicubic');
       end
    end
    if isfield(fea_first,'minsize')
       if fea_first.minsize <= 0
          ;
       else
          im = imresize(im, fea_first.minsize/min(im_h, im_w), 'bicubic');
       end
    end
    
    %Batch Orthogonal Matching Pursuit    
    omp_codes = omp_coding_layer1(im, dic_first, encoder_first); 
    omp_pooling = omp_pooling_layer1(omp_codes, encoder_first);
    omplayer1.omp_pooling{i}=omp_pooling;
end
%  disp(['DONE']);



