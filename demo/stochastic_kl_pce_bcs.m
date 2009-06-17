function [f_j_i,phi_i_beta]=stochastic_kl_pce_bcs( f_j_i, phi_i_beta, I_u, K_mu_delta, bnd, g_bnd, gam_bnd_alpha )

if size(g_bnd, 1)==size(f_j_i,1)
    g_j_i=f_j_i;
elseif size(g_bnd, 1)==length(bnd)
    g_j_i=zeros( size(f_j_i,1), size(g_bnd,2) );
    g_j_i(bnd,:)=g_bnd;
else
    error('wronge length')
end

if nargin<7 || isempty(gam_bnd_alpha)
    gam_bnd_alpha=zeros(1,length(I_u));
    gam_bnd_alpha(1)=1;
end
    
trunc_k=100;
trunc_eps=1e-7;

x=apply_stochastic_kl_operator( K_mu_delta, {g_j_i, gam_bnd_alpha'}, trunc_k, trunc_eps );
x=tensor_add( x, {f_j_i, phi_i_beta'} );
x=tensor_truncate( x, trunc_k, trunc_eps );


f_j_i=[f_j_i x{1}];
phi_i_beta=[phi_i_beta x{2}'];


function Y=apply_stochastic_kl_operator( A, X, trunc_k, trunc_eps )
A_0={ A{1}, A{2} };
A_i={A{3}{:};A{4}{:}}';

Y=tensor_apply( A_0, X );
for i=1:size(A_i,1)
    S_i=tensor_apply( A_i(i,:), X );
    Y=tensor_add( Y, S_i, -1 );
    Y=tensor_truncate( Y, trunc_k, trunc_eps );
end

