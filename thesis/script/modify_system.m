if iscell(mod_opts)
    mod_opts=varargin2options(mod_opts);
end
l_k=get_option( mod_opts, 'l_k', [] );

if ~isempty( l_k )
    l_k=min(l_k, size(Ki,1));
    Ki=Ki(1:l_k,:);
    K=K(1:l_k,:);
end


if isempty(prec)
   prec='mean'; 
end
Mi_inv=stochastic_precond_mean_based( Ki, 'precond_type', prec );
