function show_accuracy

clc;
[A, F, U]=setup_system();
f=to_tensor( F );
gvector_error( tensor_to_array( f ), F, [], true )
u=to_tensor( U );
gvector_error( tensor_to_array( u ), U, [], true )

R=compute_residual_std( F, A, U );
gvector_norm(R)
r=compute_residual_std( f, A, u );
r=tensor_truncate( r );
gvector_norm(r)

gvector_error( tensor_to_array( r ), R, [], false )
gvector_error( r, to_tensor(R), [], false )
% gvector_error( R, tensor_to_array( to_tensor(R)), [], false )
% gvector_error( r, to_tensor(tensor_to_array(r)), [], false )


U1=tensor_truncate( U, 'k_max', inf, 'eps', 0.001 );
R1=compute_residual_std( F, A, U1 );
gvector_error(U1, U, [], true)
gvector_norm(R1)

u1=to_tensor( U1 );
r1=compute_residual_std( f, A, u1 );
gvector_error(u1, u, [], true)
gvector_norm(r1)



function Ut=to_tensor( T )
[U,S,V]=svd(T,0);
Ut={U*S,V};


function R=compute_residual_std( F, A, U )
R=gvector_add( F, operator_apply(A,U), -1 );


function [A, F, U]=setup_system

model_large
num_refine=0; %#ok<*NASGU>
lc_k=0.2;
lc_f=0.2;
l_f=10;
l_k=10;
p_f=2;
p_k=4;
p_u=2;
verbose=false;
define_geometry
discretize_model
setup_equation
%solve_by_pcg;

Fi_vec=tensor_to_vector( Fi );

disp(' ');
maxit=100;
reltol=1e-6;

Ki_fun=@(x)(tensor_operator_apply(Ki,x));
Mi_inv=stochastic_preconditioner_deterministic(Ki);
Mi_inv_fun=@(x)(tensor_operator_apply(Mi_inv,x));


[Ui_vec,flag,info.relres,info.iter,resvec]=pcg(Ki_fun,Fi_vec,reltol,maxit,Mi_inv_fun); %#ok<*ASGLU>

for i=1:2
    R_vec=gvector_add( Fi_vec, operator_apply(Ki,Ui_vec), -1 );
    [Ui_vec_delta,flag,info.relres,info.iter,resvec]=pcg(Ki_fun,R_vec,reltol,maxit,Mi_inv_fun);
    Ui_vec=Ui_vec+Ui_vec_delta;
end

A=Ki;
F=Fi_vec;
U=Ui_vec;

d=tensor_operator_size(A); d=d(:,1)';
F=reshape(F,d);
U=reshape(U,d);
