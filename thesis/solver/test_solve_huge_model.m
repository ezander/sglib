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
do_compare( 'model_giant_easy', 1, 2 );
disp( ' ' );
%do_compare( 'model_huge_easy', 10, 4 );
%disp( ' ' );


% do_compare( 'model_huge_easy', 1, 2 );
% disp( ' ' );


% do_compare( 'model_large_easy', 1, 4 )
%do_compare( 'model_large_easy', 10, 4 )

function do_compare( model, mult, num )
 
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

U={}; Ui={}; info_tp={}; tp_err={};
for i=1:num
    switch mult*i
        case 1
            underline( 'normal tensor solver' );
            prec=false; dyn=false; trunc_mode='operator';
            descr='normal';
        case 2
            underline( 'dynamic tensor solver' );
            prec=false; dyn=true; trunc_mode='operator';
            descr='dyna';
        case 3
            underline( 'prec tensor solver' );
            prec=true; dyn=false; trunc_mode='operator';
            descr='prec';
        case 4
            underline( 'dynamic prec tensor solver' );
            prec=true; dyn=true; trunc_mode='operator';
            descr='dyna prec';
        case 10
            underline( 'tensor solver: after trunc' );
            prec=false; dyn=false; trunc_mode='after';
            descr='after';
        case 20
            underline( 'tensor solver: before trunc' );
            prec=false; dyn=false; trunc_mode='before';
            descr='before';
        case 30
            underline( 'tensor solver: in operator trunc' );
            prec=false; dyn=false; trunc_mode='operator';
            descr='operator';
        case 40
            underline( 'dynamic tensor solver' );
            prec=false; dyn=true; trunc_mode='operator';
            descr='dynamic';
    end
    
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
    plot_solution_overview(model, info_tp{1})
    % if strcmp(info_tp{2}.descr,'before')
    %     info_tp(2)=[];
    % end
    plot_solution_comparison(model, info_tp)
end

function show_mesh_and_sample( model, pos, els, f_i_k, f_k_alpha, I_f )
%%
strvarexpand( 'randn seed: $randn(''seed'')$' );
%1919081000
randn('seed',1296810479); %#ok<RAND>
randn('seed',1919081000); %#ok<RAND>
randn('seed',1484588618); %#ok<RAND>

multiplot_init
plot_mesh( pos, els, 'zpos', 1-1, 'bndcolor', 'r' );
axis equal
%plot_field( pos, els, kl_pce_field_realization(k_i_k, k_k_alpha,I_k), 'show_mesh', false );
plot_field( pos, els, kl_pce_field_realization(f_i_k, f_k_alpha,I_f), 'show_mesh', false );
view(3);
save_figure( gca, {'mesh_and_sample_rhs_%s', model}, 'png' );
%plot_kl_pce_mean_var( pos, els, f_i_k, f_k_alpha, I_f, 'show_mesh', false );

function plot_solution_comparison(model, infos)
saveit=strcmp(infos{end}.descr,'dynamic');

close
num=length(infos);
marker={'-x','-*','-o','-+'};
multiplot_init(2,3)
multiplot; field='errvec'; title( 'rel. error' );  logax='y'; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
if saveit; save_figure( gca, {'compare_rel_err_by_trunc_mode_%s', model} ); end
multiplot; field='resvec'; title( 'rel. residual' );  logax='y'; for i=1:num; plot( infos{i}.(field)/infos{i}.(field)(1), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='updvec'; title( 'update ratio' );  logax=''; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='epsvec'; title( 'epsilon' );  logax='y'; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='rank_res_before'; title( 'rank residual' );  logax=''; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
if saveit; save_figure( gca, {'compare_res_rank_by_trunc_mode_%s', model} ); end
multiplot; field='rank_sol_after'; title( 'rank solution' );  logax=''; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );

function plot_solution_overview(model, info)
close
multiplot_init(2,2)
multiplot
rho=info.rho;
errest=rho/(1-rho)*info.updnormvec/info.norm_U+info.epsvec;

% Achtung: fieser hack here
while length(info.errvec)<length(info.resvec)
    info.errvec(end+1)=info.errvec(end);
end

