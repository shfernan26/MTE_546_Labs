function z = measureModel(x)
    
    A = 5.224514;
    B = -2.196009;
    C = 0.198318;
    D = -2.468841;

    % Converts distance to voltage
    z = A*((x+B)^-C)+D;

end

