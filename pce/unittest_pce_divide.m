function unittest_pce_divide
% UNITTEST_PCE_DIVIDE Test the PCE_DIVIDE function.
%
% Example (<a href="matlab:run_example unittest_pce_divide">run</a>) 
%    unittest_pce_divide
%
% See also PCE_DIVIDE, MUNIT_RUN_TESTSUITE

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


munit_set_function( 'pce_divide' );


% test 1a) polynomial * 2
x_gamma=pce_divide( [1 2 3 4], [0;1;2;3], [0.5 0 0 0], [0;1;2;3] );
assert_equals( x_gamma, [2 4 6 8], 'const' );

% test 1b) polynomial * 2, different multiindex sets
x_gamma=pce_divide( [1 2 3 4], [0;1;2;3], [0.5 0], [0;1], [0;1;2;3;4;5] );
assert_equals( x_gamma, [2 4 6 8 0 0], 'const_diff' );

% test 1c) x^2 / x 
x_gamma=pce_divide( [1 0 1], [0;1;2], [0 1], [0;1], [0;1;2;3] );
assert_equals( x_gamma, [0 1 0 0], 'x2_by_x' );

% test 1d) 2*poly / poly
x_gamma=pce_divide( [2 4 6], [0;1;2], [1 3 2], [0;2;1] );
assert_equals( x_gamma, [2 0 0], 'same' );


% test 1b) polynomial * 2, different multiindex sets
x_gamma=pce_divide( [1 2 3 4], [0;1;2;3], [0.5 0; 0.25 0], [0;1], [0;1;2;3] );
assert_equals( x_gamma, [2 4 6 8; 4 8 12 16], 'const_diff' );


%return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% test 1: single rand. var, using anon functions

% Define the random variables A, B and X.
%a_func={@exponential_stdnor, {2}};
p=10;
a_func={@lognormal_stdnor, {1.5, 0.5}};
b_func={@uniform_stdnor, {2,3}};
x_func={@div_func,{a_func, b_func}};

% method 3: pce by b_func/a_func
x_gamma_ex=pce_expand_1d( x_func, p );

% method 4: solving stochastic galerkin equatin with pces of a and b
[a_alpha,I_a]=pce_expand_1d( a_func, p );
[b_beta,I_b]=pce_expand_1d( b_func, p );

% direct check
x_gamma=pce_divide( a_alpha, I_a, b_beta, I_b );
assert_equals( x_gamma(1:5), x_gamma_ex(1:5), 'pce_coeff', 'reltol', 10.^-[7,5,4,4,2] );

% realization check (this is not stochastic like MC or something, should
% hold for any realization).

xi=randn_sorted(10)';
A=pce_evaluate( a_alpha, I_a, xi );
B=pce_evaluate( b_beta, I_b, xi );
X=pce_evaluate( x_gamma, I_b, xi );
assert_equals( X, A./B, 'vec_rand_multi', 'reltol', 0.001 );

%%% test 2: just do it with the previous pce variables doubled
x_gamma_ex=[x_gamma_ex;x_gamma_ex];
x_gamma=pce_divide( [a_alpha;a_alpha], I_a, [b_beta;b_beta], I_b );
assert_equals( x_gamma(1:5), x_gamma_ex(1:5), 'pce_coeff', 'reltol', 10.^-[7,5,4,4,2] );


% test using pce_multiply (which hopefully works)
N=10; m=3; p_X=2; p_Y=4;
I_X=multiindex(m,p_X); X_alpha=rand(N,size(I_X,1)); 
I_Y=multiindex(m,p_Y); Y_beta=rand(N,size(I_Y,1)); 
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );
Y2_beta=pce_divide( Z_gamma, I_Z, X_alpha, I_X, I_Y );
X2_alpha=pce_divide( Z_gamma, I_Z, Y_beta, I_Y, I_X );

assert_equals( X2_alpha, X_alpha, 'muldivx' );
assert_equals( Y2_beta,  Y_beta, 'muldivy' );


function y=div_func( x, num_func, den_func )
y=funcall(num_func,x)./funcall(den_func,x);



