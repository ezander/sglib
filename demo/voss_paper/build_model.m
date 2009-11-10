function build_model( pre_run, post_run )

% ==========
% = prolog =
% ==========
eval( pre_run );
disp('building model')
disp(strvarexpand( 'beta_a=$beta_a$'))
%whos
%keyboard

% ==========
% =  main  =
% ==========

build_model_1d;

% ==========
% = epilog =
% ==========
eval( post_run );
