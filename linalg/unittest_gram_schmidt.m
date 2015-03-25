function unittest_gram_schmidt
% UNITTEST_GRAM_SCHMIDT Test the GRAM_SCHMIDT function
%
% Example (<a href="matlab:run_example unittest_gram_schmidt">run</a>)
%    unittest_gram_schmidt
%
% See also MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2007-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'gram_schmidt' );

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
assert_matrix( R, 'upper triangular', 'dgs_R_is_upper');
assert_matrix( Q'*Q, 'identity', 'dgs_orth_Q' );
assert_equals( A, Q*R, 'dgs_eq_A_QR' );

% Classical Gram-Schmidt
[Q,R]=gram_schmidt( A, [], false, 0 );
assert_matrix( R, 'upper triangular', 'gs_R_is_upper');
assert_matrix( Q'*Q, 'identity', 'gs_orth_Q' );
assert_equals( A, Q*R, 'gs_eq_A_QR' );

% Modified Gram-Schmidt
[Q,R]=gram_schmidt( A, [], true, 0 );
assert_matrix( R, 'upper triangular', 'mgs_R_is_upper');
assert_matrix( Q'*Q, 'identity', 'mgs_orth_Q' );
assert_equals( A, Q*R, 'mgs_eq_A_QR' );

% Gram-Schmidt with reorthogonalization
[Q,R]=gram_schmidt( A, [], [], 1 );
assert_matrix( R, 'upper triangular', 'gs2_R_is_upper');
assert_matrix( Q'*Q, 'identity', 'gs2_orth_Q' );
assert_equals( A, Q*R, 'gs2_eq_A_QR' );



% Default conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M );
assert_matrix( R, 'upper triangular', 'dcgs_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'dcgs_M_orth_Q' );
assert_equals( A, Q*R, 'dcgs_eq_A_QR' );

% Conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M, false, 0 );
assert_matrix( R, 'upper triangular', 'cgs_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'cgs_M_orth_Q' );
assert_equals( A, Q*R, 'cgs_eq_A_QR' );

% Modified conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M, true, 0 );
assert_matrix( R, 'upper triangular', 'mcgs_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'mcgs_M_orth_Q' );
assert_equals( A, Q*R, 'mcgs_eq_A_QR' );

% Conjugate Gram-Schmidt with reorthogonalization
[Q,R]=gram_schmidt( A, M, [], 1 );
assert_matrix( R, 'upper triangular', 'cgs2_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'cgs2_M_orth_Q' );
assert_equals( A, Q*R, 'cgs2_eq_A_QR' );

% Modified conjugate Gram-Schmidt with reorthogonalization
[Q,R]=gram_schmidt( A, M, true, 1 );
assert_matrix( R, 'upper triangular', 'mcgs2_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'mcgs2_M_orth_Q' );
assert_equals( A, Q*R, 'mcgs2_eq_A_QR' );

%% this was an example that had failed
M=[
    2.071049081337153   1.609333535203871   1.704251014646915   1.315471187763935
    1.609333535203871   2.195518740700989   1.349514355963204   1.691143336290343
    1.704251014646915   1.349514355963204   1.611882888259560   1.231975301129495
    1.315471187763935   1.691143336290343   1.231975301129495   1.397813726138777
    ];
A=[
    0.735696840442576   0.204553051481281   0.792352904934600   0.735696840442576   0.204553051481281   0.792352904934600
    0.856797318373247   0.923136245889187   0.075273235829209   0.856797318373247   0.923136245889187   0.075273235829209
    0.192529899157830   0.150884659565466   0.117274581509305   0.192529899157830   0.150884659565466   0.117274581509305
    0.850015145656660   0.918473316784237   0.033891426880793   0.850015145656660   0.918473316784237   0.033891426880793
    ];


[Q,R]=gram_schmidt( A, M, true, 1 );
assert_matrix( R, 'upper triangular', 'R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'M_orth_Q' );
assert_equals( A, Q*R, 'eq_A_QR' );


%% New tests come here
% testing for tall and squat matrices, also for matrices with repeated
% entries

n=20;
k=30;
A=rand(n,k);
F=rand(n,n);
M=F'*F;

% Default conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M );
assert_matrix( R, 'upper triangular', 'dcgs_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'dcgs_M_orth_Q' );
assert_equals( A, Q*R, 'dcgs_eq_A_QR' );

% Default conjugate Gram-Schmidt
A=[A A];
[Q,R]=gram_schmidt( A, M );
assert_matrix( R, 'upper triangular', 'dcgs_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'dcgs_M_orth_Q' );
assert_equals( A, Q*R, 'dcgs_eq_A_QR' );

n=40;
k=30;
A=rand(n,k);
F=rand(n,n);
M=F'*F;

% Default conjugate Gram-Schmidt
[Q,R]=gram_schmidt( A, M );
assert_matrix( R, 'upper triangular', 'dcgs_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'dcgs_M_orth_Q' );
assert_equals( A, Q*R, 'dcgs_eq_A_QR' );

% Default conjugate Gram-Schmidt
A=[A A];
[Q,R]=gram_schmidt( A, M );
assert_matrix( R, 'upper triangular', 'dcgs_R_is_upper');
assert_matrix( Q'*M*Q, 'identity', 'dcgs_M_orth_Q' );
assert_equals( A, Q*R, 'dcgs_eq_A_QR' );
