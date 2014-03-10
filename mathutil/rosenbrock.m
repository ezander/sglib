function [y,dy,ddy]=rosenbrock(x)

% page 30, Ex 2.1, (2.23)
y = 100*(x(2,:) - x(1,:).^2).^2 + (1-x(1,:)).^2;

if nargout>1
    dy = [
        -400*x(1,:).*(x(2,:) - x(1,:).^2) - 2*(1-x(1,:));
        200*(x(2,:) - x(1,:).^2)
        ];
end
if nargout>2
    ddy = [
        -400*(x(2,:) - x(1,:).^2) + 800*x(1,:).^2 + 2;
        -400*x(1,:);
        -400*x(1,:);
        repmat(200, 1, size(x,2));
    ];
    ddy = reshape(ddy, 2, 2, []);
end
