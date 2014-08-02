function fea_first=load_data(infile,p);
% loading tactile data
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

  if_exists(infile);
  check_fileList_format(infile);
  
  tmp=importdata(infile);
  fileList=cellfun(@(x) x(3:end), tmp, 'UniformOutput', false);
 
  
  % Processing each file separatly
  k=1; %frame numerator
  for seqIdx=1:length(fileList)
    
    % Loading data from the file
    data=load(fileList{seqIdx});

    %Loading frames
    for frameId=1:(data.seqLength-p.nF+1)
	if strcmp(p.databaseName,'Drimus12RAS_schunk_dexterous')
	  if strcmp(p.joinType,'single')
	    for ift=1:p.nF
	      fea_first.mat{1}.im{k}(:,:,ift) = [data.TS{1}(:,:,frameId+ift-1); data.TS{2}(:,:,frameId+ift-1)];
	      fea_first.mat{2}.im{k}(:,:,ift) = [data.TS{3}(:,:,frameId+ift-1); data.TS{4}(:,:,frameId+ift-1)];
	      fea_first.mat{3}.im{k}(:,:,ift) = [data.TS{5}(:,:,frameId+ift-1); data.TS{6}(:,:,frameId+ift-1)];
	    end
	  elseif strcmp(p.joinType,'conc')
	    for ift=1:p.nF
	      fea_first.mat{1}.im{k}(:,:,ift)=[data.TS{1}(:,:,frameId+ift-1) data.TS{3}(:,:,frameId+ift-1) data.TS{5}(:,:,frameId+ift-1); data.TS{2}(:,:,frameId+ift-1) data.TS{4}(:,:,frameId+ift-1) data.TS{6}(:,:,frameId+ift-1)];
	    end
	  end
	else
	  error(['Data alignment is not specified for the database: ',p.databaseName]);
	end%if:databaseName
      k=k+1;
    end%frameId
  end%for:seqIdx

  fea_first.nFrame=k-1;

  n=min( size(fea_first.mat{1}.im{1},1),size(fea_first.mat{1}.im{1},2));
  fea_first.minsize = floor(n*p.imScale); 
  


