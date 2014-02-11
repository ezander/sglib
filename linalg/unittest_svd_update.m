function unittest_svd_update
% UNITTEST_SVD_UPDATE Test the SVD_UPDATE function.
%
% Example (<a href="matlab:run_example unittest_svd_update">run</a>)
%   unittest_svd_update
%
% See also SVD_UPDATE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'svd_update' );

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
C=rand(M,L);
Xn=[X C];

% no truncation
[Un,Sn,Vn]=svd_update(U,S,V,C);
assert_equals( Xn, Un*Sn*Vn', 'full' )

[Un,Sn,Vn]=svd_update(U*S,[],V,C);
assert_equals( Un*Vn', Xn, 'full' )
assert_equals( Sn, [], 'fullS' )

% no truncate to some eps (here rank larger than eps dictates)
[Un,Sn,Vn,err]=svd_update( U, S, V, C, 'rank', 75, 'reltol', 0.01, 'pnorm', 2 );
assert_true( err<0.01, 'error too large', 'err_lt_eps' )
assert_equals( Xn, Un*Sn*Vn', 'eps1', 'norm', 'fro', 'reltol', 0.01 );

% no truncate to some eps (here eps smaller than rank allows)
[Un,Sn,Vn,err]=svd_update( U, S, V, C, 'rank', 30, 'reltol', 0.01, 'pnorm', 2 );
assert_true( size(Un,2)<=30, 'rank' )
assert_equals( Un*Sn*Vn', Xn, 'eps1', 'norm', 'fro', 'reltol', err*1.001 );



%%
M=100;
N=200;

% Create a rank K data matrix X of size MxN to begin with
K=20;
U=orth(rand(M,K));
V=orth(rand(N,K));
S=diag(1:K);
X=U*S*V';

L=50;
C=rand(M,L);
Xn=[X C];

% no truncation
[Un,Sn,Vn]=svd_update(U,S,V,C);
assert_equals( Xn, Un*Sn*Vn', 'full' )

