function [y,w]=clenshaw_curtis_legendre_rule(k)
% quad1d_cc_legendre - nodes and weights of clenshaw-curtis formula
%                      for Legendre measure

%n = floor(order/2)+1;
%assert(k>0);

if k==1
    y=0;
    w=1;
    return
end

% order:
m = 2^(k-1)+1;

%
J = 1:m;
y = -cos(pi * (J-1)/(m-1));

w = 1 - cos(pi * (J-1))/(m*(m-2));
for k=1:(m-3)/2
    w = w - 2*1/(4*k^2-1)*cos(2 * pi * k * (J-1)/(m-1));
end

w = w * 2/(m-1);
w=w';

w(1)=1/(m*(m-2));
w(m)=w(1);
