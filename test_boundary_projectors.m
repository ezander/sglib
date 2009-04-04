function test_boundary_projectors

assert_set_function( 'boundary_projectors' );
[P_B,P_I]=boundary_projectors( [1,3,5], 8 );

assert_equals( P_B*(1:8)', [1;3;5], 'P_B' );
assert_equals( P_I*(1:8)', [2;4;6;7;8], 'P_I' );

assert_equals( P_B*P_B', eye(3), 'proj_I_B' );
assert_equals( P_I*P_I', eye(5), 'proj_I_I' );
assert_equals( P_B'*P_B+P_I'*P_I, eye(8), 'id' );

I_B=P_B'*P_B;
I_I=P_I'*P_I;
assert_equals( I_B*I_B, I_B, 'proj_B' );
assert_equals( I_I*I_I, I_I, 'proj_I' );
assert_equals( I_I*I_B, zeros(8), 'proj_orth' );
assert_equals( I_I+I_B, eye(8), 'proj_compl' );


n=7;
K=spdiags( ones(n,1)*[-1,2,-1], [-1,0,1], n, n );
K(1,1)=1;
K(n,n)=1;
bnd=[1,n];
f=(1:n)';
g=((n:-1:1).*(n:-1:1))';


% test whether the stuff works on a simple fem problem
[P_B,P_I]=boundary_projectors( bnd, n );
I_B=P_B'*P_B;
I_I=P_I'*P_I;

s=0.5;
Ks=I_I*K*I_I+s*I_B;
fs=I_I*(f-K*I_B*g)+s*I_B*g;
u=Ks\fs;

assert_equals( P_B*u, P_B*g, 'u_g_B' );
assert_equals( P_I*K*u, P_I*f, 'Ku_f_I' );
