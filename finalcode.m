clear all
clc
% 参数设置
t_values = 1:10000000; % 时间t的取值
refractionProbability = 0.8; % 折射概率
bounds = [10, 10, 10]; % 立方体边界
numRays = 8; % 光线数量

% 读取 TSPLIB 数据
filename = 'kroB200.tsp';
[cities, edge_weight_type] = readfile(filename);
numCities = size(cities, 1);

% 开始计时
tic;

% 运行优化算法
[bestPath, iterationDistances] = optimize(t_values, refractionProbability, bounds, numRays, cities, edge_weight_type, numCities);

% 结束计时并显示时间
elapsed_time = toc;
disp(['本次优化所用的时间为: ', num2str(elapsed_time), ' 秒']);

% 绘制总路程随迭代次数的变化
plot_total_distance(iterationDistances);

% 绘制最优路径
plot_best_path(cities, bestPath);

function [bestPath, iterationDistances] = optimize(t_values, refractionProbability, bounds, numRays, cities, edge_weight_type, numCities)
    % 初始化空间振幅和忍耐值数组
    initialAmplitude = 4; % 初始空间振幅 numCities / numRays
    amplitude_values = initialAmplitude * ones(numCities, 1);
    initialTolerance = numCities; % 初始忍耐值
    tolerance_values = initialTolerance * ones(numCities, 1);

    % 根据边权类型计算城市之间的距离矩阵
    distances = calculateDistances(cities, edge_weight_type);

    % 随机生成八条初始路径解
    paths = cell(numRays, 1);
    for i = 1:numRays
        paths{i} = randperm(numCities);
    end

    % 计算每条路径的初始路径长度
    currentDistances = zeros(numRays, 1);
    bestDistances = zeros(numRays, 1);
    bestPaths = cell(numRays, 1);
    for i = 1:numRays
        currentDistances(i) = calculateTotalDistance(paths{i}, distances);
        bestDistances(i) = currentDistances(i);
        bestPaths{i} = paths{i};
    end

    % 初始化光线位置和方向
    initial_positions = rand(numRays, 3) .* bounds; % 随机初始位置
    directions = rand(numRays, 3) * 2 - 1; % 随机方向向量
    directions = directions ./ vecnorm(directions, 2, 2); % 归一化方向向量
    current_positions = initial_positions; % 当前光线的位置

    % 记录每次迭代的当前路径总路程
    iterationDistances = zeros(length(t_values), numRays);

    % 主循环
    for t_idx = 1:length(t_values)
        t = t_values(t_idx);
        % 计算当前遍历到的城市
        currentCityIndex = mod(t - 1, numCities) + 1;

        % 检查当前城市的空间振幅
        if amplitude_values(currentCityIndex) == 0
            % 恢复所有城市的空间振幅为初始值
            amplitude_values = initialAmplitude * ones(numCities, 1);
            % 将当前记录的最优路径赋给每条光线
            for i = 1:numRays
                paths{i} = bestPaths{i};
            end
        else
            % 对于每条光线
            for ray = 1:numRays
                % 计算当前光线的位置并映射到城市ID
                current_positions(ray, :) = current_positions(ray, :) + directions(ray, :);
                current_positions(ray, :) = mod(current_positions(ray, :), bounds); % 确保位置在边界内

                % 映射到城市ID
                currentCityID = coordinate_to_city_id(floor(current_positions(ray, 1)), floor(current_positions(ray, 2)), floor(current_positions(ray, 3)), numCities);

                % 对当前城市与遍历到的第n个城市进行2-opt操作
                new_path = paths{ray};
                i = mod(currentCityID, numCities) + 1; % 确保索引在范围内
                j = currentCityIndex;
                if i < j
                    new_path(i:j) = paths{ray}(j:-1:i);
                elseif i > j
                    new_path(j:i) = paths{ray}(i:-1:j);
                end

                % 计算新路径总路程
                new_distance = calculateTotalDistance(new_path, distances);

                % 路径更新
                if new_distance < currentDistances(ray)
                    paths{ray} = new_path;
                    currentDistances(ray) = new_distance;
                    bestDistances(ray) = new_distance;
                    bestPaths{ray} = new_path;
                    amplitude_values(currentCityIndex) = amplitude_values(currentCityIndex) - 1; % 更新空间振幅
                    tolerance_values(currentCityIndex) = initialTolerance; % 忍耐值恢复为初始值
                else
                    if rand < refractionProbability
                        directions(ray, :) = rand(1, 3) * 2 - 1; % 随机方向
                        directions(ray, :) = directions(ray, :) / norm(directions(ray, :)); % 归一化
                    end
                    tolerance_values(currentCityIndex) = max(tolerance_values(currentCityIndex) - 1, 0); % 忍耐值减1，最小为0
                end

                % 记录当前路径总路程
                iterationDistances(t_idx, ray) = currentDistances(ray);
            end
        end

        % 打印当前八个解的最短路径
        disp(['迭代 ', num2str(t), ': 当前八个解的最短路径: ', num2str(bestDistances')]);

        % 检查所有城市的忍耐值是否都为0
        if all(tolerance_values == 0)
            iterationDistances = iterationDistances(1:t_idx, :); % 截断未使用的部分
            break;
        end
    end

    % 输出结果
    [minDistance, bestRayIdx] = min(bestDistances);
    bestPath = bestPaths{bestRayIdx};

    disp(['全局最优路径长度: ', num2str(minDistance)]);
    disp(['对应的路径: ', num2str(bestPath)]);

    function city_id = coordinate_to_city_id(x, y, z, numCities)
        % 将三维坐标 (x, y, z) 拼接成一个唯一的城市编号
        % 防止城市ID超过总数
        maxID = numCities - 1;
        city_id = mod(str2double(strcat(num2str(x), num2str(y), num2str(z))), maxID) + 1;
    end
end
