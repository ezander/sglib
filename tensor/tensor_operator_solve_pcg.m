function [X,flag,info,stats]=tensor_operator_solve_pcg( A, F, varargin )

options=varargin2options( varargin{:} );
[M,options]=get_option( options, 'M', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_options,options]=get_option( options, 'truncate_options', {} );
[trunc_mode,options]=get_option( options, 'trunc_mode', 2 );
[vareps,options]=get_option( options, 'vareps', false );
[stats,options]=get_option( options, 'stats', 'this_a_bad_hack' );
[stats_gatherer,options]=get_option( options, 'stats_gatherer', @gather_stats_def );
check_unsupported_options( options, mfilename );

if ischar(stats) && strcmp(stats, 'this_a_bad_hack')
    stats=struct();
end


info.abstol=abstol;
info.reltol=reltol;
info.maxiter=maxiter;
info.truncate_options=truncate_options;
info.trunc_mode=trunc_mode;
info.vareps=vareps;

null_vector=@tensor_null;
add=@tensor_add;
prec_solve=@tensor_operator_solve_elementary;
apply_operator=@tensor_operator_apply;
scale=@tensor_scale;
if isnumeric(F)
    truncate=@tensor_truncate;
    inner_prod=@(a,b)(a'*b);
    vec_norm=@norm;
else
    truncate=@tensor_truncate;
    inner_prod=@tensor_scalar_product;
    vec_norm=@tensor_norm;
end

iter=0;
flag=0;

Xc=null_vector(F);
Rc=add( F, apply_operator( A, Xc ), -1);
Zc=prec_solve( M, Rc );
Pc=Zc;

initres=vec_norm( Rc );

stats=stats_gatherer( 'init', stats, initres );

while true
    alpha=inner_prod(Rc,Zc)/inner_prod(Pc,apply_operator(A,Pc));
    Xn=add(Xc,Pc,alpha);
    Rn=add(Rc,apply_operator(A,Pc),-alpha);

    Xn=truncate( Xn, truncate_options );
    Rn=truncate( Rn, truncate_options );

    normres=vec_norm( Rn );
    relres=normres/initres;

    % Proposed update is DY=alpha*Pc
    % actual update is DX=T(Xn)-Xc;
    % update ratio is (DX,DY)/(DY,DY) should be near one
    % no progress if near 0
    DY=scale( Pc, alpha );
    DX=add( Xn, Xc, -1 );
    upratio=inner_prod( DX, DY )/inner_prod( DY, DY );

    stats=stats_gatherer( 'step', stats, F, A, Xn, Rn, normres, relres, upratio );

    if normres<abstol || relres<reltol; break; end

    %urc=iter-50;
    if abs(1-upratio)>.2 %&& urc>10
        flag=-1;
        break;
    end

    Zn=prec_solve(M,Rn);
    beta=inner_prod(Rn,Zn)/inner_prod(Rc,Zc);
    Pn=add(Zn,Pc,beta);

    % truncate all iteration variables
    Xc=truncate( Xn, truncate_options );
    Pc=truncate( Pn, truncate_options );
    Rc=truncate( Rn, truncate_options );
    Zc=truncate( Zn, truncate_options );

    % increment and check iteration counter
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end

    if false && mod(iter,100)==0
        keyboard
    end
end
X=truncate( Xn, truncate_options );

stats=stats_gatherer( 'finish', stats, X );

info.flag=flag;
info.iter=iter;
info.relres=relres;
info.upratio=upratio;

% if we were not successful but the user doesn't retrieve the flag as
% output argument we issue a warning on the terminal
if flag && nargout<2
    %solver_message( 'tensor_pcg', tol, maxit, flag, iter, relres )
    solver_message( 'tensor_pcg', flag, info )
end

function stats=gather_stats_def( what, stats, varargin )
what; %#ok, ignore
varargin; %#ok, ignore

