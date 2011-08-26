%function test_precond
%%
clear;
rand('seed',12353);
randn('seed',12353);
model_small_easy; 
model_medium_easy; 
mean_g_func=make_spatial_func('0');
[a,b]=beta_find_ratio( 0.25 );
dist_k={'beta', {a,b}, 0.001, 1.0 };

define_geometry; 
discretize_model; 
if false
    display_model_details;
    discretize_model;
end
strvarexpand( '%var_f: $percent_var_f$' );
strvarexpand( '%var_k: $percent_var_k$' );

%return
%%
setup_equation


%%
A=tensor_operator_to_matrix( Ki );
F=tensor_to_array(Fi);
F=F+rand(size(F))*3;

%%


for pkind=1:3
    stats=struct();
    tic
    strvarexpand( '($pkind$) setting up preconditioner...' );
    switch pkind
        case 1
            [Pinv,P,info]=stochastic_precond_mean_based( Ki, 'precond_type',0,'decomp_type','');
            stats.name='mean';
        case 2
            [Pinv,P,info]=stochastic_precond_mean_based( Ki, 'precond_type',1,'decomp_type','');
            stats.name='kron';
        case 3
            [Pinv,P,info]=stochastic_precond_mean_based( Ki, 'precond_type',3,'decomp_type','');
            stats.name='ikron';
    end
    toc
    stats.setup_time=toc;
    PP={P{1}{2}{2}{1},P{2}{2}{2}{1}};
    P=tensor_operator_to_matrix( PP );

    strvarexpand( '($pkind$) norm(P-P^T)/norm(P): $norm(full(PP{1}-PP{1}'')/norm(full(PP(2))))$' );
    strvarexpand( '($pkind$) norm(Q-Q^T)/norm(Q): $norm(full(PP{2}-PP{2}'')/norm(full(PP(2))))$' );

    %%
    norm( A-P, 'fro' );
    strvarexpand( '($pkind$) frob: $ans$' );
    stats.diff_norm_fro=ans;
    
    svds( A-P, 1 );
    strvarexpand( '($pkind$) spectral norm: $ans$' );
    stats.diff_norm_2=ans;

    abs(eigs( A-P, 1 ));
    strvarexpand( '($pkind$) spectral radius: $ans$' );
    stats.diff_rho=ans;
    
    simple_iteration_contractivity( A, Pinv );
    strvarexpand( '($pkind$) contractivity: $ans$' );
    stats.idiff_contract=ans;
    
    %[L,U]=lu(P);B=U\(L\A); B=eye(size(B))-B;
    n=size(A,1);
    op=@(x)(x-tensor_operator_apply(Pinv,tensor_operator_apply(Ki,x)) );
    opT=@(x)(x-tensor_operator_apply(Ki,tensor_operator_apply(Pinv,x)) );
    op2=@(x)([op(x(n+1:2*n)); opT(x(1:n))]);
    op3=@(x)(opT(op(x)));
    
%     xxx=rand(n,1);
%     tic; yyy1=B'*(B*xxx); toc;
%     tic; yyy2=op3(xxx); toc;
%     assert_equals( yyy1, yyy2, 'aaa' );
    
%     norm( B, 'fro');
%     strvarexpand( '($pkind$) iterop frob: $ans$' );
%     svds( B, 1);
%     strvarexpand( '($pkind$) iterop spectral norm: $ans$' );
%     abs( eigs( op2, 2*n, 1) );
%     strvarexpand( '($pkind$) iterop spectral norm: $ans$' );
    sqrt( abs( eigs( op3, n, 1) ) );
    strvarexpand( '($pkind$) iterop spectral norm: $ans$' );
    stats.idiff_norm_2=ans;

    %     abs( eigs( B, 1) );
%     strvarexpand( '($pkind$) iterop rho: $ans$' );
    abs( eigs( op, n, 1) );
    strvarexpand( '($pkind$) iterop rho: $ans$' );
    stats.idiff_rho=ans;
    
    %%
    if true
        [X,flag,info]=generalized_solve_pcg( A, F(:), 'Minv', Pinv, 'verbosity', 0 );
        info.iter;
        strvarexpand( '($pkind$) pcg solve steps: $ans$ (rr: $info.relres$)' );
        stats.npcg=info.iter;
        [X,flag,info]=generalized_solve_simple( A, F(:), 'Minv', Pinv, 'verbosity', 0 );
        info.iter;
        strvarexpand( '($pkind$) simple solve steps: $ans$ (rr: $info.relres$)' );
        stats.ngsi=info.iter;
    end
    
    if pkind==1
        all_stats=stats;
    else
        all_stats(end+1)=stats;
    end
end

show_tex_table( 2, all_stats )

    
