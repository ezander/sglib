function err=gvector_error(TA, TE, G, relerr)
% GVECTOR_ERROR Short description of gvector_error.
%   GVECTOR_ERROR Long description of gvector_error.
%
% Example (<a href="matlab:run_example gvector_error">run</a>)
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
% TA-TE since minus is not necessarily defined for the gvector type, and
% taking the norm of gvector_add( TA, TE, -1 ) takes more time than the
% following lines.
if isnumeric(TA) && isempty(G)
    norm_TE=gvector_norm(TE);
    err=gvector_norm(TA-TE,G);
    gvector_scalar_product( TA, TE, G );
else
    norm_TA=gvector_norm(TA,G);
    norm_TE=gvector_norm(TE,G);
    inner_TAE=gvector_scalar_product( TA, TE, G );
    err=sqrt(norm_TA^2+norm_TE^2-2*inner_TAE);
end

if relerr
    err=err/norm_TE;
end
