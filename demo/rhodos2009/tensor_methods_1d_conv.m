%function demo_tensor_methods

clf; dock; clear; 
props={'Interpreter', 'latex', 'FontSize', 16, };


%% load the geomatry
% 1D currently, so nothing to plot here
N=51;
[pos,els,bnd]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );

%% load the kl variables of the conductivity k
% define stochastic parameters
p_k=4;
m_k=4;
l_k=4;
lc_k=0.3;
stdnor_k={@beta_stdnor,{4,2}};
cov_k={@gaussian_covariance,{lc_k,1}};
% create field
[k_i_alpha, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
[k_i_k,k_k_alpha]=pce_to_kl( k_i_alpha, I_k, l_k, G_N );
% plot field
clf;
plot(pos,k_i_k); 
title('KL eigenfunctions of $\kappa$', props{:});
print( 'rf_k_kl_eig.eps', '-depsc' );
plot_kl_pce_realizations_1d( pos, k_i_k, k_k_alpha, I_k, 'realizations', 50 ); 
title('mean/var/samples of $\kappa$', props{:} );
print( 'rf_k_kl_real.eps', '-depsc' );
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
[f_i_alpha, I_f]=expand_field_pce_sg( stdnor_f, cov_f, [], pos, G_N, p_f, m_f );
[f_i_k,f_k_alpha]=pce_to_kl( f_i_alpha, I_f, l_f, G_N );
% plot field
clf;
plot(pos,f_i_k); 
title('KL eigenfunctions of $f$', props{:});
print( 'rf_f_kl_eig.eps', '-depsc' );
plot_kl_pce_realizations_1d( pos, f_i_k, f_k_alpha, I_f, 'realizations', 50 ); 
title('mean/var/samples of $f$', props{:});
print( 'rf_f_kl_real.eps', '-depsc' );
userwait;

%% define (deterministic) boundary conditions g
% this defines the function g(x)=x_1
select=@(x,n)(x(n,:)');
g_func={ select, {1}, {2} };
% dummy pce (just the mean)
g_i_alpha=funcall( g_func, pos);
I_g=multiindex(0,0);
% "null" kl expansion of g
[g_i_k,g_k_alpha]=pce_to_kl( g_i_alpha, I_g, 0 );


%% combine the multiindices
% (i.e. build the product sample space $Omega_u=Omega_k \times Omega_f \times
% Omega_g$ in which the solution lives)
[I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, -1 );
M=size(I_u,1); %#ok, full stochastic dimension


%% create the right hand side
% i.e. scale the pce coefficients with the norm of the stochastic ansatz
% functions and create tensor, matrix and vector versions out of it
f_k_beta=compute_pce_rhs( f_k_alpha, I_f, I_u );
F=kl_to_tensor( f_i_k, f_k_beta );
F_mat=tensor_to_array(F);
F_vec=tensor_to_vector(F);

g_k_beta=compute_pce_rhs( g_k_alpha, I_g, I_u );
G=kl_to_tensor( g_i_k, g_k_beta );
G_mat=tensor_to_array( G );
G_vec=tensor_to_vector( G );


%% load and create the operators 
% since this takes a while we cache the function call
kl_operator_version=1;
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};
opt.silent=false;
opt.show_timings=true;
op_filename=sprintf('kl_operator_1d_%d_%d.mat', N, M );

% create tensor operators
K=cached_funcall(...
    @compute_kl_pce_operator,...
    { k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'mu_delta' }, ...
    1,... % just one output argument
    op_filename, ...
    kl_operator_version, ...
    {'message', 'recomputing kl-operator', ...
     'show_timings', opt.show_timings, 'silent', opt.silent, ...
     'extra_params', {'show_timings', opt.show_timings, 'silent', opt.silent}...
    } ...
);

% create matrix and tensor operators
K_mat=tensor_operator_to_matrix(K);


%% apply boundary conditions
[P_I,P_B]=boundary_projectors( bnd, size(pos,2) );

Ki=apply_boundary_conditions_operator( K, P_I );
Ki_mat=apply_boundary_conditions_operator( K_mat, P_I );

Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );
Fi_vec=apply_boundary_conditions_rhs( K_mat, F_vec, G_vec, P_I, P_B );
Fi_vec2=apply_boundary_conditions_rhs( K, F_vec, G_vec, P_I, P_B );
Fi_mat=apply_boundary_conditions_rhs( K, F_mat, G_mat, P_I, P_B );
% 
all_same=(norm(Fi_vec-Fi_vec2)+norm(Fi_vec-Fi_mat(:))+norm(Fi{1}*Fi{2}'-Fi_mat)<=1e-10);
underline('apply_boundary_conditions');
fprintf( 'all_same: %g\n', all_same );
if ~all_same
    gvector_error( tensor_to_vector(G), G_vec )
    gvector_error( tensor_to_vector(F), F_vec )
    gvector_error( tensor_to_vector(Fi), Fi_vec )
    gvector_error( tensor_to_vector(Fi), Fi_vec2 )
    gvector_error( tensor_to_array(Fi), Fi_mat )
    keyboard;
end


%% solve the system via direct solver for comparison
Ui_vec=Ki_mat\Fi_vec;

%%
% the preconditioner
Mi=Ki(1,:);
Mi_mat=tensor_operator_to_matrix( Mi );

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
    [Ui,flag,info,stats]=tensor_operator_solve_pcg( Ki, Fi, 'M', Mi, 'truncate_options', {'eps',tol, 'relcutoff', true} );
    ui_vec3=tensor_to_vector(Ui);
    relerr=gvector_error( ui_vec3, ui_vec, [], true );
    k=size(Ui{1},2);
    if tol>0
        R=relerr/tol;
    else
        R=1;
    end
    fprintf( 'truncate: %s:: flag: %d, relres: %g, iter: %d, relerr: %g k: %d, R: %g\n', truncate, flag, info.relres, info.iter, relerr, k, R );
    
    res(tolexp,1)=tolexp;
    res(tolexp,2)=tol;
    res(tolexp,3)=relerr;
    res(tolexp,4)=R;
    res(tolexp,5)=k;
    res(tolexp,6)=info.iter;
end

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
[u_i_k, u_k_alpha]=tensor_to_kl( U );

clf;
plot(pos,u_i_k); 
title('KL eigenfunctions of $u$', props{:});
print( 'rf_u_kl_eig.eps', '-depsc' );
plot_kl_pce_realizations_1d( pos, u_i_k, u_k_alpha, I_u, 'realizations', 50 );
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


