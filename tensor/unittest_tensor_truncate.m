function unittest_tensor_truncate
% UNITTEST_TENSOR_TRUNCATE Test the TENSOR_TRUNCATE function.
%
% Example (<a href="matlab:run_example unittest_tensor_truncate">run</a>)
%    unittest_tensor_truncate
%
% See also TENSOR_TRUNCATE, TESTSUITE

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



munit_set_function( 'tensor_truncate' );

k0=5;
T={rand(8,k0), rand(10,k0)};
U=tensor_truncate(T);
assert_equals( U{1}*U{2}', T{1}*T{2}', 'truncate_0' )
assert_equals( schatten_norm(U,2), schatten_norm(T,2), 'truncate_0' )
U=tensor_truncate(T,'k_max',4);
assert_equals( size(U{1},2), 4, 'truncate_k4' )
U=tensor_truncate(T,'k_max',2);
assert_equals( size(U{1},2), 2, 'truncate_k2' )


%[M1,options]=get_option( options, 'M1', [] );
%[M2,options]=get_option( options, 'M2', [] );
%[Sp,options]=get_option( options, 'Sp', 2 );
%[k_max,options]=get_option( options, 'k_max', inf );
%[eps,options]=get_option( options, 'eps', 0 );
%[relcutoff,options]=get_option( options, 'relcutoff', true );

eps=schatten_norm( T, 2 )/50;
U=tensor_truncate(T, 'p', 2, 'eps', eps, 'relcutoff', false );
assert_equals( schatten_norm(T,2), schatten_norm(U,2), 'truncate_0', 'abstol', eps )
U={U{1}(:,1:end-1),U{2}(:,1:end-1)};
assert_equals( true, abs(schatten_norm(tensor_add(T,U,-1),2))>eps, 'truncate_0', 'abstol', eps )


if exist( 'schattenp_truncate' ) %#ok
    % copy this function inline to test it
    munit_set_function( 'schattenp_truncate' );

    s=[5,4,3,2,1];
    assert_equals( schattenp_truncate( s, 6, false, inf ), 0 );
    assert_equals( schattenp_truncate( s, 5, false, inf ), 1 );
    assert_equals( schattenp_truncate( s, 4.5, false, inf ), 1 );
    assert_equals( schattenp_truncate( s, 4, false, inf ), 2 );
    assert_equals( schattenp_truncate( s, 1.5, false, inf ), 4 );
    assert_equals( schattenp_truncate( s, 0.5, false, inf ), 5 );
    assert_equals( schattenp_truncate( s, 0, false, inf ), 5 );

    assert_equals( schattenp_truncate( s, 4, false, 2 ), 2 );
    assert_equals( schattenp_truncate( s, sqrt(5), false, 2 ), 3 );
    assert_equals( schattenp_truncate( s, 2, false, 2 ), 4 );
    assert_equals( schattenp_truncate( s, 1, false, 2 ), 4 );
    assert_equals( schattenp_truncate( s, 0, false, 2 ), 5 );

    assert_equals( schattenp_truncate( s, 4, false, 1 ), 3 );
    assert_equals( schattenp_truncate( s, 3, false, 1 ), 3 );
    assert_equals( schattenp_truncate( s, 2.5, false, 1 ), 4 );
end



function n=schatten_norm( A, p )
if iscell(A)
    A=A{1}*A{2}';
end
s=svd(A);
n=norm(s,p);

