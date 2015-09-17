function Z=tensor_multiply( X, Y, xdim, ydim )
% TENSOR_MULTIPLY Multiplies to tensors, contracting dimensions.
%   Z=TENSOR_MULTIPLY( X, Y ) multiplies tensor X and Y given the result Z,
%   where Z(i1,i2,...,j1,j2,...)=X(i1,i2,...)*Y(j1,j2,...).
%   Z=TENSOR_MULTIPLY( X, Y, XDIM, YDIM ) gives the product of the tensors
%   X and Y with dimension XDIM and YDIM contracted (i.e. summed over the
%   products). Therefore SIZE(X,XDIM) must be equal to SIZE(Y,YDIM). The
%   shape of the result tensor Z is that of the concatenation of the shapes
%   of X and Y without the contracted dimensions (see example).
%
% Note: Currently only full tensors are supported.
%
% Example (<a href="matlab:run_example tensor_multiply">run</a>)
%   X=rand(2,3,4);
%   Y=rand(5,2,3,2);
%   Z1=tensor_multiply( X, Y );
%   disp( size(Z1) ); % should be [2,3,4,5,2,3,2]
%   Z2=tensor_multiply( X, Y, 2, 3 );
%   disp( size(Z2) ); % should be [2,4,5,2,2]
%   Z3=tensor_multiply( X, Y, [2 1], [3 2] );
%   disp( size(Z3) ); % should be [4,5,2]
%
% See also CTENSOR_ADD, CTENSOR_SCALE

%   Elmar Zander
%   Copyright 2009-2014, Inst. of Scientific Computing, TU Braunschweig
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
    xperm=1:ndims(X);
    xperm(xdim)=[];
    X=permute( X, [xperm, xdim] );
    X=reshape( X, [], prod(xshape(xdim)) );
    xshape(xdim)=[];
    
    yperm=1:ndims(Y);
    yperm(ydim)=[];
    Y=permute( Y, [yperm, ydim] );
    Y=reshape( Y, [], prod(yshape(ydim)) );
    yshape(ydim)=[];
    
    Z=X*Y';
    zshape=[xshape yshape];
    switch length(zshape)
        case 0
            % do nothing
        case 1
            Z = Z(:);
        otherwise
            Z=reshape( Z, zshape );
    end
end


