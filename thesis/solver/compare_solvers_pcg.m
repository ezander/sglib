function compare_solvers_pcg( model, solve_options, varargin )

global U_mat_true Ui_mat_true
global U_mat Ui_mat info_pcg pcg_err eps
global U Ui info_tp tp_err

options=varargin2options( varargin );
[accurate,options]=get_option( options, 'accurate', true );
[pcgcmp,options]=get_option( options, 'pcgcmp', accurate );
[eps,options]=get_option( options, 'eps', 1e-4 );
check_unsupported_options( options, mfilename );



%rebuild_scripts( model );
disp_model_data( model )



% solve with pcg accurately for error estimates
if accurate
    underline( 'accurate pcg' );
    [U_mat_true, Ui_mat_true, info_acc, rho]=compute_by_pcg_accurate( model );
else
    U_mat_true=[]; 
    Ui_mat_true=[];
    rho=0.8;
end

% solve with pcg approximately for performance comparison
if pcgcmp
    if numel(U_mat_true)
        underline( 'approximate pcg' );
        pcg_tol=1e-3;
        [U_mat, Ui_mat, info_pcg]=compute_by_pcg_approx( model, Ui_mat_true, pcg_tol, false );
        pcg_err=gvector_error( U_mat, U_mat_true, 'relerr', true );
        eps=eps_from_error( pcg_err, rho );
    end
    info_pcg.rho=rho;
    info_pcg.norm_U=gvector_norm(Ui_mat);
    info_pcg.descr='pcg';
    
    info=info_pcg;
    display_tensor_solver_details;
    
    underline( 'Computing truncation eps' )
    fprintf( 'pcg_tol:       tol=%g \n', pcg_tol );
    fprintf( 'PCG_ERR:       e_p=%g \n', pcg_err );
    fprintf( 'Contractivity: rho=%g \n', rho );
    fprintf( 'Tensor_eps:    eps=%g \n', eps );
end

num=length(solve_options);

U={}; Ui={}; info_tp={}; tp_err={};
for i=1:num
    eps=get_option( solve_options{i}, 'eps', eps );
    prec=get_option( solve_options{i}, 'prec', {'none'} );
    dyn=get_option( solve_options{i}, 'dyn', false );
    trunc_mode=get_option( solve_options{i}, 'trunc_mode', 'operator' );
    descr=get_option( solve_options{i}, 'descr', '?' );
    longdescr=get_option( solve_options{i}, 'longdescr', '?' );
    underline( longdescr );
    
    timers( 'resetall' );
    profile( 'on' )
    [U{i}, Ui{i}, info_tp{i}]=compute_by_tensor_simple( model, Ui_mat_true, eps, prec, dyn, trunc_mode );
    info_tp{i}.timers=timers( 'getall' );
    profile( 'off' )
    info_tp{i}.prof=profile('info');

    info_tp{i}.descr=descr;
    info_tp{i}.rho=rho;
    info_tp{i}.norm_U=gvector_norm(Ui{i});

    if ~isempty(U_mat_true)
        tp_err{i}=gvector_error( U{i}, U_mat_true, 'relerr', true );
    else
        tp_err{i}=nan;
    end
end

fprintf( '\n============ TIME =====================================\n' );
strvarexpand( 'meth: pcg time: $info_pcg.time$ err: $pcg_err$' );
for i=1:numel(tp_err)
    strvarexpand( 'meth: $info_tp{i}.descr$ time: $info_tp{i}.time$ err: $tp_err{i}$' );
    if isfield( info_tp{i}, 'timers' )
        disp( info_tp{i}.timers );
    end
end

fprintf( '\n============ STATS =====================================\n' );
info=info_pcg;
display_tensor_solver_details;
for i=1:num
    info=info_tp{i};
    display_tensor_solver_details;
end


fprintf( '\n============ TIME =====================================\n' );
info=info_pcg;
strvarexpand( 'model: $model$' )
strvarexpand( 'description: $info.descr$' )
strvarexpand( 'time: $info.time$' )
for i=1:num
    info=info_tp{i};
    strvarexpand( 'description: $info.descr$' )
    strvarexpand( 'time: $info.time$' )
end

% display graphics
if false && ~strcmp( model, 'model_giant_easy' )
    plot_solution_overview(model, info_tp{1})
    plot_solution_comparison(model, info_tp)
end



