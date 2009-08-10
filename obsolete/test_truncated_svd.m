function test_truncated_svd
% TEST_TRUNCATED_SVD Test the TRUNCATED_SVD function.
% Example 
%    test_truncated_svd
% See also TESTSUITE, TRUNCATED_SVD

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id: test_truncated_svd.m 316 2009-07-16 12:05:58Z ezander $ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'truncated_svd' );


A=eye(10);
A5=truncated_svd(A,5);
A5a=[eye(5), zeros(5); eye(5,10)];
assert_equals( rank(A5), 5, 'rank' );
% A5 should be the best approximation in the Frobenius norm
assert_true( norm(A5,'fro')<=norm(A5a,'fro'), '', 'best_frob_approx' );


[U,S,V]=svds(A,7);
A7s={U*S,V}; %B={diag(S),U,V};
A5s=truncated_svd(A7s,5);
assert_equals( size(A5s{1}), [10,5], 'size' );
assert_equals( rank(A5s{1}*A5s{2}'), 5, 'rank' );
assert_true( norm(A5s{1}*A5s{2}','fro')<=norm(A5a,'fro'), '', 'best_frob_approx' );


A=rand(8,6);
A5=truncated_svd(A,5);
assert_equals( rank(A5), 5, 'rank' );
assert_equals( svds(sparse(A5),5), svds(sparse(A),5), 'sing_vals' );


A=rand(18,16);
[U,S,V]=svds(sparse(A),12);
A5a=truncated_svd({U*S,V},5);
A5b=truncated_svd({diag(S),U,V},5);
assert_equals( size(A5a{1}), [18,5], 'size_u' );
assert_equals( size(A5a{2}), [16,5], 'size_v' );
assert_equals( norm(A5a{1}*A5a{2}'-A,2), S(6,6), '2norm' );
assert_equals( A5b{1}, svds(sparse(A),5), 'sing_vals' );
A5a2=truncated_svd(A5a,5);
assert_equals( A5a2{1}*diag(1./diag(A5a2{1})), A5a{1}*diag(1./diag(A5a{1})), 'stable' );
assert_equals( A5a2{2}*diag(1./diag(A5a2{1})), A5a{2}*diag(1./diag(A5a{1})), 'stable' ); % {1} is no error here!

