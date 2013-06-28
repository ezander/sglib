% move polysys_pdf to gpc, create cdfinv and cdf
% move mean_var_update to stats
% move plot_resp to plot_gpc_resp...
% need function to check compatibility of gpc's

%% 19 Jun 2013

% error measure for response surface (+)
% plotting for response surfaces (+)
% full tensor grid 

%% Todos as of 12 Jun 2013

% implement polysys_invcdf  (extract from gpc_sample...)
% implement all polysys distributions also in statistics (could reuse their
%    cdf then) (nearly, arcsine and semicircle??? or keep beta???)
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
% get_param % whick workspace? separate functions? integration with autoloader; cache_script


