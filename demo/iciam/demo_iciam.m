%function demo_iciam

addpath '../'
init_demos
clf
clear

% Solving with stochastic operator
global n x els M %#ok
global p_f m_gam_f m_f lc_f h_f cov_f f_alpha I_f mu_f f_i_alpha v_f %#ok
global p_k m_gam_k m_k lc_k h_k cov_k k_alpha I_k mu_k k_i_alpha v_k %#ok
global p_u m_gam_u I_u %#ok

% loads everything into the global variables
model();


% show the sparsity structure of the deterministic, stochastic-only,
% complete stochastic system matrix
global K_ab K_mu_delta K_mu_iota %#ok
operators();


K_ab_mat=cell2mat(K_ab);
show_sparsity_pattern( K_ab_mat, n );
userwait;

f_beta=stochastic_pce_rhs( f_alpha, I_f, I_u );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% solve
fprintf('\n\n==================================================================================================\n');
%solve_method=6;
solve_method=7;
solve_method=1;
tol=1e-4; maxit=50;

m=size(f_beta,2);
[P_B,P_I]=boundary_projectors( [1,n], n );
g_beta=0*f_beta;
[K_ab_mat_x,f_beta_vec]=...
    apply_essential_boundary_conditions( K_ab_mat, f_beta(:), g_beta(:), P_B, P_I, m, .7 );
K_ab_mat=K_ab_mat_x;
f_beta=reshape( f_beta_vec, size(f_beta));

u_alpha0=K_ab_mat\f_beta(:);
u_alpha0=u_alpha0+K_ab_mat\(f_beta(:)-K_ab_mat*u_alpha0);
u_alpha0=reshape( u_alpha0, size(f_beta) );
switch solve_method
    case 1 % use direct solver 
        u_alpha=K_ab_mat\f_beta(:);
        itermethod='direct solver'; iter=1; relres=0; flag=0;
    case 2 % pcg with matrices
        M=kron( spdiags(multiindex_factorial(I_u),0,size(I_u,1),size(I_u,1)), K_ab_mat(1:n,1:n) );
        [u_alpha,flag,relres,iter]=pcg( K_ab_mat, f_beta(:), tol, maxit, M );
        itermethod='pcg(mat)';
    case 3 % use pcg on flat system
        Minv=kron( spdiags(1./multiindex_factorial(I_u),0,size(I_u,1),size(I_u,1)), inv(K_ab{1,1}) );
        A_func=@(x)(K_ab_mat*x);
        Minv_func=@(x)(Minv*x);
        [u_alpha,flag,relres,iter]=pcg( A_func, f_beta(:), tol, maxit, Minv_func );
        itermethod='pcg(funcs,flat)';
    case 4 % 
        %Minv=kron( inv(sparse(K_mu_delta{2})), inv(K_mu_delta{1}) );
        Minv_op={ inv(K_mu_delta{1}); inv(sparse(K_mu_delta{2})); {}; {} };
        shape=size(f_beta);
        %Minv_func=@(x)(apply_flat(Minv,x,shape));
        Minv_func=@(x)(apply_flat(Minv_op,x,shape));
        %A_func=@(x)(apply_flat(K_mu_delta,x,shape));
        A_func={@apply_flat,{K_mu_delta,shape},{1,3}};
        [u_alpha,flag,relres,iter]=pcg( A_func, f_beta(:), tol, maxit, Minv_func );
        itermethod='pcg(funcs,mu_delta)';
    case 5
        options.method='gs';
        options.omega=1;
        options.abstol=tol;
        options.reltol=tol;
        options.maxiter=maxit;
        [u_alpha,flag,relres,iter]=solve_linear_stat( K_ab_mat, f_beta(:), options );
        itermethod='mat_decomp(mat)';
    case 6
        options.method='gs';
        options.omega=1;
        options.abstol=tol;
        options.reltol=tol;
        options.maxiter=maxit;
        options.maxiter=10; % check for divergence(!!)
        
        [u_alpha,flag,relres,iter]=solve_mat_decomp_block( K_ab, f_beta, options );
        itermethod='mat_decomp(block,flat)';
    case 7
        options.method='jac';
        options.omega=1;
        options.abstol=tol;
        options.reltol=tol;
        options.trunc_eps=0.0001;

        maxit=100;
        options.abstol=0.0001;
        options.reltol=0.0001;
        options.trunc_eps=0.000001;
        options.trunc_k=20;
        options.maxiter=maxit;
        options.relax=1;
        options.algorithm=2;
        
        [U,S,V]=svd(f_beta);
        n=rank(S);
        f1=U(:,1:n)*S(1:n,1:n);
        f2=V(:,1:n);
        F_tp={f1,f2};
        
        %K_mu_delta{1}=1*K_mu_delta{1};
        for i=1:size(K_mu_delta{3},1); K_mu_delta{3}{i}=1.0*K_mu_delta{3}{i}; end
        
        K_mu_delta{2}=sparse(K_mu_delta{2});
        for i=1:size(K_mu_delta{4},1); K_mu_delta{4}{i}=sparse(K_mu_delta{4}{i}); end
        
        [u_alpha,flag,relres,iter]=solve_linear_stat_tensor( K_mu_delta, F_tp, options );
        itermethod='mat_decomp(tensor)';
        u_alpha=u_alpha{1}*u_alpha{2}';
    case 99 % statements saved for later use
end

solver_message(itermethod,tol,maxit,flag,iter,relres);

if isvector(u_alpha)
    u_alpha=reshape( u_alpha, size(f_beta) );   
end

fprintf( 'method:   %d\n', solve_method );
fprintf( 'residual: %g\n', normest(apply_stochastic_operator( K_ab, u_alpha)-f_beta)/normest(f_beta))
fprintf( 'error:    %g\n', normest(u_alpha-u_alpha0)/normest(u_alpha0))
%return

% Show sample realizations and 
show_in_out_samples( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, 30 );
userwait;
%return

% Show covariances
show_covariances2( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k, cov_f );
userwait;

