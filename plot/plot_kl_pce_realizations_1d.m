function plot_kl_pce_realizations_1d( pos, mu_u_j, u_j_i, u_i_alpha, I_u, varargin )


% Hint: The dimensions of the parameters must be such that 
%    POS * MU_U_I
%    POS * U_I_K * U_K_ALPHA * I_ALPHA * XI
%   are well-defined matrix products.

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

    [mu_i,var_i]=pce_moments( u_i_alpha, I_u ); %#ok<ASGLU>
    var_u=u_j_i.^2*var_i;

    std_u=sqrt(var_u);
    for i=0:stat
        plot(pos, mu_u_j*[1,1]+i*std_u*[-1,1], ...
	     'Color', col(1+round(i*size(col,1)/(stat+2)),:) );
        hold on;
    end
end


if ~isempty(xi)
  n=size(xi,2);
end
for i=1:n
  if isempty(xi)
    u_i=kl_pce_field_realization(mu_u_j,u_j_i,u_i_alpha,I_u,[]);
  else
    u_i=kl_pce_field_realization(mu_u_j,u_j_i,u_i_alpha,I_u,xi(:,i));
  end
  plot( pos, u_i, '-', 'Color', [0.5,0.5,0.5] );
  hold on;
end
hold off;
