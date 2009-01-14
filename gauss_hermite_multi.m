function int=gauss_hermite_multi( func, n, p )
% GAUSS_HERMITE_MULTI Perform multidimensional Gauss-Hermite quadrature.
%   INT=GAUSS_HERMITE_MULTI( func, P ) approximates the integral
%     $$ \int_{-\infty}^\infty func(x) exp(-sum(x(i)^2)/2)/sqrt(2\pi)^i dx^i $$
%   by combined Gauss-Hermite quadrature of order 2*p. The weights and quadrature
%   points are calculated on the fly but stored in a persistent array for
%   later use. The precision of the coefficients has still to be assessed.
% 
% Note: 
%   func has to be vectorized. Thus instead of @(x)(x*x) write @(x)(x.*x).
%
% Example
%   int=gauss_hermite_multi( @(x)(x'*x), 2, 4 ); % => 1
%
% See also GAUSS_HERMITE_RULE, GAUSS_HERMITE_MULTI

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


if nargin==0
    func=@(x)(x'*x);
    p=4;
end

[x,w]=gauss_hermite_rule(p);

%TODO: this method should be vectorized on the lower levels
int=0;
ind=ones(n,1);
while all(ind)
    int=int+sum( prod(w(ind)) * funcall( func, x(ind)) );
    ind=increase(ind,n,p);
end


function ind=increase(ind,n,p)
% INCREASE Increase an index tuple by one.
i=1;
while i<=n
    ind(i)=ind(i)+1;
    if ind(i)<=p; return; end
    ind(i)=1;
    i=i+1;
end
ind=0*ind;
