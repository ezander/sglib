function compare_solvers_pcg( model, solve_options, varargin )

global U_mat_true Ui_mat_true
global U_mat Ui_mat pcg_err eps
global U Ui info_tp tp_err

options=varargin2options( varargin );
[accurate,options]=get_option( options, 'accurate', true );
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

num=length(solve_options);

U={}; Ui={}; info_tp={}; tp_err={};
for i=1:num
    type=get_option( solve_options{i}, 'type', 'gss' );
    descr=get_option( solve_options{i}, 'descr', '?' );
    longdescr=get_option( solve_options{i}, 'longdescr', '?' );
    underline( longdescr );
    
    switch  type
        case 'pcg'
            pcg_tol=get_option( solve_options{i}, 'tol', 1e-3 );
            [U_mat, Ui_mat, info_tp{i}]=compute_by_pcg_approx( model, Ui_mat_true, pcg_tol );
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
        case {'gss', 'gpcg' }
            eps=get_option( solve_options{i}, 'eps', eps );
            prec=get_option( solve_options{i}, 'prec', {'none'} );
            dyn=get_option( solve_options{i}, 'dyn', false );
            solve=get_option( solve_options{i}, 'solve', {} );
            trunc_mode=get_option( solve_options{i}, 'trunc_mode', 'operator' );
            
            [U{i}, Ui{i}, info_tp{i}]=compute_by_tensor_method( model, type, Ui_mat_true, eps, prec, dyn, trunc_mode, solve );
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

fprintf( '\n============ TIME =====================================\n' );
for i=1:num
    strvarexpand( 'meth: $info_tp{i}.descr$ time: $info_tp{i}.time$ err: $tp_err{i}$' );
    if isfield( info_tp{i}, 'timers' )
        display_timing_details( info_tp{i}.timers )
    end
    fprintf('\n');
end

fprintf( '\n============ STATS =====================================\n' );
for i=1:num
    info=info_tp{i};
    display_tensor_solver_details;
end


fprintf( '\n============ TIME =====================================\n' );
strvarexpand( 'model: $model$' )

for i=1:num
    info=info_tp{i};
    strvarexpand( 'description: $info.descr$' )
    strvarexpand( 'time: $info.solve_options$' )
    strvarexpand( 'time: $info.time$' )
end

% display graphics
if false && ~strcmp( model, 'model_giant_easy' )
    plot_solution_overview(model, info_tp{1})
    plot_solution_comparison(model, info_tp)
end
