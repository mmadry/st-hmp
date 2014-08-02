function [dic_first,dic_second] = set_dictionary_parameters(p);
% setting dictionary parameters
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  % Init values (do not change)
  init.windowstep=0;
  init.samplenum=0;
  
  %----------------------
  % Please specify values of parameters 
  
    samplingType='uniform'; % Method of sampling raw signal patches. Patches can be sampled 
                            % - 'uniform' manner (recommended), specify a window step value (L.windowstep)
                            % - 'random' manner, specify a number of samples to be extracted (L.samplenum)
  
    % First layer dictionary parameters
    L1.samplingType=samplingType;
    L1.dicsize=100;       % size of a dictionary at the first layer, can be chosen using cross-validation  
    L1.patchsize=4;       % size of a sampled patch; parameter value depends on an input matrix size (default: 4x4 pixels)
    
    if strcmp(samplingType,'uniform')
      L1.windowstep=2;    % step for 'uniform' sampling (default: 2 pixels = every second window)
      L1.samplenum=init.samplenum; 
    elseif strcmp(samplingType,'random')
      L1.windowstep=init.windowstep;
      L1.samplenum=30;    % number of samples for 'random' sampling
    end
    
    % Second layer dictionary parameters
    if p.noLayers==2      
      L2.samplingType=samplingType;
      L2.dicsize=15;      % size of a dictionary at the second layer, can be chosen using cross-validation 
      L2.patchsize=3;     % size of a sampled patch; parameter value depends on an input matrix size (default: 3x3 pixels for p.joinType='conc' and 1x1 p.joinType='single')
      
    if strcmp(samplingType,'uniform')
      L2.windowstep=1;    % step for 'uniform' sampling (default: 1 pixels = all windows)
      L2.samplenum=init.samplenum;
    elseif strcmp(samplingType,'random')
      L2.windowstep=init.windowstep;
      L2.samplenum=20;   % number of samples for 'random' sampling
    end

   end
  
   % Setting and validating parameters
   dic_first=validate_dictionary_parameters(L1); % <- look to this file to learn about valid (possible) parameters values
   
   if p.noLayers==2
    dic_second=validate_dictionary_parameters(L2); % <- look to this file to learn about valid (possible) parameters values
   else
    dic_second=[];
   end
  