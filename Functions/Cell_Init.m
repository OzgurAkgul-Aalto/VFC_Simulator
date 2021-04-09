function [UserMatrix, CellMatrix] = Cell_Init(CellMatrix, UserMatrix, CellID_loc, IsBlocked_loc, USERCOUNT, Demand_Resource_loc)
    % Assuming all the vehicles are always connected at to a base station
    UserMatrix(:, IsBlocked_loc) = 0;
    for user = 1: USERCOUNT
        if(UserMatrix(user,1)==0 && UserMatrix(user, CellID_loc) ==0)
            % Skip
        else
            if(CellMatrix(UserMatrix(user, CellID_loc),1) + UserMatrix(user, CellID_loc)<= CellMatrix(UserMatrix(user, CellID_loc),2))
                CellMatrix(UserMatrix(user, CellID_loc),1) = CellMatrix(UserMatrix(user, CellID_loc),1) + UserMatrix(user, Demand_Resource_loc);     
            else
                UserMatrix(user, IsBlocked_loc) = 1;
            end
        end
    end
    
end