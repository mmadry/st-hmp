function omp_codes = omp_coding_layer2(omp_fea, dic_second, encoder_second)
% batch orthogonal matching pursuit in the second layer
% written by Liefeng Bo at Intel Corporation on August 2012

% sparse coding
switch encoder_second.coding
    case 'omp'
        DxX = (dic_second.dic)'*omp_fea.fea;
        codes = omp(DxX, dic_second.G, encoder_second.sparsity);
        omp_codes.codes = abs(codes);
        omp_codes.height = omp_fea.height;
        omp_codes.width = omp_fea.width;

    case 'omp_sign'
        DxX = (dic_second.dic)'*omp_fea.fea;
        codes = omp(DxX, dic_second.G, encoder_second.sparsity);
        codes_pos = double(codes > 0);
        codes_neg = double(codes < 0);
        omp_codes.codes = [codes.*codes_pos; -codes.*codes_neg];
        omp_codes.height = omp_fea.height;
        omp_codes.width = omp_fea.width;

    otherwise
        disp('unknown type');
end

