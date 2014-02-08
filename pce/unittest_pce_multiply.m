function unittest_pce_multiply
% UNITTEST_PCE_MULTIPLY Test the PCE_MULTIPLY function.
%
% Example (<a href="matlab:run_example unittest_pce_multiply">run</a>) 
%    unittest_pce_multiply
%
% See also PCE_MULTIPLY, MUNIT_RUN_TESTSUITE

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


munit_set_function( 'pce_multiply' );


% test for multiplication of H1 with itself
X_alpha=[0,1]; I_X=[0;1];
Y_beta=[0,1];  I_Y=[0;1];
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );
assert_equals( Z_gamma, [1,0,1], 'H1_H1' )
assert_equals( I_Z, (0:2)', 'I_H1_H1' )

% test for multiplication of H2 with H3
X_alpha=[0,0,1];  I_X=[0;1;2];
Y_beta=[0,0,0,1]; I_Y=[0;1;2;3];
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );
assert_equals( Z_gamma, [0,6,0,6,0,1], 'H2_H3' )
assert_equals( I_Z, (0:5)', 'I_H2_H3' )

% test for multiplication of a sum of univariate Hermites
X_alpha=[4,3,1];  I_X=[0;1;2];
Y_beta=[-2,2,-5,3]; I_Y=[0;1;2;3];
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );
assert_equals( Z_gamma, [-12, -6, -9, 17, 4, 3], 'HX_HY' )
assert_equals( I_Z, (0:5)', 'I_HX_HY' )



% test for multiplication of a two random vector of univariate Hermites
% equality checked with random numbers, not directly on the polynomials
N=10;
X_alpha=rand(N,5); I_X=(0:4)';
Y_beta=rand(N,7);  I_Y=(0:6)';
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );

xi=rand(1,10);
Z=pce_evaluate( Z_gamma, I_Z, xi );
X=pce_evaluate( X_alpha, I_X, xi );
Y=pce_evaluate( Y_beta, I_Y, xi );
assert_equals( Z, X.*Y, 'vec_rand' );

%% test for multiplication of a two random vector of multivariate Hermites
% equality checked with random numbers, not directly on the polynomials
N=11; m=3; p_X=2; p_Y=4;
I_X=multiindex(m,p_X); X_alpha=rand(N,size(I_X,1)); 
I_Y=multiindex(m,p_Y); Y_beta=rand(N,size(I_Y,1)); 
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );

xi=rand(m,10);
Z=pce_evaluate( Z_gamma, I_Z, xi );
X=pce_evaluate( X_alpha, I_X, xi );
Y=pce_evaluate( Y_beta, I_Y, xi );
assert_equals( Z, X.*Y, 'vec_rand_multi' );


[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y, [], 'vectorized', true );
Z=pce_evaluate( Z_gamma, I_Z, xi );
assert_equals( Z, X.*Y, 'vec_rand_multi1' );
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y, [], 'vectorized', false );
Z=pce_evaluate( Z_gamma, I_Z, xi );
assert_equals( Z, X.*Y, 'vec_rand_multi2' );
[Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y, [], 'full', true );
Z=pce_evaluate( Z_gamma, I_Z, xi );
ZZ=reshape( ( permute( tensor_multiply(X,Y), [1,3,2,4] ) ), [121, 100] );
ZZ=ZZ(:,1:11:100);
assert_equals( Z, ZZ, 'vec_rand_multi_full' );



% test returning of the multiplication tensor
N=11; m=3; p_X=2; p_Y=4;
I_X=multiindex(m,p_X); X_alpha=rand(N,size(I_X,1)); 
I_Y=multiindex(m,p_Y); Y_beta=rand(N,size(I_Y,1)); 
[Z_gamma,I_Z,M]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );
[Z_gamma2,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y, [], 'M', M );
assert_equals( Z_gamma2, Z_gamma, 'mult_tensor' )


