function [dfront, dside, dtop, hist] = compDMS(front, side, top)
    [~,~,frms] = size(front);
    dfront = zeros(size(front));
    dfront(:,:,end) = [];
    dside = zeros(size(side));
    dside(:,:,[]) = [];
    dtop = zeros(size(top));
    dtop(:,:,[]) = [];
    hist = zeros(3, frms-1);
    
    sigma = 5;
    
    for fi = 1: frms-1
        dfronti = front(:,:,fi+1) - front(:,:,fi);
        dsidei = side(:,:,fi+1) - side(:,:,fi);
        dtopi = top(:,:,fi+1) - top(:,:,fi);
        
        dfronti(dfronti < sigma) = 0;
        dsidei(dsidei < sigma) = 0;
        dtopi(dtopi < sigma) = 0;
        
        dfronti = logical(dfronti);
        dsidei = logical(dsidei);
        dtopi = logical(dtopi);
        
        dfront(:,:,fi) = logical(dfronti);
        dside(:,:,fi) = logical(dsidei);
        dtop(:,:,fi) = logical(dtopi);
        
        hist(:, fi) = [sum(dfronti(:)), sum(dsidei(:)), sum(dtopi(:))];
        
    end
    
end
