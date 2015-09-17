function [X,flag,relres,iter,info]=tensor_operator_solve_richardson( A, F, varargin )

options=varargin2options( varargin );
[M,options]=get_option( options, 'M', [] );
[abstol,options]=get_option( options, 'abstol', 1e-5 );
[reltol,options]=get_option( options, 'reltol', 1e-5 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_options,options]=get_option( options, 'truncate_options', {} );
check_unsupported_options( options, mfilename );

%A0=A(1,:);
%AR=A(2:end,:);

null_vector=@ctensor_null;
add=@ctensor_add;
truncate=@ctensor_truncate;
prec_solve=@tensor_operator_solve_elementary;
apply_operator=@tensor_operator_apply;

flag=0;
iter=0;

X=null_vector(F);
R=F;
for i=1:20
    % Solve for update:
    %  DX=M\R;
    DX=prec_solve( M, R );

    % Apply update and truncate:
    %   X=X+DX
    X=add( X, DX );
    X=truncate( X, truncate_options );

    % Compute residual and truncate:
    %   R=F-A*X;
    R=add( F, apply_operator( A, X ), -1 );
    [R,sigma]=truncate( R, truncate_options );

    % TODO: compare residual and update, maybe the truncation is always
    % just reverting the previous update, then bail out

    % increment and check iteration count
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end
end

relres=-1;
info=struct();





function [X,flag,relres,iter]=old_tensor_operator_solve_jacobi( A, F, varargin )
% SOLVE_STAT_TENSOR Solves a linear system in tensor product form using stationary methods.

% init section
options=varargin2options( varargin );
[M,options]=get_option( options, 'M', [] );
[abstol,options]=get_option( options, 'abstol', 1e-7 );
[reltol,options]=get_option( options, 'reltol', 1e-7 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_options,options]=get_option( options, 'truncate_options', {''} );
check_unsupported_options( options, mfilename );

%[omega,options]=get_option( options, 'overrelax', 1 ); %#ok
%[relax,options]=get_option( options, 'relax', 1.0 );
%[trunc_k,options]=get_option( options, 'trunc_k', 20 );
%[trunc_eps,options]=get_option( options, 'trunc_eps', 1e-4 );
%[algorithm,options]=get_option( options, 'algorithm', 1 ); %#ok


% solver section
A0=A(1,:);
AR=A(2:end,:);
norm_A0=tensor_operator_normest( AR ); % need to relate the truncation epsilons depending on when truncation is performed

X=ctensor_null(F);


R=compute_residual( A0, AR, X, F, truncate_options );
norm_R0=ctensor_norm( R );
norm_R=norm_R0;

flag=0;
iter=0;
tol=max( norm_R0*reltol, abstol );
tol=max( tol, max( norm_R0*trunc_eps, trunc_eps ) );

% fprintf( 'Start: %g\n', norm_R0 );
while norm_R>tol

    if algorithm==1
        Y=jacobi_step_alg1( X, A0, AR, F, truncate_options );
    else
        Y=jacobi_step_alg2( X, A0, AR, F, truncate_options );
    end

    while true
        if relax<1.0
            Z=relax_update( X, Y, relax, truncate_options );
        else
            Z=Y;
        end

        R=compute_residual( A0, AR, Z, F, truncate_options );
        norm_R_new=ctensor_norm( R );
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

    X=Z;
    norm_R=norm_R_new;

    %fprintf( 'Iter: %d -> %g (k:%d,relax:%g)\n', iter, norm_R, size(X_r{1},2), relax );
    fprintf( 'Iter: %d -> %g (k:%d,relax:%g)\n', iter, norm_R, -1, relax );

    % increment and check iteration counter
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end
end
%final_res=norm_R;
relres=norm_R/norm_R0;



function R=compute_residual( A0, AR, X, F, truncate_opts )
R=F;
R=ctensor_add( R, tensor_operator_apply_elementary( A0, X ), -1 );
R=ctensor_truncate( R, truncate_opts );
for i=1:size(AR,1)
    R=ctensor_add( R, tensor_operator_apply_elementary( AR(i,:), X ), -1 );
    R=ctensor_truncate( R, truncate_opts );
end


function Y=jacobi_step_alg1( X, A0, AR, F, truncate_opts )
Y=tensor_solve( A0, F );
for i=1:size(AR,1)
    S=tensor_operator_apply_elementary( AR(i,:), X );
    S=tensor_solve( A0, S );
    Y=ctensor_add( Y, S, -1 );
    Y=ctensor_truncate( Y, truncate_opts );
end


function Y=jacobi_step_alg2( X, A0, AR, F, truncate_opts )
Y=F;
for i=1:size(AR,1)
    S=tensor_operator_apply_elementary( AR(i,:), X );
    Y=ctensor_add( Y, S, -1 );
    Y=ctensor_truncate( Y, truncate_opts );
end
Y=tensor_solve( A0, Y );


function Z=relax_update( X, Y, relax, truncate_opts )
Z=ctensor_add( Y, Y, relax-1 );
Z=ctensor_add( Z, X, 1-relax );
Z=ctensor_truncate( Z, truncate_opts  );
