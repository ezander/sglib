%function test_precond
%%
clear;
%model_small_easy; 
model_medium_easy; 
define_geometry; 
discretize_model; 
display_model_details; 
strvarexpand( '%var_f: $percent_var_f$' );
strvarexpand( '%var_k: $percent_var_k$' );

%return
%%
setup_equation

%%
A=tensor_operator_to_matrix( Ki );

%%
tic
[Pinv1,P,info]=stochastic_precond_mean_based( Ki, 'precond_type',0,'decomp_type','');
toc
PP1={P{1}{2}{2}{1},P{2}{2}{2}{1}};
P1=tensor_operator_to_matrix( PP1 );

tic
[Pinv2,P,info]=stochastic_precond_mean_based( Ki, 'precond_type',1,'decomp_type','');
toc
PP2={P{1}{2}{2}{1},P{2}{2}{2}{1}};
P2=tensor_operator_to_matrix( PP2 );

tic
[Pinv3,P,info]=stochastic_precond_mean_based( Ki, 'precond_type',3,'decomp_type','');
toc
PP3={P{1}{2}{2}{1},P{2}{2}{2}{1}};
P3=tensor_operator_to_matrix( PP3 );


% disp( 'iterop frob' );
% [L,U]=lu(P1);B=U\(L\A); B=eye(size(B))-B; norm( B, 'fro')
% [L,U]=lu(P2);B=U\(L\A); B=eye(size(B))-B; norm( B, 'fro')
% [L,U]=lu(P3);B=U\(L\A); B=eye(size(B))-B; norm( B, 'fro')
% return
%%
disp( 'frob' );
norm( A-P1, 'fro' )
norm( A-P2, 'fro' )
norm( A-P3, 'fro' )
disp( 'spectral' );
svds( A-P1, 1 ) %normest( A-P1 )
svds( A-P2, 1 ) %normest( A-P2 )
svds( A-P3, 1 ) %normest( A-P2 )
disp( 'rho' );
eigs( A-P1, 1 ) %normest( A-P1 )
eigs( A-P2, 1 ) %normest( A-P2 )
eigs( A-P3, 1 ) %normest( A-P2 )

%%
%tic; s1=svds( A-P1, 1 ), toc; %sum(s1(1:10) )

disp( 'contractivity' );
simple_iteration_contractivity( A, Pinv1 )
simple_iteration_contractivity( A, Pinv2 )
simple_iteration_contractivity( A, Pinv3 )

[L,U]=lu(P1);B=U\(L\A); B1=eye(size(B))-B; 
[L,U]=lu(P2);B=U\(L\A); B2=eye(size(B))-B; 
[L,U]=lu(P3);B=U\(L\A); B3=eye(size(B))-B; 

disp( 'iterop frob' );
norm( B1, 'fro')
norm( B2, 'fro')
norm( B3, 'fro')

disp( 'iterop spectral' );
svds( B1, 1)
svds( B2, 1)
svds( B3, 1)

disp( 'iterop rho' );
eigs( B1, 1)
eigs( B2, 1)
eigs( B3, 1)

%%
if true
    F=tensor_to_array(Fi);
    [X,flag,info1]=generalised_solve_pcg( A, F(:), 'Minv', Pinv1, 'verbosity', 0 );
    [X,flag,info2]=generalised_solve_pcg( A, F(:), 'Minv', Pinv2, 'verbosity', 0 );
    [X,flag,info3]=generalised_solve_pcg( A, F(:), 'Minv', Pinv3, 'verbosity', 0 );
    disp('pcg solve steps')
    info1.iter
    info2.iter
    info3.iter
    [X,flag,info1]=generalised_solve_simple( A, F(:), 'Minv', Pinv1, 'verbosity', 0 );
    [X,flag,info2]=generalised_solve_simple( A, F(:), 'Minv', Pinv2, 'verbosity', 0 );
    [X,flag,info3]=generalised_solve_simple( A, F(:), 'Minv', Pinv3, 'verbosity', 0 );
    disp('simple solve steps')
    info1.iter
    info2.iter
    info3.iter
end
    
    
    
