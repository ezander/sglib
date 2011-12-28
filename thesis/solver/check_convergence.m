function check_convergence( model, all_options, varargin )

options=varargin2options( varargin );
[eps,options]=get_option( options, 'eps', 1e-4 );
check_unsupported_options( options, mfilename );

if fasttest('get')
    model='model_medium_easy';
    fprintf( 'FASTTEST enabled; using medium model\n' );
end

Ui_mat_true = [];


num_fail=0;
num=length(all_options);
U={}; Ui={}; info_tp={}; tp_err={};
for i=1:num
    check=get_option( all_options{i}, 'check', false );
    if ~check; continue; end

    type=get_option( all_options{i}, 'type', 'gsi' );
    descr=get_option( all_options{i}, 'descr', '?' );
    longdescr=get_option( all_options{i}, 'longdescr', '?' );
    solve_opts=get_option( all_options{i}, 'solve_opts', {} );
    mod_opts=get_option( all_options{i}, 'mod_opts', {} );
    
    fprintf('CHECKING:\n')
    underline( longdescr );
    strvarexpand( 'options: $all_options{i}$' )
    
    switch  type
        case {'gsi', 'gpcg' }
            eps=get_option( all_options{i}, 'eps', eps );
            prec_strat=get_option( all_options{i}, 'prec_strat', {'basic'} );
            dyn=get_option( all_options{i}, 'dyn', false );
            trunc_mode=get_option( all_options{i}, 'trunc_mode', 'operator' );
            tol=get_option( all_options{i}, 'tol', 1e-4 );
            prec=get_option( all_options{i}, 'prec', 'mean' );
            
            [U{i}, Ui{i}, info_tp{i}]=compute_by_tensor_method( model, prec, type, Ui_mat_true, tol, eps, prec_strat, dyn, trunc_mode, solve_opts, mod_opts );
        otherwise
            error( 'unknown' );
    end
    
    if info_tp{i}.flag>0
        num_fail=num_fail+1;
        fprintf('CONVERGENCE CHECK FAILED!!!!!\n\n');
        break
    end
end

if num_fail
    error('convergence check failed');
end
