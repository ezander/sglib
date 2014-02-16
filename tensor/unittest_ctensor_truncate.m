function unittest_ctensor_truncate
% UNITTEST_CTENSOR_TRUNCATE Test the CTENSOR_TRUNCATE function.
%
% Example (<a href="matlab:run_example unittest_ctensor_truncate">run</a>)
%    unittest_ctensor_truncate
%
% See also CTENSOR_TRUNCATE, MUNIT_RUN_TESTSUITE

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



munit_set_function( 'ctensor_truncate' );

k0=5;
T={rand(8,k0), rand(10,k0)};
U=ctensor_truncate(T);
assert_equals( U{1}*U{2}', T{1}*T{2}', 'truncate_0' )
assert_equals( schatten_norm(U,2), schatten_norm(T,2), 'truncate_0' )
U=ctensor_truncate(T,'k_max',4);
assert_equals( size(U{1},2), 4, 'truncate_k4' )
U=ctensor_truncate(T,'k_max',2);
assert_equals( size(U{1},2), 2, 'truncate_k2' )


%[M1,options]=get_option( options, 'M1', [] );
%[M2,options]=get_option( options, 'M2', [] );
%[Sp,options]=get_option( options, 'Sp', 2 );
%[k_max,options]=get_option( options, 'k_max', inf );
%[eps,options]=get_option( options, 'eps', 0 );
%[relcutoff,options]=get_option( options, 'relcutoff', true );

eps=schatten_norm( T, 2 )/50;
U=ctensor_truncate(T, 'p', 2, 'eps', eps, 'relcutoff', false );
assert_equals( schatten_norm(T,2), schatten_norm(U,2), 'truncate_0', 'abstol', eps )
U={U{1}(:,1:end-1),U{2}(:,1:end-1)};
assert_equals( true, abs(schatten_norm(ctensor_add(T,U,-1),2))>eps, 'truncate_0', 'abstol', eps )


L1=rand(8,8);
L2=rand(10,10);
G={L1*L1',L2*L2'};
U=ctensor_truncate(T,'G',G);
P1=U{1}'*G{1}*U{1};
P2=U{2}'*G{2}*U{2};
assert_equals( P1, diag(diag(P1)), 'P1_G_orth' )
assert_equals( P2, diag(diag(P2)), 'P2_G_orth' )


function n=schatten_norm( A, p )
if iscell(A)
    A=A{1}*A{2}';
end
s=svd(A);
n=norm(s,p);
