%%% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

%% Init stuff
init_demos
clear

%% We use the pde toolbox to generate the geometry and the mass matrix
%% (gramian)
[pos,els,M]=load_pdetool_geom( 'cardioid', 1, true );
[pos,els,M]=load_pdetool_geom( 'circle', 2, true );
[pos,els,M]=load_pdetool_geom( 'scatter', 2, true );
pos=pos/max(max(pos)-min(pos))*2;

% expansion of the right hand side field (f)
m=22;
lc_f=0.5; %#ok
cov_func={@gaussian_covariance,{lc_f,1}}; %#ok

%% now expanding field in ...
disp( 'expanding field, this may take a while ...' );

C=covariance_matrix( pos, cov_func );
options.correct_var=true;
v_f=kl_expand( C, M, m, options );
    
%% plot the whole stuff
h=clf;
set( h, 'Position', [0, 0, 600, 900] );
set( gcf, 'Renderer', 'zbuffer' );

for i=1:8
    subplot(4,4,i);
    plot_field( els, pos, v_f(:,i) );
    title(sprintf('KLE: f_%d',i));
end
for i=1:8
    subplot(4,4,i+8);
    plot_field( els, pos, v_f(:,i) );
    view( [30,15] );
    title(sprintf('KLE: f_%d',i));
end

if false
for i=1:12
    subplot(4,4,i);
    plot_field( els, pos, v_f(:,i) );
    title(sprintf('KLE: f_%d',i));
end
for i=13:16
    subplot(4,4,i);
    f_ex=kl_pce_field_realization( pos, mu_f, v_f, f_i_alpha, I_f );
    plot_field( els, pos, f_ex );
    title(sprintf('Sample: %d',i-12));
end
end

disp( 'the first three rows shows the KL eigenfunctions of the field' );
disp( 'the last row shows some sample realizations' );
