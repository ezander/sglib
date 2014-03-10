function [y,dy,ddy]=rosenbrock_nd1(x)

% extension of rosenbrock (see wikipedia)
n = length(x);
i=1:n-1;
y = sum(100*(x(i+1) - x(i).^2).^2 + (1-x(i)).^2);

if nargout>1
    dy = zeros(n,1);
    dy(i) = - 400*x(i).*(x(i+1)-x(i).^2) - 2*(1-x(i));
    dy(i+1) = dy(i+1) + 200*(x(i+1)-x(i).^2);
end
if nargout>2
    ddy = zeros(n, n);
    ddy(i,i) = diag(-400*x(i+1) + 1200*x(i).^2 + 2);
    ddy(i+1,i+1) = ddy(i+1,i+1) + 200*eye(n-1);
    ddy = ddy - diag(400*x(i),1) - diag(400*x(i),-1);
end
