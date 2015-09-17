function unittest_svd_add
% UNITTEST_SVD_ADD Test the SVD_ADD function.
%
% Example (<a href="matlab:run_example unittest_svd_add">run</a>)
%   unittest_svd_add
%
% See also SVD_ADD, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'svd_add' );

munit_control_rand('seed');


M=100;
N=200;

% first create a data matrix X of size MxN to begin with
X=rand(M,N);
[U,S,V]=svd(X,'econ');

% reduce that to rank K in Xn (components are U,s,V)
K=20;
U=U(:,1:K);
V=V(:,1:K);
S=S(1:K,1:K);
X=U*S*V';

L=50;
A=rand(M,L);
B=rand(N,L);
Xn=X+A*B';

% no truncation
[Un,Sn,Vn]=svd_add( U, S, V, A, B );
assert_equals( Un*Sn*Vn', Xn, 'full' )

[Un,Sn,Vn]=svd_add( U*S, [], V, A, B );
assert_equals( Un*Vn', Xn, 'full_noS' )
assert_equals( Sn, [], 'full_noS' )

[Un,Sn,Vn]=svd_add( U, diag(S), V, A, B );
assert_equals( Un*diag(Sn)*Vn', Xn, 'full_vecS' )


% no truncate to k (check correct error reporting)
[Un,Sn,Vn,err]=svd_add( U, S, V, A, B, 'rank', 10, 'pnorm', 2 );
assert_true( size(Un,2)<=10, 'rank' )
assert_equals( norm(Xn-Un*Sn*Vn','fro')/norm(Xn,'fro'), err, 'norm' )

[Un,Sn,Vn,err]=svd_add( U*S, [], V, A, B, 'rank', 10 ); %#ok<ASGLU>
assert_true( size(Un,2)<=10, 'rank' )
assert_equals( norm(Xn-Un*Vn','fro')/norm(Xn,'fro'), err, 'norm' )
 
[Un,Sn,Vn,err]=svd_add( U, diag(S), V, A, B, 'rank', 10 );
assert_true( size(Un,2)<=10, 'rank' )
assert_equals( norm(Xn-Un*diag(Sn)*Vn','fro')/norm(Xn,'fro'), err, 'norm' )

% no truncate to k (check correct error reporting for diff norms)
[Un,Sn,Vn,err]=svd_add( U, S, V, A, B, 'rank', 12, 'pnorm', 2 );
assert_equals( norm(Xn-Un*Sn*Vn','fro')/norm(Xn,'fro'), err, 'norm_fro' )

[Un,Sn,Vn,err]=svd_add( U, S, V, A, B, 'rank', 12, 'pnorm', inf );
assert_equals( norm(Xn-Un*Sn*Vn',2)/norm(Xn,2), err, 'norm_2' )

% no truncate to some eps 
[Un,Sn,Vn,err]=svd_add( U, S, V, A, B, 'reltol', 0.01, 'pnorm', 2 );
assert_true( err<0.01, 'error too large', 'err_lt_eps' )
assert_equals( Un*Sn*Vn', Xn, 'eps1', 'norm', 'fro', 'reltol', 0.01 );

[Un,Sn,Vn,err]=svd_add( U, S, V, A, B, 'reltol', 0.01, 'pnorm', inf );
assert_true( err<0.01, 'error too large', 'err_lt_eps' )
assert_equals( Un*Sn*Vn', Xn, 'eps1', 'norm', 2, 'reltol', 0.01 );

