function ctime = compDescripter(info, param)
    ctime = zeros(info.dataSum, 3);
    
    for di = 1: info.dataSum
        dataName = info.dataTable{di,1};
        depthPath = [info.dataPath,'/',dataName,'_sdepth.mat'];
           
        % load depth mat
        load(depthPath,'depth');
        display(['computing descriptor of depth: ', dataName, ' ......']);
        
        if strcmp(info.dataName,'MSRActionPairs')
            depth = backgroundRemoval(depth);
        end

        t1 = cputime;
        % get the projection of depth maps
        [front,side,top] = resharpMap(depth);

        %get the difference of projection
        [dfront, dside, dtop, hist] = compDMS(front, side, top);
        
        % spatio-temporal cuboid pyramid
        desc = SpatioTemporalCuboidPyramid(dfront, dside, dtop, hist, param);
                                

        t2 = cputime;
        fps = (size(depth,3))/(t2- t1);
        display([' -- speed: ', num2str(fps),' fps -- time:',num2str(t2- t1),' s --']);
        ctime(di,:) = [fps,t2-t1,size(depth,3)];
        
        % save descripter mat
        descName = [info.descPath,'/',dataName, '_desc.mat'];
        save(descName, 'desc');
        
    end
    
end
