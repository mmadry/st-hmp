function demo_HMP_STHMP()
% Spatio-Temporal Hierarchical Matching Pursuit (ST-HMP) demo 
% It contains implementation of a complete classification system that uses the ST-HMP descriptor to represent sequences of real tactile data for  
% * Learning and extracting:
%   - Hierarchical Matching Pursuit features
%   - Spatio-Temporal Hierarchical Matching Pursuit features
% * Training and testing using SVM classifiers
% > Demo is run for sequences of real tactile data for an object instance recognition task
% > System parameters are described in files in the directory ./parameters
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

    disp('*** TRAINING')
    
  % Loading data and labels
    dataTrain = load_data(filePath.listTrain,p); 
    [labelTrain,seqIdTrain] = load_labels(filePath.listTrain,p);
    
  % Learning and extracting HMP features (Hierarchical Matching Pursuit)
    [hmpTrain,dict]=hmp_learn_extract(dataTrain,p,filePath);
    
  % Extracting ST-HMP features (Spatio-Temporal Hierarchical Matching Pursuit) 
    sthmpTrain = sthmp_extract_batch(hmpTrain,seqIdTrain,p,filePath,'train');
    
  % Classifier Training
    classifierHMP = train_SVM(labelTrain.frame,hmpTrain');
    classifierSTHMP = train_SVM(labelTrain.seq,sthmpTrain');

%------------------------
% 	TESTING

    disp('*** TESTING')
  
  % Loading data and labels
    dataTest = load_data(filePath.listTest,p);
    [labelTest,seqIdTest] = load_labels(filePath.listTest,p);

  % Extracting HMP features (Hierarchical Matching Pursuit)
    hmpTest = hmp_extract(dataTest,dict,p,filePath);
    
  % Extracting ST-HMP features (Spatio-Temporal Hierarchical Matching Pursuit)   
    sthmpTest = sthmp_extract_batch(hmpTest,seqIdTest,p,filePath,'test');
     
  % Classification
    [accHMP,labelPredictHMP]=test_SVM(classifierHMP,labelTest.frame,hmpTest');
    [accSTHMP,labelPredictSTHMP]=test_SVM(classifierSTHMP,labelTest.seq,sthmpTest');
    
   
  % Saving model and results
    if filePath.results.save 
      save_results(classifierHMP,accHMP,labelTest.frame,labelPredictHMP,p,filePath,'hmp');
      save_results(classifierSTHMP,accSTHMP,labelTest.seq,labelPredictSTHMP,p,filePath,'sthmp');
    end
   
    


 
