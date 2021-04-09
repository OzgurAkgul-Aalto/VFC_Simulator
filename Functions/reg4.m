function const = reg4(USERCOUNT, OBJSIZE, Hmax, U3)
    const = zeros(USERCOUNT, OBJSIZE);
    for k = 1 : USERCOUNT
        const (k, USERCOUNT +k) = 1;       % Uk
        const (k, 2*USERCOUNT +k) = Hmax;   % key1
        const (k, 4*USERCOUNT +k) = Hmax - U3(k); %key3
    end

end