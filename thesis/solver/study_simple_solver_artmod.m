function study_simple_solver_artmod

%study_cmp_high_and_low_contract
study_cmp_err_ratio_diff_contract
%study_trace_into_problem

function study_trace_into_problem
% compare ratio of error to truncation for different contractivities
%global last
%last=[];

global ps_results defaults

% set return fields
fields=get_ret_fields();

% set parameters
defaults=get_defaults();
defaults.tol=1e-16;
variable.eps={10.^-6, 10.^-8, 10.^-10};
defaults.mode='operator';
%defaults.mode='after';
variable.r=0.00331;

% run parameter study
%dbstop in generalized_solve_simple at 48
ps_results=param_study( 'do_artmod_simple', variable, defaults, fields, 'cache', true, 'cache_partial', true );
ps_results=cell2mat_all( ps_results );
show_update_ratio_error_and_residual

function show_update_ratio_error_and_residual
global ps_results
close
multiplot_init(2,2)
for i=1:3
    multiplot;
    info=ps_results.info(i);
    plot( info.resvec, 'x-' );
    plot( info.errvec, 'x-' );
    plot( info.updvec, 'x-' );
    logaxis( gca, 'y' );
    legend( 'residual', 'error', 'update ratio' );
end

for i=1:3
    multiplot( [], i );
    save_figure( gca, {'update_ratio_error_and_residual_%d', -log10(ps_results.eps(i)) } );
end

function study_cmp_err_ratio_diff_contract
% compare ratio of error to truncation for different contractivities
global last
global ps_results defaults
last=[];

% set return fields
fields=get_ret_fields();

% set parameters
defaults=get_defaults();
defaults.tol=1e-16;
defaults.maxiter=500;
defaults.eps=10.^-6 ;
defaults.mode='operator';
variable.r=0.0023:0.0001:0.0037;
%variable.r=[0.0023:0.00005:0.0037]; % 0.004];

% run parameter study
ps_options={'cache', true, 'cache_partial', true };
ps_results=param_study( 'do_artmod_simple', variable, defaults, fields, ps_options{:} );
ps_results=cell2mat_all( ps_results );


%%
global ps_results defaults
multiplot_init( 2, 2 )
multiplot([],1); 
plot( ps_results.rho, ps_results.err/defaults.eps, 'x-' );
legend_add( 'error est.' );
plot( ps_results.rho, 1./(1-ps_results.rho), 'x-' );
legend_add( 'error meas.' );
xlabel('$\rho$')
save_figure( [], 'error_and_estimate_over_contract' );
%%
global ps_results defaults
multiplot([],2); logaxis( gca, 'y' );
cla
for i=1:length(ps_results.info)
    plot( ps_results.info(i).errvec, 'x-' );
end
%userwait;


global ps_results defaults
multiplot([],3); %logaxis( gca, 'y' );
conterr=[];
contres=[];
for i=1:length(ps_results.info)
    info=ps_results.info(i);
    ind=find(abs(1-info.updvec)<0.1);
    ind(end-7:end)=[];
    ind
    %ind=1:12;
     [m,n]=polyfit( ind, log(info.errvec(ind)), 1 );
    conterr(end+1)=exp(m(1));
     [m,n]=polyfit( ind, log(info.resvec(ind)), 1 );
    contres(end+1)=exp(m(1));
end
plot( contres, 'x-' );
plot( conterr, 'x-' );
plot( ps_results.rho, 'x-' );
legend( 'contr res', 'contr err', 'rho' ); 
%plot( ps_results.rho./abs(cont)', 'x-' );


global ps_results defaults
multiplot([],4); 
plot( ps_results.r, ps_results.err/defaults.eps, 'x-' );
plot( ps_results.r, 1./(1-contres), 'x-' );
plot( ps_results.r, 1./(1-conterr), 'x-' );
plot( ps_results.r, 1./(1-ps_results.rho), 'x-' );
legend( 'err/eps', 'contr res', 'contr err', 'rho' ); 
%userwait;

function study_cmp_high_and_low_contract
global last
global ps_results
last=[];

% variable.eps=10.^-(0:0.5:14);
% variable.mode={'operator', 'before', 'after'};
% variable.r={0.00237, 0.00274, 0.00307, 0.00335, 0.00362, 0.00387 };


% set return fields
fields=get_ret_fields;

% set parameters
defaults=get_defaults;
defaults.tol=1e-16;
variable.eps=10.^(-14:-2);
variable.r=[0.00237, 0.003, 0.00362];

% run parameter study
ps_options={'cache', true };
ps_results=param_study( 'do_artmod_simple', variable, defaults, fields, ps_options{:} );
ps_results=cell2mat_all( ps_results );

%show_ranks
%show_modes
%show_time 
show_error
show_error_ratio

function show_ranks
global ps_results
multiplot_init( 2, 1 )
multiplot; 
for i=1:size(ps_results.rank,1); 
    plot( ps_results.rank{i,1} );
end
multiplot; 
for i=1:size(ps_results.rank,1); 
    plot( ps_results.rank{i,2} );
end
%userwait;


function show_modes
global ps_results
multiplot_init( 2, 1 )
multiplot; logaxis( gca, 'y' );
for i=1:size(ps_results.modes,1); 
    plot( ps_results.modes{i,1}*(1.2^i) );
end
multiplot; logaxis( gca, 'y' );
for i=1:size(ps_results.rank,1); 
    plot( ps_results.modes{i,2}*(1.2^i) );
end
%userwait;


function show_time
global ps_results
multiplot_init( 1, 1 )
multiplot; logaxis( gca, 'x' );
plot( ps_results.eps(:,1), ps_results.time, 'x-' );
%userwait;


function show_error
global ps_results
multiplot_init( 1, 1 )
multiplot; logaxis( gca, 'xy' );
plot( ps_results.eps(:,1), ps_results.err, 'x-' );
plot( ps_results.eps(:,1), ps_results.eps(:,1), '-' );
%userwait;


function show_error_ratio
global ps_results
multiplot_init( 1, 1 )
multiplot; logaxis( gca, 'x' );
plot( ps_results.eps(:,1), ps_results.err(:,1)./ps_results.eps(:,1), 'x-' );
plot( ps_results.eps(:,1), ps_results.err(:,2)./ps_results.eps(:,1), 'x-' );
plot( ps_results.eps(:,1), ps_results.err(:,3)./ps_results.eps(:,1), 'x-' );
ylim( [0,3] );
%userwait;

function fields=get_ret_fields
fields={...
    {'info','info'}, ...
    {'resvec','info.resvec'}, ...
    {'err', 'curr_err'}, ...
    {'res', 'info.relres/gvector_norm(F)'}, ...
    {'time', 'tt'}, ...
    {'rank', 'info.rank_sol_after' }, ...
    {'modes', 'tensor_modes( X )' }, ...
    {'flag','flag'}, ...
    {'iter','info.iter'}, ...
    {'cmptime','cmptime'}, ...
    {'rho','rho'}, ...
    };

function defaults=get_defaults
defaults=struct();
defaults.N=151;
defaults.M=173;
defaults.maxiter=60;
defaults.tol=1e-4;
defaults.eps=10^-6;
defaults.r=0.0027;
defaults.mode='operator';
