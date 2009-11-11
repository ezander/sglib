function plot_model( pre_run, post_run )

% ==========
% = prolog =
% ==========
eval( pre_run );
disp('plotting model stuff')
%keyboard

% ==========
% =  main  =
% ==========

plot_model_1d;

% ==========
% = epilog =
% ==========
eval( post_run );
