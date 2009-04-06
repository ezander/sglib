function [Ks,fs]=apply_essential_boundary_conditions( K, f, g, P_B, P_I, m, s )

n=size(K,1);
I=speye(m);

I_B=kron(P_B'*P_B,I);
I_I=kron(P_I'*P_I,I);
I_B=kron(I,P_B'*P_B);
I_I=kron(I,P_I'*P_I);

Ks=I_I*K*I_I+s*I_B;
fs=I_I*(f-K*I_B*g)+s*I_B*g;
