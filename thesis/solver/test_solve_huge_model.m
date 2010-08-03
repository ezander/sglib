function test_solve_huge_model

%#ok<*NASGU>
%#ok<*NOPRT>
%#ok<*DEFNU>
%#ok<*ASGLU>
%#ok<*AGROW>
%#ok<*STOUT>
%#ok<*INUSL>
%#ok<*NODEF>

clc
% do_compare( 'model_giant_easy', 1, 2 );
% disp( ' ' );
%do_compare( 'model_huge_easy', 1, 4 );
%disp( ' ' );
% do_compare( 'model_huge_easy', 10, 4 );
% disp( ' ' );
% do_compare( 'model_large_easy', 1, 4 )
do_compare( 'model_large_easy', get_solve_options )

function do_compare( model, solve_options )
 
global U_mat_true Ui_mat_true
global U_mat Ui_mat info_pcg pcg_err eps
global U Ui info_tp tp_err

% rebuild_scripts
show_model_data( model )

underline( 'accurate pcg' );
[U_mat_true, Ui_mat_true, info_acc, rho]=compute_by_pcg_accurate( model );

if numel(U_mat_true)
    underline( 'approximate pcg' );
    [U_mat, Ui_mat, info_pcg]=compute_by_pcg_approx( model, Ui_mat_true, 1e-3, false );
    pcg_err=gvector_error( U_mat, U_mat_true, 'relerr', true );
    eps=eps_from_error( pcg_err, rho );
else
    pcg_err=nan;
    info_pcg.time=nan;
    eps=1e-4;
end
info_pcg.rho=rho;
info_pcg.norm_U=gvector_norm(Ui_mat);

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
    
    [U{i}, Ui{i}, info_tp{i}]=compute_by_tensor_simple( model, Ui_mat_true, eps, prec, dyn, trunc_mode );
    info_tp{i}.descr=descr;
    info_tp{i}.rho=rho;
    info_tp{i}.norm_U=gvector_norm(Ui{i});

    if ~isempty(U_mat_true)
        tp_err{i}=gvector_error( U{i}, U_mat_true, 'relerr', true );
    else
        tp_err{i}=nan;
    end
end

strvarexpand( 'meth: pcg time: $info_pcg.time$ err: $pcg_err$' );
for i=1:numel(tp_err)
    strvarexpand( 'meth: $info_tp{i}.descr$ time: $info_tp{i}.time$ err: $tp_err{i}$' );
end

for i=1:num
    info=info_tp{i};
    display_tensor_solver_details;
end
if ~strcmp( model, 'model_giant_easy' ) 
    show_solution_overview(model, info_tp{1})
    show_solution_comparison(model, info_tp)
end


function rebuild_scripts( model )
autoloader( loader_scripts( model ), true, 'caller' );




function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'normal tensor solver', 'descr', 'normal');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'descr', 'dyna');
opts{end+1}=struct( 'longdescr', 'prec tensor solver', 'prec', {{'same'}}, 'descr', 'prec');
opts{end+1}=struct( 'longdescr', 'dynamic prec tensor solver', 'prec', {{'same'}}, 'dyn', true, 'descr', 'dyna prec');

opts{end+1}=struct( 'longdescr', 'tensor solver: after trunc', 'trunc_mode', 'after', 'descr', 'after');
opts{end+1}=struct( 'longdescr', 'tensor solver: before trunc', 'trunc_mode', 'before', 'descr', 'before');
opts{end+1}=struct( 'longdescr', 'tensor solver: in operator trunc', 'trunc_mode', 'operator', 'descr', 'operator');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'trunc_mode', 'operator', 'descr', 'dynamic');

