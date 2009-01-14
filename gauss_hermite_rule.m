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
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


persistent quadrule

if isempty(quadrule)
    quadrule={};
end

if length(quadrule)<p || isempty(quadrule{p}) 
    h=hermite(p);
    dh=polyder(h);
    hm=hermite(p-1);

    x=sort(roots(h));
    w=factorial(p-1)./(polyval(hm,x).*polyval(dh,x));
    
    quadrule{p}.x=x(:);
    quadrule{p}.w=w(:);
else
    rule=quadrule{p};
    x=rule.x;
    w=rule.w;
end
