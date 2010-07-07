function [d,dsqr]=gvector_norm( T, G )
% GVECTOR_NORM Compute the norm of a sparse vector.
%   D=GVECTOR_NORM( T, G ) computes the norm of the sparse vector product
%   T with respect to scalar product defined by the matrices given in G. G
%   may be ommitted or single entries in G may be empty, in which case the
%   Euclidean scalar product is used.
%   As second output argument the square of the norm is also returned
%   (i.e. if the function is called like [D,DSQR]=GVECTOR_NORM( T, G )).
%
%
% Example (<a href="matlab:run_example gvector_norm">run</a>)
%   T={rand(8,2), rand(10,2)};
%   fprintf('%f\n', gvector_norm( T ) )
%   Z=gvector_add(T,T,-1);
%   fprintf('%f\n', gvector_norm( Z ) )
%
% See also GVECTOR_ADD, GVECTOR_REDUCE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<2
    G=[];
end

if is_tensor(T)
    d=tensor_norm(T,G);
else
    dsqr=max( gvector_scalar_product(T,T,G), 0 );
    d=sqrt( dsqr );
end
