function demo_field_expand_2d 
% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.


%% Initialization stuff
% We use the pde toolbox to generate the geometry and the mass matrix
% (gramian)
[pos,els,G_N]=load_pdetool_geom( 'cardioid', 1, true );


% expansion of the right hand side field (f)
p_f=3;
m_f=22;
l_f=12;
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
[f_i_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, cov_gam, pos, G_N, p_f, m_f, options_expand_f );
toc
disp( 'performing kl expansion, this may take a while, too ...' );
tic
[f_i_0, f_i_k, f_k_alpha, relerr]=pce_to_kl( f_i_alpha, I_f, l_f, G_N, [] );
toc
fprintf( 'relative error computing KL: %g\n', relerr );

%% plot the whole stuff
h=clf;
set( h, 'Position', [0, 0, 600, 900] );
%set( h, 'PaperPosition', [0, 0, 600, 900] );
set( gcf, 'Renderer', 'zbuffer' );

for k=1:12
    subplot(4,4,k);
    plot_field( pos, els, f_i_k(:,k) );
    title(sprintf('KLE: f_{%d}',k));
end
for j=1:4
    subplot(4,4,12+j);
    f_ex=kl_pce_field_realization( pos, f_i_0, f_i_k, f_k_alpha, I_f );
    plot_field( pos, els, f_ex );
    title(sprintf('Sample: %d',j));
end

disp( 'the first three rows shows the KL eigenfunctions of the field' );
disp( 'the last row shows some sample realizations' );
