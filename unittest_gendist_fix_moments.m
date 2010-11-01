function unittest_gendist_fix_moments
% UNITTEST_GENDIST_FIX_MOMENTS Test the GENDIST_FIX_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_gendist_fix_moments">run</a>)
%   unittest_gendist_fix_moments
%
% See also GENDIST_FIX_MOMENTS, TESTSUITE 

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

munit_set_function( 'gendist_fix_moments' );

dist='lognormal';
params={0,1};
[shift,scale]=gendist_fix_moments( dist, params, 3.1, 2.4 );
[mean,var]=gendist_moments( dist, params, shift, scale );
assert_equals( mean, 3.1, 'mean' );
assert_equals( var, 2.4, 'var' );

