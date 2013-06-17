%% Todos as of 12 Jun 2013

% Move paramstudy, octcompat into util
% qmc -> sampling?
% implement polysys_invcdf for sampling from qmc
% implement statistics/xxx_invcdf for expansion of gpc parameters
% implement all polysys distributions also in statistics (could reuse their
% cdf then)
% put kde into stats/private and use in kernel_estimate_fast or something
% import stiffness matrix functions
% remove thesis from here and organise as submodule thing
% move svd_type stuff in linalg into private
% move inv_reg_beta into private? or math_util?

% move plot_range, xxxspace into plotting?
% check pcefunc stuff, works? 

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


