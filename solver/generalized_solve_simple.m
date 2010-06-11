function [X,flag,info,solver_stats]=generalized_solve_simple( A, F, varargin )

global gsolver_stats

options=varargin2options( varargin );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_operator_func,options]=get_option( options, 'truncate_operator_func', @identity );
[truncate_before_func,options]=get_option( options, 'truncate_before_func', truncate_operator_func );
[truncate_after_func,options]=get_option( options, 'truncate_after_func', truncate_before_func );
[apply_operator_options,options]=get_option( options, 'apply_operator_options', {} );
[gsolver_stats,options]=get_option( options, 'stats', struct() );
[debug_level,options]=get_option( options, 'debug_level', 0 );
[stats_func,options]=get_option( options, 'stats_func', @gather_stats_def );
check_unsupported_options( options, mfilename );

if ~isequal(truncate_operator_func,@identity)
    apply_operator_options=[apply_operator_options, {'pass_on', {'truncate_func', truncate_operator_func}}];
end

info.abstol=abstol;
info.reltol=reltol;
info.maxiter=maxiter;

Xc=gvector_null(F);
Rc=F;
Rc=funcall( truncate_before_func, Rc );
initres=gvector_norm( Rc );
resvec=[initres];

gsolver_stats=funcall( stats_func, 'init', gsolver_stats, initres );
flag=1;
for iter=1:maxiter
    % add the preconditioned residuum to X
    Z=operator_apply(Minv,Rc);
    Xn=gvector_add( Xc, Z );
    Xn=funcall( truncate_after_func, Xn );
    if is_tensor(Xn)
        disp( strvarexpand('Ranks($iter$): Xn: $tensor_rank(Xn)$,  Rc:  $tensor_rank(Rc)$ ' ) );
    end
    
    % compute new residuum
    if true % false
        AXn=operator_apply(A,Xn, apply_operator_options{:} );
        Rn=gvector_add( F, AXn, -1 );
        Rn=funcall( truncate_before_func, Rn );
    else
        Rn=operator_apply(A,Xn, 'residual', true, 'b', F, apply_operator_options{:} );
        Rn=funcall( truncate_before_func, Rn );
    end
    
    normres=gvector_norm( Rn );
    relres=normres/initres;
    
    resvec(end+1)=normres; %#ok<AGROW>
    if debug_level>0
        fprintf('iter: %d  res:%g \n', iter, normres );
    end
    
    % Proposed update is DY=alpha*Pc
    % actual update is DX=T(Xn)-Xc;
    % update ratio is (DX,DY)/(DY,DY) should be near one
    % no progress if near 0
    
    %     DY=gvector_scale( Pc, alpha );
    %     DX=gvector_add( Xn, Xc, -1 );
    %     upratio=gvector_scalar_product( DX, DY )/gvector_scalar_product( DY, DY );
    %
    %     gsolver_stats=funcall( stats_func, 'step', gsolver_stats, F, A, Xn, Rn, normres, relres, upratio );
    
    if normres<abstol || relres<reltol;
        flag=0;
        break;
    end
    
    %     if abs(1-upratio)>.2 %&& urc>10
    %         flag=-1;
    %         break;
    %     end
    
    % set all iteration variables to new state
    Xc=Xn;
    Rc=Rn;
    
    
    if false && mod(iter,100)==0
        keyboard
    end
end
X=funcall( truncate_after_func, Xn );

%gsolver_stats=funcall( stats_func, 'finish', gsolver_stats, X );

info.flag=flag;
info.iter=iter;
info.relres=relres;
%info.upratio=upratio;
info.resvec=resvec(:);

solver_stats=gsolver_stats;

% if we were not successful but the user doesn't retrieve the flag as
% output argument we issue a warning on the terminal
if flag && nargout<2
    solver_message( 'generalized_simple_iter', flag, info )
end

function stats=gather_stats_def( what, stats, varargin )
what; %#ok, ignore
varargin; %#ok, ignore

