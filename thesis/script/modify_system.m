if iscell(mod_opts)
    mod_opts=varargin2options(mod_opts);
end
l_k=get_option( mod_opts, 'l_k', [] );
M_u=get_option( mod_opts, 'M_u', [] );

if ~isempty( l_k )
    l_k=min(l_k, size(Ki,1));
    Ki=Ki(1:l_k,:);
    K=K(1:l_k,:);
end

if ~isempty( M_u )
    M_u=min(M,M_u);
    I_u=I_u(1:M_u,:);
    I_OP=I_OP(1:M_u,:);
    I_RHS=I_RHS(1:M_u,:);
    G_X=G_X(1:M_u,1:M_u);
    M=M_u;
    f_k_beta=f_k_beta(:,1:M_u);
    g_k_beta=g_k_beta(:,1:M_u);
    for i=1:size(K,1)
        K{i,2}=K{i,2}(1:M_u,1:M_u);
        Ki{i,2}=Ki{i,2}(1:M_u,1:M_u);
    end
    F{1,2}=F{1,2}(1:M_u,:);
    Fi{1,2}=Fi{1,2}(1:M_u,:);
    G{1,2}=G{1,2}(1:M_u,:);
end


if isempty(prec)
   prec='mean'; 
end
[Mi_inv, Mi]=stochastic_precond_mean_based( Ki, 'precond_type', prec );
