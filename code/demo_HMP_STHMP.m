function demo_HMP_STHMP()
% Spatio-Temporal Hierarchical Matching Pursuit (ST-HMP) demo 
% It contains implementation of a complete classification system that uses the ST-HMP descriptor to represent sequences of tactile data.
% * Learning and extracting:
%   - Hierarchical Matching Pursuit (HMP) features
%   - Spatio-Temporal Hierarchical Matching Pursuit (ST-HMP) features
% * Training and testing using SVM classifiers
% > Demo runs for sequences of real tactile data for an object instance recognition task
% > System parameters are defined and described in the directory ./parameters
%------------------------
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%------------------------

% Setting parameters
  % Adding toolbox paths
    add_ext_paths;
    
  % Setting values of parameters
    p=set_general_parameters;
    
  % Setting directory and file paths
    dirPath=set_dir_paths;
    filePath=set_file_paths(dirPath,p);
    
%------------------------
% 	TRAINING
    disp('===== TRAINING =====');
    
  % Loading data and labels
    disp('*** LOADING TRAINING DATA');
    dataTrain = load_data(filePath.listTrain,p); 
    [labelTrain,seqIdTrain] = load_labels(filePath.listTrain,p);
  
  % Learning and extracting HMP features (Hierarchical Matching Pursuit)
    disp('*** FEATURE LEARNING - HMP');
    [hmpTrain,dict]=hmp_learn_extract(dataTrain,p,filePath);
    
  % Extracting ST-HMP features (Spatio-Temporal Hierarchical Matching Pursuit) 
    disp('*** FEATURE LEARNING - ST-HMP');  
    sthmpTrain = sthmp_extract_batch(hmpTrain,seqIdTrain,p,filePath,'train');

  % Classifier Training
    disp('*** TRAINING SVM - HMP');
    classifierHMP = train_SVM(labelTrain.frame,hmpTrain');
    
    disp('*** TRAINING SVM - ST-HMP'); 
    classifierSTHMP = train_SVM(labelTrain.seq,sthmpTrain');

%------------------------
% 	TESTING
    disp('===== TESTING =====');
    
    % Loading data and labels
    disp('*** LOADING TESTING DATA');
    dataTest = load_data(filePath.listTest,p);
    [labelTest,seqIdTest] = load_labels(filePath.listTest,p);

  % Extracting HMP features (Hierarchical Matching Pursuit)
    disp('*** FEATURE EXTRACTION - HMP');
    hmpTest = hmp_extract(dataTest,dict,p,filePath);
    
  % Extracting ST-HMP features (Spatio-Temporal Hierarchical Matching Pursuit)  
    disp('*** FEATURE EXTRACTION - ST-HMP');    
    sthmpTest = sthmp_extract_batch(hmpTest,seqIdTest,p,filePath,'test');
     
  % Classification
    disp('*** CLASSIFICATION - HMP');
    [accHMP,labelPredictHMP]=test_SVM(classifierHMP,labelTest.frame,hmpTest');
    disp('*** CLASSIFICATION - ST-HMP'); 
    [accSTHMP,labelPredictSTHMP]=test_SVM(classifierSTHMP,labelTest.seq,sthmpTest');
     
  % Saving model and results
    if filePath.results.save 
      save_results(classifierHMP,accHMP,labelTest.frame,labelPredictHMP,p,filePath,'hmp');
      save_results(classifierSTHMP,accSTHMP,labelTest.seq,labelPredictSTHMP,p,filePath,'sthmp');
    end
   
    


 
