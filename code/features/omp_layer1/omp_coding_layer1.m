function omp_codes = omp_coding_layer1(im, dic_first, encoder_first)
% compute sparse codes by batch orthogonal matching pursuit in the first layer
% written by Liefeng Bo at Intel Corporation on August 2012

switch encoder_first.coding

    case 'omp'
        % overcomplete basis vectors
        if size(im,3) == 1
           X = im2colstep(im, [dic_first.patchsize dic_first.patchsize], [1 1] );
        else
           X = im2colstep(im, [dic_first.patchsize dic_first.patchsize size(im,3)], [1 1 1] );
        end
        X = remove_dc(X, 'columns');
        DxX = dic_first.dic'*X;
        omp_codes.codes = omp(DxX, dic_first.G, encoder_first.sparsity);
        omp_codes.codes = abs(omp_codes.codes)/sqrt(size(dic_first.dic,1)); 
        omp_codes.height = size(im,1)-dic_first.patchsize+1;
        omp_codes.width = size(im,2)-dic_first.patchsize+1;
 
    case 'omp_sign'
        % overcomplete basis vectors
        if size(im,3) == 1
           X = im2colstep(im, [dic_first.patchsize dic_first.patchsize], [1 1] ); 
        else
           X = im2colstep(im, [dic_first.patchsize dic_first.patchsize size(im,3)], [1 1 1] );
        end
        X = remove_dc(X, 'columns'); 
        DxX = dic_first.dic'*X; 
       
        codes = omp(DxX, dic_first.G, encoder_first.sparsity);
        codes_pos = double(codes > 0);
        codes_neg = double(codes < 0); 
        omp_codes.codes = [codes.*codes_pos; -codes.*codes_neg]; 
        omp_codes.codes = omp_codes.codes/sqrt(size(dic_first.dic,1)); 
        omp_codes.height = size(im,1)-dic_first.patchsize+1; 
        omp_codes.width = size(im,2)-dic_first.patchsize+1; 

    otherwise
        disp('unknown type');
end

