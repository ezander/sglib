function [Ki,fi]=apply_boundary_conditions( K, f, g, P_B, P_I, varargin )

options=varargin2options( varargin{:} );
%[s,options]=get_option( options, 'scaling', 1 );
check_unsupported_options( options, mfilename );


if isnumeric(K)
    m=size(K,1)/size(P_B,2);
    I_S=speye(m);
    I_B=tkron(I_B,I_S);
    I_I=tkron(I_I,I_S);

    Ki=P_I*K*P_I';
    fi=P_I*(f-K*I_B*g);
else
    Ki=K;
    for i=1:size(K,1)
        Ki{i,1}=compose_linear_operator( Ki{i,1}, P_I' )
        Ki{i,1}=compose_linear_operator( P_I, Ki{i,1} )
    end
    fi=apply_tensor_operator( 
    if nargout>1
        error('not yet implemented');
    end
end


