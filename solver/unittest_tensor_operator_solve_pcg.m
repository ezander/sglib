function unittest_tensor_operator_solve_pcg
% UNITTEST_TENSOR_OPERATOR_SOLVE_PCG Test the TENSOR_OPERATOR_SOLVE_PCG function.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_solve_pcg">run</a>)
%   unittest_tensor_operator_solve_pcg
%
% See also TENSOR_OPERATOR_SOLVE_PCG, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_operator_solve_pcg' );

[A,M,F]=setup( 5, 3, 3, 2 );
XvecEx=tensor_operator_to_matrix(A)\tensor_to_vector(F);
tol=1e-7;
%pcg_opts={ 'eps', 1e-7, 'k_max', 2 };
assert_opts={ 'abstol', 10*tol, 'reltol', 10*tol };

[X,flag,info]=tensor_operator_solve_pcg( A, F);
Xvec1=tensor_to_vector( X );
assert_equals( flag, 0, 'tensor_pcg_op_flag' );
assert_equals( Xvec1, XvecEx, 'tensor_pcg_op', assert_opts{:} );

[X,flag,info]=tensor_operator_solve_pcg( A, F, 'M', M );
Xvec1=tensor_to_vector( X );
assert_equals( flag, 0, 'tensor_pcg_op_flag' );
assert_equals( Xvec1, XvecEx, 'tensor_pcg_op', assert_opts{:} );



function [A,M,F]=setup( n, m, kA, kf )
A{1,1} = matrix_gallery('tridiag',n,-1,2,-1);
A{1,2} = matrix_gallery('randcorr',m);
for i=1:kA
    A{i+1,1} = 0.1*matrix_gallery('tridiag',n,-1,3,-1);
    A{i+1,2}=matrix_gallery('randcorr',m);
end
M=A(1,:);
F={rand(n,kf),  rand(m,kf) };
