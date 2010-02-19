function T=tt_tensor_add( T1, T2, alpha )
% TT_TENSOR_ADD Short description of tt_tensor_add.
%   TT_TENSOR_ADD Long description of tt_tensor_add.
%
% Example (<a href="matlab:run_example tt_tensor_add">run</a>)
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

T=T1+alpha*T2;
