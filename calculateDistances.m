function distances = calculateDistances(cities, edge_weight_type)
    switch edge_weight_type
        case 'EUC_2D'
            distances = calculateEUC2D(cities);
        case 'EUC_3D'
            distances = calculateEUC3D(cities);
        case 'MAX_2D'
            distances = calculateMAX2D(cities);
        case 'MAX_3D'
            distances = calculateMAX3D(cities);
        case 'MAN_2D'
            distances = calculateMAN2D(cities);
        case 'MAN_3D'
            distances = calculateMAN3D(cities);
        case 'CEIL_2D'
            distances = calculateCEIL2D(cities);
        case 'GEO'
            distances = calculateGEO(cities);
        case 'ATT'
            distances = calculateATT(cities);
        otherwise
            error('未知的边权类型 %s', edge_weight_type);
    end
end

function distances = calculateEUC2D(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = cities(i, 1) - cities(j, 1);
            yd = cities(i, 2) - cities(j, 2);
            distances(i, j) = round(sqrt(xd * xd + yd * yd));
        end
    end
end

function distances = calculateEUC3D(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = cities(i, 1) - cities(j, 1);
            yd = cities(i, 2) - cities(j, 2);
            zd = cities(i, 3) - cities(j, 3);
            distances(i, j) = round(sqrt(xd * xd + yd * yd + zd * zd));
        end
    end
end

function distances = calculateMAX2D(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = abs(cities(i, 1) - cities(j, 1));
            yd = abs(cities(i, 2) - cities(j, 2));
            distances(i, j) = max(round(xd), round(yd));
        end
    end
end

function distances = calculateMAX3D(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = abs(cities(i, 1) - cities(j, 1));
            yd = abs(cities(i, 2) - cities(j, 2));
            zd = abs(cities(i, 3) - cities(j, 3));
            distances(i, j) = max(round(xd), round(yd), round(zd));
        end
    end
end

function distances = calculateMAN2D(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = abs(cities(i, 1) - cities(j, 1));
            yd = abs(cities(i, 2) - cities(j, 2));
            distances(i, j) = round(xd + yd);
        end
    end
end

function distances = calculateMAN3D(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = abs(cities(i, 1) - cities(j, 1));
            yd = abs(cities(i, 2) - cities(j, 2));
            zd = abs(cities(i, 3) - cities(j, 3));
            distances(i, j) = round(xd + yd + zd);
        end
    end
end

function distances = calculateCEIL2D(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = cities(i, 1) - cities(j, 1);
            yd = cities(i, 2) - cities(j, 2);
            distances(i, j) = ceil(sqrt(xd * xd + yd * yd));
        end
    end
end

function distances = calculateGEO(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    
    PI = 3.141592;
    RRR = 6378.388;
    
    latitudes = zeros(numCities, 1);
    longitudes = zeros(numCities, 1);
    
    for i = 1:numCities
        x = cities(i, 1);
        y = cities(i, 2);
        
        deg = floor(x);
        min = x - deg;
        latitudes(i) = PI * (deg + 5.0 * min / 3.0) / 180.0;
        
        deg = floor(y);
        min = y - deg;
        longitudes(i) = PI * (deg + 5.0 * min / 3.0) / 180.0;
    end
    
    for i = 1:numCities
        for j = 1:numCities
            q1 = cos(longitudes(i) - longitudes(j));
            q2 = cos(latitudes(i) - latitudes(j));
            q3 = cos(latitudes(i) + latitudes(j));
            
            distances(i, j) = round(RRR * acos(0.5 * ((1.0 + q1) * q2 - (1.0 - q1) * q3)) + 1.0);
        end
    end
end

function distances = calculateATT(cities)
    numCities = size(cities, 1);
    distances = zeros(numCities);
    for i = 1:numCities
        for j = 1:numCities
            xd = cities(i, 1) - cities(j, 1);
            yd = cities(i, 2) - cities(j, 2);
            rij = sqrt((xd * xd + yd * yd) / 10.0);
            tij = round(rij);
            if tij < rij
                distances(i, j) = tij + 1;
            else
                distances(i, j) = tij;
            end
        end
    end
end
