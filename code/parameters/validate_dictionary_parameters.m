function dic=validate_dictionary_parameters(L)
% validating dictionary parameter values
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

      dic=inputParser;
    
      % Validating parameter values
      expectedSamplingType = {'uniform','random'};
      addRequired(dic,'samplingType',@(x) any(validatestring(x,expectedSamplingType)));
      addRequired(dic,'dicsize',     @(x) ( x > 0 && mod(x,1)==0 ));
      addRequired(dic,'patchsize',   @(x) ( x > 0 && mod(x,1)==0 ));
      addRequired(dic,'windowstep',  @(x) ((strcmp(L.samplingType,'uniform') && x > 0 && mod(x,1)==0) || (strcmp(L.samplingType,'random')  && x==0) ));
      addRequired(dic,'samplenum',   @(x) ((strcmp(L.samplingType,'random')  && x > 0 && mod(x,1)==0) || (strcmp(L.samplingType,'uniform') && x==0) ));
      parse(dic,L.samplingType,L.dicsize,L.patchsize,L.windowstep,L.samplenum); 
      dic=dic.Results;  
