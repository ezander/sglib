function show_accuracy

[A, F, U]=setup_system();




function [A, F, U]=setup_system

model_large
num_refine=0;
lc_k=0.2;
lc_f=0.2;
l_f=10;
l_k=10;
p_f=2;
p_k=4;
p_u=2;
define_geometry
discretize_model
setup_equation


A=1;
F=1;
U=1;
