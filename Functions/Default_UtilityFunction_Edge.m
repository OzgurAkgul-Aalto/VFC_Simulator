function const = Default_UtilityFunction_Edge(UserList, price_list, OBJSIZE, USERCOUNT, Resource_Demand_loc, Remaining_Time_loc, Demand_ServiceType_loc)
    const = zeros(USERCOUNT, OBJSIZE);
    for k = 1:1:USERCOUNT
        if (log(UserList (k, Remaining_Time_loc))>0)
            const(k,k)= -price_list(UserList(k, Demand_ServiceType_loc)) * UserList (k, Resource_Demand_loc) * 1 / log(UserList (k, Remaining_Time_loc));
        else
            const(k,k)= -price_list(UserList(k, Demand_ServiceType_loc)) * UserList (k, Resource_Demand_loc) * 15;
        end
        const(k,USERCOUNT+k)=1;
    end
    return 
end