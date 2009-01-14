function [x,w]=gauss_hermite_rule( p )
% GAUSS_HERMITE_RULE Return the Gauss-Hermite quadrature rule with p nodes.
%   [X,W]=GAUSS_HERMITE_RULE( P ) returns the Gauss-Hermite quadrature rule
%   of order 2*p. X contains the quadrature points and W contains the 
%   weights of the quadrature rule.
%
% Example
%   [x,w]=gauss_hermite_rule( 4 );

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 

persistent quadrule

if isempty(quadrule)
    quadrule={};
end

if length(quadrule)<p || isempty(quadrule{p}) 
    h=hermite(p);
    dh=polyder(h);
    hm=hermite(p-1);

    x=sort(roots(h));
    w=zeros(size(x));
    for i=1:p
        w(i)=factorial(p-1)/(polyval(hm,x(i))*polyval(dh,x(i)));
    end
    quadrule{p}.x=x(:);
    quadrule{p}.w=w(:);
else
    rule=quadrule{p};
    x=rule.x;
    w=rule.w;
end
