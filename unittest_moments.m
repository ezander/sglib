function test_moments
% TEST_MOMENTS Test the moment computing functions.
%
% Example (<a href="matlab:run_example test_moments">run</a>) 
%    test_moments
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'moments' );

%% Normal distribution
[m,v,s,k]=normal_moments(2,3);
assert_equals( [m,v,s,k], [2,3^2,0,0], 'normal' );

%% Sampled normal distribution
N=100000;
x=2+3*randn(N,1);
[md,vd,sd,kd]=data_moments( x );
assert_equals( [md,vd,sd,kd], [m,v,s,k], 'normal_sampled', 'abstol', 1e-1, 'fuzzy', true );

%% Moments of lognormal distribution
[m,v,s,k]=lognormal_moments(0.2,0.3);
e1=exp(0.245); e2=exp(0.09);
assert_equals([m,v,s,k], [e1,(e2-1)*e1^2, (e2+2)*sqrt(e2-1),e2^4+2*e2^3+3*e2^2-6], 'lognormal');

%% Sampled lognormal distribution
N=100000;
x=lognormal_stdnor( randn(N,1), 0.2, 0.3 );
[md,vd,sd,kd]=data_moments( x );
assert_equals( [md,vd,sd,kd], [m,v,s,k],  'lognormal_sampled', 'abstol', [0.01, 0.01, 0.1, 1], 'fuzzy', true );

%% Exponential distribution
[m,v,s,k]=exponential_moments( 1.3 );
assert_equals( [m,v,s,k], [1/1.3,1/1.3^2,2,6], 'exp' );

%% Sampled exponential distribution
N=100000;
x=exponential_stdnor( randn(N,1), 1.3 );
[md,vd,sd,kd]=data_moments( x );
assert_equals( [md,vd,sd,kd], [m,v,s,k], 'exp_sampled', 'abstol', [0.01, 0.01, 0.1, 1], 'fuzzy', true );

%% Beta distribution
[m,v,s,k]=beta_moments(4,2);
assert_equals( [m,v,s,k], [4/6,8/(36*7),2*(-2)*sqrt(7)/(8*sqrt(8)),6*(64-48+12-64)/(8*8*9)], 'beta' );


%% Sampled beta distribution
N=10000;
x=beta_stdnor( randn(N,1), 4, 2 );
[md,vd,sd,kd]=data_moments( x );
assert_equals( [md,vd,sd,kd], [m,v,s,k], 'beta_sampled', 'abstol', [0.01, 0.01, 0.1, 0.2], 'fuzzy', true );

%% pce of lognormal
mu=-1;
sigma=1;
p=9;
h={@lognormal_stdnor,{mu,sigma}};
pcc=pce_expand_1d(h,p);
[me,ve,se]=lognormal_moments( mu, sigma );
[mp,vp,sp]=pce_moments( pcc );
assert_equals( [me,ve,se], [mp,vp,sp], 'pce_lognormal', 'abstol', [1e-8,1e-6,2e-3] );

