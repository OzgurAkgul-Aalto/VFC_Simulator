function const = Default_UtilityFunction(USERCOUNT, user_list, OBJSIZE)
    const = zeros(USERCOUNT, OBJSIZE);
    
    for k = 1:1:USERCOUNT
        const(k,k)=-user_list(k);   % xkrk
        const(k,USERCOUNT+k)=1;     % Uk
    end
    return 
end