function plot_total_distance(iterationDistances)
    figure;
    hold on;
    for ray = 1:size(iterationDistances, 2)
        plot(1:size(iterationDistances, 1), iterationDistances(:, ray), 'b-');
    end
    xlabel('迭代次数');
    ylabel('总路程');
    title('当前路径总路程随迭代次数的变化');
    hold off;
end
