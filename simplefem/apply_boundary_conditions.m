function [Ks,fs]=apply_boundary_conditions( K, f, g, P_B, P_I, m, varargin )

options=varargin2options( varargin{:} );
[s,options]=get_option( options, 'scaling', 1 );
[spatial_pos,options]=get_option( options, 'spatial_pos', 1 );
check_unsupported_options( options, mfilename );

I=speye(m);


if spatial_pos==1
    I_B=kron(P_B'*P_B,I);
    I_I=kron(P_I'*P_I,I);
else
    I_B=kron(I,P_B'*P_B);
    I_I=kron(I,P_I'*P_I);
end

Ks=I_I*K*I_I+s*I_B;
fs=I_I*(f-K*I_B*g)+s*I_B*g;
