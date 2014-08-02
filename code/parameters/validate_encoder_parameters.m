function encoder = validate_encoder_parameters(E)
% validating encoder parameter values
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

      encoder = inputParser;
      
      expectedCoding = {'omp','omp_sign'};
      addRequired(encoder,'coding',@(x) any(validatestring(x,expectedCoding)));
      %addRequired(encoder,'pooling',@(x) ( (x > 0 && mod(x,1)==0) ||   )); 
      
      validateattributes(E.pooling, {'numeric'},{'positive','integer'}); %'increasing', issorted() not in Matlab R2011b, thus:
      if length(E.pooling)
	for i=1:length(E.pooling)-1 %'increasing'
	  assert(E.pooling(i)<E.pooling(i+1));
	end
      end
      addRequired(encoder,'pooling',@(x) length(x)>0);

      if isempty(E.patchsize)
	addRequired(encoder,'sparsity',@(x) ( x > 0 && mod(x,1)==0 ));  
	parse(encoder,E.coding,E.pooling,E.sparsity);
      elseif isempty(E.sparsity)
        addRequired(encoder,'patchsize',@(x) ( x > 0 && mod(x,1)==0  ));
	parse(encoder,E.coding,E.pooling,E.patchsize);
      else
	addRequired(encoder,'sparsity',@(x) ( x > 0 && mod(x,1)==0 )); 
	addRequired(encoder,'patchsize',@(x) ( x > 0 && mod(x,1)==0  ));
	parse(encoder,E.coding,E.pooling,E.sparsity,E.patchsize);
      end
      
      encoder=encoder.Results;
