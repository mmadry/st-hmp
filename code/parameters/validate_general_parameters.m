function p=validate_general_parameters(P);
% validating general parameter values
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

      p = inputParser;
      
      expectedDatabaseName = {'Drimus12RAS_schunk_dexterous'};
      addRequired(p,'databaseName',@(x) any(validatestring(x,expectedDatabaseName)));
      
      expectedJoinType = {'single','conc'};
      addRequired(p,'joinType',@(x) any(validatestring(x,expectedJoinType)));
  
      addRequired(p,'nF',@(x) ( x > 0 && mod(x,1)==0 )); 
      addRequired(p,'noLayers',@(x) ( x==1 || x==2 ));
    
      addRequired(p,'iternumSVD',@(x) ( x > 10 && mod(x,1)==0 ));
      addRequired(p,'imScale',   @(x) ( x > 0 )); 
      addRequired(p,'normMag',   @(x) ( x == 0 || x==1 ));
      
      validateattributes(P.pyramid, {'numeric'},{'positive','integer'}); %'increasing', issorted() not in Matlab R2011b, thus:
      if length(P.pyramid) > 1
      	for i=1:length(P.pyramid)-1 %'increasing'
	  assert(P.pyramid(i)<P.pyramid(i+1));
	end
      end
      addRequired(p,'pyramid',@(x) length(x)>0);
      
      parse(p,P.databaseName,P.joinType,P.nF,P.noLayers,P.iternumSVD,P.imScale,P.normMag,P.pyramid); 
      p=p.Results;