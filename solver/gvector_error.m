function err=gvector_error(TA, TE, varargin )
% GVECTOR_ERROR Short description of gvector_error.
%   GVECTOR_ERROR Long description of gvector_error.
%
% Example (<a href="matlab:run_example gvector_error">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[G,options]=get_option(options,'G',[]);
[relerr,options]=get_option(options,'relerr',false);
check_unsupported_options(options);

if ~is_tensor(TE) && is_tensor(TA)
    if isvector(TE)
        TA=tensor_to_vector(TA);
    else
        TA=tensor_to_array(TA);
    end
end

norm_TE=gvector_norm(TE,G);
DT=gvector_add(TA,TE,-1);
err=gvector_norm(DT,G);

if relerr
    err=err/norm_TE;
end
