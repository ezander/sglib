%%% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

%% Init stuff
addpath('../');
init_demos
clear
close

% expansion of the right hand side field (f)
m=22;
lc_f=0.5; %#ok
cov_func={@gaussian_covariance,{lc_f,1}}; %#ok
options.correct_var=true;

%% LShaped domain

[pos,els,M]=load_pdetool_geom( 'lshape', 0, false );
v_f=kl_expand( covariance_matrix( pos, cov_func ), M, m, options );

%% KL of the cardioid
    
set( gcf, 'Position', [0, 0, 900, 900] );
set( gcf, 'Renderer', 'zbuffer' );
modes=[1,5,10,20];

for i=1:4
    subplot(2,2,i);
    plot_field( els, pos, v_f(:,modes(i)), 'view', [210,15], 'colormap', 'cool', 'show_surf', true, 'shading', 'faceted' );
    plot_field_contour( els, pos, v_f(:,modes(i)) );
    title(sprintf('KLE: f_{%d}',modes(i)));
end
