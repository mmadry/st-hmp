function classifier = set_classifier_parameters();
% setting classifier parameters
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  s=1; % 1=linear kernel; described in the liblinear README file
  c=1; % cost

  % Validation
  classifier = inputParser;
  
  addRequired(classifier,'s',@(x) ( x >= 0 && x <= 6 && mod(x,1)==0 ));  
  addRequired(classifier,'c',@(x) ( x > 0 ));  
  parse(classifier,s,c);
  classifier=classifier.Results;
  