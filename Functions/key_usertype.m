function key_const = key_usertype(USERCOUNT, R1, R2, R3)

    key1_const = zeros(USERCOUNT, 1);
    key2_const = zeros(USERCOUNT, 1);
    key3_const = zeros(USERCOUNT, 1);
    for k = 1 : USERCOUNT
        key1_const(k, 1) = R1(k) / 100;
        key2_const(k, 1) = R2(k) / 100;
        key3_const(k, 1) = R3(k) / 100;
    end
    key_const = [key1_const; key2_const; key3_const];
end