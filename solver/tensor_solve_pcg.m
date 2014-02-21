function [X,flag,info]=tensor_solve_pcg( A, F, varargin )

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

[beta_formula,options]=get_option( options, 'beta_formula', 'PR' );

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

tensor_mode=is_ctensor(F);
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

Xc=tensor_null(F);
Rc=funcall( truncate_before_func, F );
initres=tensor_norm( Rc );
normres=initres;
relres=normres/initres;
lastnormres=normres;
info.resvec(1)=initres;
start_cputime=cputime();
start_tic=tic;
prev_tic=start_tic;

switch lower(beta_formula)
    case {'fr', 'fletcher-reeves', 0}; beta_formula=0;
    case {'pr', 'polak-ribiere', 1}; beta_formula=1;
    case {'hs', 'hestenes-stiefel', 2}; beta_formula=2;
    otherwise; error( 'sglib:tensor_solve_pcg', 'unknown beta_formula' );
end
if beta_formula
    DR=Rc;
end

flag=1;
restart=true;
for iter=1:maxiter
    % add the preconditioned residuum to X
    if tensor_mode
        info.rank_res_before(iter)=ctensor_rank(Rc);
        info.epsvec(iter)=trunc.eps;
    end
    timers( 'start', 'gsolve_prec_apply' );
    Z=operator_apply(Minv,Rc);
    Z=funcall( truncate_after_func, Z );
    timers( 'stop', 'gsolve_prec_apply' );
    rho_n=tensor_scalar_product( Rc, Z );
    if beta_formula
        rhod_n=tensor_scalar_product( DR, Z );
    end
    if restart
        P=Z;
        restart=false;
    else
        switch beta_formula
            case 0; beta=rho_n/rho_c;
            case 1; beta=rhod_n/rho_c;
            case 2; beta=rhod_n/rhod_c;
        end
        beta=max(beta,0);
        % P=Z+beta*P;
        P=tensor_scale( P, beta );
        P=tensor_add( Z, P );
        P=funcall( truncate_after_func, P );
    end
    
    %     q=A*p;
    Qc=operator_apply(A,P, 'residual', false, apply_operator_options{:} );
    Qn=Qc;
    
    abort=false;
    while true
    %     alpha=rho/(p'*q);
    %     x=x+alpha*p;
        Qn=funcall( truncate_after_func, Qc );
        alpha=rho_n/tensor_scalar_product( P, Qc );
        DX=tensor_scale( P, alpha );
        
        % add update and truncate
        Xn=tensor_add( Xc, DX );
        Xn=funcall( truncate_after_func, Xn );
        
        % compute update ratio
        DY=tensor_add( Xn, Xc, -1 );
        updnorm=tensor_norm( DX );
        upratio=tensor_scalar_product( DY, DX, [], 'orth', false )/updnorm^2;
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
                    {'pass_on', {'truncate_func', truncate_operator_func, 'fast_qr', fast_qr}}]; %#ok<AGROW>
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
        info.rank_sol_after(iter)=ctensor_rank(Xn);
        if verbosity>0
            strvarexpand('iter: $iter$  ranks:  Xn: $ctensor_rank(Xn)$,  Rc:  $ctensor_rank(Rc)$ ' );
        end
    end
    
    % log rel error if given
    if ~isempty(X_true)
        curr_err=tensor_error( Xn, X_true, 'relerr', true );
        if verbosity>0 && ~isempty(X_true)
            strvarexpand('iter: $iter$  relerr: $curr_err$ ' );
        end
        info.errvec(iter)=curr_err;
    end
    
    % compute new residuum
    if tensor_mode
        timers( 'start', 'gsolve_oper_apply' );
        Rn=operator_apply(A,Xn, 'residual', true, 'b', F, apply_operator_options{:} );
        timers( 'stop', 'gsolve_oper_apply' );
        Rn=funcall( truncate_before_func, Rn );
    else
        %     r=r-alpha*q;
        Rn=tensor_add( Rc, tensor_scale( -alpha, Qn ) );
    end

    
    % compute norm of residuum
    lastnormres=min(lastnormres,normres);
    normres=tensor_norm( Rn );
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
    
    % keep difference in residual for Polak-Ribiere and Hestenes-Stiefel
    if beta_formula
        DR=tensor_add( Rn, Rc, -1 );
        rhod_c=rhod_n;
    end
        
    % set all iteration variables to new state
    Xc=Xn;
    Rc=Rn;
    rho_c=rho_n;
end
X=funcall( truncate_after_func, Xn );

info.method=mfilename;
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
    tensor_solver_message( info )
end

timers( 'stop', 'gen_solver_simple' );
