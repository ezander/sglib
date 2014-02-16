function err=ctensor_error(TA, TE, varargin)
% CTENSOR_ERROR Short description of ctensor_error.
%   CTENSOR_ERROR Long description of ctensor_error.
%
% Example (<a href="matlab:run_example ctensor_error">run</a>)
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

norm_TE=ctensor_norm(TE,G);
DT=ctensor_add(TA,TE,-1);
err=ctensor_norm(DT,G);

if relerr
    err=err/norm_TE;
end
