function test_gram_schmidt
% TEST_GRAM_SCHMIDT Test the GRAM_SCHMIDT function
%
% Example (<a href="matlab:run_example test_gram_schmidt">run</a>) 
%    test_gram_schmidt
%
% See also TESTSUITE

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


assert_set_function( 'gram_schmidt' );

% Test is currently only with random matrices, should be done also with
% matrices from the matrix toolbox (but first, availability for octave has
% to be checked...)

n=100; 
k=40;
A=rand(n,k);
F=rand(n,n); 
M=F'*F; 

% Default Gram-Schmidt
[Q,R]=gram_schmidt( A );
assert_equals( R, triu(R), 'dgs_triu_R' );
assert_equals( Q'*Q, eye(k), 'dgs_orth_Q' );
assert_equals( A, Q*R, 'dgs_eq_A_QR' );

% Classical Gram-Schmidt
[Q,R]=gram_schmidt( A, [], false, 0 );
assert_equals( R, triu(R), 'gs_triu_R' );
assert_equals( Q'*Q, eye(k), 'gs_orth_Q' );
assert_equals( A, Q*R, 'gs_eq_A_QR' );

% Modified Gram-Schmidt
[Q,R]=gram_schmidt( A, [], true, 0 );
assert_equals( R, triu(R), 'mgs_triu_R' );
assert_equals( Q'*Q, eye(k), 'mgs_orth_Q' );
assert_equals( A, Q*R, 'mgs_eq_A_QR' );

% Gram-Schmidt with reorthogonalization
[Q,R]=gram_schmidt( A, [], [], 1 );
assert_equals( R, triu(R), 'gs2_triu_R' );
assert_equals( Q'*Q, eye(k), 'gs2_orth_Q' );
assert_equals( A, Q*R, 'gs2_eq_A_QR' );



% Default conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M );
assert_equals( R, triu(R), 'dcgs_triu_R' );
assert_equals( Q'*M*Q, eye(k), 'dcgs_M_orth_Q' );
assert_equals( A, Q*R, 'dcgs_eq_A_QR' );

% Conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M, false, 0 );
assert_equals( R, triu(R), 'cgs_triu_R' );
assert_equals( Q'*M*Q, eye(k), 'cgs_M_orth_Q' );
assert_equals( A, Q*R, 'cgs_eq_A_QR' );

% Modified conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M, true, 0 );
assert_equals( R, triu(R), 'mcgs_triu_R' );
assert_equals( Q'*M*Q, eye(k), 'mcgs_M_orth_Q' );
assert_equals( A, Q*R, 'mcgs_eq_A_QR' );

% Conjugate Gram-Schmidt with reorthogonalization
[Q,R]=gram_schmidt( A, M, [], 1 );
assert_equals( R, triu(R), 'cgs2_triu_R' );
assert_equals( Q'*M*Q, eye(k), 'cgs2_M_orth_Q' );
assert_equals( A, Q*R, 'cgs2_eq_A_QR' );

% Modified conjugate Gram-Schmidt with reorthogonalization
[Q,R]=gram_schmidt( A, M, true, 1 );
assert_equals( R, triu(R), 'mcgs2_triu_R' );
assert_equals( Q'*M*Q, eye(k), 'mcgs2_M_orth_Q' );
assert_equals( A, Q*R, 'mcgs2_eq_A_QR' );

