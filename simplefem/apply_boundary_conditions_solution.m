function u=apply_boundary_conditions_solution( ui, g, P_B, P_I )
if iscell(ui)
    M=size(ui{2},1);
else
    Ni=size(P_I,1);
    NiM=numel(ui);
    M=NiM/Ni;
end
if M>1; I_S=speye(M); else I_S=1; end

% fi=P_I*(f-K*P_B'*P_B*g);
u=tensor_operator_apply( {P_I', I_S}, ui );
if false && size(g,1)==Nb*M
    g=tensor_operator_apply( {P_B', I_S}, g );
else
    g=tensor_operator_apply( {P_B'*P_B, I_S}, g );
end
    
if iscell(u)
    %u=tensor_add( u, g, 1, 'reduce', {} );
    u=tensor_add( u, g );
    u=tensor_reduce( u );
else
    u=u+g;
end
