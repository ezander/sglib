function [a,b]=beta_find_ratio(r,c,relerr)

if nargin<2 || isempty(c)
    c=1;
end
if nargin<3
    relerr=0.0001;
end
maxiter=100;

a0=beta_start_val(r,c);
a1=a0; while beta_ratio(a1,c/a1)>r; a1=a1/2; end
a2=a0; while beta_ratio(a2,c/a2)<r; a2=a2*2; end
a=fzero( @(a)(beta_ratio(a,c/a)-r), [a1,a2] );
%[a,rv,flag,output]=fzero( @(a)(beta_ratio(a,c/a)-r), [a1,a2] );
b=c/a;

function a0=beta_start_val( r, c )
% determine starting value based on asymptotic approximation of r(a,b) with
% b=c/a, with asymptotic ranges for a>>sqrt(c), a<<sqrt(c), plus something
% in between and the whole thing made continuous, then the function in the
% three ranges can be inverted easily
if r^2>(2*sqrt(c)+1)^3/c
    a0=(c*r^2)^(1/3);
elseif r^2<c/(2*sqrt(c)+1)
    a0=r^2;
else
    a0=r*c/(2*sqrt(c)+1);
end

function r=beta_ratio(a,b)
[mb,vb]=beta_moments(a,b);
r=mb/sqrt(vb);
