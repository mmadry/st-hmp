function sthmp = sthmp_extract_batch(hmp,seqIdBatch,p,filePath,str);
% batch extraction of Spatio-Temporal Hierarchical Matching Pursuit descriptors for several sequences
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
	
  % Extracting features for each sequance
  for iseq=1:max(seqIdBatch)
    hmpSeq = hmp(:,seqIdBatch==iseq); % hmp features for the sequance iseq
    
    sthmp(:,iseq) = sthmp_extract(hmpSeq,p);
  end

  % Save data
  if filePath.feature.save
    if strcmp(str,'train')
      save(filePath.feature.sthmp.train,'sthmp');
    elseif strcmp(str,'test')
      save(filePath.feature.sthmp.test,'sthmp');
    end
  end
  



