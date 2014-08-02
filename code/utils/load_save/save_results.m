function save_results(classifier,acc,labelTest,labelPredict,p,filePath,str);
% saving results
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

    if strcmp(str,'hmp')
      save(filePath.results.hmp,'classifier','acc','labelTest','labelPredict','p');
      disp(['Results saved in: ',filePath.results.hmp]);
    elseif strcmp(str,'sthmp')
      save(filePath.results.sthmp,'classifier','acc','labelTest','labelPredict','p');
      disp(['Results saved in: ',filePath.results.sthmp]);
    end
