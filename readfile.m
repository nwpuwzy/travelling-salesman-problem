function [cities, edge_weight_type] = readfile(filename)
    fileID = fopen(filename, 'r');
    if fileID == -1
        error('无法打开文件 %s', filename);
    end
    
    numCities = 0;
    cities = [];
    edge_weight_type = '';
    
    while ~feof(fileID)
        line = fgetl(fileID);
        
        if startsWith(line, 'DIMENSION')
            numCities = sscanf(line, 'DIMENSION : %d');
        elseif startsWith(line, 'EDGE_WEIGHT_TYPE')
            edge_weight_type = sscanf(line, 'EDGE_WEIGHT_TYPE : %s');
        elseif startsWith(line, 'NODE_COORD_SECTION')
            cities = zeros(numCities, 2);
            for i = 1:numCities
                line = fgetl(fileID);
                data = sscanf(line, '%d %f %f');
                cities(data(1), :) = data(2:3);
            end
        elseif startsWith(line, 'EOF')
            break;
        end
    end
    
    fclose(fileID);
end
