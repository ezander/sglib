%TODO Contains my personal TODO

% write help for gpcbasis_create (important!!)

% check halton_sequence for n==0

% implement arcine and semicircle as beta in gendist_create


% check results from smolyak in the new demo


% There seem to be some problems with the generation of the random fields,
% as can be seen in demo_rf_expand_pce_sg, need to write unittests for that
% definitely now.

% Sfem functions should be changed to work with gendists instead of functions
% handles. Also cov_models should be introduced and used.

% statistics distributions: remove stdnor stuff, keep only in normal, lognormal, and
% gendist (otherwise compose dynamically), create density_plot,
% gendist_from_stat_toolbox, after removal of stdnor: change demos and sfem
% methods to use dists instead of stdnor stuff
%
% introduce similar concept for covariances: gencov (or something), from
% kernel, flags (isotropic, homogeneous), spectral density, ...
% 
% make the rug plot determine the length of the rugs things in relation to
% the total plot size (maybe in points or something), further include in
% the density plot as option (with symm(etric), up and down, off or something)

%% 25 Nov 2013
% move polysys_pdf to gpc, create cdfinv and cdf
% move mean_var_update to stats
% move plot_resp to plot_gpc_resp...
% need function to check compatibility of gpc's
% gpcbasis_create should also work with an rvtype, 
% need function to map polynomials system char's to names
% insert @default stuff into get_option
% better heuristics for ranges in plot_resp_surface

%% 19 Jun 2013

% error measure for response surface (+)
% plotting for response surfaces (+)

%% Todos as of 12 Jun 2013

% put kde into stats/private and use in kernel_estimate_fast or something
% import stiffness matrix functions from fileexchange
% remove thesis from here and organise as submodule thing
% to the same with the testing area
% reorganise the demo area (publish, xiu_book, lecture, ....)
% move svd_type stuff in linalg into private

% move plot_range, xxxspace into plotting?

% make list of subdirs for and 
%   check all Contents.m
%   check lint stuff
%   check for undocumented functions
%   check for assert's 
%   find funcs without unittest




%% Old todo: need to check what's still relevant

% some functions to write
% pce_field_expand
% pce_field_expand_gaussian
% pce_field_expand_lognormal?
% kl_pce_field_expand
% kl_pce_field_expand_gaussian
% kl_pce_moments->mean,var

% preconditioners: use ilu, also invmean, and zabaras
% examine number of iterations as function of prec type


% implement neumann bc

% for cg: add tracking of res accuracy
    
% comparison with monte carlo (partly done)
% l2 norm diff with smolyak

% parameter stuff
% get_param: which workspace? separate functions? integration with autoloader; cache_script


