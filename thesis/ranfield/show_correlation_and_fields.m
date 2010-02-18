function show_correlation_and_fields

% DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.


% We use the pde toolbox to generate the geometry and the mass matrix
% (gramian)
%[els,pos,G_N]=load_pdetool_geom( 'cardioid', 1, true );
%[els,pos,G_N]=load_pdetool_geom( 'square', 2, true );
[els,pos,G_N]=load_pdetool_geom( 'square', 0, true );

%#ok<*NASGU>

% expansion of the right hand side field (f)
p_f=1;
m_f=200;
lc_fs=[0.5 0.05]; 
lc_f=0.020; 
h_f={@normal_stdnor,{0,1}};

funcs={@gaussian_covariance, @exponential_covariance, @spherical_covariance};
lc_fs=[0.02,0.2,2,20];

subfig=false;


for i=1:length(funcs);
    for j=1:length(lc_fs)
        cov_func={funcs{i},{lc_fs(j), 1}};
        cov_f=cov_func;
        cov_gam=cov_func;
        % now expanding field in ...
        disp( 'expanding field, this may take a while ...' );
        [f_i_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, cov_gam, pos, G_N, p_f, m_f );

        fprintf( '%s   %g\n', func2str(funcs{i}),lc_fs(j));
        if subfig
            h=clf;
            set( gcf, 'Renderer', 'zbuffer' );
            for j=1:4
                subplot(2,2,j);
                f_ex=pce_field_realization( pos, f_i_alpha, I_f );
                plot_field( els, pos, f_ex );
                title(sprintf('Sample: %d',j));
            end
        else
            clf;
            set( gcf, 'Renderer', 'zbuffer' );
            f_ex=pce_field_realization( pos, f_i_alpha, I_f );
            plot_field( els, pos, f_ex );
            shading interp;
            zlim([-2,2]);
            colorbar
            save_thesis_figure( 'ranfield_%s_l_%g', {func2str(funcs{i}),lc_fs(j)} );
        end
    end
end
%% plot the whole stuff

disp( 'the first three rows shows the KL eigenfunctions of the field' );
disp( 'the last row shows some sample realizations' );
keyboard


