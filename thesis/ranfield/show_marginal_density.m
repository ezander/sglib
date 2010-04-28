function show_marginal_density

mh=multiplot_init( 3, 4 );

% Show that created random fields indeed show the right marginal densities
tic
N=50;

[pos,els,bnd]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );

% load the kl variables of the conductivity k
% define stochastic parameters
for n=1:3
    switch n
        case 1
            dist='beta';
            dist_params={4,2};
            rng=[0,1.2];
        case 2
            dist='lognormal';
            dist_params={0.3,0.5};
            rng=[0,5];
        case 3
            dist='exponential';
            dist_params={0.5};
            rng=[-1,7];
    end
    dist_shift=0.1;
    dist_scale=1;
    
    
    
    for p_k=1:4
        m_k=4;
        l_k=4;
        lc_k=0.3;
        
        stdnor_k=@(x)(gendist_stdnor(x,dist,dist_params,dist_shift,dist_scale));
        pdf_k=@(x)(gendist_pdf(x,dist,dist_params,dist_shift,dist_scale));
        [mu_k,var_k]=gendist_moments(dist,dist_params,dist_shift,dist_scale);
        
        cov_k={@gaussian_covariance,{lc_k,1}};
        % create field
        [k_i_alpha, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
        
        x=linspace(rng(1),rng(2));
        y_ex=pdf_k(x);
        N=100000;
        Nout=30;
        i=10;
        y_rf1=pce_pdf( x, k_i_alpha(i,:), I_k, 'N', N, 'Nout', Nout );
        y_rf2=pce_pdf( x, k_i_alpha(i,:), I_k, 'N', N, 'Nout', Nout );
        y_rf3=pce_pdf( x, k_i_alpha(i,:), I_k, 'N', N, 'Nout', Nout );
        y_rf4=pce_pdf( x, k_i_alpha(i,:), I_k, 'N', N, 'Nout', Nout );
%         y_rf2=pce_pdf( x, k_i_alpha(10,:), I_k, 'N', 100000 );
%         y_rf3=pce_pdf( x, k_i_alpha(30,:), I_k, 'N', 100000 );
%         y_rf4=pce_pdf( x, k_i_alpha(50,:), I_k, 'N', 100000 );
        multiplot(mh,n,p_k);
        plot(x, y_ex, 'LineWidth', 2 ); 
%         plot(x, y_rf, 'g' );
%         plot(x, y_rf2, 'g' );
%         plot(x, y_rf3, 'g' );
%         plot(x, y_rf4, 'g' );
        plot(x, 0.25*(y_rf1+y_rf2+y_rf3+y_rf4), 'LineWidth', 2 ); 
        %drawnow;
        save_figure( mh(n,p_k), {'ranfield_marginal_density-%s-p%d', dist,p_k} );
    end
end


