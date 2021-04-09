function UserList_All = Default_EdgeScheduler_Limitted(B_pow, R3, R2, GAMMA, UserList_All, CellMatrix, price_list, Spectral_Resource_loc, Resource_Demand_loc, Is_Block_loc, Remaining_Time_loc, Demand_ServiceType_loc, bus)
    counter = 1;  
    % If the user has spectral resources, it is considered for edge
    % computation else the demand is blocked
    % Bus computation capacity is considered to be fix and 1M it is in the
    % constraint itself
    
    for k = 1: size(UserList_All,1)
        UserList_All(k, Is_Block_loc) = 1;
        if ( log2(1+UserList_All(k,1)/GAMMA)*UserList_All(k, Spectral_Resource_loc)>= 0 && UserList_All(k,Demand_ServiceType_loc)>0)
            if(log2(1+UserList_All(k,1)/GAMMA)*UserList_All(k, Spectral_Resource_loc)>= 1.15*R2(k))
                UserList(counter,:) = UserList_All(k,:);
                user_info(counter, 1) = k;
                counter = counter +1;
            else
                k;
%                 UserList_ALL(k, )
            end
        end
    end
    if(counter == 1)
        return
    end
    USERCOUNT = size(UserList,1);
    UserList_All(:, Is_Block_loc) = 1;
    
    
%% Objective Function                        
    c=[ zeros(1,USERCOUNT) -ones(1,USERCOUNT)]; %r_k*x_k  U_k
    OBJSIZE=size(c,2);

%% Utility Function Definition
    UtilityPerUser = Default_UtilityFunction_Edge(UserList, price_list, OBJSIZE, USERCOUNT, Resource_Demand_loc, Remaining_Time_loc, Demand_ServiceType_loc);
    Val_UtilityFunction = zeros(USERCOUNT,1);

%% Total assigned resources are limitted with the available resources
    Tot_AssignedResources = [UserList(:, Resource_Demand_loc)' zeros(1, OBJSIZE - USERCOUNT)];
    Val_AssignedResources = CellMatrix(1,2)+size(bus,1)*B_pow;
    if Val_AssignedResources>0
        B_pow;
    end
%% OPTIMIZER

    B = [   %Lefthandside of equations
            Tot_AssignedResources;
            UtilityPerUser;
    ];
    b = [   %Righthandside of equations
            Val_AssignedResources;
            Val_UtilityFunction;
    ];
    A = [   % Lefthandside of equality constraints
    
    ];
    a = [   % Righthandside of equality constraints
    
    ];
    lb = zeros(1, OBJSIZE);  % Lower bound
    ub = [ones(1, USERCOUNT) ones(1, OBJSIZE-USERCOUNT)*Inf];  % Upper Bound
    intcon=1: USERCOUNT; %Integger constraint - in case of need

    [xsol,fval,exitflag,time]=intlinprog_gurobi(c',intcon,B,b,A,a,lb,ub);
    res =  xsol(1:USERCOUNT);
    for user = 1: USERCOUNT
        if (res(user)==1)
            UserList_All(user_info(user), Is_Block_loc) = 0;
        end
    end

end