function unittest_gpc_moments
% UNITTEST_GPC_MOMENTS Test the GPC_MOMENTS function.
%
% Note:
%   For this unit test analytical expressions for the statistical moments
%   were needed. See [1-5].
%
% References:
%   [1] http://en.wikipedia.org/wiki/Normal_distribution
%   [2] http://en.wikipedia.org/wiki/Exponential_distribution
%   [3] http://en.wikipedia.org/wiki/Uniform_distribution_%28continuous%29
%   [4] http://en.wikipedia.org/wiki/Arcsine_distribution
%   [5] http://en.wikipedia.org/wiki/Wigner_semicircle_distribution
%
% Example (<a href="matlab:run_example unittest_gpc_moments">run</a>)
%   unittest_gpc_moments
%
% See also GPC_MOMENTS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_moments' );

%% First check up to kurtosis for simple random vars

r_i_alpha=[4, 0.3, 0, 0];
I_r=[0; 1; 2; 3];

[mu,var,skew,kurt]=gpc_moments( r_i_alpha, {'H', I_r} );
assert_equals( [mu,var,skew,kurt], [4,0.09,0,0], 'mvsk_H' );

[mu,var,skew,kurt]=gpc_moments( r_i_alpha, {'P', I_r} );
assert_equals( [mu,var,skew,kurt], [4,0.09/3,0,-6/5], 'mvsk_P' );

% Exponential distribution, note that L_1=1-x, that's why the skewness is
% -2, not 2
[mu,var,skew,kurt]=gpc_moments( r_i_alpha, {'L', I_r} );
assert_equals( [mu,var,skew,kurt], [4,0.09,-2,6], 'mvsk_L' );

% Variance of the arcsine distribution is 1/2
[mu,var,skew,kurt]=gpc_moments( r_i_alpha, {'T', I_r} );
assert_equals( [mu,var,skew,kurt], [4,0.09/2,0,-3/2], 'mvsk_T' );

% Variance of the semicircle distribution is 1/4 but U_1=2x, so both cancel
% out
[mu,var,skew,kurt]=gpc_moments( r_i_alpha, {'U', I_r} );
assert_equals( [mu,var,skew,kurt], [4,0.09,0,-1], 'mvsk_U' );



%% A Test for skewness sign

I_r=[0; 1; 2];
[mu,var,skew1,kurt]=gpc_moments( [4,  6, -7], {'H', I_r} ); %#ok<*NASGU,*ASGLU>
[mu,var,skew2,kurt]=gpc_moments( [4,  6, 7], {'H', I_r} );
assert_equals( skew1, -skew2, 'skew' );

%% Check mean and var for several distributions/orth. polynomials
r_i_alpha=[2, 3, 5, 7];
I_r=[0; 1; 2; 3];
[mu,var]=gpc_moments( r_i_alpha, {'H', I_r} );
assert_equals( [mu,var], [2, 9+25*2+49*6], 'm1_H' );
[mu,var]=gpc_moments( r_i_alpha, {'h', I_r} );
assert_equals( [mu,var], [2, 9+25+49], 'm1_h' );
[mu,var]=gpc_moments( r_i_alpha, {'P', I_r} );
assert_equals( [mu,var], [2, 9/3+25/5+49/7], 'm1_P' );
[mu,var]=gpc_moments( r_i_alpha, {'p', I_r} );
assert_equals( [mu,var], [2, 9+25+49], 'm1_p' );
[mu,var]=gpc_moments( r_i_alpha, {'L', I_r} );
assert_equals( [mu,var], [2, 9+25+49], 'm1_L' );
[mu,var]=gpc_moments( r_i_alpha, {'U', I_r} );
assert_equals( [mu,var], [2, 9+25+49], 'm1_U' );


%% Check with multiple or missing "mean multiindices"
r_i_alpha=[2, 3, 5, 7];
[mu,var]=gpc_moments( r_i_alpha, {'h', [0; 0; 2; 3]} );
assert_equals( [mu,var], [2+3, 25+49], 'm1_mean2' );
[mu,var]=gpc_moments( r_i_alpha, {'h', [0; 1; 2; 0]} );
assert_equals( [mu,var], [2+7, 9+25], 'm1_mean2b' );
[mu,var]=gpc_moments( r_i_alpha, {'h', [0; 0; 0; 0]} );
assert_equals( [mu,var], [2+3+5+7, 0], 'm1_mean2c' );
[mu,var]=gpc_moments( r_i_alpha, {'h', [1; 1; 1; 1]} );
assert_equals( [mu,var], [0, 4+9+25+49], 'm1_no_mean' );


%% Now with multiple different random variables
I_r=[0 0 0; 1 3 4; 2 1 5; 3 2 6; 0 0 0];
r_i_alpha=[2, 3, 5, 7, 9];

[mu,var]=gpc_moments( r_i_alpha, {'HPL', I_r} );
assert_equals( [mu,var], [11,9*1/7+25*2/3+49*6/5], 'm3_HPL' );


%% Check consistency between different algorithms
I_r=multiindex(3,3);
V_r={'pHt', I_r};
r_i_alpha=rand(10,size(I_r,1));

[mu1,var1,skew1,kurt1]=gpc_moments( r_i_alpha, V_r, 'algorithm', 'mixed' );
[mu2,var2,skew2,kurt2]=gpc_moments( r_i_alpha, V_r, 'algorithm', 'integrate' );

assert_equals( [mu1,var1,skew1,kurt1], [mu2,var2,skew2,kurt2], 'consistency' );

%% Check var_only stuff
r_i_alpha=[4, 0.3, 0, 0];
I_r=[0; 1; 2; 3];
V={'H', I_r};

assert_equals( gpc_moments( r_i_alpha, V, 'var_only', true ), 0.09, 'var_H' );
assert_equals( gpc_moments( r_i_alpha, V, 'var_only', true, 'algorithm', 'mixed' ), 0.09, 'var_Hm' );
assert_equals( gpc_moments( r_i_alpha, V, 'var_only', true, 'algorithm', 'integrate' ), 0.09, 'var_Hi' );

assert_error( funcreate(@should_raise), 'sglib:', 'err_two_arg');

function [m,v]=should_raise()
r_i_alpha=[4, 0.3, 0, 0];
I_r=[0; 1; 2; 3];
V={'H', I_r};
[m,v]=gpc_moments(r_i_alpha, V, 'var_only', true );
