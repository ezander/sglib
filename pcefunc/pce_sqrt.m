function u_alpha=pce_sqrt( x_alpha, I_x, varargin )

options=varargin2options( varargin{:} );
[u0,options]=get_option( options, 'u0', [] );
[maxiter,options]=get_option( options, 'maxiter', 10 );
[abstol,options]=get_option( options, 'abstol', 1e-5 );
[reltol,options]=get_option( options, 'reltol', 1e-5 );
[show_stats,options]=get_option( options, 'show_stats', false );
check_unsupported_options( options, mfilename );

if isempty(u0)
    u_alpha=zeros(size(x_alpha));
    u_alpha(:,1)=sqrt(x_alpha(:,1));
else
    u_alpha=u0;
end

[mean,var]=pce_moments( x_alpha, I_x );
x_norm=sqrt( mean.^2+var );
iter=0;
while true
    iter=iter+1;
    %u_alpha=0.5*(u_alpha + pce_divide( u_alpha, I_x, x_alpha, I_x, I_x ) );
    diff=0.5*(pce_divide( u_alpha, I_x, x_alpha, I_x, I_x )-u_alpha);
    u_alpha=u_alpha+diff;

    [mean,var]=pce_moments( diff, I_x );
    diff_norm=sqrt( mean.^2+var );
    if all(diff_norm<abstol || diff_norm<x_norm*reltol ) 
        break;
    end
    if iter>maxiter
        warning( 'pce_sqrt:convergence', 'pce_sqrt did not converge to the desired tolerance of %f in %d iterations', reltol, maxiter );
    end
end

if show_stats
    fprintf( 'pce_sqrt converged to the desired tolerance of %f in %d iterations\n', reltol, iter );
end
