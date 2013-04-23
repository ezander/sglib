function [node,weight]=lgwt_2D(N,a,b)
% a and b are left and right bounds of teh domain

[x,w]=lgwt(N,a,b);

[X, Y] = ndgrid(x, x);

node=[X(:)'; Y(:)'];

weight = kron(w,w');

weight = weight(:)';

end