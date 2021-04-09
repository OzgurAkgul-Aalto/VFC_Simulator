function const = reg1_right(USERCOUNT, U1)
    const = zeros(USERCOUNT, 1);
    for k = 1 : USERCOUNT
        const(k) = U1(k);
    end
end