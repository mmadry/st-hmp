function filePath=set_file_paths(dirPath,p)
% setting file paths
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  % Files with a list of training and testing data 
  filePath.listTrain=[dirPath.main,'/data/',p.databaseName,'/format:mat/_setup/train.list']; %list of labels and files to be loaded. NOTE: Labels are to be 0-9
  filePath.listTest=[dirPath.main,'/data/',p.databaseName,'/format:mat/_setup/test.list']; %list of labels and files to be loaded. NOTE: Labels are to be 0-9
  
  % Default paths to save results
  filePath.dictionary.save=1; % 0 - do not save, 1 - save
  filePath.dictionary.L1.prefix=[dirPath.dictionary,'/dictionary_L1_'];
  filePath.dictionary.L2.prefix=[dirPath.dictionary,'/dictionary_L2_'];
  
  filePath.feature.save=1; 
  filePath.feature.hmp.train=[dirPath.feature,'/feature_HMP_train.mat'];
  filePath.feature.hmp.test=[dirPath.feature,'/feature_HMP_test.mat'];
  filePath.feature.sthmp.train=[dirPath.feature,'/feature_STHMP_train.mat'];
  filePath.feature.sthmp.test=[dirPath.feature,'/feature_STHMP_test.mat'];
  
  filePath.results.save=1; 
  filePath.results.hmp=[dirPath.result,'/hmp_classifier_results.mat'];
  filePath.results.sthmp=[dirPath.result,'/sthmp_classifier_results.mat'];;

  % Validating
  if_exists(filePath.listTrain);
  if_exists(filePath.listTest);
  if_bin(filePath.dictionary.save);
  if_bin(filePath.feature.save);