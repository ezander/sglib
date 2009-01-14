

% Here we will look at a simple stochastic boundary value problem described
% by a simple PDE (vibrating string) 
% First we will consider a stochastic right hand side (i.e. stochastic
% loading on the string)
% Then we will make the stiffness of the string stochastic too.

% general system parameters
clear;
N=11;
x=linspace(0,1,N)';
els=[1:N-1; 2:N]';
M=mass_matrix( els, x );

% parameters of the random field
dist=distribution_object( 'beta', 2, 4 );
l=0.3;
cov_f=@(x1,x2)(gaussian_covariance(x1,x2,l));

% random field expansion parameters
m_gam=4;
p=3;
m_f=5;
options.transform.correct_var=true;

% perform random field expansion
[f_alpha, I_f]=expand_field_pce_sg( dist.stdnor, cov_f, [], x, M, p, m_gam, options );
[mu_f,f_i_alpha,v_f]=pce_to_kl( f_alpha, I_f, M, m_f );

% Now setup everything for K*u(x,om)=f(x,om)
% the question we want to answer is: project(u_alpha)==u_i_alpha

% some testing first
%f=rand(N,1);
%[u,it]=solve_jacobi( M, f );

%K=stiffness_matrix( );
[u_alpha,it]=solve_jacobi( M, f_alpha, 'transpose', true );


