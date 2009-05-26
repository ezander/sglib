function [Ks,fs]=apply_boundary_conditions( K, f, g, P_B, P_I, varargin )

options=varargin2options( varargin{:} );
[s,options]=get_option( options, 'scaling', 1 );
check_unsupported_options( options, mfilename );


I_B=P_B'*P_B;
I_I=P_I'*P_I;

if isnumeric(K)
    m=size(K,1)/size(P_B,2);
    I_S=speye(m);
    I_B=tkron(I_B,I_S);
    I_I=tkron(I_I,I_S);

    Ks=I_I*K*I_I+s*I_B;
    fs=I_I*(f-K*I_B*g)+s*I_B*g;
else
    Ks=K;
    for i=1:size(K,1)
        Ks{i,1}=I_I*K{i,1}*I_I+s*I_B;
    end
    if nargout>1
        error('not yet implemented');
    end
end


