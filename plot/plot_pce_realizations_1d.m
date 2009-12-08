function plot_pce_realizations_1d( x, u_alpha, I_u, varargin )

options=varargin2options( varargin );
[n,options]=get_option( options, 'realizations', 20 );
[xi,options]=get_option( options, 'xi', [] );
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
        plot_opts={'Color', col(1+round(i*size(col,1)/(stat+2)),:)};
        if i==0
            plot_opts={plot_opts{:}, 'LineWidth', 2};
        end
        plot(x, mu_u*[1,1]+i*std_u*[-1,1], plot_opts{:} );
        hold on;
    end
end

if isempty(xi)
    for i=1:n
        pce_field_realization(x,u_alpha,I_u,[],'plot_options',{'-', 'Color', [0.5,0.5,0.5]} );
        hold on;
    end
else
    for i=1:size(xi,1)
        pce_field_realization(x,u_alpha,I_u,xi(i,:),'plot_options',{'-', 'Color', [0.5,0.5,0.5]} );
        hold on;
    end
end
hold off;


