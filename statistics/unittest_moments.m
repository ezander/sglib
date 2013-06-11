function unittest_moments
% UNITTEST_MOMENTS Test the moment computing functions.
%
% Example (<a href="matlab:run_example unittest_moments">run</a>)
%    unittest_moments
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% Normal distribution
munit_set_function( 'normal_moments' );
[m,v,s,k]=normal_moments();
assert_equals( [m,v,s,k], [0,1,0,0], 'normal1' );
[m,v,s,k]=normal_moments(2,3);
assert_equals( [m,v,s,k], [2,3^2,0,0], 'normal2' );

% Moments of lognormal distribution
munit_set_function( 'lognormal_moments' );
[m,v,s,k]=lognormal_moments();
e=exp(1);
assert_equals([m,v,s,k], [sqrt(e), (e-1)*e, (e+2)*sqrt(e-1), e^4+2*e^3+3*e^2-6], 'lognormal1');
[m,v,s,k]=lognormal_moments(0.2,0.3);
e1=exp(0.245); e2=exp(0.09);
assert_equals([m,v,s,k], [e1,(e2-1)*e1^2, (e2+2)*sqrt(e2-1),e2^4+2*e2^3+3*e2^2-6], 'lognormal2');

% Exponential distribution
munit_set_function( 'exponential_moments' );
[m,v,s,k]=exponential_moments( 1.3 );
assert_equals( [m,v,s,k], [1/1.3,1/1.3^2,2,6], 'exp' );

% Beta distribution
munit_set_function( 'beta_moments' );
[m,v,s,k]=beta_moments(4,2);
assert_equals( [m,v,s,k], [4/6,8/(36*7),2*(-2)*sqrt(7)/(8*sqrt(8)),6*(64-48+12-64)/(8*8*9)], 'beta' );


% Uniform distribution
[m,v,s,k]=uniform_moments();
assert_equals( [m,v,s,k], [0.5,1/12,0,-6/5], 'uniform1' );
[m,v,s,k]=uniform_moments(2,4);
assert_equals( [m,v,s,k], [3,1/3,0,-6/5], 'uniform2' );
[m,v,s,k]=uniform_moments(7,7);
assert_equals( [m,v,s,k], [7,0,0,-6/5], 'uniform_empty' );



%% Uniform distribution
[m,v,s,k]=uniform_moments( 2, 4 );
assert_equals( [m,v,s,k], [3,4/12,0,-6/5], 'exp' );


