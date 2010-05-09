function unittest_generalized_solve_simple
% UNITTEST_GENERALIZED_SOLVE_SIMPLE Test the GENERALIZED_SOLVE_SIMPLE function.
%
% Example (<a href="matlab:run_example unittest_generalized_solve_simple">run</a>)
%   unittest_generalized_solve_simple
%
% See also GENERALIZED_SOLVE_SIMPLE, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'generalized_solve_simple' );
clc


rand('seed', 12345 );
randn('seed', 12345 );

[A,M,F]=setup( 5, 3, 3, 2, 0.01 );
%return
s=0;
for i=2:size(A,1)
    s=s+norm(full(kron(A{i,1},A{i,2})));
end

%i=2;norm(full(kron(A{i,1},A{i,2})))
%norm(full(kron(A{1,1},A{1,2})))
X=zeros(15);
for i=1:size(A,1)
    X=X+full(kron(A{i,1},A{i,2}));
end
%format short
AA=A{1,2}; full(AA) %full(AA(AA~=0))'
norm(full(AA))
A=tensor_operator_to_matrix(A);
M=tensor_operator_to_matrix(M);
b=tensor_to_vector(F);
b=b/norm(b)*2; % makes reltol more significant than abstol
tol=1e-9; maxit=100; 

norm(full(X))
norm(full(A))
norm(full(M))
norm(full(A-M))
s
%norm(full(eye(15)-M\A))


[x,flag,relres,iter,resvec]=textbook_simple_iter( A, b, tol, maxit, M ); %#ok<ASGLU>
assert_equals(x,A\b,'x')

return
[X,flag,info]=generalized_solve_simple( A, b, 'reltol', tol, 'Minv', inv(M) ); %#ok<ASGLU>
assert_equals(X,x,'x')
assert_equals(info.resvec,resvec,'resvec');
assert_equals(info.iter,iter,'pre_iter')
assert_equals(info.relres,relres,'pre_relres')



function [A,M,F]=setup( n, m, kA, kf, r )
A{1,1} = matrix_gallery('tridiag',n,-1,2,-1);
A{1,2} = matrix_gallery('randcorr',m);
for i=1:kA
    A{i+1,1}=r*matrix_gallery('tridiag',n,-1,3,-1);
    A{i+1,2}=  matrix_gallery('randcorr',m);
end
M=A(1,:);
F={rand(n,kf),  rand(m,kf) };


function [x,flag,relres,iter,resvec]=textbook_simple_iter( A, b, tol, maxit, M )
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
    x=x+M\r;
    r=b-A*x;
    
    resvec(end+1)=norm(r); %#ok<AGROW>
    if norm(r)<tolb
        flag=1;
        break;
    end
end
relres=norm(r)/norm_r0;
resvec=resvec(:);



function value=get_param_default( name, default )
try
    value=evalin( 'caller', name );
catch
    value=default;
end

