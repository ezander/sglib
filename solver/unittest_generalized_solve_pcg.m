function unittest_generalized_solve_pcg
% UNITTEST_GENERALIZED_SOLVE_PCG Test the GENERALIZED_SOLVE_PCG function.
%
% Example (<a href="matlab:run_example unittest_generalized_solve_pcg">run</a>)
%   unittest_generalized_solve_pcg
%
% See also GENERALIZED_SOLVE_PCG, TESTSUITE 

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

munit_set_function( 'generalized_solve_pcg' );

rand('seed', 12345 );

[A,M,F]=setup( 5, 3, 3, 2 );
A=tensor_operator_to_matrix(A);
M=tensor_operator_to_matrix(M);
b=tensor_to_vector(F);
b=b/norm(b)*2; % makes reltol more significant than abstol
tol=1e-6; maxit=100; 

[x,flag,relres,iter,resvec]=textbook_pcg( A, b, tol, maxit ); %#ok<ASGLU>
[x2,flag2,relres2,iter2,resvec2]=pcg( A, b, tol, maxit ); %#ok<ASGLU>
assert_equals(x,x2,'pre_x')
assert_equals(iter,iter2,'pre_iter')
assert_equals(relres,relres2,'pre_relres')
assert_equals(resvec,resvec2,'pre_resvec')

[X,flag,info]=generalized_solve_pcg( A, b, 'reltol', tol ); %#ok<ASGLU>
assert_equals(X,x2,'x')
assert_equals(info.resvec,resvec,'resvec');


[x,flag,relres,iter,resvec]=textbook_pcg( A, b, tol, maxit, M ); %#ok<ASGLU>
[x2,flag2,relres2,iter2,resvec2]=pcg( A, b, tol, maxit, M ); %#ok<NASGU>
[X,flag,info]=generalized_solve_pcg( A, b, 'reltol', tol, 'Minv', inv(M) ); %#ok<ASGLU>
assert_equals(x,x2,'pre_x')
assert_equals(resvec,resvec2,'pre_resvec')
assert_equals(X,x2,'x')
assert_equals(info.resvec,resvec,'resvec');
assert_equals(info.iter,iter,'pre_iter')
assert_equals(info.relres,relres,'pre_relres')


% test the stuff for matrices
[A,M,F]=setup( 5, 3, 3, 2 );
A=tensor_operator_to_matrix(A);
M=tensor_operator_to_matrix(M);
Minv=operator_from_matrix(M,'solve', 'use_lu', true);
F=tensor_to_vector(F);
Xex=A\F;
tol=1e-6;

[X,flag,info]=generalized_solve_pcg( A, F, 'abstol', tol );
assert_equals( flag, 0, 'pcg_op_flag' );
assert_equals( X, Xex, 'pcg_op', 'abstol', tol, 'reltol', tol  );

[X,flag,info]=generalized_solve_pcg( A, F, 'Minv', Minv );
assert_equals( flag, 0, 'pcgprec_op_flag' );
assert_equals( X, Xex, 'pcgprec_op', 'abstol', tol, 'reltol', tol  );

A=operator_from_matrix(A);
[X,flag,info]=generalized_solve_pcg( A, F, 'Minv', Minv );
assert_equals( flag, 0, 'pcg_linop_flag' );
assert_equals( X, Xex, 'pcg_linop', 'abstol', tol, 'reltol', tol  );



% test the stuff for matrices and linear operators
[A,M,F]=setup( 5, 3, 3, 2 );
%M=tensor_operator_to_matrix(M);
%Minv=operator_from_matrix(M,'solve', 'use_lu', true);
Xex=tensor_operator_to_matrix(A)\tensor_to_vector(F);
%A=operator_from_function( {@tensor_operator_apply, {A}, {1}}, tensor_operator_size(A) );
tol=1e-5;
truncate_func={@tensor_truncate, {'eps', 0}};
[X,flag,info]=generalized_solve_pcg( A, F, 'truncate_before_func', truncate_func );
assert_equals( flag, 0, 'pcg_op_flag' );
X=tensor_to_vector(X);
assert_equals( X, Xex, 'pcg_op', 'abstol', tol, 'reltol', tol  );

Minv=stochastic_preconditioner_deterministic( A );
[X,flag,info]=generalized_solve_pcg( A, F, 'truncate_before_func', truncate_func, 'Minv', Minv );
assert_equals( flag, 0, 'pcg_op_flag' );
X=tensor_to_vector(X);
assert_equals( X, Xex, 'pcg_op', 'abstol', tol, 'reltol', tol  );



function [A,M,F]=setup( n, m, kA, kf )
A{1,1} = matrix_gallery('tridiag',n,-1,2,-1);
A{1,2} = matrix_gallery('randcorr',m);
for i=1:kA
    A{i+1,1} = 0.1*matrix_gallery('tridiag',n,-1,3,-1);
    A{i+1,2}=matrix_gallery('randcorr',m);
end
M=A(1,:);
F={rand(n,kf),  rand(m,kf) };


function [x,flag,relres,iter,resvec]=textbook_pcg( A, b, tol, maxit, M )
tol=get_param_default('tol', 1e-6 );
maxit=get_param_default('maxit', 100 );
M=get_param_default('M', speye(size(A)) );
x=zeros(size(b));

norm_r0=norm(b);
tolb=tol*norm_r0;
r=b-A*x;
flag=1;
resvec=[norm_r0];
for iter=1:maxit
    z=M\r;
    rho=r'*z;
    if iter==1
        p=z;
    else
        beta=rho/rho_old;
        p=z+beta*p;
    end
    q=A*p;
    alpha=rho/(p'*q);
    x=x+alpha*p;
    r=r-alpha*q;
    
    resvec(end+1)=norm(r); %#ok<AGROW>
    if norm(r)<tolb
        flag=1;
        break;
    end
    
    rho_old=rho;
end
relres=norm(r)/norm_r0;
resvec=resvec(:);



function value=get_param_default( name, default )
try
    value=evalin( 'caller', name );
catch
    value=default;
end

