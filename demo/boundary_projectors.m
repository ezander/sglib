function [P_B,P_I]=boundary_projectors( bnd, n )

n_B=length(bnd);
n_I=n-n_B;

P_B=sparse( 1:n_B, bnd, ones(n_B,1), n_B, n );

int=ones(n,1);
int(bnd)=0;
int=find(int);
P_I=sparse( 1:n_I, int, ones(n_I,1), n_I, n );
