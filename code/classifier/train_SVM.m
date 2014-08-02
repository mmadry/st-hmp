function classifier = train_SVM(label,features);
% training of an SVM classifier 
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  % Loading parameters
  classifier = set_classifier_parameters;
  options = ['-s ',num2str(classifier.s),' -c ',num2str(classifier.c)]; 

  % Training
  disp('SVM training')
  classifier.model = train(label,double(features),options); 
  
  