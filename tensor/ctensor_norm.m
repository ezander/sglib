function [d,dsqr]=ctensor_norm( T, G, varargin )
% CTENSOR_NORM Compute the norm of a sparse tensor.
%   D=CTENSOR_NORM( T, G ) computes the norm of the sparse tensor product
%   T with respect to scalar product defined by the matrices given in G. G
%   may be ommitted or single entries in G may be empty, in which case the
%   Euclidean scalar product is used.
%   As second output argument the square of the norm is also returned
%   (i.e. if the function is called like [D,DSQR]=CTENSOR_NORM( T, G )).
%
%
% Example (<a href="matlab:run_example ctensor_norm">run</a>)
%   T={rand(8,2), rand(10,2)};
%   fprintf('%f\n', ctensor_norm( T ) )
%   Z=ctensor_add(T,T,-1);
%   fprintf('%f\n', ctensor_norm( Z ) )
%
% See also CTENSOR_ADD, TENSOR_TRUNCATE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
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

%d=tensor_norm( ctensor_to_array( T ) );

if ctensor_order(T)==2 && isempty(G)
    d=orth_norm( T );
else
    dsqr=max( ctensor_scalar_product(T,T,G,varargin{:}), 0 );
    d=sqrt( dsqr );
end



function s=orth_norm( T )
[QA,RA]=qr(T{1},0);
[QB,RB]=qr(T{2},0);
s=norm(RA*RB','fro');
