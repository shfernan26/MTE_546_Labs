u = [10 12 14 16 18 20]; 

x0 = [10; 0];
R = 0.05;
Q = [0.1 0;
    0 0.2];

T = 0.2;
A = [1 T; 
     0 1];

% IC's
x = x0;
P = Q;
z = 0;

syms d v 
F = double(jacobian([d+T*v ,v],[d,v]));

syms dist vel
A = 5.224514;
B = -2.196009;
C = 0.198318;
D = -2.468841;
% Converts distance to voltage
volts = dist^2;
H_jacob = jacobian(volts, [dist, vel]);
H = matlabFunction(H_jacob);

for n = 2:(length(u)-1)
    x(:,n) = F*x(:,n-1) + [Q(1,1); Q(2,2)];
    z(n) = H(x(n))*x(:,n);
    P(:,:,n) = F*P(:,:,n-1)*F'+Q;
    K = P(:,:,n)*H(x(n))'*( ( H(x(n))*P(:,:,n)*H(x(n))'+R )^-1 );
    x(:,n+1) = x(:,n) + K*(z(n) - z(n-1));
    P(:,:,n+1) = ( eye(2)-K*H(x(n)) )*P(:,:,n);   
end
    