% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.

init_demos

clear
%s=load('mesh/rect_mesh_coarse.mat');
s=load('data/rect_mesh.mat');
els=s.nodes;
pos=s.coords;

[els,pos]=correct_mesh( els, pos );
M=mass_matrix( els, pos );


% expansion of the right hand side field (f)
p_f=3;
m_gam_f=22;
m_f=22;
lc_f=[0.03 0.2]; %#ok
lc_f=0.2; %#ok
h_f={@beta_stdnor,{4,2}}; %#ok
h_f={@normal_stdnor,{0,1}}; %#ok
cov_f={@exponential_covariance,{lc_f,1}}; %#ok
cov_f={@spherical_covariance,{lc_f,1}}; %#ok
cov_f={@gaussian_covariance,{lc_f,1}}; %#ok
cov_gam={@gaussian_covariance,{lc_f,1}};
options_expand_f.transform.correct_var=true;


disp( 'expanding field, this may take a while ...' );
tic
[f_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, cov_gam, pos, M, p_f, m_gam_f, options_expand_f );
toc
disp( 'performing kl expansion, this may take a while, too ...' );
tic
[mu_f,f_i_alpha,v_f]=pce_to_kl( f_alpha, I_f, M, m_f );
toc


Bei Floerke anrufen!!!!


clf;
for i=1:12
    subplot(4,4,i);
    plot_field( els, pos, v_f(:,i) );
end
for i=13:16
    subplot(4,4,i);
    f_ex=kl_pce_field_realization( pos, mu_f, v_f, f_i_alpha, I_f );
    plot_field( els, pos, f_ex );
end

disp( 'the first three rows shows the KL eigenfunctions of the field' );
disp( 'the last row shows some sample realizations' );
