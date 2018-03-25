function trainAndTest(info, param)
    testFolds = size(info.trainSet,1);
    testResult = zeros(testFolds, info.subs+1);
    for i = 1: testFolds
        fold = sprintf('%03d',i);
        info.train = info.trainSet(i,:);
        info.test =  setdiff(1:info.subs, info.train);
        rate = svmClassify(info, param , fold);
        testResult(i,:) = [info.train, info.test, rate(1)];
    end
    aveRate = sum(testResult(:,info.subs+1))/testFolds;
    aveName = [info.logPrefix,'/',fold,'_AVE.mat'];
    save(aveName, 'aveRate', 'testResult'); 
end
