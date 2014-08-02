function if_exists(path);
% checking if dir or file exists
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

if ~exist(path)
  error(['Director or file does not exist: ',path]);
end