function unittest_generalised_solve_simple
% UNITTEST_GENERALISED_SOLVE_SIMPLE Test the GENERALISED_SOLVE_SIMPLE function.
%
% Example (<a href="matlab:run_example unittest_generalised_solve_simple">run</a>)
%   unittest_generalised_solve_simple
%
% See also GENERALISED_SOLVE_SIMPLE, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'generalised_solve_simple' );

rand('seed', 12345 ); %#ok<RAND>
randn('seed', 12345 ); %#ok<RAND>

%[A,M,F]=setup( 5, 3, 3, 2, 0.1 );
%[A,M,F]=setup( 50, 30, 3, 2, 0.0025 );
[A,M,F]=setup( 15, 17, 3, 2, 0.02);

Amat=tensor_operator_to_matrix(A);
Mmat=tensor_operator_to_matrix(M);
F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
b=tensor_to_vector(F);
tol=1e-6; maxiter=100; 

% rho=simple_iteration_contractivity( A, inv(Mmat) );
% disp(rho);


% check that the textbook implementation works
[x,flag,relres,iter,resvec]=textbook_simple_iter( Amat, b, tol, maxiter, Mmat ); %#ok<ASGLU>
assert_equals(x,Amat\b,'textbook', 'abstol', 1e-4);
assert_equals(Amat*x-b, zeros(size(b)), 'textbook_res', 'norm', 2, 'abstol',  1e-5 );

% compare normal (matrix x vector) mode with textbook implementation
[X,flag,info]=generalised_solve_simple( Amat, b, 'reltol', tol, 'abstol', tol, 'Minv', inv(Mmat) ); %#ok<ASGLU>
assert_equals(X,x,'sol')
assert_equals(info.resvec,resvec,'resvec');
assert_equals(info.iter,iter,'iter')
assert_equals(info.relres,relres,'relres')

% compare kronecker x matrix mode with textbook implementation
Minv=stochastic_precond_mean_based( A );
B=tensor_to_array(F);
[X,flag,info]=generalised_solve_simple( A, B, 'reltol', tol, 'abstol', tol, 'Minv', Minv ); %#ok<ASGLU>
assert_equals(X(:),x,'sol')
assert_equals(info.resvec,resvec,'resvec');
assert_equals(info.iter,iter,'iter')
assert_equals(info.relres,relres,'relres')

% compare kronecker x tensor format mode with textbook implementation

trunc.eps=0;
trunc.k_max=100;
trunc.show_reduction=false;

common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'verbosity', 0 };

[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc   ); %#ok<ASGLU>
assert_equals(tensor_to_vector(X),x,'sol','reltol', 1e-6);
assert_equals(info.resvec,resvec,'resvec');
assert_true(tensor_rank( X )<=min(tensor_size(X)),'rank must be smaller/equal than min dimen','rank');
assert_equals( flag, 0, 'flag');

[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'before', 'trunc', trunc ); %#ok<ASGLU>
assert_equals(tensor_to_vector(X),x,'sol','reltol', 1e-6);
assert_equals(info.resvec,resvec,'resvec');
assert_true(tensor_rank( X )<=min(tensor_size(X)),'rank must be smaller/equal than min dimen','rank');
assert_equals( flag, 0, 'flag');

%tol=1e-6;
%common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'verbosity', 0 };
[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'after', 'trunc', trunc  ); %#ok<ASGLU>
assert_equals(tensor_to_vector(X),x,'sol', 'reltol', 1e-6);
assert_equals(info.resvec(1:10),resvec(1:10),'resvec');
assert_true(tensor_rank( X )<=min(tensor_size(X)),'rank must be smaller/equal than min dimen','rank');
assert_equals( flag, 0, 'flag');


% test with truncation
trunc.eps=1e-11;
[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc  ); %#ok<ASGLU>
assert_equals( x, tensor_to_vector( X ), 'sol_trunc', 'abstol', 1e-6 );
assert_equals( flag, 0, 'flag');

[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'before', 'trunc', trunc  ); %#ok<ASGLU>
assert_equals( x, tensor_to_vector( X ), 'sol_trunc', 'abstol', 1e-6 );
assert_equals( flag, 0, 'flag');

[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'after', 'trunc', trunc  ); %#ok<ASGLU>
assert_equals( x, tensor_to_vector( X ), 'sol_trunc', 'abstol', 1e-6 );
assert_equals( flag, 0, 'flag');


% test with truncation
trunc.eps=1e-8;
tol=1e-6;
common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'verbosity', 0 };

[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc  ); %#ok<ASGLU>
assert_equals( x, tensor_to_vector( X ), 'sol_trunc', 'norm', 2, 'reltol', 2*tol );
assert_equals( flag, 0, 'flag');

[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'before', 'trunc', trunc  ); %#ok<ASGLU>
assert_equals( x, tensor_to_vector( X ), 'sol_trunc', 'norm', 2, 'reltol', 2*tol );
assert_equals( flag, 0, 'flag');

[X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'after', 'trunc', trunc  ); %#ok<ASGLU>
assert_equals( x, tensor_to_vector( X ), 'sol_trunc', 'norm', 2, 'reltol', 2*tol );
assert_equals( flag, 0, 'flag');



function [A,M,F]=setup( n, m, kA, kf, r )
A{1,1} = matrix_gallery('tridiag',n,-1,2,-1);
A{1,2} = matrix_gallery('randcorr',m);
for i=1:kA
    A{i+1,1}=r*r*matrix_gallery('tridiag',n,-1,3,-1);
    A{i+1,2}=matrix_gallery('randcorr',m);
end
M=A(1,:);
F={rand(n,kf),  rand(m,kf) };

