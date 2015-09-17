function func = funcreate(func_handle, varargin)
% FUNCREATE Helps create partially parameterised functions for FUNCALL.
%   FUNC = FUNCREATE(FUNC_HANDLE, VARARGIN) creates a cell array for use
%   with the FUNCALL function, but without the hassle to create the cell
%   array yourself. You can directly specify function arguments that shall
%   be partially applied by given that parameter value that the correct
%   positions and parameters that should be applied later by a call to
%   FUNCALL by using the @FUNARG. Arguments that always come last can be
%   separated by using the tag @ELLIPSIS.
%
% Note: @FUNARG can be given in the argument list multiple times, but
%   @ELLIPSIS can only appear once, and after it no more @FUNARG's are
%   allowed.
%
% Example (<a href="matlab:run_example funcreate">run</a>)
%    func = funcreate(@beta_pdf, @funarg, 2, 3);
%    x = 0.7;
%    fprintf('Evaluating %s at %g gives %g\n', disp_func(func), ...
%            x, funcall(func, x))
%
%    func = funcreate(@matern_covariance, 0.15, @ellipsis, 0.5, 0.5);
%    x1 = 0.7; x2=3;
%    fprintf('Evaluating %s at (%g, %g) gives %g\n', disp_func(func), ...
%            x1, x2, funcall(func, x1, x2))
%
% See also FUNCALL, FUNCALL_FUNFUN, FUNARG, ELLIPSIS, DISP_FUNC

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

%#ok<*AGROW>

has_ellipsis = false;
pos_arg_val = {};
pos_arg_pos = {};
end_arg_val = {};
pos_count = 0;
for i =1:length(varargin)
    arg = varargin{i};
    if isequal(arg, @ellipsis)
        if has_ellipsis
            error('more than once');
        end
        has_ellipsis = true;
    elseif isequal(arg, @funarg)
        if has_ellipsis
            error('funargs not allowed after ellipsis');
        end
        pos_count = pos_count + 1;
    else
        if has_ellipsis
            end_arg_val{end+1} = arg; 
        else
            pos_count = pos_count + 1;
            pos_arg_val{end+1} = arg;
            pos_arg_pos{end+1} = pos_count;
        end
    end
end

func = {func_handle, pos_arg_val, pos_arg_pos, end_arg_val};
