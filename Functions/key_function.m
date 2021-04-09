function key_const = key_function(USERCOUNT, OBJSIZE, r, R1, R2, R3)
    
    key1_const = zeros(USERCOUNT, OBJSIZE);
    key2_const = zeros(USERCOUNT, OBJSIZE);
    key3_const = zeros(USERCOUNT, OBJSIZE);

    for k = 1 : USERCOUNT
        key1_const(k, 2*USERCOUNT+k) = 1;
        key1_const(k, k) = -r(k)/ R1(k);
        
        key2_const(k, 3*USERCOUNT+k) = 1;
        key2_const(k, k) = -r(k)/ R2(k);
        
        key3_const(k, 4*USERCOUNT+k) = 1;
        key3_const(k, k) = -r(k)/ R3(k);
    end
    
    key_const = [key1_const; key2_const; key3_const];
    key_const(abs(key_const)==Inf) = -100000;
end