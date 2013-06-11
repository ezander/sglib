function c=hermite_triple_product(i,j,k)
% HERMITE_TRIPLE_PRODUCT Compute expectation of triple products of Hermite polynomials.
%   C=HERMITE_TRIPLE_PRODUCT(I,J,K) computes the value of <H_i H_j H_k>
%   where the H_ijk are the unnormalized (stochastic) Hermite polynomials
%   and the expectation <.> is over a Gaussian measure i.e.
%   <f(X)>=int_-infty^infty f(x) exp(-x^2/2)/sqrt(2*pi) dx
%
% Example (<a href="matlab:run_example hermite_triple_product">run</a>)
%   c1=hermite_triple_product(2,3,1);
%   c2=hermite_triple_product(3,1,4);
%   c3=hermite_triple_product([2 3],[3 1],[1 4]);
%   disp( sprintf( 'c1=%d, c2=%d, c3=%d=c1*c2=%d', c1, c2, c3, c1*c2 ) );
%
% See also HERMITE, HERMITE_VAL

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if isscalar(i)
    %TODO: maybe should work with vector

    % sum of i,j and k must be even
    s=i+j+k;
    if mod(s,2)~=0
        c=0;
        return
    end

    % i,j and k must fulfill the triangle inequality
    if i>j+k || j>k+i || k>i+j
        c=0;
        return;
    end

    s2=s/2+1;
    c=  prod( (s2-j):i );
    c=c*prod( (s2-k):j );
    c=c*prod( (s2-i):k );
else
    %TODO: maybe should work with vector of mi's
    c=1;
    % Note: multiindices are row vectors => size(i,2)
    if size(i,1)>1 || size(j,1)>1 || size(k,1)>1
        error([ 'hermite_triple_product: not yet implemented for ' ...
            'vectors of multiindices. Maybe you want to pass a row vector? '...
            'Or use hermite_triple_fast...' ]);
    end
    for a=1:size(i,2)
        c=c*hermite_triple_product( i(a), j(a), k(a) );
    end
end
