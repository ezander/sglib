function [X,flag,info,stats]=generalized_solve_pcg( A, F, varargin )

options=varargin2options( varargin );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_func,options]=get_option( options, 'truncate_func', @identity );
[stats,options]=get_option( options, 'stats', struct() );
[stats_func,options]=get_option( options, 'stats_func', @gather_stats_def );
check_unsupported_options( options, mfilename );


info.abstol=abstol;
info.reltol=reltol;
info.maxiter=maxiter;
iter=0;
flag=0;

Xc=gvector_null(F);
Rc=gvector_add( F, operator_apply( A, Xc ), -1);
Zc=operator_apply( Minv, Rc );
Pc=Zc;

initres=gvector_norm( Rc );

stats=funcall( stats_func, 'init', stats, initres );

while true
    APc=operator_apply(A,Pc);
    APc=funcall( truncate_func, APc );
    alpha=gvector_scalar_product( Rc, Zc)/...
        gvector_scalar_product( Pc, APc );
    Xn=gvector_add( Xc, Pc, alpha);
    Rn=gvector_add( Rc, APc, -alpha );
%     alpha=gvector_scalar_product( Rc, Zc)/...
%         gvector_scalar_product( Pc, operator_apply(A,Pc) );
%     Xn=gvector_add( Xc, Pc, alpha);
%     Rn=gvector_add( Rc, operator_apply(A,Pc), -alpha );

    %Xn=funcall( truncate_func, Xn );
    %Rn=funcall( truncate_func, Rn );

    normres=gvector_norm( Rn );
    relres=normres/initres;

    % Proposed update is DY=alpha*Pc
    % actual update is DX=T(Xn)-Xc;
    % update ratio is (DX,DY)/(DY,DY) should be near one
    % no progress if near 0
    DY=gvector_scale( Pc, alpha );
    DX=gvector_add( Xn, Xc, -1 );
    upratio=gvector_scalar_product( DX, DY )/gvector_scalar_product( DY, DY );

    stats=funcall( stats_func, 'step', stats, F, A, Xn, Rn, normres, relres, upratio );

    if normres<abstol || relres<reltol; break; end

    %urc=iter-50;
    if abs(1-upratio)>.2 %&& urc>10
        flag=-1;
        break;
    end

    Zn=operator_apply(Minv,Rn);
    beta=gvector_scalar_product(Rn,Zn)/gvector_scalar_product(Rc,Zc);
    Pn=gvector_add(Zn,Pc,beta);

    % truncate all iteration variables
    if false
        Xc=funcall( truncate_func, Xn );
        Pc=funcall( truncate_func, Pn );
        Rc=funcall( truncate_func, Rn );
        Zc=funcall( truncate_func, Zn );
    else
        Xc=funcall( truncate_func, Xn );
        Pc=funcall( truncate_func, Pn );
        Rc=funcall( truncate_func, Rn );
        Zc=funcall( truncate_func, Zn );
    end

    % increment and check iteration counter
%     disp(iter);
%     if iscell(Xn)
%         disp(tensor_rank(Xn));
%     end
        
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end

    if false && mod(iter,100)==0
        keyboard
    end
end
X=funcall( truncate_func, Xn );

stats=funcall( stats_func, 'finish', stats, X );

info.flag=flag;
info.iter=iter;
info.relres=relres;
info.upratio=upratio;

% if we were not successful but the user doesn't retrieve the flag as
% output argument we issue a warning on the terminal
if flag && nargout<2
    solver_message( 'generalized_pcg', flag, info )
end

function stats=gather_stats_def( what, stats, varargin )
what; %#ok, ignore
varargin; %#ok, ignore

