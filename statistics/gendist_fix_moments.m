function dist_new=gendist_fix_moments(dist, mean, var)
% GENDIST_FIX_MOMENTS Generates a new gendist with specified moments.
%   DIST_NEW=GENDIST_FIX_MOMENTS(DIST, MEAN, VAR) computes from the
%   distribution DIST a new shifted and scaled distribution DIST_NEW such
%   that the mean and variance of NEW_DIST are given by MEAN and VAR.
%
% Example (<a href="matlab:run_example gendist_fix_moments">run</a>)
%   dist = gendist_create('beta', {2, 4});
%   [m, v] = gendist_moments(dist);
%   fprintf( 'before: mu=%g, var=%g\n', m, v);
%   
%   dist=gendist_fix_moments(dist, pi, exp(1));
%   [m, v] = gendist_moments(dist);
%   fprintf( 'after:  mu=%g, var=%g\n', m, v);
%
% See also GENDIST_CREATE, GENDIST_MOMENTS

%   Elmar Zander
%   Copyright 2010, 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isa(dist, 'Distribution')
    dist_new = dist.fix_moments(mean, var);
    return
end

[old_mean, old_var]=gendist_moments( dist );

shift=mean-old_mean;
scale=sqrt(var/old_var);
dist_new = dist;
dist_new{3} = dist{3} + shift;
dist_new{4} = dist{4} * scale;
% dist_new = gendist_create('gendist', {dist}, 'shift', shift, 'scale', scale);
