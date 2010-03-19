function show_mean_var
% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

show_mean_var_with

function show_mean_var_without

model_large
dist_f={'beta', {4,2}, 0, 1.0 };
dist_f={'uniform', {-1,1}, 0, 1.0 };
dist_f={'beta', {0.2,0.2}, 0, 1.0 };
dist_f={'exponential', {5}, 0, 1.0 };
dist_f={'lognormal', {0,0.2}, 0, 1.0 };
m_f=20;
m_k=1;


num_refine=1;
show_mesh=false;

define_geometry

stdnor_f={@gendist_stdnor,dist_f};
lc_f=0.6;
cov_f_func=@gaussian_covariance;
cov_f={cov_f_func,{lc_f,1}};


phi_k=pce_expand_1d(stdnor_f,6);
C_f=covariance_matrix( pos, cov_f, 'max_dist', 5*lc_f );
C_gam=transform_covariance_pce( C_f, phi_k );



stdnor_f={@gendist_stdnor, dist_f};
lc_f=0.2;
cov_f_func=@gaussian_covariance;
cov_f={cov_f_func,{lc_f,1}};
eps_f=1;
mean_f_func=[];


C_f=covariance_matrix( pos, cov_f );
x=linspace(0,3); 
clf
plot( x, funcall( cov_f, x, [] ) ); drawnow

[fs_i_k,sigma_fs_k]=kl_solve_evp( C_f, G_N, 10 );

sigma_fs_k(1:4)
subplot( 2, 2, 1 ); plot_field(pos, els, fs_i_k(:,1) ); hold on
subplot( 2, 2, 2 ); plot_field(pos, els, fs_i_k(:,2) ); hold on
subplot( 2, 2, 3 ); plot_field(pos, els, fs_i_k(:,3) ); hold on
subplot( 2, 2, 4 ); plot_field(pos, els, fs_i_k(:,4) ); hold on

return

[f_i_k,f_k_alpha,I_f,l_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_f, m_f, l_f, 'eps', eps_f, 'mean_func', mean_f_func, 'projection_method', false );
%[f_i_k,f_k_alpha,I_f,l_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_f, m_f, l_f, 'eps', eps_f, 'mean_func', mean_f_func, 'projection_method', true );

[mu_fs_i,fs_i_k,sigma_fs_k,fs_k_alpha]=kl_pce_to_standard_form(f_i_k,f_k_alpha);

sigma_fs_k(1:4)
subplot( 2, 2, 1 ); plot_field(pos, els, fs_i_k(:,1) ); hold on
subplot( 2, 2, 2 ); plot_field(pos, els, fs_i_k(:,2) ); hold on
subplot( 2, 2, 3 ); plot_field(pos, els, fs_i_k(:,3) ); hold on
subplot( 2, 2, 4 ); plot_field(pos, els, fs_i_k(:,4) ); hold on
return

x=[-0.5, -0.4; 0.9, -0.9; 0.2, 0.5]';
max_f_pos=[-0.0492 -0.8387 0.8455];
min_f_pos=[0.5649 0.1045 0.3959];
x_f=[x max_f_pos(1:2)' min_f_pos(1:2)'];


clf
subplot( 2, 2, 1 ); show_field( pos, els, f_i_k, f_k_alpha, I_f )
subplot( 2, 2, 2 ); show_mesh( pos, els, x );
subplot( 2, 2, 3 ); show_density( pos, els, f_i_k, f_k_alpha, I_f, x )




% phi_k=pce_expand_1d(stdnor_f,7);
% C_f=covariance_matrix( pos, cov_f );
% C_gam=transform_covariance_pce( C_f, phi_k, 'correct_var', true );
% show_with_linreg( sort(C_f(:)), sort(C_gam(:)) );

disp('done');

return

discretize_model

