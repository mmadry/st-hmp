function if_notexists_mkdir(path);
% creating directory if it does not exist
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

if ~exist(path)
  mkdir(path);
end