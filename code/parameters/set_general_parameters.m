function p=set_general_parameters();
% setting general method parameters
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  % Setting parameter values
    P.databaseName='Drimus12RAS_schunk_dexterous'; % name of a database 
    P.joinType='conc';          % method of concatenating tactile matrices (see, paper [1] Section C.1)
                                %       - 'single' - features for each tactile sensor (finger) are extracted separately; one dictionary per one tactile sensor (finger) is learned 
                                %       - 'conc' (recommended) - data from all tactile sensors are concatenated into one large input matrix; one dictionary is learned for all sensors 
    P.nF=1;                     % ST-HMP parameter: number of frames used to compute a dictionary; if nF>1, a spatio-temporal dictionary (ST-dic) is learned (see, paper [1] Section C.4)
                                %                   in order to not run OUT OF MEMORY, check available amount of RAM when using large values of nF
    P.noLayers=1;               % HMP parameter: number of layers. In case of tactile data, noLayers=1 already provided satisfactory results
     
    P.pyramid = [1 2 4 8 16];   % ST-HMP parameter: temporal partition of a sequence in ST-HMP descriptor, can be chosen using cross-validation (see, paper [1] Section C.1)
      
    P.iternumSVD = 10;          % number of iteration in K-SVD algorithm (when running demo, observe a decreasing value of RMSE error). Default value: 35-50
    P.imScale = 1;              % input matrix scaling factor; 1 - no scaling (an original matrix size is kept)
    P.normMag = 1;              % optional normalization of a feature magnitude; 1 - normalize (recommended), 0 - do not normalize
      
    p=validate_general_parameters(P); % <- look to this file to learn about valid (possible) parameters values
      
    

