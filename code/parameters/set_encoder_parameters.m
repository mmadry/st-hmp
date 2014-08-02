function [encoder_first, encoder_second, encoder_final] = set_encoder_parameters(p);
% setting encoder parameters (HMP parameters)
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  % Init values (do not change)
  init.patchsize=[];
  init.sparsity=[];
  
  %----------------------
  % USER: please specify values of parameters 
  
  E1.coding = 'omp_sign'; % Orthogonal matching pursuit method:
			    % - 'omp' 
			    % - 'omp_sign' (recommended) -> all HMP feature vector elements are saved with positive and negative sign. HMP feature vector double its length 
  E1.pooling = 3;           % spatial pooling levels 
  E1.sparsity = 4;          % sparsity level controlling the number of the non-zero entries (see, paper [1] Eq. 1) 
  E1.patchsize=[];
  encoder_first = validate_encoder_parameters(E1);

  if p.noLayers==2
    E2.coding = E1.coding;
    E2.pooling = 1;
    E2.sparsity = 10;
    E2.patchsize=init.patchsize;
    encoder_second = validate_encoder_parameters(E2);
  elseif p.noLayers==1
    encoder_second=[];
  end
  
  EF.coding = E1.coding;
  EF.pooling = [1 2 3]; % spatial partition in HMP descriptor (default: 1 2 3, i.e. a matrix is divided into 1, 2 and 3 in both X and Y dimension giving 1+4+9 parts). If the matrix is to be divided differently in X and Y, then use a two row notation, for example [1 2 3; 4 2 1] 
  EF.sparsity = init.sparsity;
  EF.patchsize = 1;
  encoder_final = validate_encoder_parameters(EF); % <- look to this file to learn about valid (possible) parameters values

