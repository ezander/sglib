function show_talk_monte_carlo
% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

rebuild=false;
rebuild=get_param('rebuild', true);
autoloader( {'model_large'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_pcg'; 'vector_to_tensor'}, rebuild, 'caller' );
rebuild=false;

u_i_alpha=u_i_k*u_k_alpha;
u_i_alpha(:,2:end)=0.05*u_i_alpha(:,2:end);

[u_mean, u_var]=pce_moments( u_i_alpha, I_u );
u_sig=sqrt(u_var);


x=[-0.5, -0.4; 0.9, -0.9; 0.2, 0.5]';
max_f_pos=[-0.0492 -0.8387 0.8455]
min_f_pos=[0.5649 0.1045 0.3959];
x=[x max_f_pos(1:2)' min_f_pos(1:2)'];


P=point_projector( pos, els, x );
[u_P_mean, u_P_var]=pce_moments( P'*u_i_alpha, I_u );
[u_P_mean, sqrt(u_P_var)]
xi=randn(10,10000);
xv=pce_field_realization( P'*u_i_alpha, I_u, xi );
[mean(xv,2), std(xv,[], 2)]

% plot solutions fields and difference
mh=multiplot_init(2,2);
opts={'view', 3};
multiplot(mh,1); plot_field(pos, els, u_mean, opts{:} );
multiplot(mh,2); plot_field(pos, els, u_sig, opts{:} );

multiplot(mh,3); show_mesh_with_points( pos, els, x ); view(3);
multiplot(mh,4); show_pce_pdf_at( pos, els, u_i_alpha, I_u, x )

   
save_talk_figure_raster( mh(1), 'mc_mean_u' );
save_talk_figure_raster( mh(2), 'mc_std_u' );
save_talk_figure( mh(3), 'mc_mesh_px' );
save_talk_figure( mh(4), 'mc_pdf_u_x' );
