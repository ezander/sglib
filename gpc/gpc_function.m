function r_func=gpc_function(r_i_alpha, V_r)
% GPC_FUNCTION Create a callable function from a GPC.
%   R_FUNC=GPC_FUNCTION(R_I_ALPHA, V_R) creates the callable function
%   R_FUNC (callable via FUNCALL) from the GPC specified by R_I_ALPHA and
%   V_R. This mean, FUNCALL(R_FUNC, XI) gives the same as
%   GPC_EVALUATE(R_I_ALPHA, V_R, XI). This is helpful in places, where a
%   function is needed 
%
% Example (<a href="matlab:run_example gpc_function">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

r_func = funcreate(@gpc_evaluate, r_i_alpha, V_r);
