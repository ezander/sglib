%TODO Contains my personal TODO


%% gpc diffusion demo

% show also univariate cdf/pdf stuff
% maybe split the demo into two or three parts, parameter exp, blackbox,
% intrusive


% TODO: Compare response surface with true response
% TODO: Show grids for interpolation and projection
% TODO: Make plotting stuff into a function and explain
% TODO: Explain interpolation and/or projection shortly and show the code, then explain that that's been put into a function
% TODO: compare some samples computed directly and per surrogate model
% TODO: create model_stats(cmd) func (reset, print, ...)
% TODO: compare to dishis results
% TODO: create gpcbasis_info function (maybe remove gpcbasis_size)


%% 13 Feb 2014

% Help needed for: plot_density, apply_boundary_..., sfem functions, ...

% Make tensor operator or general operator avaible to use in matlab pcg
% (half done)

% Make some data/extras/... directory where data files, tex files, etc can
% be put

% Smolyak needs to be able to take funcs, which may clash with
% specification of multiple rule_funcs

% Create model and methods directories in sglib

% register new gpc types, like (dist, polysys)

% Separate the 1d diffusion model into a parametric model and a "functional
% model" (try to use solve function with mean values for the preconditioner
% of pcg).

% remove many of the old hermite_ and pce_ functions, move them to obsolete
% and issue obsoletion_warnings which may be turned off, implement them in
% terms of new functions


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

%% 25 Nov 2013
% move plot_resp to plot_gpc_resp...
% better heuristics for ranges in plot_resp_surface (take maybe from 
% need function to check compatibility of gpc's
% need function to map polynomials system char's to names

%% 19 Jun 2013

% error measure for response surface (+)
% plotting for response surfaces (+)

%% Todos as of 12 Jun 2013

% put kde into stats/private and use in kernel_estimate_fast or something
% import stiffness matrix functions from fileexchange
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


