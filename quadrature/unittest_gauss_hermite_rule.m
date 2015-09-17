function unittest_gauss_hermite_rule
% UNITTEST_GAUSS_HERMITE_RULE Test the GAUSS_HERMITE_RULE function.
%
% Example (<a href="matlab:run_example unittest_gauss_hermite_rule">run</a>)
%   unittest_gauss_hermite_rule
%
% See also GAUSS_HERMITE_RULE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gauss_hermite_rule' );

xi=0;
wi=1.;
[x,w]=gauss_hermite_rule( 1 );
assert_equals( x, xi, 'xi_1' );
assert_equals( w, wi, 'wi_1' );

xi=[-1., 1.];
wi=[0.5; 0.5];
[x,w]=gauss_hermite_rule( 2 );
assert_equals( x, xi, 'xi_2' );
assert_equals( w, wi, 'wi_2' );

xi=[-1.7320508075688772935, 0, 1.7320508075688772935];
wi=[0.16666666666666666667; 0.66666666666666666667; 0.16666666666666666667];
[x,w]=gauss_hermite_rule( 3 );
assert_equals( x, xi, 'xi_3' );
assert_equals( w, wi, 'wi_3' );

xi=[-2.3344142183389772393, -0.74196378430272585765, 0.74196378430272585765, 2.3344142183389772393];
wi=[0.045875854768068491817; 0.45412414523193150818; 0.45412414523193150818; 0.045875854768068491817];
[x,w]=gauss_hermite_rule( 4 );
assert_equals( x, xi, 'xi_4' );
assert_equals( w, wi, 'wi_4' );

xi=[-2.8569700138728056542, -1.3556261799742658658, 0, 1.3556261799742658658, 2.8569700138728056542];
wi=[0.011257411327720688933; 0.2220759220056126444; 0.53333333333333333333; 0.2220759220056126444; 0.011257411327720688933];
[x,w]=gauss_hermite_rule( 5 );
assert_equals( x, xi, 'xi_5' );
assert_equals( w, wi, 'wi_5' );

xi=[-3.3242574335521189524, -1.8891758777537106755, -0.61670659019259415219, 0.61670659019259415219, 1.8891758777537106755, 3.3242574335521189524];
wi=[0.0025557844020562464306; 0.088615746041914527481; 0.40882846955602922609; 0.40882846955602922609; 0.088615746041914527481; 0.0025557844020562464306];
[x,w]=gauss_hermite_rule( 6 );
assert_equals( x, xi, 'xi_6' );
assert_equals( w, wi, 'wi_6' );
