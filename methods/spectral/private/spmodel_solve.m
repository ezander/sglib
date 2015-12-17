function [sol, spmodel] = spmodel_solve(spmodel, params, varargin)
% SPMODEL_SOLVE Short description of spmodel_solve.
%   SPMODEL_SOLVE Long description of spmodel_solve.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example spmodel_solve">run</a>)
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

solve_func = spmodel.model_info.solve_func;
start = tic;
[sol, solve_info, spmodel]=funcall(solve_func, spmodel, params, varargin{:});
t = toc(start);
spmodel.model_stats.num_solve_calls = spmodel.model_stats.num_solve_calls + 1;
spmodel.model_stats.time_solve_calls = spmodel.model_stats.time_solve_calls + t;
spmodel.solve_info = solve_info;

if nargout<2
    warning('sglib:spmodel_solve', 'Not updating model info, stats will possibly be wrong');
end
