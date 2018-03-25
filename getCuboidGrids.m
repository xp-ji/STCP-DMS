function [ridx, cidx, didx, fidx] = getCuboidGrids(dfront, dside, ~, hist, param)
    
    [rows, cols, ~] = size(dfront);
    [~, deps, ~] = size(dside);
    
    % row ranges of spatial grids
    ridx = zeros(1,param.nrow+ 1);
    rstep = rows/param.nrow;
    for i= 1: param.nrow+ 1
        ridx(i) = 1 + round((i-1) * rstep);
    end
    if ridx(end)> rows
        ridx(end) = rows;
    end
    
   % column ranges of spatial grids
    cidx = zeros(1,param.ncol+ 1);
    cstep = cols/param.ncol;
    for i= 1: param.ncol+1 
        cidx(i) = 1 + round((i-1) * cstep);
    end
    
    if cidx(end)> cols
        cidx(end) = cols;
    end
    
   % depth ranges of spatial grids
    didx = zeros(1,param.ndep+ 1);
    dstep = deps/param.ndep;
    for i= 1: param.ndep+ 1
        didx(i) = 1 + round((i-1) * dstep);
    end
    
    if didx(end)> deps
        didx(end) = deps;
    end
       
    % normalized accumulated motion energy
    hist=sum(hist,1);
    energy = cumsum(hist / sum(hist));
    
    % frame ranges of adaptive temporal pyramids grids
    fidx = cell(param.ntmp, 1);
    for i = 1:param.ntmp
        nbins = 2 ^ (i - 1);
        fstep = 1 / nbins;
        buff = ones(1, nbins+1);

        for j = 1:nbins
            % index of the element that is the most closed to (j * fstep)  
            [~, frm] = min(abs(energy - j * fstep));
            buff(j+1) = frm;
        end

        fidx{i} = buff;
    end
end
