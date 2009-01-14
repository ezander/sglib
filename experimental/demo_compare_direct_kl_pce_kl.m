clear
%s=load('mesh/rect_mesh_coarse.mat');
s=load('mesh/rect_mesh.mat');
els=s.nodes;
pos=s.coords;


[els,pos]=correct_mesh( els, pos );

z=0*sum(pos,2);
z=randn(size(z));

trisurf( els, pos(:,1), pos(:,2), z )
view(2);


M=mass_matrix( els, pos );


% expansion of the right hand side field (f)
p_f=3;
m_gam_f=12*4;
m_f=12;
lc_f=[0.03 0.2];
lc_f=0.2/2;%/4;
h_f={@beta_stdnor,{4,2}};
cov_f={@gaussian_covariance,{lc_f,1}};
options.transform.correct_var=true;

C=covariance_matrix( pos, cov_f );
[v_f_dir,sqrt_lambda]=kl_expand( C, M, m_f, 'correct_var', true );

[f_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, [], pos, M, p_f, m_gam_f, options );
[mu_f,f_i_alpha,v_f_pce]=pce_to_kl( f_alpha, I_f, M, m_f );


clf;
v=[v_f_dir v_f_pce];
for i=1:(2*m_f)
    subplot(4,6,i);
    trisurf( els, pos(:,1), pos(:,2), v(:,i) );
    xlim([min(pos(:,1)) max(pos(:,1))]);
    ylim([min(pos(:,2)) max(pos(:,2))]);
    view(2);
    axis equal;

    shading interp;
    lighting flat;
    drawnow;
end

