function [hmp,dict] = hmp_learn_extract(fea_train,p,filePath)
% learning and extracting Hierarchical Matching Pursuit descriptors
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    based on Liefeng Bo's demo for the RGBD database

    hmp=[];
  
    for i=1:size(fea_train.mat,2)
      fea_train.type = i;
      
    % FIRST LAYER 
      % Dictionary Learning
      [dic_first,dic_second] = set_dictionary_parameters(p);        
  
      dic_first.dic = ksvd_learn_layer1(fea_train, dic_first, p.iternumSVD);
      
      % Save dictionary
	if filePath.dictionary.save
	  save([filePath.dictionary.L1.prefix,num2str(fea_train.type),'.mat'],'dic_first');
	end
	
      % Orthogonal Matching Pursuit encoder
	[encoder_first, encoder_second, encoder_final] = set_encoder_parameters(p);
	omplayer1=omp_pooling_layer1_batch(fea_train, dic_first, encoder_first); 
	
    % SECOND LAYER 
      if (p.noLayers==2) 
      
	% Dictionary Learning
	  dic_second.dic = ksvd_learn_layer2(dic_second, omplayer1, p.normMag);
	  
	% Save dictionary
	  if filePath.dictionary.save
	    save([filePath.dictionary.L2.prefix,num2str(fea_train.type),'.mat'],'dic_second');
	  end
	    
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

      dict.L1{i}=dic_first;
      dict.L2{i}=dic_second;
   end
    
   % Save HMP features
   if filePath.feature.save
    save(filePath.feature.hmp.train,'hmp');
   end
    
    
    
    
    


