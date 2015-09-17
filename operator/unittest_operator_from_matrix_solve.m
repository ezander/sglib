function unittest_operator_from_matrix_solve
% UNITTEST_OPERATOR_FROM_MATRIX_SOLVE Test the OPERATOR_FROM_MATRIX_SOLVE function.
%
% Example (<a href="matlab:run_example unittest_operator_from_matrix_solve">run</a>)
%   unittest_operator_from_matrix_solve
%
% See also OPERATOR_FROM_MATRIX_SOLVE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'operator_from_matrix_solve' );

munit_control_rand('seed', 1234567 );
munit_control_rand('seed', 1234 );

% create sparse positive definite symmetric matrix
N=30;
X=rand(N);

M=mk_any(N,0.1,1e-3);
[Ainv,A,info]=operator_from_matrix_solve(M);
assert_equals( operator_size( A ), [N,N], 'dir_size' );
assert_equals( operator_apply( A, operator_apply( Ainv, X )), X, 'dir_ident' );
assert_equals( operator_apply( A, X ), M*X, 'dir_apply' );
assert_equals( operator_apply( Ainv, X ), M\X, 'dir_solve' );
assert_equals( size(info), [1,1], 'dir_info_size' );
assert_equals( info.L*info.U, M, 'dir_fake_lu' );

M=mk_any(N,0.1,1e-3);
[Ainv,A,info]=operator_from_matrix_solve(M, 'lu');
assert_equals( operator_size( A ), [N,N], 'lu_size' );
assert_equals( operator_apply( A, operator_apply( Ainv, X )), X, 'lu_ident' );
assert_equals( operator_apply( A, X ), M*X, 'lu_apply' );
assert_equals( operator_apply( Ainv, X ), M\X, 'lu_solve' );
assert_matrix( info.L, 'lower triangular', 'lu_l_lower' );
assert_matrix( info.U, 'upper triangular', 'lu_u_upper' );


M=mk_spd(N,0.1,1e-3);
[Ainv,A]=operator_from_matrix_solve(M, 'chol');
assert_equals( operator_size( A ), [N,N], 'chol_size' );
assert_equals( operator_apply( A, operator_apply( Ainv, X )), X, 'chol_ident' );
assert_equals( operator_apply( A, X ), M*X, 'chol_apply' );
assert_equals( operator_apply( Ainv, X ), M\X, 'chol_solve' );
assert_matrix( info.L, 'lower triangular', 'chol_l_lower' );
assert_matrix( info.U, 'upper triangular', 'chol_u_upper' );

if isversion('0.0', '7.4')
    % ILU has been introduced in matlab version 7.4, so if we have a
    % smaller version number we skip these tests.
    return
end

opts = {'reltol', 1e-4};
M=mk_any(N,0.1,1);
[Ainv,A,info]=operator_from_matrix_solve(M, 'ilu'); % that's exact like exact lu (not any more as of R2012b)
assert_equals( operator_size( A ), [N,N], 'ilu_size' );
assert_equals( operator_apply( A, operator_apply( Ainv, X )), X, 'ilu_ident', opts);
%assert_equals( operator_apply( A, X ), M*X, 'ilu_apply', opts); % doesn't hold any more as of R2012b
%assert_equals( operator_apply( Ainv, X ), M\X, 'ilu_solve', opts); % doesn't hold any more as of R2012b

M=mk_any(N,0.1,1e-1);
[Ainv,A,info]=operator_from_matrix_solve(M, 'ilu', 'decomp_options', {'type', 'nofill'}); % that's exact
assert_equals( operator_size( A ), [N,N], 'ilu0_size' );
assert_equals( operator_apply( A, operator_apply( Ainv, X )), X, 'ilu0_ident' );
assert_equals( (info.L+info.U)~=0, (M~=0), 'ilu0_nofill' );
assert_matrix( info.L, 'lower triangular', 'ilu0_l_lower' );
assert_matrix( info.U, 'upper triangular', 'ilu0_u_upper' );

M=mk_any(N,0.1,1e-1);
[Ainv,A,info]=operator_from_matrix_solve(M, 'ilu', 'decomp_options', {'type', 'ilutp', 'droptol', 1e-2, 'milu', 'row'}); % that's exact
assert_equals( operator_size( A ), [N,N], 'ilutp_size' );
assert_equals( operator_apply( A, operator_apply( Ainv, X )), X, 'ilutp_ident' );
assert_matrix( info.L, 'lower triangular', 'ilutp_l_lower' );
assert_matrix( info.U, 'upper triangular', 'ilutp_u_upper' );



function M=mk_spd( N, fill, shift)
M=rand(N);
M(M>fill)=0;
M=M'*M;
M=shift*eye(size(M))+M;
M=sparse(M);

function M=mk_any( N, fill, shift )
M=rand(N);
M(M>fill)=0;
M=shift*eye(size(M))+M;
M=sparse(M);
