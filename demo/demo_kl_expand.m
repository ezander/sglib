%% DEMO_KL_EXPAND Demonstrate usage of the Karhunen-Loeve expansion functions

init_demos

%% Setup grid
clear; subplot(1,1,1); clf; hold off
n=10;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';

%% Create covariance matrix 
cov_u={@gaussian_covariance, {0.3,2}};
C_u=covariance_matrix( x, cov_u );

%% Plot the covariance function
x1=linspace(-1,1,100)'; x2=zeros(size(x1));
plot( x1, funcall( cov_u, x1, x2 ) );
userwait

%% Create KL with variance correction on and M=I
v_u=kl_expand( C_u, [], 3, 'correct_var', true );
plot( x, v_u );
%legend( 'v_1', 'v_2', 'v_3' );
userwait

%% Compute the mean and variance of the KL 
% Mean should be zero in this case and variance 4
[mu,sig2]=pce_moments( [zeros(size(v_u,1),1), v_u], multiindex(3,1)); %#ok can't get only sig2
fprintf( 'sigma^2=%f\n', sig2 );

%% Now compute KL with a true mass matrix

M=mass_matrix( els, x );
v_u=kl_expand( C_u, M, 3, 'correct_var', true );
[mu,sig2]=pce_moments( [zeros(size(v_u,1),1), v_u], multiindex(3,1)); %#ok can't get only sig2
fprintf( 'sigma^2=%f\n', sig2 );


%% Set parameters for complete field expansion
% We need marginal densities, covariance function and parameters for the
% expansions...
p=5; %order of pce
m_gam=4; % number of kl terms for underlying field
m_u=4; % number of kl terms for random field 

h_u=@(gamma)(beta_stdnor(gamma,4,2)); 
u_i=pce_expand_1d(h_u,p);
[mu,sig2]=pce_moments( u_i );
%cov_u=@(x1,x2)(gaussian_covariance( x1, x2, 0.3, sqrt(sig2) ) );
cov_u={@gaussian_covariance, {0.3, sqrt(sig2)}, {3,4} };
M=mass_matrix( els, x );
%M=[];

%% Make PC expansion of the random field 
% Using basic ghanem&sakamoto algorithm
% KL is used here only for the underlying Gaussian field
C_u=covariance_matrix( x, cov_u );
C_gam=transform_covariance_pce( C_u, u_i, 'comp_ii_reltol', 1e-4 );
v_gam=kl_expand( C_gam, M, m_gam, 'correct_var', true );
[u_alpha,I_u]=pce_transform_multi( v_gam, u_i );

xi=randn(50,m_gam);
u_real1=pce_field_realization( x, u_alpha, I_u, xi );
plot( x, u_real1 ); 

%% Make KL on RF and project on it
[v,s]=kl_expand( C_u, M, m_u );
v_u=kl_expand( C_u, M, m_u );
[mu_u,u_i_alpha]=project_pce_on_kl( u_alpha, I_u, v_u );

%% Get KL of PCE expansion directly by SVD
[mu_u2,u_i_alpha2,v_u2]=pce_to_kl( u_alpha, I_u, M, m_u ); %#ok

%% Show that both are results are basically the same
% The correlation coefficient between each two functions should be one or
% minus one.
ccorr=abs(v_u*v_u2' ./ sqrt( sum(v_u.^2,2)*sum(v_u2.^2,2)' ));
format short
disp( diag(ccorr)' )

%% Now get a realization for the KL-PCE expanded field
u_real2=kl_pce_field_realization( x, mu_u, v_u, u_i_alpha, I_u, xi );
plot( x, u_real2 ); 
userwait

%% Show small difference between realizations
hold off
plot( x, u_real1(:,1:3) );
hold on
plot( x, u_real2(:,1:3) ); 
hold off
userwait

%%%%%%%%%%
C_u_pce=pce_covariance( u_alpha, I_u );
A=normalize_pce( u_alpha, I_u );
A(:,1)=0;
C_u_pce2=A*A';

norm(C_u_pce-C_u)
norm(C_u_pce2-C_u)

%%
v_u=kl_expand( C_u_pce, M, m_u );
[mu_u,u_i_alpha]=project_pce_on_kl( u_alpha, I_u, v_u );
[mu_u2,u_i_alpha2,v_u2]=pce_to_kl( u_alpha, I_u, M, m_u );
cc=cross_correlation( v_u, v_u2, M );
fprintf( 'cross correlation=%f\n', cc );


disp(mu_u-mu_u2);
disp(u_i_alpha-row_col_mult(u_i_alpha2,diag(cc)));

u_1=pce_field_realization( 0, u_alpha(5,:), I_u, randn(10000,m_gam) );
subplot(1,1,1); clf;
hold on;
kernel_density( u_1, 100, 0.05, 'g' );
xb=linspace(-.2,1.2); plot( xb, beta_pdf( xb, 4, 2 ), 'r' );
hold off;
userwait

%% PDF of KL random vars for the two different KL generation methods
clf; hold off;
N=10000;
xi=randn(N,m_gam);
u_1=pce_field_realization( 0, u_i_alpha, I_u, xi );
u_2=pce_field_realization( 0, u_i_alpha2, I_u, xi );
subplot(2,2,1);
kernel_density( [u_1(1,:); u_2(1,:)], 100, 0.3 );
subplot(2,2,2);
kernel_density( [u_1(2,:); u_2(2,:)], 100, 0.3 );
subplot(2,2,3);
kernel_density( [u_1(3,:); u_2(3,:)], 100, 0.3 );
subplot(2,2,4);
kernel_density( [u_1(4,:); u_2(4,:)], 100, 0.3 );
userwait

%% PDFs at different values of x for the two different KL generation methods
% result: the kl on the pce is much better in terms of marginal densities
% then the projection of the pce on the kl eigenfunctions
subplot(1,1,1); clf;
N=10000;
xi=randn(N,m_gam);
u_1=kl_pce_field_realization( x, mu_u,  v_u,  u_i_alpha,  I_u, xi );
u_2=kl_pce_field_realization( x, mu_u2, v_u2, u_i_alpha2, I_u, xi );
subplot(2,2,1);
xb=linspace(-.2,1.2); plot( xb, beta_pdf( xb, 4, 2 ), 'r' );
hold on; 
kernel_density( [u_1(1,:); u_2(1,:)], 100, 0.05 );
drawnow;
hold off;
subplot(2,2,2);
xb=linspace(-.2,1.2); plot( xb, beta_pdf( xb, 4, 2 ), 'r' );
hold on; 
kernel_density( [u_1(2,:); u_2(2,:)], 100, 0.05 );
drawnow;
hold off;
subplot(2,2,3);
xb=linspace(-.2,1.2); plot( xb, beta_pdf( xb, 4, 2 ), 'r' );
hold on;
kernel_density( [u_1(3,:); u_2(3,:)], 100, 0.05 );
drawnow;
hold off;
subplot(2,2,4);
xb=linspace(-.2,1.2); plot( xb, beta_pdf( xb, 4, 2 ), 'r' );
hold on;
kernel_density( [u_1(4,:); u_2(4,:)], 100, 0.05 );
drawnow;
hold off;
userwait
