function demo_tensor_2d

%% load and show mesh
[pos,els,G_N,ptdata]=load_pdetool_geom( 'cardioid', 1, false );
pdemesh( ptdata{:} )

p_f=3;
m_f=22;
l_f=12;
%lc_f=[0.03 0.2];
lc_f=.5;
h_f={@normal_stdnor,{0,1}};
cov_f={@gaussian_covariance,{lc_f,1}};
%options_expand_f.transform.correct_var=true;

%% now expanding field in ...
disp( 'expanding field, this may take a while ...' );
[f_i_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, [], pos, G_N, p_f, m_f );
disp( 'performing kl expansion, this may take a while, too ...' );

for t=1:2
    if t==1
        C=covariance_matrix( pos, cov_f );
        f_i_k=kl_solve_evp( C, G_N, l_f );
        %f_i_k=f_i_k(:,2:end); %???
        mu_f_i=f_i_alpha(:,1);
    else
        [mu_f_i,f_i_k,f_k_alpha,relerr]=pce_to_kl( f_i_alpha, I_f, l_f, G_N, [] );
    end
    
    subplot(4,4,1+8*(t-1)); plot_field( pos, els, mu_f_i );
    subplot(4,4,2+8*(t-1)); plot_field( pos, els, f_i_k(:,1) );
    subplot(4,4,3+8*(t-1)); plot_field( pos, els, f_i_k(:,2) );
    subplot(4,4,4+8*(t-1)); plot_field( pos, els, f_i_k(:,3) );
    subplot(4,4,5+8*(t-1)); plot_field( pos, els, f_i_k(:,4) );
    subplot(4,4,6+8*(t-1)); plot_field( pos, els, f_i_k(:,5) );
    subplot(4,4,7+8*(t-1)); plot_field( pos, els, f_i_k(:,6) );
    subplot(4,4,8+8*(t-1)); plot_field( pos, els, f_i_k(:,7) );
end    
