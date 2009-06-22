%function demo_tensor_methods

clf; dock; clear; 
props={'Interpreter', 'latex', 'FontSize', 16, };


%% load the geomatry
% 1D currently, so nothing to plot here
geometries={ 'lshape', 'cardioid', 'circle', 'scatter', 'circle_segment', 'crack', 'square' };
geom_num=2;

clf;
set( gcf, 'Renderer', 'painters' );
[pos,els,G_N]=load_pdetool_geom( geometries{geom_num}, 0, true );
userwait;
N=size(pos,1);
bnd=find_boundary( els, true );



%% load the kl variables of the conductivity k
% define stochastic parameters
p_k=4;
m_k=4;
l_k=4;
lc_k=0.3;
stdnor_k={@beta_stdnor,{4,2}};
cov_k={@gaussian_covariance,{lc_k,1}};
% create field
[k_j_alpha, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
[mu_k_j,kappa_i_alpha,k_j_i]=pce_to_kl( k_j_alpha, I_k, l_k, G_N );
% plot field
plot_kl(els,pos,mu_k_j,kappa_i_alpha,k_j_i);
set( gcf, 'Renderer', 'painters' );
print( sprintf( 'k_%s_%d_kl.eps', geometries{geom_num}, N ),'-depsc2' );
userwait;

%% load the kl variables of the right hand side f 
% define stochastic parameters
p_f=3;
m_f=2;
l_f=4;
lc_f=2*0.3;
stdnor_f={@beta_stdnor,{4,2}};
cov_f={@gaussian_covariance,{lc_f,1}};
% create field
[f_j_alpha, I_f]=expand_field_pce_sg( stdnor_f, cov_f, [], pos, G_N, p_f, m_f );
[mu_f_j,phi_i_alpha,f_j_i]=pce_to_kl( f_j_alpha, I_f, l_f, G_N );
% plot field
plot_kl(els,pos,mu_f_j,phi_i_alpha,f_j_i);
set( gcf, 'Renderer', 'painters' );
print( sprintf( 'f_%s_%d_kl.eps', geometries{geom_num}, N ),'-depsc2' );
userwait;

%% define (deterministic) boundary conditions g
% this defines the function g(x)=x_1
select=@(x,n)(x(:,n));
g_func={ select, {1}, {2} };
mu_g_j=funcall( g_func, pos);
% "null" kl expansion of g
I_g=multiindex(0,0);
g_j_i=zeros(N,0);
gamma_i_alpha=zeros(0,size(I_g,1));


%% combine the multiindices
% (i.e. build the product sample space $Omega_u=Omega_k \times Omega_f \times
% Omega_g$ in which the solution lives)
[I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, -1 );
M=size(I_u,1); %#ok, full stochastic dimension


%% create the right hand side
% i.e. scale the pce coefficients with the norm of the stochastic ansatz
% functions and create tensor, matrix and vector versions out of it
phi_i_beta=stochastic_pce_rhs( phi_i_alpha, I_f, I_u );
F=kl_to_tensor( mu_f_j, f_j_i, phi_i_beta );
f_mat=F{1}*F{2}';
f_vec=f_mat(:);

gamma_i_beta=stochastic_pce_rhs( gamma_i_alpha, I_g, I_u );
G=kl_to_tensor( mu_g_j, g_j_i, gamma_i_beta );
g_mat=G{1}*G{2}';
g_vec=g_mat(:);


%% load and create the operators 
% since this takes a while we cache the function call
kl_operator_version=1;
stiffness_func={@stiffness_matrix, {els, pos}, {1,2}};
opt.silent=false;
opt.show_timings=true;
op_filename=sprintf('kl_operator_2d_%d_%d.mat', N, M );

% create tensor operators
K=cached_funcall(...
    @stochastic_operator_kl_pce,...
    { mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'mu_delta' }, ...
    1,... % just one output argument
    op_filename, ...
    kl_operator_version, ...
    {'message', 'recomputing kl-operator', ...
     'show_timings', opt.show_timings, 'silent', opt.silent, ...
     'extra_params', {'show_timings', opt.show_timings, 'silent', opt.silent}...
    } ...
);

% create matrix and tensor operators
K_mat=revkron(K);


%% apply boundary conditions
[P_I,P_B]=boundary_projectors( bnd, N );

Ki=apply_boundary_conditions_operator( K, P_I );
Ki_mat=apply_boundary_conditions_operator( K_mat, P_I );

Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );
fi_vec=apply_boundary_conditions_rhs( K_mat, f_vec, g_vec, P_I, P_B );
fi_vec2=apply_boundary_conditions_rhs( K, f_vec, g_vec, P_I, P_B );
fi_mat=apply_boundary_conditions_rhs( K, f_mat, g_mat, P_I, P_B );
% 
all_same=(norm(fi_vec-fi_vec2)+norm(fi_vec-fi_mat(:))+norm(Fi{1}*Fi{2}'-fi_mat)==0);
underline('apply_boundary_conditions');
fprintf( 'all_same: %g\n', all_same );


%% solve the system via direct solver for comparison
ui_vec=Ki_mat\fi_vec;

%%
% the preconditioner
Mi=Ki(1,:);
Mi_mat=revkron( Mi );

%% Now apply the world-famous tensor product solver
% u_vec=apply_boundary_conditions_solution( u_vec_i, g_vec, P_I, P_B );
%[Ui,flag,relres,iter]=tensor_operator_solve_richardson( Ki, Fi, 'M', Mi );

underline( 'Tensor product PCG: ' );

for tolexp=1:8
    if tolexp==8
        tol=0;
        truncate='eps 0';
    else
        tol=10^-tolexp;
        truncate=sprintf('eps 10^-%d', tolexp);
    end
    [Ui,flag,relres,iter]=tensor_operator_solve_pcg( Ki, Fi, 'M', Mi, 'truncate_options', {'eps',tol, 'relcutoff', true} );
    ui_vec3=reshape(Ui{1}*Ui{2}',[],1);
    relerr=norm(ui_vec-ui_vec3 )/norm(ui_vec);
    k=size(Ui{1},2);
    if tol>0
        R=relerr/tol;
    else
        R=1;
    end
    fprintf( 'truncate: %s:: flag: %d, relres: %g, iter: %d, relerr: %g k: %d, R: %g\n', truncate, flag, relres, iter, relerr, k, R );
    
    res(tolexp,1)=tolexp;
    res(tolexp,2)=tol;
    res(tolexp,3)=relerr;
    res(tolexp,4)=R;
    res(tolexp,5)=k;
    res(tolexp,6)=iter;
end

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
[mu_u_j, u_j_i, uu_i_alpha]=tensor_to_kl( U );

clf;
plot(pos,u_j_i); 
title('KL eigenfunctions of $u$', props{:});
print( 'rf_u_kl_eig.eps', '-depsc' );
plot_kl_pce_realizations_1d( pos, mu_u_j, u_j_i, uu_i_alpha, I_u, 'realizations', 50 ); 
title('mean/var/samples of $u$', props{:});
print( 'rf_u_kl_real.eps', '-depsc' );
userwait;



clf;
n=2:8; 
plot( n, log(res(n,2)), '-x', n, log(res(n,3)), '-x' );
xlabel('$n$', props{:}); 
ylabel('$\log(\epsilon), \log(E\,\;)$', props{:});
print( 'pcg_conv1_n_eps.eps', '-depsc' );

plot( -log(res(n,2)), res(n,5), 'x-' )
xlabel('$-\;\log(\epsilon)$', props{:});
ylabel('$k$', props{:}); 
print( 'pcg_conv1_eps_k.eps', '-depsc' );


plot( n, res(n,5), 'x-' )
plot( n, res(n,6), 'x-' ); ylim([0,20]);


