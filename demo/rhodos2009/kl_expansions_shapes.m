%%% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

%% Init stuff
clf; clear;
%close

% expansion of a random field r
l_r=22;
lc_r=0.3; %#ok
cov_func={@gaussian_covariance,{lc_r,1}}; %#ok
options.correct_var=true;

%% The geometry
geometries={ 'lshape', 'cardioid', 'circle', 'scatter', 'circle_segment', 'crack', 'square' };
geom_num=2;
num_refinements=2;

clf;
set( gcf, 'Renderer', 'painters' );
[pos,els,G_N]=load_pdetool_geom( geometries{geom_num}, num_refinements, true );
%C=covariance_matrix( pos, cov_func, 'max_dist', 3*lc_r );
C=covariance_matrix( pos, cov_func );

[i,j]=find(C>0.01);
s=C(sub2ind(size(C),i,j));
[n,m]=size(C);
C=sparse(i,j,s,n,m);
subplot(1,2,1);
spy2(C, 'display', 'density'); title('Covariance');
subplot(1,2,2);
spy2(G_N, 'display', 'density'); title('Gramian');
userwait;

r_i_k=kl_solve_evp( C, G_N, l_r, options );
print( sprintf( 'shape_%s.eps', geometries{geom_num} ),'-depsc2' );

%% KL of the cardioid
    
clf;
set( gcf, 'Position', [0, 0, 900, 900] );
set( gcf, 'Renderer', 'painters' );
opts={'shading', 'flat', 'show_mesh', false};
for k=1:8
    subplot(4,4,k);
    plot_field( pos, els, r_i_k(:,k), opts{:} );
    title(sprintf('KLE: r_{%d}',k));
    
    subplot(4,4,k+8);
    plot_field( pos, els, r_i_k(:,k), 'view', [30,15], opts{:} );
    title(sprintf('KLE: r_{%d}',k));
end
print( sprintf( 'shape_%s_kl.eps', geometries{geom_num} ),'-depsc2' );
