return 

clear

addpath ../
addpath ../munit/
addpath ../util/
addpath ../simplefem/

%% Introductory images

clf; clear
rf_filename='ranfield_smd.mat';
if exist( rf_filename, 'file' ) 
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
    lc_f=0.3;
    h_f={@beta_stdnor,{4,2}};
    cov_f={@gaussian_covariance,{lc_f,1}};
    options_expand_f.transform.correct_var=1;
    [f_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, [], x, M, p_f, m_gam_f, options_expand_f );
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



K_mu=stiffness_matrix( els, x, mu_k' );
for i=1:m_k
    K{i}=stiffness_matrix( els, x, v_k(i,:)' );
    tic
    Delta{i}=stochastic_pce_matrix( k_alpha(:,i), I_k, I_u );
    toc
    iii=1;
end
K_mu
K
Delta

return

%%
n=21;
p=5;
m=5;
lc=0.3;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';
M=mass_matrix( els, x );

h={@beta_stdnor,{4,2}};
[mu,sig2]=beta_moments( 4, 2 );

cov_f={@gaussian_covariance,lc,sqrt(sig2)};
cov_gam=[];

[f_alpha, I_f]=expand_field_pce_sg( h, cov_f, cov_gam, x, M, p, m );


%TODO: test more cases
%TODO: make correct test routine out of this script
%%
fprintf('\n----\n');
fprintf( '    |u-ut|   |Tu-ut|  |Mut-f|  |MTu-f|  |Mut-Tf|  |MTu-Tf| \n' );
% MTu-f=MTu-Mu=M(Tu-u)
% Mut-f=M(ut-u)=M(Tut-u)

numterms=10;
f_alpha_ex=f_alpha;
for numterms=3:12
    f_alpha_tr=truncated_svd( f_alpha_ex, numterms );
    %f_alpha=f_alpha_tr;
    
    [u_alpha_ex,it_ex]=solve_mat_decomp( M, f_alpha, 'transpose', true, 'algorithm', 'std' );
    u_alpha_ex_tr=truncated_svd( u_alpha_ex, numterms );
    
    [u_alpha_tr1,it_tr]=solve_mat_decomp( M, f_alpha, 'transpose', true, 'algorithm', 'tensor', 'numterms', numterms, 'tensor_alg', 1 );
    [u_alpha_tr2,it_tr]=solve_mat_decomp( M, f_alpha, 'transpose', true, 'algorithm', 'tensor', 'numterms', numterms, 'tensor_alg', 2, 'abstol', 0.3 );

    [U,S,V]=svd( f_alpha' );
    S(:,numterms+1:end)=0;
    u_alpha_tr3=((M\U)*S*V')';
    
    u_alpha_tr = u_alpha_tr1;
    fprintf( '%2d %8.5f %8.5f %8.5f %8.5f %8.5f %8.5f\n', numterms, norm(u_alpha_ex-u_alpha_tr), ...
    norm(u_alpha_ex_tr-u_alpha_tr), ...
    norm(M*u_alpha_tr'-f_alpha'), ...
    norm(M*u_alpha_ex_tr'-f_alpha'), ...
    norm(M*u_alpha_tr'-f_alpha_tr'), ...
    norm(M*u_alpha_ex_tr'-f_alpha_tr') );
%     u_alpha_tr = u_alpha_tr2;
%     fprintf( '%2d %8.5f %8.5f %8.5f %8.5f\n', numterms, norm(u_alpha_ex-u_alpha_tr), ...
%     norm(u_alpha_ex_tr-u_alpha_tr), ...
%     norm(M*u_alpha_tr'-f_alpha'), ...
%     norm(M*u_alpha_ex_tr'-f_alpha') );
    u_alpha_tr = u_alpha_tr3;
    fprintf( '%2d %8.5f %8.5f %8.5f %8.5f %8.5f %8.5f\n', numterms, norm(u_alpha_ex-u_alpha_tr), ...
    norm(u_alpha_ex_tr-u_alpha_tr), ...
    norm(M*u_alpha_tr'-f_alpha'), ...
    norm(M*u_alpha_ex_tr'-f_alpha'), ...
    norm(M*u_alpha_tr'-f_alpha_tr'), ...
    norm(M*u_alpha_ex_tr'-f_alpha_tr') );
end

