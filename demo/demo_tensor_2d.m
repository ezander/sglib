init_demos

clear

%% load and show mesh
[els,pos,G,ptdata]=load_pdetool_geom( 'cardioid', 1, false );
pdemesh( ptdata{:} )



p_f=3;
m_gam_f=22;
m_f=12;
%lc_f=[0.03 0.2];
lc_f=.5;
h_f={@normal_stdnor,{0,1}};
cov_f={@gaussian_covariance,{lc_f,1}};
options_expand_f.transform.correct_var=true;

%% now expanding field in ...
disp( 'expanding field, this may take a while ...' );
[f_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, [], pos, G, p_f, m_gam_f, options_expand_f );
disp( 'performing kl expansion, this may take a while, too ...' );
if 1
    C=covariance_matrix( pos, cov_f );
    f=kl_expand( C, G, m_f, options_expand_f.transform );
    v_f=f(:,2:end);
else
    [mu_f,f_i_alpha,v_f,relerr]=pce_to_kl( f_alpha, I_f, m_f, M, [] );
end
fprintf( 'relative error computing KL: %g\n', relerr );

subplot(2,2,1); plot_field( els, pos, mu_f );
subplot(2,2,2); plot_field( els, pos, v_f(:,1) );
subplot(2,2,3); plot_field( els, pos, v_f(:,2) );
subplot(2,2,4); plot_field( els, pos, v_f(:,3) );




