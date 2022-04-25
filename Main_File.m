Copyright (c) 2022 Aalto University

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

% clc; 
% close all;
% clear;
cd Functions;
addpath /Library/gurobi801/mac64/matlab
savepath
%% INPUT Datasets
source = "100"; % Dataset
EventRate = 0.8; % Less is more! varies between 0.5 =>1.1
servicediff=0;
[traffic] = preprocess("Input.csv", source);
traffic(:,1)=[];
traffic(1,:)=[];
traffic(:,2)=traffic(:,2)+1;
[bus] = preprocess("bus.csv", source);
bus(:,1)=[];
bus(:,3:7)=[];  % Removing some of the data as they are not needed, change if you need them
bus(:,1:2)=bus(:,1:2)+1;    % The data starts from 0 --> moving it to 1
%% Duration of simulation & users -- upperbounds
TimeFilter = 200;
UserFilter = 500;
Simulation_Duration = traffic(size(traffic,1),1);
USERCOUNT = max(traffic(:,2));
CELLCOUNT = max(traffic(:,size(traffic,2))); 
USERCOUNT = min(USERCOUNT, UserFilter);
Simulation_Duration = min(Simulation_Duration, TimeFilter);

%% SIMULATION PARAMETERS
Ttr = 1;
Texec = 1;
Tmig = 1;
GAMMA = 0.000001;
price_list = [1 2 5 10]; % Price of certain services
APP0_R = [0.05 0.07 0.071]; %R1 R2 R3 %BG
APP1_R = [0.01 0.075 0.4]; %R1 R2 R3 %M2M
APP2_R = [0.1 0.225 0.55]; %R1 R2 R3 %Inelastic 
APP3_R = [0 1.083 20]; %R1 R2 R3 %Elastic
APP0_U = [0 1 1]; %U1 U2 U3
APP1_U = [-1 0.7 1]; %U1 U2 U3
APP2_U = [-0.5 0.7 1]; %U1 U2 U3
APP3_U = [0 1 1.8]; %U1 U2 U3
W = [1 1 1 1]; % Per App type
%% AUXILIARY VARIABLES
%  UserID | loc | Simulation_Time
SINR_loc = 1;
SpectralResources_loc = 2;
Demand_Time_loc = 3;
Demand_Resource_loc = 4;
Demand_ServiceType_loc = 5;
Cell_ID_loc = 6;
IsBlocked_loc = 7;
Rem_Time_loc = 8;
X_loc = 9;
Y_loc =10;
Speed_loc =11;
Completed_loc =12;
Queue_Delay_loc = 13;
Cell_Change_loc =14;

CellMatrix = zeros(CELLCOUNT, 3, Simulation_Duration); 
% CellMatrix(:,2,:) = 5e3; % Default edge capacity % it should be 5 e3
B_pow = 5e3; % if it is 0 - no fog devices on buses
% B_pow = 0; % if it is 0 - no fog devices on buses
UserMatrix = UserMatrix_Func(USERCOUNT, Simulation_Duration, traffic, SINR_loc, Cell_ID_loc, X_loc, Y_loc, Speed_loc, 14);
% UserMatrix(:,SINR_loc,:) = UserMatrix(:,SINR_loc,:)*0.5;
ServiceRequirements = [ APP0_R;
                        APP1_R;
                        APP2_R;
                        APP3_R;
                        ];
ServiceUtilities = [ APP0_U;
                     APP1_U;
                     APP2_U;
                     APP3_U;
                     ];
%% THE EVENT GENERATION ~ PER TTI
% dummy = User_driven_event(USERCOUNT,3, Simulation_Duration, 1, 1); % 1 -> heterogenous services
events = zeros(1,4);
for n = 1 : Simulation_Duration
    port = UserMatrix(:,Cell_ID_loc,n)>0;
    dummy = Ozgur_User_driven_event(sum(port,1),3, 1, 1, EventRate , UserMatrix(:,Cell_ID_loc,n)>0);
    dummy = reshape(cell2mat(dummy), [size(dummy{1},2) 4]);
    dummy( ~any(dummy,2), : ) = [];
    dummy(:,1) = n; 
    events = [events; dummy];
