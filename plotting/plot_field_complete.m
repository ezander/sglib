function plot_field_complete( pos, els, r, varargin )

options=varargin2options(varargin);
[x,options]=get_option( options, 'x', [0.5, -0.4; 0.9, -0.9; 0.2, 0.5]' );
[N,options]=get_option( options, 'N', 2e4 );
[cov,options]=get_option( options, 'cov', [] );
[dist,options]=get_option( options, 'dist', [] );
[dlim,options]=get_option( options, 'dlim', [0,1] );
check_unsupported_options(options, mfilename);


opts={'view', 3};
if length(r)==2
    [r_mean,r_var]=pce_moments( r{:} );
    r_samp1=pce_field_realization( r{:} );
    r_samp2=pce_field_realization( r{:} );
else
    [r_mean,r_var]=kl_pce_moments( r{:} );
    r_samp1=kl_pce_field_realization( r{:} );
    r_samp2=kl_pce_field_realization( r{:} );
end
    
multiplot_init(2,3);

multiplot([],1); plot_field(pos, els, r_mean, opts{:}, 'show_mesh', true ); 
multiplot([],2); plot_field(pos, els, sqrt(r_var), opts{:} ); 
multiplot([],3); plot_field(pos, els, r_samp1, opts{:}, 'show_mesh', true ); 
multiplot([],4); plot_field(pos, els, r_samp2, opts{:} ); 


multiplot([],5); show_mesh_with_points( pos, els, x, 'MarkerSize', 10, 'zpos', 0.01 ); view(3);
if length(r)==3
    r_i_alpha=r{1}*r{2};
    I_r=r{3};
else
    r_i_alpha=r{1};
    I_r=r{2};
end
multiplot([],6);
if ~isempty(dist)
    hold all;
    y=linspace(dlim(1), dlim(2), 1000);
    v=gendist_pdf( y, dist{:} );
    plot( y, v, 'Color', 'k', 'LineWidth',2  );
end
show_pce_pdf_at( pos, els, r_i_alpha, I_r, x, 'N', N )
