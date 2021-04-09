function UserMatrix = UserMatrix_Func(USERCOUNT, Simulation_Duration, traffic, SINR_loc, Cell_ID_loc, X_loc, Y_loc, Speed_loc,Num_Col)
% Simulation_Duration = traffic(size(traffic,1),1);
% USERCOUNT = max(traffic(:,2));
UserMatrix = zeros(USERCOUNT, Num_Col, Simulation_Duration);

for l = 1: size(traffic, 1)
    time = traffic(l, 1);
    vehicle = traffic(l, 2);
    X = traffic(l, 3);
    Y = traffic(l, 4);
    SINR = traffic(l, size(traffic,2)-1);
    CellID = traffic(l, size(traffic,2));
    speed = traffic(l, 5);   % Currently Not Active
    if(time<=Simulation_Duration)
        if(vehicle<=USERCOUNT)
            UserMatrix(vehicle, X_loc, time) = X;
            UserMatrix(vehicle, Y_loc, time) = Y;
            UserMatrix(vehicle, Speed_loc, time) = speed;
            UserMatrix(vehicle, SINR_loc, time) = SINR;
            UserMatrix(vehicle, Cell_ID_loc, time) = CellID;
        end
    end
end


end