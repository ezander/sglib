%%% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

%% Init stuff
clf; clear;
%close

% expansion of the right hand side field (f)
l_f=22;
lc_f=0.5; %#ok
cov_func={@gaussian_covariance,{lc_f,1}}; %#ok
options.correct_var=true;

%% The geometry
geometries={ 'lshape', 'cardioid', 'circle', 'scatter', 'circle_segment', 'crack', 'square' };
geom_num=2;

clf;
set( gcf, 'Renderer', 'painters' );
[els,pos,G_N]=load_pdetool_geom( geometries{geom_num}, 2, true );
f_i_k=kl_expand( covariance_matrix( pos, cov_func, 'max_dist', 4*lc_f ), G_N, l_f, options );
print( sprintf( 'shape_%s.eps', geometries{geom_num} ),'-depsc2' );

%% KL of the cardioid
    
clf;
set( gcf, 'Position', [0, 0, 900, 900] );
set( gcf, 'Renderer', 'painters' );
opts={'shading', 'flat', 'show_mesh', false};
for i=1:8
    subplot(4,4,i);
    plot_field( els, pos, v_f(:,i), opts{:} );
    title(sprintf('KLE: f_{%d}',i));
    
    subplot(4,4,i+8);
    plot_field( els, pos, v_f(:,i), 'view', [30,15], opts{:} );
    title(sprintf('KLE: f_{%d}',i));
end
print( sprintf( 'shape_%s_kl.eps', geometries{geom_num} ),'-depsc2' );
