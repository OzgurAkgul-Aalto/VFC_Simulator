function [eventInfo] = Ozgur_User_driven_event(N_user, N_appType, T_totalSim, flag,Event, port)
%% NEW CODE
ui_taskType = randi(N_appType,[1,N_user]); % Each user is assumed to use an application (single task type) 
appData     = cell(1,N_appType);  % 3 different applications
% Later we could consider different combinations, but now simple one.
%Demand       AvgSize(kB)    Intensity(cycles/bit)   deadline(sec) 
% appData{1}  = [0                 0                  .25];   % Empty requests
appData{1}  = [0.5e3         250                    .15];   % Light
appData{2}  = [1.0e3         2500                   .20];   % Medium
appData{3}  = [1.5e3         10000                  .25];   % Heavy
N_cell      = 1;
Epoch       = .5; % 0.1 or 0.5 or 1.0sec controllable for insane result
Lambda      = N_user/N_cell/Epoch; %Number of active users/packets within time duration Epoch 
% Lambda = Lambda * Event;
t           = -log(rand)/Lambda;
n           = 0;
et          = 0;

arc = poissrnd(N_user,N_user,1);
arc = arc/max(arc);
arc(arc>= Event * mean(arc))=1;
arc(arc< Event * mean(arc))=0;

for k = 1 : size(port,1)
    
    if(port(k)>0)
        n = n + 1;
        if(arc(n)>0)
            ui(n) = k;  % userId
            if flag == 0
                tt(n) = ui_taskType(ui(n)); % single taskType 
            else
                tt(n) = randi(N_appType); % multiple taskType
            end
            ts(n) = appData{tt(n)}(1) + appData{tt(n)}(1)*(rand()*0.2 - 0.1); %taskSize
            et(n) = t;
            t = t - log(rand)/Lambda;
        end
    end
end

% while t < T_totalSim
% %     n = n + 1;
% %     ui(n) = randi(N_user); % userId
%     if flag == 0
%         tt(n) = ui_taskType(ui(n)); % single taskType 
%     else
%         tt(n) = randi(N_appType); % multiple taskType
%     end
%     ts(n) = appData{tt(n)}(1) + appData{tt(n)}(1)*(rand()*0.2 - 0.1); %taskSize
%     et(n) = t;
%     t = t - log(rand)/Lambda;
% end
eventInfo{1} = et; % sorted time
eventInfo{2} = ui; % user index based on sorted time
eventInfo{3} = tt; % task type based on sorted time
eventInfo{4} = ts; % task size based on sorted time
                   % Later, we may consider different computation intensities for different applications 
                   % Later, we may also consider some applicaion specific RTT deadline

