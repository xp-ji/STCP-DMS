function info = getDataTables(info)

    info.dataTable = cell(1000, 4);
    idx = 1; 
    for ai = 1: info.acts
        ai_str = sprintf('a%02d', ai);
        
        for si = 1: info.subs
            si_str = sprintf('s%02d',si);
            
            for ei = 1: info.exps
                ei_str = sprintf('e%02d',ei);
                
                dataName = [ai_str,'_',si_str,'_',ei_str];
                dataPath = [info.dataPath,'/',dataName,'_sdepth.mat'];
                
                 % some missed videos
                if ~exist(dataPath, 'file')
                    continue;
                end
                
                info.dataTable{idx,1} = dataName;
                info.dataTable{idx,2} = ai;
                info.dataTable{idx,3} = si;
                info.dataTable{idx,4} = ei;
                idx = idx +1;
            end
        end
    end
    info.dataTable(idx:end,:)=[];
    info.dataSum  = idx- 1;
end
