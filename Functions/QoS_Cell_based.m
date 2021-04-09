function T = QoS_Cell_based(Cell_ID_loc, Ttr, Tmig, Texec, Cell_Change_loc, Demand_Time_loc,Queue_Delay_loc, UserMatrix)
% Demand time+2 --> demand type
% Isblocked = CellID+1
dummy = TD_TD(UserMatrix(:,Cell_ID_loc,:), size(UserMatrix,1),size(UserMatrix, 3));
blocked = TD_TD(UserMatrix(:,Cell_ID_loc+1,:), size(UserMatrix,1),size(UserMatrix, 3));
dummy2 = TD_TD(UserMatrix(:,Queue_Delay_loc,:), size(UserMatrix,1),size(UserMatrix, 3));
type = TD_TD(UserMatrix(:,Demand_Time_loc+2,:), size(UserMatrix,1),size(UserMatrix, 3));
Cells = zeros(1, max(max(dummy)));
Cell_trace = zeros(size(dummy,2), max(max(dummy)));
Cell_trace_users = zeros(size(dummy,2), max(max(dummy)));
Unconnected_users = size(blocked( ~any(dummy,2), : ),1);
blocked( ~any(dummy,2), : ) = [];
dummy2( ~any(dummy,2), : ) = [];
type( ~any(dummy,2), : ) = [];
dummy( ~any(dummy,2), : ) = [];
% if there is at least 1 unserved user --> there is a bootleneck at the
% cell

for i = 1 : size(dummy,1)
    for j = 1: size(dummy,2)
        if(dummy(i,j)==0)
            blocked(i,j) = 1;
        end
        if (dummy(i,j)>0) % If the user is connected to a cell
            Cell_trace_users(j,dummy(i,j)) = Cell_trace_users(j,dummy(i,j))+1;
            % First tracing the total number of users at each TTI
            if blocked(i,j)>0
                if Cell_trace(j,dummy(i,j)) == 0 % Firts time reporting  
                   Cells(1,dummy(i,j))=Cells(1,dummy(i,j))+1;
                   Cell_trace(j,dummy(i,j)) = 1;
                end
            end
        end
    end
end
%% Plotting
% for c= 1:size(Cell_trace_users,2)
%     arc(c) =  
% end
T = Cells*100./sum(Cell_trace_users~=0,1);%When the cell had users but did not served
% figure('DefaultAxesFontSize',18);
% hold on;
% bar(T.');%, 'stacked');
% xlabel('Cell ID');
% ylabel('Congestion Duration (%Time)');
% % legend('Queueing Delay', 'Migration Delay', 'Transmission Delay', 'Execution Delay');
% set(gca, 'XTick',1:1:size(Cells,2));
% ylim([0 100]);
% grid on;
% hold off;
end