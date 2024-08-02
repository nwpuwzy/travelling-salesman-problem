function distance = calculateTotalDistance(path, distances)
    distance = 0;
    for j = 1:(length(path) - 1)
        distance = distance + distances(path(j), path(j + 1));
    end
    distance = distance + distances(path(end), path(1)); % 回到起点
end
