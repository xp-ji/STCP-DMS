function idesc = SpatioCuboidLayer(dfront, dside, dtop, ridx, cidx, didx, fidx, ntmps, param)

    idims = param.hogDim;
    ndims = idims * param.nrow * param.ncol * param.ndep * ntmps;
    feats = zeros(3, ndims);
    s = 1; e = 0;
    gridSize =  param.gridSize;

    for f = 1: length(fidx)-1
        for r = 1: length(ridx)-1
            for c = 1: length(cidx)-1
                for d = 1: length(didx)-1
                    
                    % range of rows, cols, deps & frms
                    rs = ridx(r); re = ridx(r+1);
                    cs = cidx(c); ce = cidx(c+1);
                    ds = didx(d); de = didx(d+1);
                    fs = fidx(f); fe = fidx(f+1);
                    
                    subFront = dfront(rs:re, cs:ce, fs:fe);
                    subSide = dside(rs:re, ds:de, fs:fe);
                    subTop = dtop(ds:de, cs:ce, fs:fe);
                    
                    subFront = sum(subFront,3);
                    subSide = sum(subSide,3);
                    subTop = sum(subTop,3);
                    
                    subFront = imresize(subFront,gridSize);
                    subSide = imresize(subSide,gridSize);
                    subTop = imresize(subTop,gridSize);
                    
                    hogF = extractHOGFeatures(subFront);
                    hogS = extractHOGFeatures(subSide);
                    hogT = extractHOGFeatures(subTop);
                    
                    e = e + idims;
                    feats(:,s:e)=[hogF;hogS;hogT];
                    s = e + 1;
                    
                end
            end
        end
    end
    idesc = feats;
end
