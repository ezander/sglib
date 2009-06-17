function Ki=apply_boundary_conditions_operator( K, P_B, P_I )
N=size(P_B,2);
NM=tensor_operator_size(K);
M=NM(1)/N;
if M>1; I_S=speye(M); else I_S=1; end

% Ki=P_I*K*P_I';
Ki=tensor_operator_compose( {P_I, I_S}, K );
Ki=tensor_operator_compose( Ki, {P_I', I_S} );
