function [eventInfo] = User_driven_event(N_user, N_appType, T_totalSim, flag,Event)
% Outcome: This function generates event information on the time a task is generated and its size
% Assum1: Each user is assumed to use an application (single task type)
% Assum2: Three different types of tasks are considered

%% NEW CODE
% flag        = 1;   % Each UE may have single (flag 0) or multiple task types (flag 1)
ui_taskType = randi(N_appType,[1,N_user]); % Each user is assumed to use an application (single task type) 
appData     = cell(1,N_appType);  % 3 different applications
% Later we could consider different combinations, but now simple one.
%Demand       AvgSize(kB)    Intensity(cycles/bit)   deadline(sec) 
appData{1}  = [0.5e3         250                    .15];   % Light
appData{2}  = [1.0e3         2500                   .20];   % Medium
appData{3}  = [1.5e3         10000                  .25];   % Heavy
N_cell      = 1;
Epoch       = .5; % 0.1 or 0.5 or 1.0sec controllable for insane result
Lambda      = N_user/N_cell/Epoch; %Number of active users/packets within time duration Epoch 
Lambda = Lambda * Event;
t           = -log(rand)/Lambda;
n           = 0;
et          = 0;
while t < T_totalSim
    n = n + 1;
    ui(n) = randi(N_user); % userId
    if flag == 0
        tt(n) = ui_taskType(ui(n)); % single taskType 
    else
        tt(n) = randi(N_appType); % multiple taskType
    end
    ts(n) = appData{tt(n)}(1) + appData{tt(n)}(1)*(rand()*0.2 - 0.1); %taskSize
    et(n) = t;
    t = t - log(rand)/Lambda;
end
eventInfo{1} = et; % sorted time
eventInfo{2} = ui; % user index based on sorted time
eventInfo{3} = tt; % task type based on sorted time
eventInfo{4} = ts; % task size based on sorted time
                   % Later, we may consider different computation intensities for different applications 
                   % Later, we may also consider some applicaion specific RTT deadline



%% Check the individual pkt generation interval and control it with "Epoch"
% idx = eventInfo{2}==1; % user id  1
% figure
% subplot(2,1,1)
% plot(eventInfo{1}(idx),eventInfo{2}(idx),'ro');
% subplot(2,1,2)
% plot(eventInfo{1}(idx),eventInfo{3}(idx),'ro');

% close all
% clear all
% clc

% N_user     = 50; % Number of offloading service users
% N_appType  = 3;   % Number of application types
% T_totalSim = 60*60*1; % Total simulation time 60sec*60min*1hour
% T_totalSim = 59;
%% OLD CODE
% appData    = cell(1,N_appType);  % 3 different applications
% 
% %            intvl(sec)  size(kB)      active(sec) idle(sec)
% appData{1} = [02         0.5e3         40          20];   % Low
% appData{2} = [05         1.0e3         45          25];   % Medium
% appData{3} = [10         1.5e3         15          90];   % High
% 
% taskGeneration = cell(1,4); 
% for n = 1:N_user
%     
%     taskType        = randi(N_appType); % each user is assumed to randomly choose single taskType for the whole simulation time. 
%     avg_taskArrvl   = appData{taskType}(1);
%     avg_taskSize    = appData{taskType}(2);
%     avg_actvPeriod  = appData{taskType}(3);
%     avg_idlePeriod  = appData{taskType}(4);
%     
%     act_startTime   = rand(1)*10; % active period starts shortly after the simulation started
%     act_Temp        = act_startTime;  
%     while act_Temp < T_totalSim
%         act_taskArrvl = exprnd(avg_taskArrvl); 
%         act_Temp      = act_Temp + act_taskArrvl;
%         if act_Temp > act_startTime + avg_actvPeriod
%             act_startTime = act_startTime + avg_actvPeriod + avg_idlePeriod;
%             act_Temp      = act_startTime;
%         end
%         taskGeneration{1} = [taskGeneration{1} act_Temp]; % time stamp
%         taskGeneration{2} = [taskGeneration{2} n];        % user index  
%         taskGeneration{3} = [taskGeneration{3} taskType]; % task type
%         taskGeneration{4} = [taskGeneration{4} avg_taskSize+ (rand()*avg_taskSize*0.2 - avg_taskSize*0.1)]; % task size
%         
%     end
% end
% [sorted, idx] = sort(taskGeneration{1});
% eventInfo{1} = taskGeneration{1}(idx); % sorted time
% eventInfo{2} = taskGeneration{2}(idx); % user index based on sorted time
% eventInfo{3} = taskGeneration{3}(idx); % task type based on sorted time
% eventInfo{4} = taskGeneration{4}(idx); % task size based on sorted time



