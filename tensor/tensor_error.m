function err=tensor_error(TA, TE, G, relerr)
% TENSOR_ERROR Short description of tensor_error.
%   TENSOR_ERROR Long description of tensor_error.
%
% Example (<a href="matlab:run_example tensor_error">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3
    G=[];
end
if nargin<4
    relerr=false;
end

% For normal vectors the following is pretty inefficient, for separated
% representations, however it is more efficient. Note that we cannot write
% TA-TE since minus is not necessarily defined for the tensor type, and
% taking the norm of tensor_add( TA, TE, -1 ) takes more time than the
% following lines.
if false
    norm_TA=tensor_norm(TA,G);
    norm_TE=tensor_norm(TE,G);
    inner_TAE=tensor_scalar_product( TA, TE, G );
    err=sqrt(max(norm_TA^2+norm_TE^2-2*inner_TAE),0);
else
    norm_TE=tensor_norm(TE,G);
    DT=tensor_add(TA,TE,-1);
    err=tensor_norm(DT,G);
end

if relerr
    err=err/norm_TE;
end
