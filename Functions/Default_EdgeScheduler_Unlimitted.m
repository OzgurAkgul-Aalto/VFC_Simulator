%%%%%%%% DEFAULT SCHEDULER %%%%%%%%
% TYPE: UNLIMITTED EDGE RESOURCE USAGE
% MULTI-TENANCY: OFF
% DETAILS: ALL THE USERS WITH SPECTRAL RESOURCES ARE ADMITTED TO EXECUTE
% THEIR TASKS. THE KEY ASSUMPTION IS THE NECESSARY MACHINES ARE ACTIVE. THE
% BASE STATION HAS UNLIMITTED EDGE RESOURCES SO THERE IS NO UPPER LIMIT OR
% OPTIMIZATION PROBLEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Total_Resources, UserList] = Default_EdgeScheduler_Unlimitted(UserList)

    Resource_Demand_loc = size(UserList,2)-4;
    Is_Block_loc = size(UserList,2)-1;
    Remaining_Time_loc = size(UserList,2);
    Spectral_Resource_loc = size(UserList, 2) - 7;
    
    
    Total_Resources = sum(UserList(:, Resource_Demand_loc));
    UserList(:, Is_Block_loc) = 1;
    for k = 1 : size(UserList, 1)
        if (UserList(k, Spectral_Resource_loc)>0)
            UserList(:, Is_Block_loc) = 0;  % The task is activated
            UserList(:, Remaining_Time_loc) = UserList(:, Remaining_Time_loc) - 1;  % Task is executed
        end
    end
    
end