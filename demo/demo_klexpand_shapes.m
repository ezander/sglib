%%% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

%% Init stuff
init_demos
clear
%close

% expansion of the right hand side field (f)
m=22;
lc_f=0.5; %#ok
cov_func={@gaussian_covariance,{lc_f,1}}; %#ok
options.correct_var=true;

%[els,pos,G_N]=load_pdetool_geom( 'circle', 2, true );
%[els,pos,G_N]=load_pdetool_geom( 'scatter', 2, true );

%% The cardioid
%% (gramian)

[els,pos,G_N]=load_pdetool_geom( 'circle', 1, true );
[els,pos,G_N]=load_pdetool_geom( 'scatter', 1, true );
[els,pos,G_N]=load_pdetool_geom( 'cardioid', 1, true );
[els,pos,G_N]=load_pdetool_geom( 'circle_segment', 1, true );
[els,pos,G_N]=load_pdetool_geom( 'crack', 1, true );
v_f=kl_expand( covariance_matrix( pos, cov_func ), G_N, m, options );

%% KL of the cardioid

set( gcf, 'Position', [0, 0, 900, 900] );
set( gcf, 'Renderer', 'zbuffer' );

for i=1:8
    subplot(4,4,i);
    plot_field( els, pos, v_f(:,i) );
    title(sprintf('KLE: f_{%d}',i));

    subplot(4,4,i+8);
    plot_field( els, pos, v_f(:,i), { 'view', [30,15] } );
    title(sprintf('KLE: f_{%d}',i));
end