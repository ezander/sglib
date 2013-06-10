function test_cc

[x,w]=clencurt(9)
sum(w)

function [x,w]=clencurt(n)
% Computes the Clenshaw Curtis nodes and weights
% Adapted a code by G. von Winckel
% http://www.scientificpython.net/1/post/2012/04/clenshaw-curtis-quadrature.html
if n == 1
    x = 0;
    w = 2;
else
    C = zeros(n,2);
    k = 2*(1:floor((n-1)/2));
    C(1:2:end,1) = 2./[1, 1-k.*k];
    C(2,2) = -(n-1);
    V = [C; flipud(C(2:n-1,:))];
    F = real(ifft(V)); %, n=None, axis=0))
    x = F(1:n,2);
    w = [F(1,1), 2*F(2:n-1,1)', F(n,1)];
end
