function show_mean_var
% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

show_mean_var_with

function show_mean_var_without

model_large
m_f=1;
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
