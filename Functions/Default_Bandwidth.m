function const = Default_Bandwidth(MAXBW, OBJSIZE, USERCOUNT, user_list)
    const = zeros(USERCOUNT, OBJSIZE);
    for k = 1:1:USERCOUNT
        const(k,k)=MAXBW*user_list(k);
    end
    return 
end