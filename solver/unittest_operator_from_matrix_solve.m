function unittest_operator_from_matrix_solve
% UNITTEST_OPERATOR_FROM_MATRIX_SOLVE Test the OPERATOR_FROM_MATRIX_SOLVE function.
%
% Example (<a href="matlab:run_example unittest_operator_from_matrix_solve">run</a>)
%   unittest_operator_from_matrix_solve
%
% See also OPERATOR_FROM_MATRIX_SOLVE, TESTSUITE 

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

munit_set_function( 'operator_from_matrix_solve' );

M=[1, 2, 3; 3, 4, 6; 5, 10, 8];
M=sparse(M);
M=M'*M;

N=30;
M=rand(N);
M(M<0.9)=0;
M=M'*M;
% [V,D]=eig(M);
% D=diag(diag(D)+1e-13); %-10*min(diag(D)));
% M=V*D*V';
M=2*eye(size(M))+M;
M=sparse(M);

M=rand(N);
M(M<0.7)=0;

solver=operator_from_matrix_solve(M, 'lu');
applier=operator_from_matrix_solve(M, 'lu', 'apply', true );
%solver=operator_from_matrix_solve(M, 'chol');
%solver=operator_from_matrix_solve(M, 'ilu');
d=operator_size( solver );

x=ones(d(1),1);
%y=M*x;
y=operator_apply( applier, x );
x2=operator_apply( solver, y );
disp( ' ' );
%disp(round([x,x2, y]));
disp(norm(x-x2));

