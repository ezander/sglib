function test_tensor_reduce
% TEST_TENSOR_REDUCE Test the TENSOR_REDUCE function.
%
% Example (<a href="matlab:run_example test_tensor_reduce">run</a>) 
%    test_tensor_reduce
%
% See also TENSOR_REDUCE, TESTSUITE

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


assert_set_function( 'schattenp_truncate' );

s=[5,4,3,2,1];
assert_equals( schattenp_truncate( s, 4, false, inf ), 2 );
assert_equals( schattenp_truncate( s, 4, false, 2 ), 2 ); % sqrt(1+4+9)=sqrt(14)<=4
assert_equals( schattenp_truncate( s, 4, false, 1 ), 3 );

return 
assert_set_function( 'tensor_reduce' );

k0=5;
T={rand(8,k0), rand(10,k0)};
U=tensor_reduce(T);
assert_equals( U{1}*U{2}', T{1}*T{2}', 'reduce_0' )
assert_equals( schatten_norm(U,2), schatten_norm(T,2), 'reduce_0' )
U=tensor_reduce(T,'k_max',4);
assert_equals( size(U{1},2), 4, 'reduce_k4' )
U=tensor_reduce(T,'k_max',2);
assert_equals( size(U{1},2), 2, 'reduce_k2' )


%[M1,options]=get_option( options, 'M1', [] );
%[M2,options]=get_option( options, 'M2', [] );
%[Sp,options]=get_option( options, 'Sp', 2 );
%[k_max,options]=get_option( options, 'k_max', inf );
%[eps,options]=get_option( options, 'eps', 0 );
%[relcutoff,options]=get_option( options, 'relcutoff', true );

eps=schatten_norm( T, 2 )/50;
U=tensor_reduce(T, 'Sp', 2, 'eps', eps, 'relcutoff', false );
assert_equals( schatten_norm(T,2), schatten_norm(U,2), 'reduce_0', 'abstol', eps )
U={U{1}(:,1:end-1),U{2}(:,1:end-1)};
assert_equals( true, abs(schatten_norm(tensor_add(T,U,-1),2))>eps, 'reduce_0', 'abstol', eps )



function n=schatten_norm( A, p )
if iscell(A)
    A=A{1}*A{2}';
end
s=svd(A);
n=norm(s,p);
