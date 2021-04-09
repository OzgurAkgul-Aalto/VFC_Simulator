function const = reg1(USERCOUNT, OBJSIZE, U1, Hmax)
    const = zeros(USERCOUNT, OBJSIZE);
    for k = 1 : USERCOUNT
        const (k, USERCOUNT+k) = 1; % Uk
        const (k, 2*USERCOUNT+k) = U1(k)-Hmax;  % key 1 
    end
end