function unittest_apply_boundary_conditions
% UNITTEST_APPLY_BOUNDARY_CONDITIONS Test the APPLY_BOUNDARY_CONDITIONS function.
%
% Example (<a href="matlab:run_example unittest_apply_boundary_conditions">run</a>)
%    unittest_apply_boundary_conditions
%
% See also APPLY_BOUNDARY_CONDITIONS, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'apply_boundary_conditions' );

K={rand(3,3), rand(4,4), rand(5,5);
    rand(3,3), rand(4,4), rand(5,5)};
P=rand(2,3);
KP=apply_boundary_conditions_operator( K, P );
KPex=K;
KPex{1,1}=P*K{1,1}*P';
KPex{2,1}=P*K{2,1}*P';
assert_equals( KP, KPex, 'operator' );

% consistency check
n=7;
K=spdiags( ones(n,1)*[-1,2,-1], [-1,0,1], n, n );
K(1,1)=1;
K(n,n)=1;
bnd=[1,n];
f=(1:n)';
g=((n:-1:1).*(n:-1:1))';
f=repmat(f, 1, 2);
g=repmat(g, 1, 2);

[P_I,P_B]=boundary_projectors( bnd, n );


Ki=apply_boundary_conditions_operator( K, P_I );
fi=apply_boundary_conditions_rhs( K, f, g, P_I, P_B );
ui=Ki\fi;
u=apply_boundary_conditions_solution( ui, g, P_I, P_B );

u2=P_I'*ui+P_B'*P_B*g;

assert_equals( u, u2, 'u' );
assert_equals( P_B*u, P_B*g, 'u_g_B' );
assert_equals( P_I*K*u, P_I*f, 'Ku_f_I' );




%%
[K,f,g,u,P_I,P_B]=setup_test_system(1, true);
[Kn, fn]=apply_boundary_conditions_system(K, f, g, P_I, P_B);
un = Kn\fn;
assert_equals(un, u, 'det_mat')


%%
[K,f,g,u,P_I,P_B]=setup_test_system(3, true);
[Kn, fn]=apply_boundary_conditions_system(K, f, g, P_I, P_B);
un = Kn\fn;
assert_equals(un, u, 'stoch_mat')

%%
[K,f,g,u,P_I,P_B]=setup_test_system(3, false);
[Kn, fn]=apply_boundary_conditions_system(K, f, g, P_I, P_B);
un = tensor_operator_to_matrix(Kn)\tensor_to_vector(fn);
assert_equals(un, tensor_to_vector(u), 'stoch_tensor')

%%
[K,f,g,u,P_I,P_B]=setup_test_system(3, false, true);
[Kn, fn]=apply_boundary_conditions_system(K, f, g, P_I, P_B);
un = tensor_operator_to_matrix(Kn)\fn;
assert_equals(un, u, 'stoch_tensor_vec')


function [K,f,g,u,P_I,P_B]=setup_test_system(order, vec, uvec)
if nargin<3
    uvec=vec;
end

bnd = [3, 7];
K={rand(7,7), rand(4,4), rand(5,5);
    rand(7,7), rand(4,4), rand(5,5)};
K=K(:,1:order);
if vec; K=tensor_operator_to_matrix(K); end

[P_I, P_B] = boundary_projectors(bnd, 7);
ru = 2;
u = {rand(7,ru), rand(4,ru), rand(5,ru)};
u = u(1:order);
if uvec; u=tensor_to_vector(u); end


I_I = {P_I' * P_I, eye(4), eye(5)};
I_I=I_I(:,1:order);
if vec; I_I=tensor_operator_to_matrix(I_I); end

I_B = {P_B' * P_B, eye(4), eye(5)};
I_B=I_B(:,1:order);
if vec; I_B=tensor_operator_to_matrix(I_B); end

f = operator_apply(K, u);
g = operator_apply(I_B, u);
