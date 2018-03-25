function [info, param] = setParam(datasets)

    %%% datasets setup
    info.dataPath = ['./Datasets/',datasets];
    info.dataName =  datasets;
    info.logPath =  './log';
    info.descPath = ['./desc/',datasets];
    
    switch datasets
        case 'MSRAction3D'
            info.acts = 20; % actions
            info.subs = 10; % subjects
            info.exps = 3;  % experiments
            %info.subTest = 5; % the number of subjects for test        
            %info.trainSet = nchoosek(1:info.subs, info.subs - info.subTest);
            info.trainSet = [1, 3, 5, 7, 9];
            
        case 'MSRGesture3D'
            info.acts = 12; 
            info.subs = 10;
            info.exps = 3;
            info.subTest = 1;
            info.trainSet = nchoosek(1:info.subs, info.subs - info.subTest);
            
        case 'MSRActionPairs'
            info.acts = 12;
            info.subs = 10;
            info.exps = 3;
            info.train = [1,3,5,7,9];
            info.test = setdiff(1:info.subs, info.train);
            info.subTest = 5;       
            info.trainSet = nchoosek(1:info.subs, info.subs - info.subTest);
            
        otherwise
            error(['Please check the datasets Name: ',datasets,' is unavailable']);
    end
       
    %%% external libary
    addpath('./LibMatlab');
        
    %%% parmeter setup
        
    param.nrow = 3;
    param.ncol = 3;
    param.ndep = 3;
    param.ntmp = 3;
    
    param.gridSize = [24 24];
    param.BlockSize = [2,2];
    param.CellSize = [8,8];
    param.BlockOverlap = [1,1];
    param.NumBins = 9;
    BlocksPerImage = floor( (param.gridSize./param.CellSize - param.BlockSize)./(param.BlockSize - param.BlockOverlap)+1 );
    param.hogDim = prod([BlocksPerImage param.BlockSize param.NumBins]);
    
    

    %%% data folders
    creatFolder(info);
        
    %%% save curruent setting to the *.log file
    info.logPrefix  = [info.logPath,'/',datasets,'_',datestr(now,30)];
    info.logName = [info.logPrefix,'.log'];
    fp = fopen(info.logName,'a');
    fprintf(fp, '------------------------------------------------\r\n');
    fprintf(fp, [datestr(now),'\r\n']);
    fprintf(fp, '------------------------------------------------\r\n');
    fclose(fp);
    
    set(0,'DiaryFile',info.logName);
    diary on;
    
    display(info);
    display(param);
end

% Creat the folder
function creatFolder(info)

    if ~isdir(info.logPath)
        mkdir(info.logPath);
    end

    if ~isdir(info.descPath)
        mkdir(info.descPath);
    end
        
end
