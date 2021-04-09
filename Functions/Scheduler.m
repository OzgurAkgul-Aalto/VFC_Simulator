function [UserMatrix, CellMatrix] = Scheduler(UserMatrix, CellMatrix, CellID, price_list, CellID_loc, Spectral_Resource_loc, GAMMA, Resource_Demand_loc, Is_Block_loc, Remaining_Time_loc, Demand_ServiceType_loc, bus, app_type, ServiceRequirements, ServiceUtilities, W, B_pow)  
%% Preparing the user list of the cell
    count =1;
    upper_speed = 50;
    for user = 1: size(UserMatrix,1)
        if (UserMatrix(user, CellID_loc) == CellID)
            
            UserList (count,:) = UserMatrix (user,:);
            Info_User (count,1) = user;
            if UserList(count, app_type) == 0   % No request so we are using the default
                UserList(count, app_type) = 1;
                R1(count) = ServiceRequirements(1,1);
                R2(count) = ServiceRequirements(1,2);
                R3(count) = ServiceRequirements(1,3);
                U1(count) = ServiceUtilities(1,1);
                U2(count) = ServiceUtilities(1,2);
                U3(count) = ServiceUtilities(1,3);
            else
                UserList(count, app_type) = UserList(count, app_type) +1;
                R1(count) = ServiceRequirements(UserList(count, app_type),1);
                R2(count) = ServiceRequirements(UserList(count, app_type),2);
                R3(count) = ServiceRequirements(UserList(count, app_type),3);
                U1(count) = ServiceUtilities(UserList(count, app_type),1);
                U2(count) = ServiceUtilities(UserList(count, app_type),2);
                U3(count) = ServiceUtilities(UserList(count, app_type),3);
            end
            Window_size(count) = W(UserList(count, app_type));
            count =count + 1;
        end
    end 

    if(count == 1) % No user in the cell
        return
    end
    %% Scheduler for the radio resources
    SpectralResources = Default_Scheduler(log2(1+UserList(:,1)/GAMMA), upper_speed, R1, R2, R3, U1, U2, U3, Window_size); 
    SpectralResources = round(SpectralResources*10000)/10000;
    for k = 1: size(Info_User,1) % Updating the user matrix
       UserMatrix (Info_User(k),Spectral_Resource_loc) = SpectralResources(k);
       UserList(k,Spectral_Resource_loc) = SpectralResources(k);
       UserMatrix(Info_User(k), app_type) = UserList(k, app_type);
    end
    
    %% Scheduler for the edge resources
    
%     [CellMatrix(1,1), UserList] = Default_EdgeScheduler_Unlimitted(UserList);
    UserList = Default_EdgeScheduler_Limitted(B_pow, R3, R2, GAMMA, UserList, CellMatrix, price_list, Spectral_Resource_loc, Resource_Demand_loc, Is_Block_loc, Remaining_Time_loc, Demand_ServiceType_loc, bus);

    %% Rearranging the user matrix, 
    for k = 1 : size(UserList)
        UserMatrix (Info_User(k),Is_Block_loc) = UserList(k,Is_Block_loc) ;
    end
    CellMatrix(1,1) = sum(UserList(:,Is_Block_loc) .* UserList(:,Resource_Demand_loc));
end