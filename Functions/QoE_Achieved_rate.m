function QoE_Achieved_rate(rk, xk, req, Ut,UserMatrix)
%%
Rk = TD_TD(rk .* xk, size(xk,1), size(xk,3));
% mean_Rk = mean(Rk(Rk>0));
mean_Rk = mean(Rk);
figure('DefaultAxesFontSize',18);
hold on;
cdfplot(mean_Rk*20);
xlabel('Average achieved rate (Mbps)');
ylabel('CDF');
hold off;
end