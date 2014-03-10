function [alpha, xn, yn, dyn, flag]=line_search_gradient(func, x, p, y, dy, varargin)
% LINE_SEARCH_GRADIENT Pure gradient based line search algorithm.
%   LINE_SEARCH_GRADIENT Long description of line_search_gradient.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example line_search_gradient">run</a>)
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

options=varargin2options(varargin,mfilename);
[alpha0, options]=get_option(options,'alpha0',1);
[rho, options]=get_option(options,'rho',2);
[maxiter, options]=get_option(options,'maxiter',100);
[verbosity, options]=get_option(options,'verbosity',0);
check_unsupported_options(options);

func = funcreate(@return_2nd_outarg, func, @ellipsis);

% compute f and grad(f) if not given
if isempty(dy)
    dy = funcall(func, x);
end
g = tensor_scalar_product(dy, p);

flag = 0;
alpha = alpha0;

xn = tensor_add(x, p, alpha);
dyn = funcall(func, xn);
gn = tensor_scalar_product(dyn, p);
while sign(g)==sign(gn)
    alpha = alpha * rho;
    xn = tensor_add(x, p, alpha);
    dyn = funcall(func, xn);
    gn = tensor_scalar_product(dyn, p);
end


zero_func = funcreate(@dir_func, func, @funarg, x, p);
fzero_opts.d = p;
fzero_opts.maxiter = maxiter;
fzero_opts.maxiter = 1;
fzero_opts.fa = g;
fzero_opts.fb = gn;
%[alpha, flag, info] = fzero_ridders(zero_func, 0, alpha, fzero_opts);
[alpha, flag, info] = fzero_illinois(zero_func, 0, alpha, fzero_opts);

xn = tensor_add(x, p, alpha);
yn = nan;
dyn = info.gval;

function dy=return_2nd_outarg(func, x)
[~, dy] = funcall(func, x);

function dy=dir_func(func, alpha, x, p)
xn = tensor_add(x, p, alpha);
dy = funcall(func, xn);

