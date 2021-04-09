function plot_QueueingDelay(DataMatrix)
    figure('DefaultAxesFontSize',18);
    hold on;
    title('Queueing Delay per User');
    ylim([0 inf])
    xlabel('User');
    ylabel('Total delay');
    bar(sum(DataMatrix));
    hold off;
end