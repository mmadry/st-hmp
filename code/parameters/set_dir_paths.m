function dirPath=set_dir_paths;
% setting directory paths
% written by Marianna Madry
%    place: Royal Institute of Technology (KTH), Sweden and University of Washington, WA, USA 
%    date: June, 2014 
%    email: marianna.madry@gmail.com

    dirPath.main='/home/marianna/Praca/repos/code/sthmp/branch/KIT'; %Please set your own path 
    
    % default paths
    dirPath.data=[dirPath.main,'/data'];
    dirPath.code=[dirPath.main,'/code'];
    dirPath.output=[dirPath.main,'/output'];
    dirPath.feature=[dirPath.output,'/feature'];
    dirPath.result=[dirPath.output,'/results'];
    dirPath.dictionary=[dirPath.output,'/dictionary'];
    
    if_exists(dirPath.data);
    if_exists(dirPath.code);

    if_notexists_mkdir(dirPath.output);
    if_notexists_mkdir(dirPath.feature);
    if_notexists_mkdir(dirPath.result);
    if_notexists_mkdir(dirPath.dictionary);
