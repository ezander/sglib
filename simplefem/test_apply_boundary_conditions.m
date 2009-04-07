function test_boundary_projectors

assert_set_function( 'apply_boundary_conditions' );

n=7;
K=spdiags( ones(n,1)*[-1,2,-1], [-1,0,1], n, n );
K(1,1)=1;
K(n,n)=1;
bnd=[1,n];
f=(1:n)';
g=((n:-1:1).*(n:-1:1))';

[P_B,P_I]=boundary_projectors( bnd, n );


[Ks,fs]=apply_boundary_conditions( K, f, g, P_B, P_I, 1, 'scaling', .7 );
u=Ks\fs;

assert_equals( P_B*u, P_B*g, 'u_g_B' );
assert_equals( P_I*K*u, P_I*f, 'Ku_f_I' );

