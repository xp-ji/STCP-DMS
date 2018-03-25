clear all; close all; clc;

binPath = './Depth';
matSave = './Datasets/MSRAction3D';

acts = 20;
sbjs = 10; 
exps = 3;


if ~isdir(matSave)
    mkdir(matSave);
end

for i = 1:20
    idxcls = sprintf('a%02d', i);
    
    for j = 1:10
        idxsbj = sprintf('s%02d', j);
        
        for k = 1:3
            idxexp = sprintf('e%02d', k);
                                   
            % read depth sequences from a binary file
            actName = [idxcls, '_', idxsbj, '_', idxexp];
            binName = [binPath,'/', actName, '_sdepth.bin'];
            
            % some missed videos
            if ~exist(binName, 'file')
                continue;
            end
            
            depth = readDepthBin(binName);
            
            display(['covert bin to mat: ', idxcls, '_', idxsbj, '_', idxexp, ' ......']);
           
            
            % save the matrix file
            matName = [matSave,'/', idxcls, '_', idxsbj, '_', idxexp, '_sdepth.mat'];
            save(matName, 'depth');

        end
    end
end

function depth = readDepthBin(fileName)

	fp = fopen(fileName, 'rb');

	if fp < 0
	    depth = [];
	    return;
	end

	header = fread(fp, 3, 'int32');
	nfrms = header(1); 
	ncols = header(2); 
	nrows = header(3);

	depth = zeros(nrows, ncols, nfrms);

	for i = 1:nfrms
	    temp = fread(fp, [ncols, nrows], 'int32');
	    depth(:, :, i) = temp';
	end

	fclose(fp);

end
