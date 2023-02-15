function output = H(dist)

    % Converts distance to voltage
    H_jacob = [1.0./(dist+2.844489).^2.23633.*(-3.574215070407e1) 0.0];
    
    output = H_jacob;
    
   
end

