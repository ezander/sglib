function func = func_combine_f_df(f_func, df_func)
% FUNC_COMBINE_F_DF Combines separately given func and derivative into one function.
%   FUNC_COMBINE_F_DF Long description of func_combine_f_df.
%
% Example (<a href="matlab:run_example func_combine_f_df">run</a>)
%
% See also FUNCREATE, FUNCALL

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

func = funcreate(@combined_func, f_func, df_func, @ellipsis);

function [y, dy] = combined_func(f_func, df_func, x)
y = funcall(f_func, x);
dy = funcall(df_func, x);
