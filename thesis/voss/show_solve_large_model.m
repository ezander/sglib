
rebuild=get_param('rebuild', false);
%autoloader( {'model_1d_large'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_pcg'; 'vector_to_tensor'}, rebuild, 'caller' );
autoloader( {'model_1d_large'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_gsolve_pcg' }, rebuild, 'caller' );
rebuild=false;

info_cg=info;
%[rho,flag]=simple_iteration_contractivity( Ki, Mi_inv,  'abstol', 1e-2 )
Ui_vec_true=Ui_vec;
solve_by_gsolve_simple


info_si=info;

%%
multiplot_init(1,1)
plot(info_cg.resvec,'-x')
plot(info_si.resvec,'-x')
logaxis( gca, 'y' )
grid on

%% Statitics
% calling stoch. mat-vector prod
% calling determ. mat-vector prod
% calling determ. precond
% calling reduction 
