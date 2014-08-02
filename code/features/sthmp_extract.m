function sthmpSeq = sthmp_extract(hmpSeq,p)
% extracting Spatio-Temporal Hierarchical Matching Pursuit descriptor for a single sequence
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

    seqLength = size(hmpSeq,2);

    if (max(p.pyramid)>seqLength) 
      error(['Too many parts in the time pyramid. Max possible value in p.pyramid: ',num2str(seqLength)]);
    end
	  
    sthmpSeq=[];
    for ip=1:length(p.pyramid) 
      nParts = p.pyramid(ip); 
      partLength = floor(seqLength/nParts); 
	      
      frame_cell_id = meshgrid(1:nParts,1:partLength); 
      frame_cell_id = frame_cell_id(:);

      % Padding. Last frames go to to the last cell
      if (length(frame_cell_id) < seqLength)
	frame_cell_id = [frame_cell_id ; ones(seqLength-length(frame_cell_id),1)*frame_cell_id(end)]; 
      end
      assert(length(frame_cell_id) == seqLength); 
	       
      % Max pooling
      for iip=1:nParts
	tmp = max( hmpSeq(:,frame_cell_id==iip), [], 2);
	sthmpSeq=[sthmpSeq; tmp];
      end
    end
    assert(length(sthmpSeq) == size(hmpSeq,1)*sum(p.pyramid));


