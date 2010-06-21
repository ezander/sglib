function [X,flag,info,solver_stats]=generalized_solve_simple( A, F, varargin )

global gsolver_stats

options=varargin2options( varargin );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[trunc,options]=get_option( options, 'trunc', {'eps',0,'k_max',inf} );
[trunc_mode,options]=get_option( options, 'trunc_mode', 'none' );

[apply_operator_options,options]=get_option( options, 'apply_operator_options', {} );
[gsolver_stats,options]=get_option( options, 'stats', struct() );
[verbosity,options]=get_option( options, 'verbosity', 0 );
[stats_func,options]=get_option( options, 'stats_func', @gather_stats_def );
check_unsupported_options( options, mfilename );

[truncate_operator_func, truncate_before_func, truncate_after_func]=define_truncate_functions( trunc_mode, trunc );
if ~isequal(trunc_mode,'none')
    apply_operator_options=[apply_operator_options, {'pass_on', {'truncate_func', truncate_operator_func}}];
end

tensor_mode=is_tensor(F);
info.abstol=abstol;
info.reltol=reltol;
info.maxiter=maxiter;
info.rank_res_before=[];
info.rank_sol_after=[];

Xc=gvector_null(F);
Rc=F;
Rc=funcall( truncate_before_func, Rc );
initres=gvector_norm( Rc );
normres=initres;
lastnormres=normres;
resvec=[initres];

gsolver_stats=funcall( stats_func, 'init', gsolver_stats, initres );
flag=1;
for iter=1:maxiter
    % add the preconditioned residuum to X
    if tensor_mode
        info.rank_res_before=[info.rank_res_before tensor_rank(Rc)];
    end
    Z=operator_apply(Minv,Rc);
    Xn=gvector_add( Xc, Z );
    Xn=funcall( truncate_after_func, Xn );
    if tensor_mode
        info.rank_sol_after=[info.rank_sol_after tensor_rank(Xn)];
    end
    if tensor_mode && verbosity>0
        disp( strvarexpand('Ranks($iter$): Xn: $tensor_rank(Xn)$,  Rc:  $tensor_rank(Rc)$ ' ) );
    end
    
    % compute new residuum
    if false
        AXn=operator_apply(A,Xn, apply_operator_options{:} );
        Rn=gvector_add( F, AXn, -1 );
        Rn=funcall( truncate_before_func, Rn );
    else
        Rn=operator_apply(A,Xn, 'residual', true, 'b', F, apply_operator_options{:} );
        Rn=funcall( truncate_before_func, Rn );
    end
    
    lastnormres=min(lastnormres,normres);
    normres=gvector_norm( Rn );
    relres=normres/initres;
    
    resvec(end+1)=normres; %#ok<AGROW>
    if verbosity>0
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
    
    if iter==10
        rhoest=(normres/initres)^0.1;
        noconvsteps=0;
    end
    if iter>10 
        if 1-lastnormres/normres<0.02%*(1-rhoest)
            noconvsteps=noconvsteps+1;
        else
            noconvsteps=0;
        end
        if noconvsteps>=1000
            break;
        end
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


function [trunc_operator_func, trunc_before_func, trunc_after_func]=define_truncate_functions( trunc_mode, trunc )
tr={@tensor_truncate_fixed, {trunc}, {2}};
id=@identity;
switch trunc_mode
    case 'none'
        funcs={id,id,id};
    case 'operator';
        funcs={tr,tr,tr};
    case 'before';
        funcs={id,tr,tr};
    case 'after'
        funcs={id,id,tr};
    otherwise
        error( 'sglib:generalized_solve_simple:trunc_mode', 'unknown truncation mode %s', truncmode );
end
[trunc_operator_func,trunc_before_func,trunc_after_func]=funcs{:};
