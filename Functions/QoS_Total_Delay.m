function QoS_Total_Delay(Ttr, Tmig, Texec, Cell_Change_loc, Demand_Time_loc,Queue_Delay_loc, UserMatrix)

% Total delay is the summation of queueing delay, transmission delay,
% execution delay and th e migration delay. 

%% T queueing
dummy = TD_TD(UserMatrix(:,Queue_Delay_loc,:), size(UserMatrix,1),size(UserMatrix, 3));
Tqueueing = dummy (:, size(dummy,2))';
%% T migration calculation
pre_m = TD_TD(UserMatrix(:,Cell_Change_loc,:), size(UserMatrix,1),size(UserMatrix, 3));
for i =1 : size(pre_m,1)
    m(i) = max(pre_m(i,:));
end
Tmigration = Tmig * m;
%% T execution calculation
pre_r = TD_TD(UserMatrix(:,Demand_Time_loc,:), size(UserMatrix,1),size(UserMatrix, 3));
pre_r(pre_r<0)=0;
r = sum(pre_r, 2);
Texecution = (Texec .* r)';
%% T transmission calculation
% NOT SURE OF THIS
Ttrans = (r .* 0.5 .* Ttr)';

%% Plotting

T = [Tqueueing; Tmigration];%; Ttrans]; %Texecution];
figure('DefaultAxesFontSize',18);
hold on;
bar(T.', 'stacked');
xlabel('Users ID');
ylabel('Total Delay');
legend('Queueing Delay', 'Migration Delay');%, 'Transmission Delay');%, 'Execution Delay');
grid on;
hold off;
end