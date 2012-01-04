function [X,flag,info]=generalised_solve_pcg( A, F, varargin )

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

timers( 'start', 'gen_solver_pcg' );

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

Zc=operator_apply( Minv, Rc );
%Zc=funcall( truncate_after_func, F );
Pc=Zc;

releps=reltol; % not correct
start_tic=tic;
prev_tic=start_tic;

flag=1;
for iter=1:maxiter
    %if is_tensor( Xc); fprintf( 'Rank X: %d\n', tensor_rank(Xc) ); end
    APc=operator_apply(A,Pc, 'pass_on', {'truncate_func', truncate_operator_func} );
    %if is_tensor( Xc); fprintf( 'Rank A: %d\n', tensor_rank(APc) ); end
    APc=funcall( truncate_before_func, APc );
    %if is_tensor( Xc); fprintf( 'Rank A: %d\n', tensor_rank(APc) ); end
    alpha=gvector_scalar_product( Rc, Zc)/...
        gvector_scalar_product( Pc, APc );
    Xn=gvector_add( Xc, Pc, alpha);
    Rn=gvector_add( Rc, APc, -alpha );

    Xn=funcall( truncate_before_func, Xn );
    Rn=funcall( truncate_before_func, Rn );

    normres=gvector_norm( Rn );
    relres=normres/initres;
    
    %if true && (normres<abstol || relres<reltol || normres<ltres*sqrt(releps) )
    if true && normres<lastnormres*sqrt(releps)
        AXn=operator_apply(A,Xn, 'pass_on', {'truncate_func', truncate_operator_func} );
        Rn=gvector_add( F, AXn, -1 );
        Rn=funcall( truncate_before_func, Rn );
        new_normres=gvector_norm( Rn );
        new_relres=new_normres/initres;
        if true %~((new_normres<abstol || new_relres<reltol))
            if verbosity>0
                disp( 'Normres and relres were grossly wrong. Continuing with iteration!')
                % fprintf( 'normres: %g=>%g, relres: %g=>%g\n', normres, new_normres, relres, new_relres );
                % keyboard;
            end
            normres=new_normres;
            relres=new_relres;
            lastnormres=new_normres;
        end
    end
    
    info.resvec(end+1)=normres; %#ok<AGROW>
    info.timevec(end+1)=toc(prev_tic);
    prev_tic=tic;

    if verbosity>0
        strvarexpand('iter: $iter$  residual: $normres$  relres: $relres$' );
        strvarexpand('iter: $iter$  time: $info.timevec(end)$' );
    end

    % Proposed update is DY=alpha*Pc
    % actual update is DX=T(Xn)-Xc;
    % update ratio is (DX,DY)/(DY,DY) should be near one
    % no progress if near 0
    DY=gvector_scale( Pc, alpha );
    DX=gvector_add( Xn, Xc, -1 );
    upratio=gvector_scalar_product( DX, DY )/gvector_scalar_product( DY, DY );

    if memtrace
        memmax=memstats( 'mem', memmax, 'append', false );
    end
    
    if normres<abstol || relres<reltol;
        flag=0;
        break; 
    end

    %fprintf( 'Iter: %2d relres: %g upratio: %g\n', iter, relres, upratio );
    
    %urc=iter-50;
    if abs(1-upratio)>.2 %&& urc>10
        flag=-1;
        break;
    end

    Zn=operator_apply(Minv,Rn);
    beta=gvector_scalar_product(Rn,Zn)/gvector_scalar_product(Rc,Zc);
    Pc=funcall( truncate_before_func, Pc );
    Pn=gvector_add(Zn,Pc,beta);

    % set all iteration variables to new state
    Xc=funcall( truncate_after_func, Xn );
    Rc=funcall( truncate_after_func, Rn );
    Pc=funcall( truncate_after_func, Pn );
    Zc=funcall( truncate_after_func, Zn );

end
X=funcall( truncate_after_func, Xn );

info.flag=flag;
info.iter=iter;
info.relres=relres;
info.upratio=upratio;
info.time=toc(start_tic);
if memtrace
    info.memorig=memorig;
    info.memmax=memmax;
end

% if we were not successful but the user doesn't retrieve the flag as
% output argument we issue a warning on the terminal
if flag && nargout<2
    solver_message( 'generalized_pcg', flag, info )
end

timers( 'start', 'gen_solver_pcg' );
