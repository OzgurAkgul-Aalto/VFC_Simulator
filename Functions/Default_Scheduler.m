%%%%%%%% DEFAULT SCHEDULER %%%%%%%%
% TYPE: MAXRATE SCHEDULER
% MULTI-TENANCY: OFF
% DETAILS: ASSIGNS RESOURCES TO USERS BASED ON THEIR ACHIEVABLE RATES AND 
% UTILITY FUNCTIONS. THE UTILITY FUNCTION IS UNITLESS AND CAN BE CUSTOMIZED
% ACCORDING TO THE SCENARIO.
% NOTE: THE CURRENT VERSION DOES NOT CARRY THE SERVICE TYPES BECAUSE THEY
% HAVE NOT BEEN DETERMINED YET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = Default_Scheduler(user_list, upper_speed, R1, R2, R3, U1, U2, U3, Window_size)
USERCOUNT = size(user_list,1);
Hmax = 1000;
%% Objective Function                        
    c=[ zeros(1,USERCOUNT) -ones(1,USERCOUNT) -ones(1,3*USERCOUNT)]; %x_k  U_k key1 key2 key3
    OBJSIZE=size(c,2);

%% Utility Function Definition
%     UtilityPerUser = Default_UtilityFunction(USERCOUNT, user_list, OBJSIZE); %MAX RATE SCHEDULER - NO SERVICE DIFFERENTIATION
%     Val_UtilityFunction = zeros(USERCOUNT,1);

%% Total assigned resources are limitted with the available resources
    Tot_AssignedResources = [ones(1, USERCOUNT) zeros(1, OBJSIZE - USERCOUNT)];
    Val_AssignedResources = 1;

%% Upper limit per user
    Tot_AssignedBandwidth = Default_Bandwidth(20, OBJSIZE, USERCOUNT, user_list); %20 MHz BW
    Val_AssignedBandwidth = R3' .* 20; % Assuming 20 MHz BW

    
%% Sigmoid function design
    keys_constraint = key_function(USERCOUNT, OBJSIZE, user_list, R1, R2, R3);
    keys_lefthandside = zeros(USERCOUNT*3,1);
    
%% Utility function
    % Region 1
    reg1_const_left = reg1(USERCOUNT, OBJSIZE, U1, Hmax);
    reg1_const_right = reg1_right(USERCOUNT, U1);
    % Region 2
    reg2_const_left = reg2(USERCOUNT, OBJSIZE, user_list, R1, R2, U2, Hmax);
    reg2_const_right = reg2_right(USERCOUNT, Hmax);
    % Region 3
    reg3_const_left = reg3(USERCOUNT, OBJSIZE, user_list, U2, U3, R2, R3, Hmax);
    reg3_const_right = reg3_right(USERCOUNT, U2, Hmax);
    % Region 4
    reg4_const_left = reg4(USERCOUNT, OBJSIZE, Hmax, U3);
    reg4_const_right = reg4_right(USERCOUNT, Hmax);
%% OPTIMIZER

    B = [   %Lefthandside of equations
            Tot_AssignedResources;
%             UtilityPerUser;
            Tot_AssignedBandwidth;
            keys_constraint;
            reg1_const_left;
            reg2_const_left;
            reg3_const_left;
            reg4_const_left;
    ];
    b = [   %Righthandside of equations
            Val_AssignedResources;
%             Val_UtilityFunction;
            Val_AssignedBandwidth;
            keys_lefthandside;
            reg1_const_right;
            reg2_const_right;
            reg3_const_right;
            reg4_const_right;
    ];
    A = [   % Lefthandside of equality constraints
    
    ];
    a = [   % Righthandside of equality constraints
    
    ];
    lb = zeros(1, OBJSIZE);  % Lower bound
    ub = ones(1, OBJSIZE) * 100;  % Upper Bound
    ub(2*USERCOUNT+1 : OBJSIZE) = 1; % Upper bounded to 1
    intcon= 2*USERCOUNT+1 : OBJSIZE ; %Integger constraint 

    [xsol,fval,exitflag,time]=intlinprog_gurobi(c',intcon,B,b,A,a,lb,ub);
    res =  xsol(1:USERCOUNT);
    
end