plot( info.errvec, 'x-' ); legend_add( 'rel. error' );
plot( errest, '*-' ); legend_add( 'error est.' );
plot( info.resvec/info.resvec(1), 'o-' ); legend_add( 'rel. residual' );
plot( info.updvec, 'd-' ); legend_add( 'update ratio' );
logaxis( gca, 'y' )
save_figure( gca, {'update_ratio_error_and_residual_%s', model} );

multiplot;
plot( info.rank_res_before, 'x-' ); legend_add( 'rank residuum' );
plot( info.rank_sol_after, 'x-' ); legend_add( 'rank solution' );
save_figure( gca, {'ranks_res_and_sol_%s', model} );


function rebuild_scripts( model )
autoloader( loader_scripts( model ), true, 'caller' );


function show_model_data( model )
autoloader( loader_scripts( model ), false, 'caller' );
pos(2,:)=-pos(2,:); % invert y axis for display
display_model_details
show_mesh_and_sample( model, pos, els, f_i_k, f_k_alpha, I_f )


function [U_mat, Ui_mat, info, rho]=compute_by_pcg_accurate( model )

autoloader( loader_scripts( model ), false, 'caller' );

show_modes( f_i_k,f_k_alpha, pos, cov_f, G_N, F )
if prod(tensor_size(Fi))<=3e7
    cache_script( @compute_contractivity );
    reltol=1e-12;
    cache_script( @solve_by_gsolve_pcg );
else
    rho=0.7;
    U_mat=[];
    Ui_mat=[];
    info=[];
end



function show_modes( f_i_k,f_k_alpha, pos, cov_f, G_N, F )
if size(f_i_k,1)>3000; return; end

[mu_fs_i,fs_i_k,sigma_fs_k,fs_k_alpha]=kl_pce_to_standard_form(f_i_k,f_k_alpha); 
C_f=covariance_matrix( pos, cov_f );
[r_i_k,sigma_f]=kl_solve_evp( C_f, G_N, 30 );
sigma_F=tensor_modes(F);
close
hold all
plot( sigma_f/sigma_f(1) )
plot( sigma_fs_k/sigma_fs_k(1) )
plot( sigma_F/sigma_F(1) )
drawnow;



function [U_mat, Ui_mat, info]=compute_by_pcg_approx( model, Ui_true, tol, prec ) 

autoloader( loader_scripts( model ), false, 'caller' );
reltol=tol;
abstol=tol;
if prec
    [Mi_inv, Ki, Fi]=precond_operator( Mi_inv, Ki, Fi );
end
cache_script solve_by_gsolve_pcg;
info.rank_K=size(Ki,1);




function [U, Ui, info]=compute_by_tensor_simple( model, Ui_true, eps, prec, dyn, trunc_mode )
swallow( trunc_mode );
autoloader( loader_scripts( model ), false, 'caller' );
reltol=1e-16;
abstol=1e-16;
if prod(gvector_size(Fi))>1e10
    clear Ui_true
end
dynamic_eps=dyn;
if prec
    [Mi_inv, Ki, Fi]=precond_operator( Mi_inv, Ki, Fi );
    eps=eps/2;
end
if ~exist('trunc_mode', 'var')
    trunc_mode='operator';
end
cache_script solve_by_gsolve_simple_tensor;
info.rank_K=size(Ki,1);



function scripts=loader_scripts( model )
scripts={model; 'define_geometry'; 'discretize_model'; 'setup_equation' };

prefix=['.cache/' mfilename '_' model '_'];
for i=1:size(scripts,1)
    target=[prefix, scripts{i,1}, '.mat'];
    scripts{i,2}=target;
end



function eps=eps_from_error( pcg_err, rho )
eps=pcg_err*(1-rho);
scale=10^(floor(log10(eps)))/10;
eps=roundat( eps, scale );



function [PMi_inv, PKi, PFi]=precond_operator( Mi_inv, Ki, Fi )
PKi=tensor_operator_compose( Mi_inv, Ki );
PMi_inv={speye(size(Ki{1,1})),speye(size(Ki{1,2}))};
PFi=tensor_operator_apply( Mi_inv, Fi );
