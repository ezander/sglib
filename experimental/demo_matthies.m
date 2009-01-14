function demo_matthies

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
show_sparsity_pattern( K_ab_mat, n );
%waitforbuttonpress;

f_beta=stochastic_pce_rhs( f_alpha, I_f, I_u );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    %show goodness of approximation for different svd methods
    tsvd_options.sparse_svd=false;
    show_goodness_of_approximations( K_ab, u_alpha0, f_beta, tsvd_options );

    tsvd_options.sparse_svd=true;
    tsvd_options.tol=1e-8;
    show_goodness_of_approximations( K_ab, u_alpha0, f_beta, tsvd_options );

    tsvd_options.sparse_svd=true;
    tsvd_options.tol=1e-10;
    show_goodness_of_approximations( K_ab, u_alpha0, f_beta, tsvd_options );

    tsvd_options.sparse_svd=true;
    tsvd_options.tol=1e-12;
    show_goodness_of_approximations( K_ab, u_alpha0, f_beta, tsvd_options );

    tsvd_options.sparse_svd=true;
    tsvd_options.tol=1e-8;
    tsvd_options.maxit=1000;
    show_goodness_of_approximations( K_ab, u_alpha0, f_beta, tsvd_options );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% solve
fprintf('\n\n==================================================================================================\n');
solve_method=6;
tol=1e-4; maxit=50;
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
        A_func=@(x)(apply_flat(K_mu_delta,x,shape));
        [u_alpha,flag,relres,iter]=pcg( A_func, f_beta(:), tol, maxit, Minv_func );
        itermethod='pcg(funcs,mu_delta)';
    case 5
        options.method='gs';
        options.omega=1;
        options.abstol=tol;
        options.reltol=tol;
        options.maxiter=maxit;
        [u_alpha,flag,relres,iter]=solve_mat_decomp( K_ab_mat, f_beta(:), options );
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
    case 99 % statements saved for later use
end

itermsg(itermethod,tol,maxit,flag,iter,relres);

if isvector(u_alpha)
    u_alpha=reshape( u_alpha, size(f_beta) );   
end

fprintf( 'method:   %d\n', solve_method );
fprintf( 'residual: %g\n', norm(apply_stochastic_operator( K_ab, u_alpha)-f_beta, inf)/norm(f_beta, inf))
fprintf( 'error:    %g\n', norm(u_alpha-u_alpha0, inf)/norm(u_alpha0, inf))

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
function y=apply_flat_reduce(A,x,shape,m)
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
    plot(x,pce_field_realization(x,u_alpha,I_u),':k');
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

%%
function operators
global n x els M %#ok
global p_f m_gam_f m_f lc_f h_f cov_f f_alpha I_f mu_f f_i_alpha v_f %#ok
global p_k m_gam_k m_k lc_k h_k cov_k k_alpha I_k mu_k k_i_alpha v_k %#ok
global p_u m_gam_u I_u %#ok

global K_ab K_mu_delta K_mu_iota %#ok
stiffness_func={@stiffness_matrix, {els, x}, {1,2}};

rf_filename='operator_kl_smd.mat';
reinit=false;
if ~reinit && exist( rf_filename, 'file' ) 
    load( rf_filename )
else
    tic
    K_ab=stochastic_operator_kl_pce( mu_k, v_k, k_i_alpha, I_k, I_u, stiffness_func, 'alpha_beta' );
    toc
    tic
    K_mu_delta=stochastic_operator_kl_pce( mu_k, v_k, k_i_alpha, I_k, I_u, stiffness_func, 'mu_delta' );
    toc
    tic
    K_mu_iota=stochastic_operator_kl_pce( mu_k, v_k, k_i_alpha, I_k, I_u, stiffness_func, 'mu_iota' );
    toc
    save( rf_filename, 'K_*', '-V6' );
end

%%
function model()

