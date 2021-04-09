function const = reg4_right(USERCOUNT, Hmax)
    const = zeros(USERCOUNT, 1);
    for k = 1 : USERCOUNT
        const (k) = 2 * Hmax;
    end
end