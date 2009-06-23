%%% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

%% Init stuff
init_demos

clear

%% We use the pde toolbox to generate the geometry and the mass matrix
%% (gramian)
[els,pos,G_N]=load_pdetool_geom( 'cardioid', 1, true )


% expansion of the right hand side field (f)
p_f=3;
m_gam_f=22;
m_f=12;
lc_f=[0.03 0.2]; %#ok
lc_f=0.5; %#ok
h_f={@beta_stdnor,{4,2}}; %#ok
h_f={@normal_stdnor,{0,1}}; %#ok
cov_f={@exponential_covariance,{lc_f,1}}; %#ok
cov_f={@spherical_covariance,{lc_f,1}}; %#ok
cov_f={@gaussian_covariance,{lc_f,1}}; %#ok
cov_gam={@gaussian_covariance,{lc_f,1}};
options_expand_f.transform.correct_var=true;

%% now expanding field in ...
disp( 'expanding field, this may take a while ...' );
tic
[f_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, cov_gam, pos, G_N, p_f, m_gam_f, options_expand_f );
toc
disp( 'performing kl expansion, this may take a while, too ...' );
tic
[mu_f,f_i_alpha,v_f,relerr]=pce_to_kl( f_alpha, I_f, m_f, G_N, [] );
toc
fprintf( 'relative error computing KL: %g\n', relerr );

%% plot the whole stuff
h=clf;
set( h, 'Position', [0, 0, 600, 900] );
%set( h, 'PaperPosition', [0, 0, 600, 900] );
set( gcf, 'Renderer', 'zbuffer' );

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

disp( 'the first three rows shows the KL eigenfunctions of the field' );
disp( 'the last row shows some sample realizations' );
