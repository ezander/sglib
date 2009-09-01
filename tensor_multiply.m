function Z=tensor_multiply( X, Y, xdim, ydim )
% TENSOR_MULTIPLY Multiplies to tensors, contracting dimensions.
%   TENSOR_MULTIPLY Long description of tensor_multiply.
%
% Example (<a href="matlab:run_example tensor_multiply">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

xshape=size(X);
yshape=size(Y);

if nargin<3
    zshape=[xshape yshape];
    Z=reshape( reshape(X, [], 1)*reshape(Y, 1, []), zshape );
else
    X=permute( X, [1:xdim-1, xdim+1:ndims(X), xdim] );
    X=reshape( X, [], xshape(xdim) );
    xshape(xdim)=[];
    Y=permute( Y, [1:ydim-1, ydim+1:ndims(Y), ydim] );
    Y=reshape( Y, [], yshape(ydim) );
    yshape(ydim)=[];
    zshape=[xshape yshape];
    Z=reshape( X*Y', zshape );
end


