function [res, spmodel] = spmodel_residual(spmodel, curr_sol, params, varargin)
% SPMODEL_RESIDUAL Short description of spmodel_residual.
%   SPMODEL_RESIDUAL Long description of spmodel_residual.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example spmodel_residual">run</a>)
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

res_func = spmodel.model_info.res_func;
start = tic;
[res, spmodel]=funcall(res_func, spmodel, curr_sol, params, varargin{:});
t = toc(start);
spmodel.spmodel_stats.num_res_calls = spmodel.model_stats.num_res_calls + 1;
spmodel.spmodel_stats.time_res_calls = spmodel.model_stats.time_res_calls + t;
