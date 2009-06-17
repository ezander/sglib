function demo_tensor_methods

init_demos

clf; clear

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
%show_sparsity_pattern( K_ab_mat, n );
%waitforbuttonpress;

f_beta=stochastic_pce_rhs( f_alpha, I_f, I_u );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% solve
fprintf('\n\n==================================================================================================\n');
solve_method=7;
tol=1e-4; maxit=50;
u_alpha0=K_ab_mat\f_beta(:);
u_alpha0=u_alpha0+K_ab_mat\(f_beta(:)-K_ab_mat*u_alpha0);
u_alpha0=reshape( u_alpha0, size(f_beta) );
switch solve_method
    case 1 % use direct solver 
        u_alpha=K_ab_mat\f_beta(:);
        itermethod='direct solver'; iter=1; relres=0; flag=0;
    case 2 % pcg with matrices
        M=revkron( K_ab_mat(1:n,1:n), spdiags(multiindex_factorial(I_u),0,size(I_u,1),size(I_u,1)) );
        [u_alpha,flag,relres,iter]=pcg( K_ab_mat, f_beta(:), tol, maxit, M );
        itermethod='pcg(mat)';
    case 3 % use pcg on flat system
        Minv=revkron( inv(K_ab{1,1}), spdiags(1./multiindex_factorial(I_u),0,size(I_u,1),size(I_u,1)) );
        A_func=@(x)(K_ab_mat*x);
        Minv_func=@(x)(Minv*x);
        [u_alpha,flag,relres,iter]=pcg( A_func, f_beta(:), tol, maxit, Minv_func );
        itermethod='pcg(funcs,flat)';
    case 4 % 
        %Minv=revkron( inv(K_mu_delta{1}), inv(sparse(K_mu_delta{2})) );
        Minv_op={ inv(K_mu_delta{1}); inv(sparse(K_mu_delta{2})); {}; {} };
        shape=size(f_beta);
        %Minv_func=@(x)(apply_flat(Minv,x,shape));
        Minv_func=@(x)(apply_flat(Minv_op,x,shape));
        A_func=@(x)(apply_flat(K_mu_delta,x,shape));
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

solver_message( itermethod, tol, maxit, flag, iter, relres );

if isvector(u_alpha)
    u_alpha=reshape( u_alpha, size(f_beta) );   
end

fprintf( 'method:   %d\n', solve_method );
fprintf( 'residual: %g\n', normest(apply_stochastic_operator( K_ab, u_alpha)-f_beta)/normest(f_beta))
fprintf( 'error:    %g\n', normest(u_alpha-u_alpha0)/normest(u_alpha0))
%return

% Show sample realizations and 
show_in_out_samples( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, n );
%waitforbuttonpress;
%return

% Show covariances
show_covariances( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k, cov_f );
show_corr_coeffs( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k, cov_f );
show_covariances2( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u );
%waitforbuttonpress;

%%
function show_goodness_of_approximations( K_ab, u_alpha0, f_beta, tsvd_options )
% How does the residual decrease with better approximation to the
% solution
m=min(size(u_alpha0))-1;
dk=m-1;
s=svd(u_alpha0);

fprintf('2-norm\n'); n=2;
norm_f_beta=norm(f_beta, n);
norm_u_alpha0=norm(u_alpha0, n);
for i=m:-1:m-dk
    u_alpha=truncated_svd( u_alpha0, i, tsvd_options );

    a(i,1)=norm(apply_stochastic_operator( K_ab, u_alpha)-f_beta, n)/norm_f_beta;
    a(i,2)=norm(u_alpha-u_alpha0, n)/norm_u_alpha0;
    a(i,3)=s(i+1)/max(s);

    fprintf( 'residual: %2d %10.7e   %10.7e  %10.7e\n', i, a(i,1), a(i,2), a(i,3) );
end
a(a(:,3)==0,3)=min(a(a(:,3)>0,3));
clf;
semilogy(1./a); legend('res','err','err-sing',   'Location','NorthWest' );
fprintf('frobenius\n'); n='fro';


%%
function y=apply_flat_truncate(A,x,shape,m)
xs=reshape(x,shape);
ys=apply_stochastic_operator(A,xs);
ys=truncated_svd(x,m);
y=reshape(ys,size(x));

%%
function y=apply_flat(A,x,shape)
xs=reshape(x,shape);
ys=apply_stochastic_operator(A,xs);
y=reshape(ys,size(x));

%%
function show_sparsity_pattern( K_ab, n )
clf;
subplot( 1,3,1);
spy( K_ab(1:n,1:n) );
subplot( 1,3,2);
spy( K_ab(1:n:end,1:n:end) );
subplot( 1,3,3);
spy( K_ab );

%%
function show_in_out_samples( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, n )
clf;
subplot(1,3,1); stoch_plot_1d( x, k_alpha, I_k, n )
subplot(1,3,2); stoch_plot_1d( x, f_alpha, I_f, n )
subplot(1,3,3); stoch_plot_1d( x, u_alpha, I_u, n )

