function T = ResourceDistribution(UserMatrix, events, IsBlocked_loc)
% SimulationHorizon = size(UserMatrix,3);
% Number_User = size(UserMatrix,1);
Total_Requests = zeros(1, 4);
Accepted_Requests = zeros(1, 4);
Hasta = TD_TD(UserMatrix(:,5,:), size(UserMatrix,1), size(UserMatrix,3));
Blocked = TD_TD(UserMatrix(:,7,:), size(UserMatrix,1), size(UserMatrix,3));
Res = TD_TD(UserMatrix(:,2,:), size(UserMatrix,1), size(UserMatrix,3));
% Req = TD_TD(UserMatrix(:,2,:), size(UserMatrix,1), size(UserMatrix,3));
Total_Requests(1) = sum(sum(Hasta==1));
Total_Requests(2) = sum(sum(Hasta==2));
Total_Requests(3) = sum(sum(Hasta==3));
Total_Requests(4) = sum(sum(Hasta==4));
for i = 1: size(Blocked, 1)
    for j = 1 : size(Blocked,2)
        if (Blocked(i,j)==0 && Hasta(i,j)>1)
            Accepted_Requests(Hasta(i,j)) = Accepted_Requests(Hasta(i,j)) + 1;
        end
        if(Hasta(i,j)==1 && Res(i,j)>0)
            Accepted_Requests(Hasta(i,j)) = Accepted_Requests(Hasta(i,j)) + 1;
        end
    end
end
if(sum(sum(Hasta==1))==0) % No request is sent
    unconnected = sum(sum(Hasta,2)==0);
    Accepted_Requests(1)=size(Hasta,1)-unconnected;
    Total_Requests(1) = size(Hasta,1);
end
if(sum(sum(Hasta==1))>0 && sum(sum(Hasta,2)==0)>0) % There is active requests but also unconnected
    unconnected = sum(sum(Hasta,2)==0);
    Total_Requests(1) = Total_Requests(1) +unconnected;
end

% for l = 1 : size(events,1)
% %     Total_Requests(events(l,3)) = Total_Requests(events(l,3))+1;
%     if(UserMatrix(events(l,2),IsBlocked_loc, events(l,1))==0)
%         Accepted_Requests(events(l,3)) = Accepted_Requests(events(l,3))+1;
%     end
% end
Total_Requests(Total_Requests==0)=1;
T = Accepted_Requests*100./Total_Requests;
% figure('DefaultAxesFontSize',18);
% hold on;
% bar(T.', 'stacked');
% xlabel('User ID');
% ylabel('Request Acceptance Ratio per Service Type');
% % legend('Queueing Delay');%, 'Transmission Delay');%, 'Execution Delay');
% grid on;
% hold off;


end