end
events(1,:)=[];
% if(servicediff==0)
%     events(:,3)=3;
%     events(:,4)=987;
% end
for i = 1 : size(events,1)
    time_slot = events(i,1);
    user = events(i,2);
    app_type = events(i,3);
    demand = events(i,4);
    UserMatrix(user,Demand_ServiceType_loc,time_slot) = app_type;
    UserMatrix(user,Demand_Time_loc,time_slot) = 1;
    UserMatrix(user,Demand_Resource_loc,time_slot) = demand;
end
UserMatrix(:,Rem_Time_loc,1) = UserMatrix(:,Demand_Time_loc,1);
Unserved = zeros(1, USERCOUNT);
%% SIMULATOR
for n =1:1:Simulation_Duration
    for c = 1:1:CELLCOUNT
        [UserMatrix(:,:,n), CellMatrix(c,:,n)] = Scheduler(UserMatrix(:,:,n), CellMatrix(c,:,n), c, price_list, Cell_ID_loc, SpectralResources_loc, GAMMA, Demand_Resource_loc, IsBlocked_loc, Rem_Time_loc, Demand_ServiceType_loc, bus(bus(:,1)==n & bus(:,5)==c, :), Demand_ServiceType_loc, ServiceRequirements, ServiceUtilities, W, B_pow);
    end
    % Update process
    if (n>1) %only migration and completed tasks
        [CellMatrix(:,:,n), UserMatrix(:,:,n)]= Default_CellUpdate(CellMatrix(:,:,n-1), UserMatrix(:,:,n-1), UserMatrix(:,:,n), Cell_ID_loc, Demand_Resource_loc, IsBlocked_loc, Completed_loc, Rem_Time_loc, Cell_Change_loc);    
    end
    for user = 1: USERCOUNT % Queueing delays
        if user==144 && n == 5
            user;
        end
        if (n>1) % Setting the initial value for the Queue
            UserMatrix(user,Queue_Delay_loc,n)=UserMatrix(user,Queue_Delay_loc,n-1);
        end
        % If the user had a task, connected the base station but didnot
        % served
        if (UserMatrix(user,Rem_Time_loc,n)>0 &&  UserMatrix(user,IsBlocked_loc,n)==1 && UserMatrix(user,SINR_loc,n)>0)
            UserMatrix(user,Queue_Delay_loc,n)=UserMatrix(user,Queue_Delay_loc,n)+1;
        end
        if n<Simulation_Duration
            if (UserMatrix(user,Demand_Time_loc,n+1)>0 && UserMatrix(user,Rem_Time_loc,n)>0)
                if n>1
                    Unserved(user) = Unserved(user)+1;
                end
                UserMatrix(:,Rem_Time_loc,n+1) = UserMatrix(:,Demand_Time_loc,n+1);
            elseif (UserMatrix(user,Demand_Time_loc,n+1)==0 && UserMatrix(user,Rem_Time_loc,n)>=0)
                UserMatrix(:,Rem_Time_loc,n+1) = UserMatrix(:,Rem_Time_loc,n);
            else
                UserMatrix(:,Rem_Time_loc,n+1) = UserMatrix(:,Demand_Time_loc,n+1);
            end
        end
    end
    
%     UserMatrix(:,Rem_Time_loc,n) = UserMatrix(:,Demand_Time_loc,n);
end
% Measuring the cell edge load
% ResourceDistribution(UserMatrix, events,IsBlocked_loc);
% Acceptance_ratio(Unserved, events)
% QoS_Cell_based(Cell_ID_loc, Ttr, Tmig, Texec, Cell_Change_loc, Demand_Time_loc,Queue_Delay_loc, UserMatrix)
% QoS_Total_Delay(Ttr, Tmig, Texec, Cell_Change_loc, Demand_Time_loc,Queue_Delay_loc, UserMatrix)
% QoE_Achieved_rate(log2(1+UserMatrix(:,SINR_loc,:)/GAMMA), UserMatrix(:,SpectralResources_loc,:), ServiceRequirements, ServiceUtilities, UserMatrix)

cd ..
