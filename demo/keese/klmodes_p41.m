%% KL modes on lshaped domain (page 41).

addpath('../');
init_demos
clear

% properties for the covariance function and expansion
modes=[1,5,10,20];
mode_names={'First', '5-th', '10-th', '20-th' };
m=max(modes);
lc=0.5;
cov_func={@gaussian_covariance,{lc,1}};

% LShaped domain
[els,pos,G_N]=load_pdetool_geom( 'lshape', 1, false );
v_f=kl_expand( covariance_matrix( pos, cov_func ), G_N, m, 'correct_var', true );
for j=1:m
    if mean(v_f(:,j))<0; v_f(:,j)=-v_f(:,j); end
end

set( gcf, 'Renderer', 'zbuffer' );
if ~strcmp( get( gcf, 'WindowStyle' ), 'docked' )
    set( gcf, 'Position', [0, 0, 900, 900])
end

for i=1:4
    subplot(2,2,i);
    u=v_f(:,modes(i));
    plot_field( els, pos, u, 'view', [220,25], 'colormap', 'cool', 'show_surf', true, 'shading', 'faceted' );
    plot_field_contour( els, pos, u, 'zpos', 'min' );
    plot_boundary( els, pos, 'color', 'k', 'zpos', min(u) );
    title(sprintf('%s KL-mode, L-shaped domain',mode_names{i}));
end
