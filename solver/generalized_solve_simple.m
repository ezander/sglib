function [X,flag,info]=generalized_solve_simple( A, F, varargin )

options=varargin2options( varargin );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[trunc,options]=get_option( options, 'trunc', struct('eps',0,'k_max',inf) );
[trunc_mode,options]=get_option( options, 'trunc_mode', 'none' );

%[contract_limit,options]=get_option( options, 'contract_limit', 0.99 );
[dynamic_eps,options]=get_option( options, 'dynamic_eps', false );
[stag_steps,options]=get_option( options, 'stag_steps', 5 );
[upratio_delta,options]=get_option( options, 'upratio_delta', 0.1 );
[dyneps_factor,options]=get_option( options, 'dyneps_factor', 0.1 );

[apply_operator_options,options]=get_option( options, 'apply_operator_options', {} );
[verbosity,options]=get_option( options, 'verbosity', 0 );
[X_true,options]=get_option( options, 'solution', [] );
[memtrace,options]=get_option( options, 'memtrace', 1 );
check_unsupported_options( options, mfilename );

if memtrace
    memorig=memstats();
    memmax=memorig;
end

if dynamic_eps
    min_eps=trunc.eps;
    trunc.eps=0.1;
end
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
info.timevec=[];
info.resvec=[];
info.epsvec=[];
info.errvec=[];
info.updvec=[];
info.updnormvec=[];

Xc=gvector_null(F);
Rc=F;
Rc=funcall( truncate_before_func, Rc );
initres=gvector_norm( Rc );
normres=initres;
lastnormres=normres;
noconvsteps=0;
info.resvec(end+1)=initres;
start_tic=tic;
prev_tic=start_tic;

flag=1;
for iter=1:maxiter
    % add the preconditioned residuum to X
    if tensor_mode
        info.rank_res_before(end+1)=tensor_rank(Rc);
        info.epsvec(end+1)=trunc.eps;
    end
    DX=operator_apply(Minv,Rc);
    Xn=gvector_add( Xc, DX );
    Xn=funcall( truncate_after_func, Xn );
    
    % check update ratio
    % Proposed update is DY=alpha*Pc
    % actual update is DX=T(Xn)-Xc;
    % update ratio is (DX,DY)/(DY,DY) should be near one
    % no progress if near 0
    
    DY=gvector_add( Xn, Xc, -1 );
    %upratio=gvector_scalar_product( DY, DX )/gvector_scalar_product( DX, DX );
    updnorm=gvector_norm( DX );
    upratio=gvector_scalar_product( DY, DX, [], 'orth', false )/updnorm^2;
    info.updvec(end+1)=upratio;
    info.updnormvec(end+1)=updnorm;
    
    if verbosity>0
        strvarexpand('iter: $iter$  upratio: $upratio$ res contract: $normres/lastnormres$  (stagstep: $noconvsteps$)');
    end
    if abs(upratio-1)>upratio_delta
        noconvsteps=noconvsteps+1;
        if noconvsteps>=stag_steps
            flag=2;
            break;
        end
        if dynamic_eps
            trunc.eps=max( min_eps, trunc.eps*dyneps_factor );
            if verbosity>0
                strvarexpand('iter: $iter$  Reducing eps to $trunc.eps$');
            end
            [truncate_operator_func, truncate_before_func, truncate_after_func]=define_truncate_functions( trunc_mode, trunc );
            if ~isequal(trunc_mode,'none')
                apply_operator_options=[apply_operator_options, {'pass_on', {'truncate_func', truncate_operator_func}}];
            end
            % retry with new epsilon (don't throw away precious
            % information!)
            Xn=gvector_add( Xc, DX );
            Xn=funcall( truncate_after_func, Xn );
        end
    else
        noconvsteps=0;
    end
    
    % log rank if in tensor mode
    if tensor_mode
        info.rank_sol_after(end+1)=tensor_rank(Xn);
        if verbosity>0
            strvarexpand('iter: $iter$  ranks:  Xn: $tensor_rank(Xn)$,  Rc:  $tensor_rank(Rc)$ ' );
        end
    end
    
    % log rel error if given
    if ~isempty(X_true)
        curr_err=gvector_error( Xn, X_true, 'relerr', true );
        if verbosity>0 && ~isempty(X_true)
            strvarexpand('iter: $iter$  relerr: $curr_err$ ' );
        end
        info.errvec(end+1)=curr_err;
    end
    
    % compute new residuum
    if false
        AXn=operator_apply(A,Xn, apply_operator_options{:} );
        Rn=gvector_add( F, AXn, -1 );
    else
        Rn=operator_apply(A,Xn, 'residual', true, 'b', F, apply_operator_options{:} );
    end
    Rn=funcall( truncate_before_func, Rn );
    
    lastnormres=min(lastnormres,normres);
    normres=gvector_norm( Rn );
    relres=normres/initres;
    
    info.resvec(end+1)=normres; %#ok<AGROW>
    info.timevec(end+1)=toc(prev_tic);
    prev_tic=tic;
    
    if verbosity>0
        strvarexpand('iter: $iter$  residual: $normres$  relres: $relres$' );
        strvarexpand('iter: $iter$  time: $info.timevec(end)$' );
    end

    if memtrace
        memmax=memstats( 'mem', memmax, 'append', false );
    end
    
    % check residual for meeting tolerance
    if normres<abstol || relres<reltol;
        flag=0;
        break;
    end
    
    % set all iteration variables to new state
    Xc=Xn;
    Rc=Rn;
    
    
    if false && mod(iter,100)==0
        keyboard
    end
end
X=funcall( truncate_after_func, Xn );

info.flag=flag;
info.iter=iter;
info.relres=relres;
info.time=toc(start_tic);
if memtrace
    info.memorig=memorig;
    info.memmax=memmax;
end

% if we were not successful but the user doesn't retrieve the flag as
% output argument we issue a warning on the terminal
if flag && nargout<2
    solver_message( 'generalized_simple_iter', flag, info )
end

function [trunc_operator_func, trunc_before_func, trunc_after_func]=define_truncate_functions( trunc_mode, trunc )
tr={@tensor_truncate_fixed, {trunc}, {2}};
trunc_op=trunc; trunc_op.eps=trunc.eps/3;
to={@tensor_truncate_fixed, {trunc_op}, {2}};
id=@identity;
switch trunc_mode
    case 'none'
        funcs={id,id,id};
    case 'operator';
        funcs={to,tr,tr};
    case 'before';
        funcs={id,tr,tr};
    case 'after'
        funcs={id,id,tr};
    otherwise
        error( 'sglib:generalized_solve_simple:trunc_mode', 'unknown truncation mode %s', truncmode );
end
[trunc_operator_func,trunc_before_func,trunc_after_func]=funcs{:};
