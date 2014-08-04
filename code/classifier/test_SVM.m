function [acc,labelPredict]=test_SVM(classifier,labelTrue,features)
% testing using an SVM classifier 
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  [labelPredict, acc, decValues] = predict(labelTrue, double(features), classifier.model);
  

  
