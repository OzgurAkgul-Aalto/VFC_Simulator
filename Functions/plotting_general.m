function plotting_general(value, x_text, y_text)

figure('DefaultAxesFontSize',18);
hold on;
bar(value.', 'stacked');
xlabel(x_text);
ylabel(y_text);
grid on;
hold off;

end