function test_third_order

%#ok<*NASGU>
clc
model_name='model_medium_easy';
model_name='model_small_easy';
tol=1e-3;
k_max=100;
eps=1e-5;

solve_2way( model_name, tol, eps, k_max )
solve_3way( model_name, tol, eps, k_max )

function solve_3way(model_name, tol, eps, k_max)
abstol=tol;
reltol=tol; 
eval(model_name);
define_geometry
discretize_model
solver_name='gsi';

setup_equation_3way
solve_by_gsolve_tensor

function solve_2way(model_name, tol, eps, k_max)
abstol=tol;
reltol=tol; 
eval(model_name);
define_geometry
discretize_model
solver_name='gsi';

setup_equation
solve_by_gsolve_tensor
