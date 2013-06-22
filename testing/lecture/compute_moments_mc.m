function [u_mean, u_var] = compute_moments_mc(init_func, solve_func, polysys, N, varargin)
% COMPUTE_MOMENTS_MC Compute mean and variance by Monte-Carlo.
%   [U_MEAN, U_VAR] = COMPUTE_MOMENTS_MC(INIT_FUNC, SOLVE_FUNC, N) computes
%   the mean and variance of a system described by INIT_FUNC and SOLVE_FUNC
%   by a Monte-Carlo method with N samples. The distribution is specified
%   by POLYSYS (see <a href="matlab:help gpc">GPC</a>).
%
% Example (<a href="matlab:run_example compute_moments_mc">run</a>)
%
% See also GPC

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[mode,options]=get_option(options, 'mode', '');
check_unsupported_options(options, mfilename);

sample_options=struct;
if ~isempty(mode)
    sample_options.mode = mode;
end

state = funcall(init_func);
V = {polysys, multiindex(state.num_params, 0)};
u = zeros(state.num_vars, N);
p = gpc_sample(V, N, sample_options);
for i = 1:N
    u_i = funcall(solve_func, state, p(:, i));
    u(:, i) = u_i;
end

u_mean = mean(u, 2);
u_var = var(u, [], 2);
