function unittest_gpcbasis_poly_ind
% UNITTEST_GPCBASIS_POLY_IND Test the GPCBASIS_POLY_IND function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_poly_ind">run</a>)
%   unittest_gpcbasis_poly_ind
%
% See also GPCBASIS_POLY_IND, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpcbasis_poly_ind' );



V = gpcbasis_create('h', 'm', 3);
inds=gpcbasis_poly_ind(V);
assert_equals(inds, {{'h', true(1,3)}}, 'same');

V = gpcbasis_create('PlPPlP');
inds=gpcbasis_poly_ind(V);
assert_equals(inds, {{'P', logical([1,0,1,1,0,1])},{'l', logical([0,1,0,0,1,0])}}, 'two');
