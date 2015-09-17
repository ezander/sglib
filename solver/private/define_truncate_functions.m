function [trunc_operator_func, trunc_before_func, trunc_after_func]=define_truncate_functions( trunc_mode, trunc, div_b, div_op )
% DEFINE_TRUNCATE_FUNCTIONS Short description of define_truncate_functions.
%   DEFINE_TRUNCATE_FUNCTIONS Long description of define_truncate_functions.
%
% Example (<a href="matlab:run_example define_truncate_functions">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

ta={@ctensor_truncate_fixed, {trunc}, {2}};
trunc_op=trunc; trunc_op.eps=trunc.eps/div_op;
to={@ctensor_truncate_fixed, {trunc_op}, {2}};
trunc_b=trunc; trunc_op.eps=trunc.eps/div_b;
tb={@ctensor_truncate_fixed, {trunc_b}, {2}};
id=@identity;
switch trunc_mode
    case 'none'
        funcs={id,id,id};
    case 'operator';
        funcs={to,tb,ta};
    case 'before';
        funcs={id,tb,ta};
    case 'after'
        funcs={id,id,ta};
    otherwise
        error( 'sglib:tensor_solve_simple:trunc_mode', 'unknown truncation mode %s', truncmode );
end
[trunc_operator_func,trunc_before_func,trunc_after_func]=funcs{:};
