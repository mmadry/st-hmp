function [label,seqIdFrame]=load_labels(infile,p);
% loading labels for tactile files
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  if_exists(infile);
  check_fileList_format(infile);
  
  tmp=importdata(infile);
  label.seq=str2num(cell2mat(cellfun(@(x) x(1), tmp, 'UniformOutput', false)))+1; % adding one to suit to the libsvm format
  fileList=cellfun(@(x) x(3:end), tmp, 'UniformOutput', false);
  
  % Processing each file separatly
  label.frame=[]; seqIdFrame=[]; 
  for seqIdx=1:length(fileList)
    data=load(fileList{seqIdx});

    label.frame=[label.frame label.seq(seqIdx)*ones(1,data.seqLength-p.nF+1)]; 
    seqIdFrame=[seqIdFrame seqIdx*ones(1,data.seqLength-p.nF+1)];
  end

  label.frame=label.frame';
