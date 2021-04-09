function const = reg3_right(USERCOUNT, U2, Hmax)
    const = zeros(USERCOUNT,1);
    for k = 1 : USERCOUNT
        const(k) = U2(k) + 2 * Hmax;
    end
end