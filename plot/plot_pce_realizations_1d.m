function plot_pce_realizations_1d( x, u_alpha, I_u, varargin )

options=varargin2options( varargin{:} );
[n,options]=get_option( options, 'realizations', 20 );
[stat,options]=get_option( options, 'show_stat', 3 );
[map,options]=get_option( options, 'colormap', 'hot' );
check_unsupported_options( options, mfilename );

if stat>=0
    oldmap=colormap;
    col=colormap(map);
    colormap(oldmap);
    
    [mu_u, var_u]=pce_moments( u_alpha, I_u);
    std_u=sqrt(var_u);
    for i=0:stat
        plot(x, mu_u*[1,1]+i*std_u*[-1,1], 'Color', col(1+round(i*size(col,1)/(stat+2)),:) );
        hold on;
    end
end
for i=1:n
    plot(x,pce_field_realization(x,u_alpha,I_u),'-', 'Color', [0.5,0.5,0.5]);
end
hold off

%%