global n x els M
global p_f m_gam_f m_f lc_f h_f cov_f f_alpha I_f mu_f f_i_alpha v_f
global p_k m_gam_k m_k lc_k h_k cov_k k_alpha I_k mu_k k_i_alpha v_k
global p_u m_gam_u I_u


rf_filename='ranfield_smd.mat';
reinit=true;
if ~reinit && exist( rf_filename, 'file' ) 
    load( rf_filename )
else
    % definition of the grid
    n=21;
    x=linspace(0,1,n)';
    els=[1:n-1; 2:n]';
    M=mass_matrix( els, x );

    % expansion of the right hand side field (f)
    p_f=3;
    m_gam_f=2;
    m_f=4;
    lc_f=2*0.3;
    h_f={@beta_stdnor,{4,2}};
    cov_f={@gaussian_covariance,{lc_f,1}};
    options_expand_f.transform.correct_var=1;
    [f_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, [], x, M, p_f, m_gam_f, options_expand_f );
    f_alpha(:,1)=0.3*f_alpha(:,1); % set mean to zero
    
    [mu_f,f_i_alpha,v_f]=pce_to_kl( f_alpha, I_f, M, m_f );

    % expansion of the right hand side field (f)
    p_k=4;
    m_gam_k=4;
    m_k=4;
    lc_k=0.3;
    h_k={@beta_stdnor,{4,2}};
    cov_k={@gaussian_covariance,{lc_f,1}};
    options_expand_k.transform.correct_var=1;
    [k_alpha, I_k]=expand_field_pce_sg( h_k, cov_k, [], x, M, p_k, m_gam_k, options_expand_k );
    [mu_k,k_i_alpha,v_k]=pce_to_kl( k_alpha, I_k, M, m_k );


    % In the expansion of the random fields f and k we have assumed that the
    % fields are independent. Now if we use both in the same application we
    % have to make sure that gamma_1 in the expansion of f has nothing to do
    % with gamma_1 in the expansion of k. We do this by combining multiindices
    % by pre- and postfixing them with the appropriate amount of zeros such
    % that those in the expansion of f are disjoint to those of k (with the
    % exception of the all-zero multiindex)
    [I_k,I_f,I_u]=multiindex_combine( {I_k, I_f}, -1 );
    %p_u=max(p_f,p_k);
    %m_gam_u=m_gam_f+m_gam_k;
    %I_u=multiindex(m_gam_u,p_u);


    save( rf_filename, '-V6' );
end



%%
function os = itermsg(itermeth,tol,maxit,flag,iter,relres)
if (flag ~= 0)
    os = sprintf([itermeth ' stopped at iteration %d without converging' ...
        ' to the desired tolerance %0.2g'],i,tol);
end

switch(flag)

    case 0
        if (iter == 0)
            if isnan(relres)
                os = sprintf(['The right hand side vector is all zero ' ...
                    'so ' itermeth '\nreturned an all zero solution ' ...
                    'without iterating.']);
            else
                os = sprintf(['The initial guess has relative residual %0.2g' ...
                    ' which is within\nthe desired tolerance %0.2g' ...
                    ' so ' itermeth ' returned it without iterating.'], ...
                    relres,tol);
            end
        else
            os = sprintf([itermeth ' converged at iteration %d to a solution' ...
                ' with relative residual %0.2g'],iter,relres);
        end
    case 1
        os = [os sprintf('\nbecause the maximum number of iterations was reached.')];
    case 2
        os = [os sprintf(['\nbecause the system involving the' ...
            ' preconditioner was ill conditioned.'])];
    case 3
        os = [os sprintf('\nbecause the method stagnated.')];
    case 4
        os = [os sprintf(['\nbecause a scalar quantity became too' ...
            ' small or too large to continue computing.'])];
    case 5
        os = [os sprintf(['\nbecause the preconditioner' ...
            ' is not symmetric positive definite.'])];
end

if (flag ~= 0)
    os = [os sprintf(['\nThe iterate returned (number %d)' ...
        ' has relative residual %0.2g'],iter,relres)];
    disp(os);
else
    disp(os);
end

