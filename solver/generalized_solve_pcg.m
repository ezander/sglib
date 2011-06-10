function [X,flag,info]=generalized_solve_pcg( A, F, varargin )

options=varargin2options( varargin );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[trunc,options]=get_option( options, 'trunc', struct('eps',0,'k_max',inf) );
[trunc_mode,options]=get_option( options, 'trunc_mode', 'none' );

[dynamic_eps,options]=get_option( options, 'dynamic_eps', false );
[upratio_delta,options]=get_option( options, 'upratio_delta', 0.1 );
[dyneps_factor,options]=get_option( options, 'dyneps_factor', 0.1 );

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
Rc=funcall( truncate_before_func, F );
initres=gvector_norm( Rc );
normres=initres;
lastnormres=normres;
info.resvec(1)=initres;
start_tic=tic;
prev_tic=start_tic;
base_apply_operator_options=apply_operator_options;

flag=1;
restart=true;
for iter=1:maxiter
    % add the preconditioned residuum to X
    if tensor_mode
        info.rank_res_before(iter)=tensor_rank(Rc);
        info.epsvec(iter)=trunc.eps;
    end
    timers( 'start', 'gsolve_prec_apply' );
    Z=operator_apply(Minv,Rc);
    Z=funcall( truncate_after_func, Z );
    timers( 'stop', 'gsolve_prec_apply' );
    rho_n=gvector_scalar_product( Rc, Z );
    if restart
        P=Z;
        restart=false;
    else
        beta=rho_n/rho_c;
        % P=Z+beta*P;
        P=gvector_scale( P, beta );
        P=gvector_add( Z, P );
        P=funcall( truncate_after_func, P );
    end
    
%     q=A*p;
%     alpha=rho/(p'*q);
%     x=x+alpha*p;
%     r=r-alpha*q;
    Q=operator_apply(A,P, 'residual', false, apply_operator_options{:} );
    Q=funcall( truncate_after_func, Q );
    alpha=rho_n/gvector_scalar_product( P, Q );
    DX=gvector_scale( P, alpha );
    
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
            [truncate_operator_func, truncate_before_func, truncate_after_func]=define_truncate_functions( trunc_mode, trunc );
            if ~isequal(trunc_mode,'none')
                apply_operator_options=[base_apply_operator_options, {'pass_on', {'truncate_func', truncate_operator_func}}];
            end
            restart=true;
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
    timers( 'start', 'gsolve_oper_apply' );
    Rn=operator_apply(A,Xn, 'residual', true, 'b', F, apply_operator_options{:} );
    timers( 'stop', 'gsolve_oper_apply' );
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
    rho_c=rho_n;
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

timers( 'stop', 'gen_solver_simple' );
