clc; clear all; close all;
% hold on;
UPBOUND=50;
fprintf("Will be run for %i instances\n", UPBOUND);
for mircolo = 1 : UPBOUND
    clc; clearvars -except mircolo UPBOUND;
    fprintf("Step %i in progress\n", mircolo);
    Main_File();
    filename = (int2str(mircolo) + ".mat");
    cd Results;
    save(filename);
    cd ..;
end

Mitico_Matrix =zeros(size(UserMatrix,1), size(UserMatrix,2), size(UserMatrix,3));
Mitico_AcceptanceRatio = zeros(1, USERCOUNT);
Mitico_RESDISP = zeros (1, 4);
Mitico_Cell = zeros(1, 12);

fprintf("Completed\n"); clearvars -except UPBOUND Mitico_Cell Mitico_RESDISP Mitico_Matrix Mitico_AcceptanceRatio;

%% For Printing
cd Results;
% UPBOUND=50;
for mitico = 1 : UPBOUND
    infile = (int2str(mitico) + ".mat");
    load(infile);
    clearvars -except UPBOUND mitico UserMatrix Mitico_Cell Mitico_RESDISP Unserved IsBlocked_loc events Mitico_AcceptanceRatio Cell_ID_loc Ttr Tmig Texec Cell_Change_loc Demand_Time_loc Queue_Delay_loc Mitico_Matrix;
    Mitico_Matrix = Mitico_Matrix + UserMatrix;
    cd ..
    cd Functions
    Mitico_AcceptanceRatio = Mitico_AcceptanceRatio + Acceptance_ratio(Unserved, events);
    Mitico_RESDISP = Mitico_RESDISP + ResourceDistribution(UserMatrix, events,IsBlocked_loc);
    Mitico_Cell = Mitico_Cell + QoS_Cell_based(Cell_ID_loc, Ttr, Tmig, Texec, Cell_Change_loc, Demand_Time_loc,Queue_Delay_loc, UserMatrix);
    cd ..
    cd Results
end
Mitico_Matrix = Mitico_Matrix/UPBOUND;
Mitico_AcceptanceRatio = Mitico_AcceptanceRatio/UPBOUND;
Mitico_RESDISP = Mitico_RESDISP/UPBOUND;
Mitico_Cell = Mitico_Cell/UPBOUND;

infile = (int2str(mitico) + ".mat");
load(infile);

cd ..; cd Functions;

QoS_Total_Delay(Ttr, Tmig, Texec, Cell_Change_loc, Demand_Time_loc,Queue_Delay_loc, Mitico_Matrix)
QoE_Achieved_rate(log2(1+Mitico_Matrix(:,SINR_loc,:)/GAMMA), Mitico_Matrix(:,SpectralResources_loc,:), ServiceRequirements, ServiceUtilities, Mitico_Matrix)
plotting_general(Mitico_Cell, 'Cell ID', 'Congestion Duration (%Time)');
plotting_general(Mitico_AcceptanceRatio, 'User ID', 'Request Acceptance Ratio');
plotting_general(Mitico_RESDISP', 'Service Type', 'Request Acceptance Ratio per Service Type');
% ResourceDistribution(UserMatrix, events,IsBlocked_loc);
% Acceptance_ratio(Unserved, events) QoS_Cell_based(Cell_ID_loc, Ttr, Tmig,
% Texec, Cell_Change_loc, Demand_Time_loc,Queue_Delay_loc, Mitico_Matrix)
cd ..
