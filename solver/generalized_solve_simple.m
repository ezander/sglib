function [X,flag,info]=generalized_solve_simple( A, F, varargin )

options=varargin2options( varargin );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[trunc,options]=get_option( options, 'trunc', struct('eps',0,'k_max',inf) );
[trunc_mode,options]=get_option( options, 'trunc_mode', 'none' );

[dynamic_eps,options]=get_option( options, 'dynamic_eps', false );
[upratio_delta,options]=get_option( options, 'upratio_delta', 0.1 );
[dyneps_factor,options]=get_option( options, 'dyneps_factor', 0.5 );
[div_b,options]=get_option( options, 'div_b', 1 );
[div_op,options]=get_option( options, 'div_op', 3 );
[fast_qr,options]=get_option( options, 'fast_qr', false );

[apply_operator_options,options]=get_option( options, 'apply_operator_options', {} );
[verbosity,options]=get_option( options, 'verbosity', 0 );
[X_true,options]=get_option( options, 'solution', [] );
[memtrace,options]=get_option( options, 'memtrace', 1 );
check_unsupported_options( options, mfilename );

timers( 'start', 'gen_solver_simple' );

if memtrace
    memorig=memstats();
    memmax=memorig;
end

if dynamic_eps
    min_eps=trunc.eps;
    trunc.eps=0.1;
end
[truncate_operator_func, truncate_before_func, truncate_after_func]=define_truncate_functions( trunc_mode, trunc, div_b, div_op );
if ~isequal(trunc_mode,'none')
    apply_operator_options=[apply_operator_options, ...
        {'pass_on', {'truncate_func', truncate_operator_func, 'fast_qr', fast_qr}}];
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
Rc=funcall( truncate_before_func, F );
initres=gvector_norm( Rc );
normres=initres;
lastnormres=normres;
info.resvec(1)=initres;
start_cputime=cputime();
start_tic=tic;
prev_tic=start_tic;
base_apply_operator_options=apply_operator_options;

flag=1;
for iter=1:maxiter
    % add the preconditioned residuum to X
    if tensor_mode
        info.rank_res_before(iter)=tensor_rank(Rc);
        info.epsvec(iter)=trunc.eps;
    end
    timers( 'start', 'gsolve_prec_apply' );
    DX=operator_apply(Minv,Rc);
    timers( 'stop', 'gsolve_prec_apply' );
    
    abort=false;
    while true
        % add update and truncate
        Xn=gvector_add( Xc, DX );
        Xn=funcall( truncate_after_func, Xn );
        
        % compute update ratio
        DY=gvector_add( Xn, Xc, -1 );
        updnorm=gvector_norm( DX );
        upratio=gvector_scalar_product( DY, DX, [], 'orth', false )/updnorm^2;
        info.updvec(iter)=upratio;
        info.updnormvec(iter)=updnorm;
        
        % show new stats
        if verbosity>0
            strvarexpand('iter: $iter$  upratio: $upratio$ res contract: $normres/lastnormres$');
        end
        
        
        % check update ratio
        if abs(upratio-1)<=upratio_delta
            break
        end;
        
        % reduce epsilon if possible
        if dynamic_eps && trunc.eps>min_eps
            trunc.eps=max( min_eps, trunc.eps*dyneps_factor );
            if verbosity>0
                strvarexpand('iter: $iter$  Reducing eps to $trunc.eps$');
            end
            [truncate_operator_func, truncate_before_func, truncate_after_func]=define_truncate_functions( trunc_mode, trunc, div_b, div_op );
            if ~isequal(trunc_mode,'none')
                apply_operator_options=[apply_operator_options, ...
                    {'pass_on', {'truncate_func', truncate_operator_func, 'fast_qr', fast_qr}}];
            end
        else
            flag=3;
            abort=true;
            break;
        end
    end
    if abort
        break;
    end
    
    % log rank if in tensor mode
    if tensor_mode
        info.rank_sol_after(iter)=tensor_rank(Xn);
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
        info.errvec(iter)=curr_err;
    end
    
    % compute new residuum
    if false
        AXn=operator_apply(A,Xn, apply_operator_options{:} );
        Rn=gvector_add( F, AXn, -1 );
    else
        timers( 'start', 'gsolve_oper_apply' );
        Rn=operator_apply(A,Xn, 'residual', true, 'b', F, apply_operator_options{:} );
        timers( 'stop', 'gsolve_oper_apply' );
    end
    Rn=funcall( truncate_before_func, Rn );
    
    % compute norm of residuum
    lastnormres=min(lastnormres,normres);
    normres=gvector_norm( Rn );
    relres=normres/initres;
    info.resvec(iter+1)=normres;
    
    % store time used for this step 
    info.timevec(iter)=toc(prev_tic);
    prev_tic=tic;
    
    if verbosity>0
        strvarexpand('iter: $iter$  residual: $normres$  relres: $relres$' );
        strvarexpand('iter: $iter$  time: $info.timevec(end)$' );
    end

    % check memory
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
   
end
X=funcall( truncate_after_func, Xn );

info.flag=flag;
info.iter=iter;
info.relres=relres;
info.cputime=cputime()-start_cputime;
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

timers( 'stop', 'gen_solver_simple' );
