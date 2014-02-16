function unittest_ctensor_truncate_svd
% UNITTEST_CTENSOR_TRUNCATE_SVD Test the CTENSOR_TRUNCATE_SVD function.
%
% Example (<a href="matlab:run_example unittest_ctensor_truncate_svd">run</a>)
%   unittest_ctensor_truncate_svd
%
% See also CTENSOR_TRUNCATE_SVD, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'ctensor_truncate_svd' );

N=110;
M=80;
L=60;

T={rand(N,L), rand(M,L)};
G={[],[]};
sv=svd(T{1}*T{2}'); sv=sv(1:L);
% eps, k_max, relcutoff, p

% check that sigma is correct and the tensor is reproduced for eps=0
[U,sigma,k]=ctensor_truncate_svd( T, G, 0, inf, true, 2 );
assert_equals( sigma, sv, 'sigma' );
assert_equals( U{1}*U{2}', T{1}*T{2}', 'reproduce' );

% check that k_max is honored over eps
[U,sigma,k]=ctensor_truncate_svd( T, G, 0, 1, true, 2 );
assert_equals( sigma, sv, 'k1sigma' );
assert_equals( ctensor_rank(U), 1, 'rank1' );
[U,sigma,k]=ctensor_truncate_svd( T, G, 0, 3, true, 2 );
assert_equals( sigma, sv, 'k3sigma' );
assert_equals( ctensor_rank(U), 3, 'rank3' );

% check that absolute eps is honored (construct as lying between the
% schatten 2 norm of the values after an including k_ex and after and
% exclude k_ex, so that the k from the truncation *must* be equal to k) 
k_ex=floor(L/3);
abseps=sqrt(0.5*sv(k_ex).^2+sum(sv(k_ex+1:end).^2));
[U,sigma,k]=ctensor_truncate_svd( T, G, abseps, inf, false, 2 );
assert_equals( k, k_ex, 'k' );
assert_equals( U{1}*U{2}', T{1}*T{2}', 'best_frob', 'norm', 'fro', 'abstol', abseps );

releps=abseps/sqrt(sum(sv.^2));
[U,sigma,k]=ctensor_truncate_svd( T, G, releps, inf, true, 2 );
assert_equals( k, k_ex, 'k' );
assert_equals( U{1}*U{2}', T{1}*T{2}', 'best_frob_rel', 'norm', 'fro', 'reltol', releps );

% Same for relative epsilon taking the spectral norm now (i.e. 2-norm or
% Schatten-inf)
k_ex=floor(2*L/3);
abseps=sqrt(0.5*sv(k_ex)^2+0.5*sv(k_ex+1)^2);
releps=abseps/sv(1);
[U,sigma,k]=ctensor_truncate_svd( T, G, abseps, inf, false, inf );
assert_equals( k, k_ex, 'k' );
assert_equals( U{1}*U{2}', T{1}*T{2}', 'best_spectral_abs', 'norm', 2, 'abstol', abseps );

[U,sigma,k]=ctensor_truncate_svd( T, G, releps, inf, true, inf );
assert_equals( k, k_ex, 'k' );
assert_equals( U{1}*U{2}', T{1}*T{2}', 'best_spectral_rel', 'norm', 2, 'reltol', releps );







% check that truncation with orthogonal columns works
N=110;
M=80;
L1=60;
L2=30;
L=L1+L2;

T={[orth(rand(N,L1)), rand(N,L2)], [orth(rand(M,L1)), rand(M,L2)]};


U=ctensor_truncate_svd( T, G, 0, inf, true, 2, L1 );
assert_equals( U{1}*U{2}', T{1}*T{2}', 'reproduce' );
