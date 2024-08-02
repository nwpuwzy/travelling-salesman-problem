function plot_best_path(cities, bestPath)
    figure;
    hold on;
    plot(cities(:, 1), cities(:, 2), 'k*'); % 绘制城市
    path_with_return = [bestPath, bestPath(1)]; % 最后一个城市连接到第一个城市
    plot(cities(path_with_return, 1), cities(path_with_return, 2), 'r-'); % 绘制最优路径
    title('最优路径');
    hold off;
end
