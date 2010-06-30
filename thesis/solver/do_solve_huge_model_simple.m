%function do_solve_huge_model_simple
tol=1e-2; % much too small, thus solver goes into stagnation
mode='operator';
trunc.eps=1e-6;
trunc.k_max=20;
trunc.k_max=100;
trunc.show_reduction=false;
Minv=stochastic_preconditioner_deterministic( Ki, true );

common={'maxiter', 100, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'verbosity', 1 };

[X,flag,info]=generalized_solve_simple( Ki, Fi, 'Minv', Minv, common{:}, 'trunc_mode', mode, 'trunc', trunc   );
