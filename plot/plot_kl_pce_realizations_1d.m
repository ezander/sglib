function plot_kl_pce_realizations_1d( pos, r_i_k, r_k_alpha, I_r, varargin )


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

    mu_u_i=r_i_k*r_k_alpha(:,1);
    [mu_k,var_k]=pce_moments( r_k_alpha, I_r ); %#ok<ASGLU>
    var_u_i=r_i_k.^2*var_k;

    std_u_i=sqrt(var_u_i);
    for j=0:stat
        plot(pos, mu_u_i*[1,1]+j*std_u_i*[-1,1], ...
	     'Color', col(1+round(j*size(col,1)/(stat+2)),:) );
        hold on;
    end
end


if ~isempty(xi)
  n=size(xi,2);
end
for i=1:n
  if isempty(xi)
    u_i=kl_pce_field_realization(r_i_k,r_k_alpha,I_r,[]);
  else
    u_i=kl_pce_field_realization(r_i_k,r_k_alpha,I_r,xi(:,i));
  end
  plot( pos, u_i, '-', 'Color', [0.5,0.5,0.5] );
  hold on;
end
hold off;
