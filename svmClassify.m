function rate = svmClassify(info, param, fold)

    % initialize 
    load([info.descPath, '/a01_s01_e01_desc.mat'], 'desc');
    ndims = length(desc);

    featTrain = zeros(info.dataSum, ndims);
    featTest = zeros(info.dataSum, ndims);
    tarTrain = zeros(info.dataSum, 1);
    tarTest = zeros(info.dataSum, 1);

    % prepare training and testing data
    itrain = 1;
    itest = 1;
    
    display('preparing the train and test data ......');
    for di = 1: info.dataSum
        
        dataName = info.dataTable{di,1};
        descName = [info.descPath, '/', dataName, '_desc.mat'];
        load(descName, 'desc');
            
            % fill in
             if ismember(info.dataTable{di,3},info.train)
                featTrain(itrain, :) = desc;
                tarTrain(itrain) = info.dataTable{di,2};
                itrain = itrain + 1;
            else
                featTest(itest, :) = desc;
                tarTest(itest) = info.dataTable{di,2};
                itest = itest + 1;
            end
    end
    featTrain(itrain:end,:)=[];
    tarTrain(itrain:end)=[];
    featTest(itest:end,:)=[];
    tarTest(itest:end)=[];
       
    
    display('scaling the data ......');
    % scale data
    [featTrainScale, ~] = scaleData(featTrain, 0, 1);
    clear featTrain;

    featTestScale = scaleData(featTest, 0, 1);
    clear featTest;

    % weighting
    unit = size(featTrainScale, 2) / (2^param.ntmp - 1);
    for ly = 1: param.ntmp
        ws = (unit * (2^(ly-1)-1)  +1);
        we = (unit * (2^ly-1));
        featTrainScale(:, ws:we) = featTrainScale(:, ws:we) * (2^(param.ntmp - ly));
        featTestScale (:, ws:we) = featTestScale (:, ws:we) * (2^(param.ntmp - ly));
    end

    % liblinear training
    display('training ......');
    model = train(tarTrain, sparse(featTrainScale));

    % liblinear testing
    display('predicting ......');
    t1 = cputime;
    [label, rate, score] = predict(tarTest, sparse(featTestScale), model);
    
    t2 = cputime;
    spa = (t2- t1)/size(tarTest,1);
    display([' -- second per action: ', num2str(spa),' s -- time sum:',num2str(t2- t1),' s --']);

    % save prediction result
    if ~isdir(info.logPrefix)
         mkdir(info.logPrefix);
    end
    trainSubs = info.train; testSubs = info.test;
    predName = [info.logPrefix,'/',fold,'_PRED.mat'];
    save(predName, 'model', 'tarTest', 'label', 'rate', 'score', 'testSubs', 'testSubs');    
end
