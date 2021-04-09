function AcceptanceRatio=Acceptance_ratio(Unserved, events)
Tot_Users = size(Unserved, 2);
% AcceptanceRatio = zeros (1, Tot_Users);
Tot_requests = zeros (1, Tot_Users);
for l =1 : size(events, 1)
    if(events(l,1)<max(events(:,1)) && events(l,1)>1)
        Tot_requests(1,events(l,2))=Tot_requests(1,events(l,2))+1;
    end
end
AcceptanceRatio = Tot_requests - Unserved;
Tot_requests(Tot_requests==0)=1;
AcceptanceRatio = (AcceptanceRatio*100./Tot_requests);

% figure('DefaultAxesFontSize',18);
% hold on;
% bar(AcceptanceRatio.', 'stacked');
% xlabel('User ID');
% ylabel('Request Acceptance Ratio');
% % legend('Queueing Delay');%, 'Transmission Delay');%, 'Execution Delay');
% grid on;
% hold off;
end