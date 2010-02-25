function demo_field_expand_2d
% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

%% Init stuff
% expansion of the right hand side field (f)
m=22;
lc_f=0.5; %#ok
cov_func={@gaussian_covariance,{lc_f,1}}; %#ok
options.correct_var=true;

%[pos,els,G_N]=load_pdetool_geom( 'circle', 2, true );
%[pos,els,G_N]=load_pdetool_geom( 'scatter', 2, true );

%% The cardioid
%% (gramian)

[pos,els,G_N]=load_pdetool_geom( 'circle', 1, true );
[pos,els,G_N]=load_pdetool_geom( 'scatter', 1, true );
[pos,els,G_N]=load_pdetool_geom( 'circle_segment', 1, true );
[pos,els,G_N]=load_pdetool_geom( 'crack', 1, true );
[pos,els,G_N]=load_pdetool_geom( 'cardioid', 1, true );
f_i_k=kl_solve_evp( covariance_matrix( pos, cov_func ), G_N, m, options );

%% KL of the cardioid

set( gcf, 'Position', [0, 0, 900, 900] );
set( gcf, 'Renderer', 'zbuffer' );

for k=1:8
    subplot(4,4,k);
    plot_field( pos, els, f_i_k(:,k) );
    title(sprintf('KLE: f_{%d}',k));

    subplot(4,4,k+8);
    plot_field( pos, els, f_i_k(:,k), 'view', [30,15] );
    title(sprintf('KLE: f_{%d}',k));
end