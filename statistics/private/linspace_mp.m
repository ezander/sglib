function [x1,x2]=linspace_mp( xmin, xmax, N )
if nargin<3
    N=100;
end
x1=linspace(xmin,xmax,N);
x2=x1(1:end-1)+(x1(2)-x1(1))/2;
