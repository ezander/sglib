function build_model( pre_run, post_run )

% ==========
% = prolog =
% ==========
eval( pre_run );
disp('building model')
%whos
disp(strvarexpand( 'beta_a=$beta_a$'))
%keyboard

% ==========
% =  main  =
% ==========





% ==========
% = epilog =
% ==========
eval( post_run );