%%
function show_covariances( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k, cov_f )
[X,Y]=meshgrid(x,x);
C_k=pce_covariance( k_alpha, I_k );
C_f=pce_covariance( f_alpha, I_f );
C_u=pce_covariance( u_alpha, I_u );
clf;
[mu_k,var_k]=pce_moments(k_alpha(2,:),I_k); %#ok
[mu_f,var_f]=pce_moments(f_alpha(2,:),I_f); %#ok
subplot(3,3,1); surf( X, Y, normalize_cov(C_k) )
subplot(3,3,4); surf( X, Y, var_k*covariance_matrix( x, cov_k ) )
subplot(3,3,7); surf( X, Y, C_k-var_k*covariance_matrix( x, cov_k ) )
subplot(3,3,2); surf( X, Y, normalize_cov(C_f) )
subplot(3,3,5); surf( X, Y, var_f*covariance_matrix( x, cov_f ) )
subplot(3,3,8); surf( X, Y, C_f-var_f*covariance_matrix( x, cov_f ) )
subplot(3,3,3); surf( X, Y, normalize_cov(C_u) )

%%
function Cn=normalize_cov( C )
Cn=C-min(C(:));
Cn=Cn/max(Cn(:));

function show_corr_coeffs( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k, cov_f )
[X,Y]=meshgrid(x,x);
C_k=pce_covariance( k_alpha, I_k );
C_f=pce_covariance( f_alpha, I_f );
C_u=pce_covariance( u_alpha, I_u );
clf;
subplot(2,2,1); surf( X, Y, to_corr_coeff(C_k) )
subplot(2,2,2); surf( X, Y, to_corr_coeff(C_f) )
subplot(2,2,3); surf( X, Y, to_corr_coeff(C_u) )

%%
function Cn=to_corr_coeff( C )
s=sqrt(diag(C));
V=s*(s');
Cn=C;
Cn(V~=0)=C(V~=0)./V(V~=0);
Cn(V==0)=1;


%%
function show_covariances2( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u )
[X,Y]=meshgrid(x,x);
C_k=pce_covariance( k_alpha, I_k );
C_f=pce_covariance( f_alpha, I_f );
C_u=pce_covariance( u_alpha, I_u );
clf;
[mu_k,var_k]=pce_moments(k_alpha(2,:),I_k); %#ok
[mu_f,var_f]=pce_moments(f_alpha(2,:),I_f); %#ok
subplot(3,3,1); surf( X, Y, C_k )
[V,D]=eig(C_k);m=6;
l=tolog10(diag(D)); 
subplot(3,3,4); plot(l,'x'); xlim([1,length(l)]);
subplot(3,3,7); plot(x,V(:,1:m)*sqrt(D(1:m,1:m))); xlim([min(x),max(x)]);

subplot(3,3,2); surf( X, Y, C_f )
[V,D]=eig(C_f);m=6;
l=tolog10(diag(D)); 
subplot(3,3,5); plot(l,'x'); xlim([1,length(l)]);
subplot(3,3,8); plot(x,V(:,1:m)*sqrt(D(1:m,1:m))); xlim([min(x),max(x)]);

subplot(3,3,3); surf( X, Y, C_u )
[V,D]=eig(C_u);m=6;
l=tolog10(diag(D)); 
subplot(3,3,6); plot(l,'x'); xlim([1,length(l)]);
subplot(3,3,9); plot(x,V(:,1:m)*sqrt(D(1:m,1:m))); xlim([min(x),max(x)]);

%%
function l=tolog10( d )
l=abs(d/d(1));
l(l<1e-18)=1e-18;
l=log10(l); 
%l=log(l); 
%l(l<-20)=-20;


%%
function stoch_plot_1d( x, u_alpha, I_u, n )
[mu_u, var_u]=pce_moments( u_alpha, I_u);
std_u=sqrt(var_u);
plot(x,mu_u, 'b', ...
    x, mu_u*[1,1]+std_u*[-1,1], 'g', ...
    x, mu_u*[1,1]+2*std_u*[-1,1], 'y', ...
    x, mu_u*[1,1]+3*std_u*[-1,1], 'r' );
hold all;
for i=1:n
    plot(x,pce_field_realization(x,u_alpha,I_u),'-k');
end
hold off

%%
function f_beta=stochastic_pce_rhs( f_alpha, I_f, I_u )
m_alpha_f=size(I_f,1);
m_beta_u=size(I_u,1);
n=size(f_alpha,1);
f_beta=zeros( n, m_beta_u );
for i=1:m_alpha_f
    ind=sum(abs(I_u-repmat(I_f(i,:),m_beta_u,1)),2)==0;
    f_beta(:,ind)=multiindex_factorial(I_f(i,:))*f_alpha(:,i);
end
% NOTE: This is really ugly imposition of Dirichlet BCs
f_beta(1,:)=0;
f_beta(end,:)=0;
f_beta(1,1)=0.0;
f_beta(end,1)=0;

