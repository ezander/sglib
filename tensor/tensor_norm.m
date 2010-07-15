function [d,dsqr]=tensor_norm( T, G, varargin )
% TENSOR_NORM Compute the norm of a sparse tensor.
%   D=TENSOR_NORM( T, G ) computes the norm of the sparse tensor product
%   T with respect to scalar product defined by the matrices given in G. G
%   may be ommitted or single entries in G may be empty, in which case the
%   Euclidean scalar product is used.
%   As second output argument the square of the norm is also returned
%   (i.e. if the function is called like [D,DSQR]=TENSOR_NORM( T, G )).
%
%
% Example (<a href="matlab:run_example tensor_norm">run</a>)
%   T={rand(8,2), rand(10,2)};
%   fprintf('%f\n', tensor_norm( T ) )
%   Z=tensor_add(T,T,-1);
%   fprintf('%f\n', tensor_norm( Z ) )
%
% See also TENSOR_ADD, TENSOR_REDUCE

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
options=varargin2options(varargin);
[orth,options]=get_option(options,'orth',true);
check_unsupported_options(options,mfilename);

check_tensor_format( T );

%d=gvector_norm( tensor_to_array( T ) );

if tensor_order(T)==2 && isempty(G)
    d=orth_norm( T );
else
    dsqr=max( tensor_scalar_product(T,T,G,varargin{:}), 0 );
    d=sqrt( dsqr );
end



function s=orth_norm( T )
[QA,RA]=qr(T{1},0);
[QB,RB]=qr(T{2},0);
s=norm(RA*RB','fro');
