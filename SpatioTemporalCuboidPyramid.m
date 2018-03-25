function desc = SpatioTemporalCuboidPyramid(dfront, dside, dtop, hist, param)
    
    [ridx,cidx, didx,fidx] = getCuboidGrids(dfront, dside, dtop, hist, param);
    
    idims = param.hogDim;
    ndims = idims * param.nrow * param.ncol * param.ndep * (2^param.ntmp -1);
    desc = zeros(1,ndims); 
    s = 1; e = 0;
    for i = 1: param.ntmp
        % number of temporal layers in the ith temporal level
        nTmpLayer = 2 ^ (i - 1);
        
        % the ith temporal level
        idesc = SpatioCuboidLayer(dfront, dside, dtop, ridx, cidx, didx, fidx{i}, nTmpLayer, param);
        
        idesc = idesc(:);
        e = e + length(idesc);
        desc(s:e) = idesc;
        s = e + 1;
    end

end
