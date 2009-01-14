function [x,flag,relres,iter]=solve_linear_stat_tensor( A_tp, F_tp, varargin )
% SOLVE_LINEAR_STAT_TENSOR Solves a linear system in tensor product form using stationary methods.

%% init section
options=varargin2options( varargin{:} );
[method_str,options]=get_option( options, 'method', 'jacobi' );
[omega,options]=get_option( options, 'overrelax', 1 ); %#ok
[abstol,options]=get_option( options, 'abstol', 1e-7 );
[reltol,options]=get_option( options, 'reltol', 1e-7 );
[maxiter,options]=get_option( options, 'maxiter', 100 );

[trunc_k,options]=get_option( options, 'trunc_k', 20 );
[trunc_eps,options]=get_option( options, 'trunc_eps', 1e-4 );
[relax,options]=get_option( options, 'relax', 1.0 );

%algorithm=get_option( options, 'algorithm', 'standard' ); %#ok
[algorithm,options]=get_option( options, 'algorithm', 1 ); %#ok
check_unsupported_options( options, mfilename );

switch method_str
    case {'jacobi', 'jac', 'jor'}
        method=1; %#ok
    case {'gauss-seidel', 'gs', 'sor'}
        method=2; %#ok
        error( 'solve_mat_decomp_tensor:impl', 'not yet implemented' );
    otherwise
        error( 'solve_mat_decomp_tensor:args', 'Unknown method (%s)', method_str );
end



%% solver section
A_0={ A_tp{1}, A_tp{2} };
A_i={A_tp{3}{:};A_tp{4}{:}}';
norm_A0=tensor_operator_normest( A_0 ); % need to relate the truncation epsilons depending on when truncation is performed

F=F_tp;
X_r=tensor_null(F); 

%check_spectral_radius( A_0, A_i )


R=compute_residual( A_0, A_i, X_r, F, trunc_k, trunc_eps );
norm_R0=tensor_norm( R );
norm_R=norm_R0;

flag=0;
iter=0;
tol=max( norm_R0*reltol, abstol );
tol=max( tol, max( norm_R0*trunc_eps, trunc_eps ) );

fprintf( 'Start: %g\n', norm_R0 );

while norm_R>tol

    if algorithm==1
        Y_r=jacobi_step_alg1( X_r, A_0, A_i, F, trunc_k, trunc_eps, norm_A0 );
    else
        Y_r=jacobi_step_alg2( X_r, A_0, A_i, F, trunc_k, trunc_eps );
    end
        

    while true
        if relax<1.0
            Z_r=relax_update( X_r, Y_r, relax, trunc_k, trunc_eps, norm_A0 );
        else
            Z_r=Y_r;
        end

        R=compute_residual( A_0, A_i, Z_r, F, trunc_k, trunc_eps );
        norm_R_new=tensor_norm( R );
        if norm_R_new>norm_R
            relax=relax/2;
            if relax<1e-2
                flag=3;
                break;
            end
        else
            break;
        end
    end
    if flag
        break;
    end
    
    X_r=Z_r;
    norm_R=norm_R_new;
    
    fprintf( 'Iter: %d -> %g (k:%d,relax:%g)\n', iter, norm_R, size(X_r{1},2), relax );

    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end
end
%final_res=norm_R;
relres=norm_R/norm_R0;
x=X_r;

%%
function R=compute_residual( A_0, A_i, X, F, trunc_k, trunc_eps )
R_r=F;
R_c=tensor_null(R_r);
R_r=tensor_add( R_r, tensor_apply( A_0, X ), -1 );
[R_r,R_c]=tensor_reduce_carry( R_r, R_c, trunc_k, trunc_eps );
for i=1:size(A_i,1)
    R_r=tensor_add( R_r, tensor_apply( A_i(i,:), X ), -1 );
    [R_r,R_c]=tensor_reduce_carry( R_r, R_c, trunc_k, trunc_eps );
end
R=R_r;

function Y_r=jacobi_step_alg1( X_r, A_0, A_i, F, trunc_k, trunc_eps, norm_A0 )
Y_r=tensor_solve( A_0, F );
Y_c=tensor_null( Y_r );
for i=1:size(A_i,1)
    S_i=tensor_apply( A_i(i,:), X_r );
    S_i=tensor_solve( A_0, S_i );
    Y_r=tensor_add( Y_r, S_i, -1 );
    [Y_r,Y_c]=tensor_reduce_carry( Y_r, Y_c, trunc_k, trunc_eps/norm_A0 );
