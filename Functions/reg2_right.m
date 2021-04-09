function const = reg2_right(USERCOUNT, Hmax)
    % normally this function is unnecessary, I have added it for future
    % expansion
    const = zeros(USERCOUNT,1);
    for k = 1: USERCOUNT
        const(k) = Hmax; 
    end

end