function [front,side,top] = resharpMap(depthi)

    depth = removeZeroframes(depthi);
    [rows, cols, frms] = size(depth);
    display([' -- new dim:',num2str(rows),'*',num2str(cols),'*',num2str(frms),' --']);
    vector = depth;
    vector(vector ==0) = [];
    maxDis = max(vector(:));
    minDis = min(vector(:));
    range = maxDis - minDis+ 1;
%     display(['max:',num2str(maxDis),'--','min:',num2str(minDis)]);
    
    front = zeros(rows,cols,frms);
    side = zeros(rows,range,frms);
    top = zeros(range,cols,frms);
    
    for fi = 1: frms
        depthframe = depth(:,:,fi);
        [fronti, sidei, topi] = frameProject(rows,cols,range,depthframe,minDis);
        front(:,:,fi) = fronti;
        side(:,:,fi) = sidei;
        top(:,:,fi) = topi;
    end

end

% project a frame
function [front, side, top] = frameProject(rows,cols,range,depthframe,minDis)

    front = zeros(rows,cols);
    side = zeros(rows,range);
    top = zeros(range,cols);
    
    % for side view
    for ri = 1: rows
        for ci = 1: cols
            if depthframe(ri,ci) == 0
                continue;
            else
                depthframe(ri,ci) = depthframe(ri,ci) - minDis +1;
                % 3-views proiection of a frame
                front(ri,ci) = depthframe(ri,ci);    % front view
                side(ri,depthframe(ri,ci)) = ci;     % side view
            end  
        end   
    end
    
    for ci = cols: -1:1
        for ri = 1: rows
            if depthframe(ri,ci) == 0
                continue;
            else
                % 3-views proiection of a frame
                top(range - depthframe(ri,ci) +1,ci) = ri;      % top view
            end  
        end   
    end
    
end

% remove all-zero frames and get the bounding box
function depthBB = removeZeroframes(depth)
    [rows, cols, frms] = size(depth);
    depthNZ = zeros(rows, cols, frms);
    masks = zeros(rows, cols);
    fo=1;
    for fi = 1: frms
        frame = depth(:,:,fi);
        mask  = logical(frame);
        if any(mask(:)) == 0
            continue
        else
            depthNZ(:,:,fo) = frame;
            masks = masks + mask;
            fo=fo+1;
        end
    end
    
    if (fo-1) < frms
        depthNZ(:,:,fo:end)=[];
        display(['frames zip:',num2str(frms),'-->',num2str(fo-1)]);
    end 
    
    BB = bounding_box(masks);
    depthBB = depthNZ(BB.top: BB.bottom, BB.left: BB.right,:);
end

% get bounding box of a images
function bb = bounding_box(img)

    [row, col] = size(img);

    for i = 1:row
        if sum(img(i,:)) > 0
            top = i;
            break
        end
    end

    for i = row:(-1):1
        if sum(img(i,:)) > 0
            bottom = i;
            break
        end
    end

    for i = 1:col
        if sum(img(:,i)) > 0
            left = i;
            break
        end
    end

    for i = col:(-1):1
        if sum(img(:,i)) > 0
            right = i;
            break
        end
    end
    bb.top = top;
    bb.bottom = bottom;
    bb.left = left;
    bb.right = right;
    %y = img(top:bottom, left:right);
end
