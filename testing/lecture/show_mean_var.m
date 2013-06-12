function show_mean_var(title, u_mean, u_var)
% SHOW_MEAN_VAR Show mean and variance of a stochastic solution
%
% Example (<a href="matlab:run_example show_mean_var">run</a>)
%    u = rand(5, 100);
%    show_mean_var("MC U[0,1], 100 samples", mean(u,2), var(u,[],2));
%
% See also

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

underline(title);
for i = 1:size(u_mean,1)
    fprintf( 'u_%d = %g+-%g\n', i, u_mean(i), sqrt(u_var(i)));
end
