function check_fileList_format(infile)
% validating format of an input file
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  tmp=importdata(infile);
  
  idx=cell2mat(strfind(tmp,' '));
  if min(idx==2)==0
    error(['Labels are to be between 0 and 9']);
  end
  
  fileList=cellfun(@(x) x(3:end), tmp, 'UniformOutput', false);
  idxExist=logical(cell2mat(cellfun(@(x) exist(x), fileList, 'UniformOutput', false)));

  if min(idxExist)==0
    noFile=fileList{idxExist==0};
    error(['File does not exist: ',noFile])
  end
