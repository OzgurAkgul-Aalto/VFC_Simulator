function [TD] = TD_TD(inp, r1, r2)
% Converting 3D function to 2D.
% Input: inp(r1,1,r2) --> TD(r1, r2)
    for i = 1: r1
        for j = 1: r2
            TD(i, j) = inp(i,:,j);
        end
    end
end