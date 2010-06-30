function err=tensor_error(TA, TE, varargin)
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

options=varargin2options( varargin );
[G,options]=get_option(options,'G',[]);
[relerr,options]=get_option(options,'relerr',false);
check_unsupported_options(options);

norm_TE=tensor_norm(TE,G);
DT=tensor_add(TA,TE,-1);
err=tensor_norm(DT,G);

if relerr
    err=err/norm_TE;
end
