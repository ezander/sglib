function solve_model( pre_run, post_run )

% ==========
% = prolog =
% ==========
eval( pre_run );
disp('solving model')
%whos
%keyboard

% ==========
% =  main  =
% ==========

switch solver
    case 'cg'
        solve_pcg_1d;
    case 'si'
        solve_si_1d;
    otherwise
        error('unknown solver');
end



% ==========
% = epilog =
% ==========
eval( post_run );