x=[-0.5, -0.4; 0.9, -0.9; 0.2, 0.5]';
max_f_pos=[-0.0492 -0.8387 0.8455];
min_f_pos=[0.5649 0.1045 0.3959];
x_f=[x max_f_pos(1:2)' min_f_pos(1:2)'];

clf
subplot( 3, 2, 1 ); show_field( pos, els, k_i_k, k_k_alpha, I_k )
subplot( 3, 2, 2 ); show_field( pos, els, f_i_k, f_k_alpha, I_f )

subplot( 3, 2, 3 ); show_mesh( pos, els, x );
subplot( 3, 2, 4 ); show_mesh( pos, els, x_f );

subplot( 3, 2, 5 ); show_density( pos, els, k_i_k, k_k_alpha, I_k, x )
subplot( 3, 2, 6 ); show_density( pos, els, f_i_k, f_k_alpha, I_f, x_f )


function show_mean_var_with
rebuild=get_param('rebuild', true, 'base' );
autoloader( {'model_large'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_pcg'}, rebuild, 'caller' );
assignin( 'base', 'rebuild', false );


x=[-0.5, -0.4; 0.9, -0.9; 0.2, 0.5]';
max_f_pos=[-0.0492 -0.8387 0.8455]
min_f_pos=[0.5649 0.1045 0.3959];
x_f=[x max_f_pos(1:2)' min_f_pos(1:2)'];

clf
subplot( 3, 3, 1 ); show_field( pos, els, k_i_k, k_k_alpha, I_k )
subplot( 3, 3, 2 ); show_field( pos, els, f_i_k, f_k_alpha, I_f )
subplot( 3, 3, 3 ); show_field( pos, els, u_i_k, u_k_alpha, I_u )

subplot( 3, 3, 4 ); show_mesh( pos, els, x );
subplot( 3, 3, 5 ); show_mesh( pos, els, x_f );
subplot( 3, 3, 6 ); show_mesh( pos, els, x );

subplot( 3, 3, 7 ); show_density( pos, els, k_i_k, k_k_alpha, I_k, x )
subplot( 3, 3, 8 ); show_density( pos, els, f_i_k, f_k_alpha, I_f, x_f )
subplot( 3, 3, 9 ); show_density( pos, els, u_i_k, u_k_alpha, I_u, x )





function c=col(n)
%colors='bgrcmyk';
colors='bkrcmyg';
c=colors(n);

function show_mesh( pos, els, x )
trimesh( els', pos(1,:), pos(2,:), zeros(size(pos(1,:))) );
%view(2)
axis equal
for i=1:size(x,2)
    line( x([1;1],i),  x([2;2],i), [0.08;0.08], 'Marker', '+', 'MarkerEdgeColor', col(i));
    %line( x([1;1],i),  x([2;2],i), [0.08;0.08], 'Marker', 'o', 'MarkerEdgeColor', col(i));
end
%hold on; trimesh( els(:,1)', pos(1,:), pos(2,:), 0.04+zeros(size(pos(1,:))) );
%view(2)
hold off;

function show_density( pos, els, r_i_k, r_k_alpha, I_r, x )
Px=point_projector( pos, els, x );
r_x_alpha=((Px'*r_i_k)*r_k_alpha);
for i=1:size(r_x_alpha,1)
    [y,x]=pce_pdf( [], r_x_alpha(i,:), I_r, 'N', 1e3);
    plot(x,y,col(i)); hold on;
end
hold off;


function show_field( pos, els, r_i_k, r_k_alpha, I_r )
[mu_r, var_r]=kl_pce_moments( r_i_k, r_k_alpha, I_r );
plot_field(pos, els, mu_r-sqrt(var_r) ); hold on
plot_field(pos, els, mu_r ); hold on;
plot_field(pos, els, mu_r+sqrt(var_r) );hold off;
view(3)

function show_with_linreg( x, y )
a=polyfit(x,y,1);
y2=polyval(a,x);
if length(x)<100
    ptype='x';
else
    ptype='-';
end
plot( x, y, ptype, x, y2, '-' );


