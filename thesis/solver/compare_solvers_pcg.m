function compare_solvers_pcg( model, all_options, varargin )

global U_mat_true Ui_mat_true
global U_mat Ui_mat pcg_err eps
global U Ui info_tp tp_err

options=varargin2options( varargin );
[accurate,options]=get_option( options, 'accurate', true );
[eps,options]=get_option( options, 'eps', 1e-4 );
check_unsupported_options( options, mfilename );

check_convergence( model, all_options, 'eps', eps );

if fasttest('get')
    model='model_small_easy';
    fprintf( 'FASTTEST enabled; using small model\n' );
end

%rebuild_scripts( model );
disp_model_data( model )

% solve with pcg accurately for error estimates
if accurate
    underline( 'accurate pcg' );
    solve_opts={};
    mod_opts={};
    [U_mat_true, Ui_mat_true, info_acc, rho]=compute_by_pcg_accurate( model, solve_opts, mod_opts );
else
    U_mat_true=[]; 
    Ui_mat_true=[];
    rho=0.8;
end

% solve with pcg approximately for performance comparison

num=length(all_options);

U={}; Ui={}; info_tp={}; tp_err={};
for i=1:num
    type=get_option( all_options{i}, 'type', 'gsi' );
    descr=get_option( all_options{i}, 'descr', '?' );
    longdescr=get_option( all_options{i}, 'longdescr', '?' );
    solve_opts=get_option( all_options{i}, 'solve_opts', {} );
    mod_opts=get_option( all_options{i}, 'mod_opts', {} );
    
    underline( longdescr );
    strvarexpand( 'options: $all_options{i}$' )
    
    switch  type
        case 'pcg'
            pcg_tol=get_option( all_options{i}, 'tol', 1e-3 );
            prec=get_option( all_options{i}, 'prec', 'mean' );
            [U_mat, Ui_mat, info_tp{i}]=compute_by_pcg_approx( model, prec, Ui_mat_true, pcg_tol, solve_opts, mod_opts );
            if numel(U_mat_true)
                pcg_err=gvector_error( U_mat, U_mat_true, 'relerr', true );
                eps=eps_from_error( pcg_err, rho );
            else
                eps=1e-4;
            end
            currUi=Ui_mat;
            
            underline( 'Computing truncation eps' )
            fprintf( 'pcg_tol:       tol=%g \n', pcg_tol );
            fprintf( 'PCG_ERR:       e_p=%g \n', pcg_err );
            fprintf( 'Contractivity: rho=%g \n', rho );
            fprintf( 'Tensor_eps:    eps=%g \n', eps );
        case {'gsi', 'gpcg' }
            eps=get_option( all_options{i}, 'eps', eps );
            prec_strat=get_option( all_options{i}, 'prec_strat', {'basic'} );
            dyn=get_option( all_options{i}, 'dyn', false );
            trunc_mode=get_option( all_options{i}, 'trunc_mode', 'operator' );
            tol=get_option( all_options{i}, 'tol', 1e-3 );
            prec=get_option( all_options{i}, 'prec', 'mean' );
            
            [U{i}, Ui{i}, info_tp{i}]=compute_by_tensor_method( model, prec, type, Ui_mat_true, tol, eps, prec_strat, dyn, trunc_mode, solve_opts, mod_opts );
            currUi=Ui{i};
        otherwise
            error( 'unknown' );
    end
    
    info_tp{i}.rho=rho;
    info_tp{i}.descr=descr;
    info_tp{i}.norm_U=gvector_norm(currUi);
    if ~isempty(Ui_mat_true)
        tp_err{i}=gvector_error( currUi, Ui_mat_true, 'relerr', true );
    else
        tp_err{i}=nan;
    end
    info_tp{i}.relerr2=tp_err{i};
end



fprintf( '\n============ STATS =====================================\n' );
for i=1:num
    info=info_tp{i};
    display_tensor_solver_details;
end


fprintf( '\n============ DETAILED TIMINGS ==========================\n' );
for i=1:num
    strvarexpand( 'meth: $info_tp{i}.descr$ time: $info_tp{i}.time$ err: $tp_err{i}$' );
    if isfield( info_tp{i}, 'timers' )
        display_timing_details( info_tp{i}.timers )
    end
    fprintf('\n');
end

fprintf( '\n============ TIME, RES, OPTS============================\n' );
for i=1:num
    info=info_tp{i};
    strvarexpand( 'description: $info.descr$' )
    strvarexpand( 'time: $info.time$' )
    strvarexpand( 'opts: $info.all_options$' )
    strvarexpand( 'resv: $info.resvec$' )
end


fprintf( '\n============ TIME =====================================\n' );
strvarexpand( 'model: $model$' )
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
