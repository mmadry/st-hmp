function [feasample, channel] = ksvd_sample_layer1(fea_first, dic_first)
% randomly sample patches from raw data matrices   
% written by Liefeng Bo at Intel Corporation on August 2012
% modified by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com
%    added functionality: handling the tactile data format, different types of sampling (uniform, uniform2, random), 3-dimensional patches

disp('Sampling matrix patches - layer 1 ......');
count = 0;

for i = 1:fea_first.nFrame

   im = fea_first.mat{fea_first.type}.im{i};
      
   % resize matrix if necessary
    im_h = size(im,1);
    im_w = size(im,2);
    if isfield(fea_first,'maxsize')
       if fea_first.maxsize <= 0
          ;
       else
          im = imresize(im, fea_first.maxsize/max(im_h, im_w), 'bicubic');
       end
    end
    if isfield(fea_first,'minsize')
       if fea_first.minsize <= 0
          ;
       else
          im = imresize(im, fea_first.minsize/min(im_h, im_w), 'bicubic');
       end
    end

    if i == 1
       feasample = zeros(dic_first.patchsize^2*size(im,3), dic_first.samplenum*fea_first.nFrame);
    end
    
    % Sampling matrix patches  
    if size(im,3) == 1 %for 2D patches
      
      if strcmp(dic_first.samplingType,'uniform')
	sample_one = im2colstep(im, [dic_first.patchsize dic_first.patchsize], [dic_first.windowstep dic_first.windowstep]); 
      elseif strcmp(dic_first.samplingType,'random') || strcmp(dic_first.samplingType,'uniform2') %uniform2 is not recommended
        % Extracting all possible patches with sliding window step equal to 1
	sample_one = im2colstep(im, [dic_first.patchsize dic_first.patchsize], [1 1]); 
      end
    else %for 3D patches 
      if strcmp(dic_first.samplingType,'uniform')
	sample_one = im2colstep(im, [dic_first.patchsize dic_first.patchsize size(im,3)], [dic_first.windowstep dic_first.windowstep dic_first.windowstep]);
      elseif strcmp(dic_first.samplingType,'random') || strcmp(dic_first.samplingType,'uniform2') %uniform2 is not recommended
	% Extracting all possible patches with sliding window step equal to 1
      	sample_one = im2colstep(im, [dic_first.patchsize dic_first.patchsize size(im,3)], [1 1 1]);
      end
   end
    
   if strcmp(dic_first.samplingType,'random') 
        %  Randomly picking up limitted number of patches
	if size(sample_one,2) > dic_first.samplenum
	  sample_one = sample_one(:,randsample(size(sample_one,2),dic_first.samplenum));
	end
   elseif strcmp(dic_first.samplingType,'uniform2')
         % Uniformy picking up limitted number of patches
	tmp=floor(linspace(1,size(sample_one,2),dic_first.samplenum));
	sample_one = sample_one(:,tmp);
   end

    % Removing dc in blocks to conserve memory
    sample_one = remove_dc(sample_one,'columns');
    samplenum = size(sample_one,2);
  
    feasample(:,count+(1:samplenum)) = sample_one;
    count = count + samplenum;
end
feasample(:,count+1:end) = [];
channel = size(im,3);

 
