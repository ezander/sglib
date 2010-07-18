function test_solve_huge_model

%#ok<*NASGU>
%#ok<*NOPRT>
%#ok<*DEFNU>
%#ok<*ASGLU>
%#ok<*STOUT>
%#ok<*INUSL>
%#ok<*NODEF>
 
global U_mat_true Ui_mat_true
global U_mat Ui_mat info_pcg pcg_err eps
global U Ui info_tp tp_err

clc
% rebuild_scripts
show_model_data

underline( 'accurate pcg' );
[U_mat_true, Ui_mat_true, info_acc, rho]=compute_by_pcg_accurate;

if numel(U_mat_true)
    underline( 'approximate pcg' );
    [U_mat, Ui_mat, info_pcg]=compute_by_pcg_approx( Ui_mat_true, 1e-3, false );
    pcg_err=gvector_error( U_mat, U_mat_true, 'relerr', true );
    eps=eps_from_error( pcg_err, rho );
else
    pcg_err=nan;
    info_pcg.time=nan;
    eps=1e-4;
end
info_pcg.rho=rho;
info_pcg.norm_U=gvector_norm(Ui_mat);

% underline( 'approximate prec pcg' );
% [U_mat2, Ui_mat2, info_pcg2]=compute_by_pcg_approx( Ui_mat_true, pcg_err, true );
% pcg_err2=gvector_error( U_mat2, U_mat_true, 'relerr', true ) 

U={}; Ui={}; info_tp={}; tp_err={};
num=1;
for i=1:num
    switch i
        case 1
            underline( 'normal tensor solver' );
            prec=false; dyn=false;
            descr='normal';
        case 2
            underline( 'dynamic tensor solver' );
            prec=false; dyn=true;
            descr='dyna';
        case 3
            underline( 'prec tensor solver' );
            prec=true; dyn=false;
            descr='prec';
        case 4
            underline( 'dynamic prec tensor solver' );
            prec=true; dyn=true;
            descr='dyna prec';
    end
    
    [U{i}, Ui{i}, info_tp{i}]=compute_by_tensor_simple( Ui_mat_true, eps, prec, dyn ); %#ok<*AGROW>
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

info=info_tp{1};
display_tensor_solver_details;
plot_solution_overview(info_tp{1})
plot_solution_comparison(info_tp)

function plot_solution_comparison(infos)
%%
close
num=length(infos);
marker={'-x','-*','-o','-+'};
multiplot_init(2,3)
multiplot; field='errvec'; title( 'rel. error' );  logax='y'; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='resvec'; title( 'rel. residual' );  logax='y'; for i=1:num; plot( infos{i}.(field)/infos{i}.(field)(1), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='updvec'; title( 'update ratio' );  logax=''; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='epsvec'; title( 'epsilon' );  logax='y'; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='rank_res_before'; title( 'rank residual' );  logax=''; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );
multiplot; field='rank_sol_after'; title( 'rank solution' );  logax=''; for i=1:num; plot( infos{i}.(field), marker{i} ); legend_add( infos{i}.descr ); end;  logaxis( gca, logax ); legend( legend, 'location', 'best' );

function plot_solution_overview(info)
%%
close
multiplot_init(2,2)
multiplot
rho=info.rho;
errest=rho/(1-rho)*info.updnormvec/info.norm_U+info.epsvec;

plot( info.errvec, 'x-' ); legend_add( 'rel. error' );
plot( errest, '*-' ); legend_add( 'error est.' );
plot( info.resvec/info.resvec(1), 'o-' ); legend_add( 'rel. residual' );
plot( info.updvec, 'd-' ); legend_add( 'update ratio' );
logaxis( gca, 'y' )

multiplot;
plot( info.rank_res_before, 'x-' ); legend_add( 'rank (before prec)' );
plot( info.rank_sol_after, 'x-' ); legend_add( 'rank (after prec)' );

multiplot;
%plot( tensor_modes( Ui ) )
%logaxis( gca, 'y' )
%keyboard
% R_vec_pcg6=operator_apply( Ki, Ui_vec_pcg6, 'residual', true, 'b', Fi_vec );
% R_vec_pcg2=operator_apply( Ki, Ui_vec_pcg2, 'residual', true, 'b', Fi_vec );
% gvector_norm( R_vec_pcg2 )/gvector_norm(Fi_vec)



function rebuild_scripts 
autoloader( loader_scripts, true, 'caller' );


function show_model_data
autoloader( loader_scripts, false, 'caller' );
pos(2,:)=-pos(2,:); % invert y axis for display

%%
display_model_details


function [U_mat, Ui_mat, info, rho]=compute_by_pcg_accurate 

autoloader( loader_scripts, false, 'caller' );

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



function [U_mat, Ui_mat, info]=compute_by_pcg_approx( Ui_true, tol, prec ) 

autoloader( loader_scripts, false, 'caller' );
reltol=tol;
abstol=tol;
if prec
    [Mi_inv, Ki, Fi]=precond_operator( Mi_inv, Ki, Fi );
end
cache_script solve_by_gsolve_pcg;
info.rank_K=size(Ki,1);




function [U, Ui, info]=compute_by_tensor_simple( Ui_true, eps, prec, dyn )

autoloader( loader_scripts, false, 'caller' );
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

cache_script solve_by_gsolve_simple_tensor;
info.rank_K=size(Ki,1);



function scripts=loader_scripts
%model='model_huge';
model='model_huge_easy';
%model='model_large';
%model='model_large_easy';
%model='model_giant_easy';
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
