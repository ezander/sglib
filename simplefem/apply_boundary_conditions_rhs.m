function fi=apply_boundary_conditions_rhs( K, f, g, P_B, P_I )
N=size(P_I,2);
NM=tensor_operator_size(K);
M=NM(1)/N;
if M>1; I_S=speye(M); else I_S=1; end

% fi=P_I*(f-K*P_B'*P_B*g);
fi=tensor_operator_apply( {P_I, I_S}, f );
g=tensor_operator_apply( {P_B'*P_B, I_S}, g );
g=tensor_operator_apply( K, g );
gi=tensor_operator_apply( {P_I, I_S}, g );
if iscell(f)
    %fi=tensor_add( fi, gi, -1, 'reduce', {} );
    fi=tensor_add( fi, gi, -1 );
    %fi=tensor_reduce( fi );
else
    fi=fi-gi;
end
