function [shift,scale]=gendist_fix_moments(dist, params, mean, var)
% GENDIST_FIX_MOMENTS Computes scale and shift to get specific moments.
%   [SHIFT,SCALE]=GENDIST_FIX_MOMENTS(DIST, PARAMS, MEAN, VAR) computes
%   shift and scale parameters such that the distribution specified by
%   DIST, PARAMS, SHIFT and SCALE has mean MEAN and variance VAR.
%
% Example (<a href="matlab:run_example gendist_fix_moments">run</a>)
%   dist = 'beta';
%   params = {2, 4};
%   [m, v] = gendist_moments(dist, params);
%   fprintf( 'before: mu=%g, var=%g\n', m, v);
%   
%   [shift,scale]=gendist_fix_moments(dist, params, pi, exp(1));
%   [m, v] = gendist_moments(dist, params, shift, scale);
%   fprintf( 'after:  mu=%g, var=%g\n', m, v);
%
% See also GENDIST_MOMENTS

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


[target_mean, target_var]=gendist_moments( dist, params );
shift=mean-target_mean;
scale=sqrt(var/target_var);