end

function Y_r=jacobi_step_alg2( X_r, A_0, A_i, F, trunc_k, trunc_eps )
Y_r=F;
Y_c=tensor_null( Y_r );
for i=1:size(A_i,1)
    S_i=tensor_apply( A_i(i,:), X_r );
    Y_r=tensor_add( Y_r, S_i, -1 );
    [Y_r,Y_c]=tensor_reduce_carry( Y_r, Y_c, trunc_k, trunc_eps );
end
Y_r=tensor_solve( A_0, Y_r );

function Z_r=relax_update( X_r, Y_r, relax, trunc_k, trunc_eps, norm_A0 )
Z_r=tensor_null( Y_r );
Z_r=tensor_add( Z_r, Y_r, relax );
Z_r=tensor_add( Z_r, X_r, 1.0-relax );
Z_r=tensor_reduce( Z_r, trunc_k, trunc_eps/norm_A0 );


%%

function [T_r,T_c]=tensor_reduce_carry( T_r, T_c, k0, eps )
[T_r,T_c]=tensor_reduce( tensor_add( T_r, T_c ), k0, eps );


function d=tensor_operator_normest( A_0 )
d=normest(A_0{1})*normest(A_0{2});

function d=tensor_operator_condest( A_0 ) %#ok
d=condest(A_0{1})*condest(A_0{2});

function rho=estimate_method_spectral_radius( X_0, Phi, relax, trunc_k, trunc_eps, norm_A0 ) %#ok
k=5; eps=0.01;
X=tensor_reduce( X_0, k, eps );
X=tensor_scale( X, 1/tensor_norm( X ) );

for iter=1:100
    Y_r=Phi( X );
    
    if relax~=1.0
        Z_r=relax_update( X, Y_r, relax, trunc_k, trunc_eps, norm_A0 );
    else
        Z_r=Y_r;
    end
   
    rho=tensor_norm(Z_r);
    lambda=tensor_scalar_product(Z_r,X);
    fprintf( 'PM-Iter: %d -> %g %g\n', iter, rho, lambda );
    X=tensor_scale( Z_r, 1/rho );
end

function check_spectral_radius( A_0, A_i )
%estimation whether the algorithm will converge and some 'optimal'
%relaxation parameter omega (doesn't really work)
%Phi=@(X_r)(jacobi_step_alg1( X_r, A_0, A_i, tensor_null(F), trunc_k, trunc_eps, norm_A0 ));
%lambda=estimate_method_spectral_radius( F, Phi, 1.0, trunc_k, trunc_eps, norm_A0 );
%lambda=estimate_method_spectral_radius( F, Phi, 0.3, trunc_k, trunc_eps, norm_A0 );
%omega=3/(2*(lambda+1))
%rho=estimate_method_spectral_radius( F, A_0, A_i, 0.03, trunc_k, trunc_eps, norm_A0 )

K_0=kron(A_0{1},A_0{2});
K_0inv=kron(inv(A_0{1}),inv(A_0{2}));
K_s=kron(A_i{1,1},A_i{1,2});
for i=2:size(A_i,1)
    K_s=K_s+kron(A_i{i,1},A_i{i,2});
end

n1=2; n2=20;
K_0=kron(A_0{1}(n1:n2,n1:n2),A_0{2});
K_0inv=kron(inv(A_0{1}(n1:n2,n1:n2)),inv(A_0{2}));
K_s=kron(A_i{1,1}(n1:n2,n1:n2),A_i{1,2});
for i=2:size(A_i,1)
    K_s=K_s+kron(A_i{i,1}(n1:n2,n1:n2),A_i{i,2});
end

K=K_0+K_s;
Id=speye(size(K));
M=Id-K_0inv*K;
eigs(M,10,'LM',struct('disp',0))
omega=1.6;
M_om=Id-omega*K_0inv*K;
eigs(M_om,10,'LM',struct('disp',0))

omega=0.002;
omega=1e-4;
M_om=Id-omega*K;
eigs(M_om,10,'LM',struct('disp',0))

