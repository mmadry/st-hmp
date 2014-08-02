function hmp = hmp_extract(fea,dict,p,filePath)
% extracting Hierarchical Matching Pursuit descriptors given learned dictionaries
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    based on Liefeng Bo's demo for the RGBD database

    hmp=[];
  
    for i=1:size(fea.mat,2)
      fea.type = i;
      
    % FIRST LAYER 
      % Dictionary
      dic_first=dict.L1{i};
	
      % Orthogonal Matching Pursuit encoder
	[encoder_first, encoder_second, encoder_final] = set_encoder_parameters(p);
	omplayer1=omp_pooling_layer1_batch(fea, dic_first, encoder_first); 
	
    % SECOND LAYER 
      if (p.noLayers==2) 
      
        % Dictionary
	dic_second=dict.L2{i};
	    
	% Orthogonal Matching Pursuit encoder
	  omplayer2=omp_pooling_layer2_batch(dic_second, encoder_second, omplayer1, p.normMag);
      end
      
    % FINAL
      if p.noLayers==1 
	omplayer=omplayer1;
      elseif p.noLayers==2
	omplayer=omplayer2;
      end
      
      hmp_one = omp_pooling_final_batch_single(encoder_final,omplayer);
      
      % Concatenation of features 
      hmp = [hmp; hmp_one];
   end
    
   % Save HMP features
   if filePath.feature.save
    save(filePath.feature.hmp.test,'hmp');
   end
    
    
    
    
    


