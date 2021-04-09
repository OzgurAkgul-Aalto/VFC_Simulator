%%%%%%%% DEFAULT USER UPDATE %%%%%%%%
% DETAILS: DETERMINES THE OFFLOADED/MIGRATED USERS BETWEEN BASE STATIONS
% AND RETURNS A SORTED LIST OF UPDATED CELLS
% CellMatrix_Update = <Old base Station ID, Moved UserID, New Base Station ID>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CellMatrix_Update = Default_UserUpdate(UserMatrix_old, UserMatrix_new)
%  UserID | <SINR, [Demand:: Time || Resource || ServiceType], CellID, Finished, Rem_Time > | Simulation_Time
    CellID_Location = size(UserMatrix_old,2)-3;
    counter = 1;
    for user = 1:1:size(UserMatrix_old, 1)
        if (UserMatrix_old(user, CellID_Location) ~= UserMatrix_new(user, CellID_Location))
           % Then the user has switched base station
           CellMatrix_Update(counter,1) = UserMatrix_old(user, CellID_Location); % Old base station
           CellMatrix_Update(counter,2) = user; % User information
           CellMatrix_Update(counter,3) = UserMatrix_new(user, CellID_Location); % New base station
           counter = counter + 1;
        end
    end
    sortrows(CellMatrix_Update)
end