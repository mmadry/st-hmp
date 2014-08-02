function if_bin(val)
% checking if val is binary
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

if ~( val==0 || val==1)
  error(['Value should be 0 (false) or 1 (true): ',num2str(val)]);
end