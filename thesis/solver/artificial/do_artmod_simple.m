global last F X A P Pinv rho x sigma_X sigma_F cmptime

N=get_base_param( 'N', 151 );
M=get_base_param( 'M', 173 );
r=get_base_param( 'r', 0.002 );

eps=get_base_param( 'eps', 0 );
k_max=get_base_param( 'k_max', inf );
trunc_mode=get_base_param( 'trunc_mode', 'operator' );
stag_steps=get_base_param( 'stag_steps', 5 );
upratio_delta=get_base_param( 'upratio_delta', 0.1 );
dynamic_eps=get_base_param( 'dynamic_eps', false );

tol=get_base_param( 'tol', 1e-6 );
abstol=get_base_param( 'abstol', tol );
reltol=get_base_param( 'reltol', tol );
maxiter=get_base_param( 'maxiter', 100 );

    
if isempty(last) || last.r~=r || last.N~=N || last.M~=M
    rand('seed', 12345 ); %#ok<RAND>
    randn('seed', 12345 ); %#ok<RAND>
    [A,P,F,X]=setup_test_system( 151, 173, 22, 20, r, 0.6 );
    F=X;
    
    F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
    b=tensor_to_vector(F);
    Pinv=stochastic_precond_mean_based( A );
    
    sigma_F=svd(reshape(b,tensor_size(F))); %#ok<NASGU>
    
    rho=simple_iteration_contractivity( A, Pinv );
    disp(rho);
    
    % solve by standard pcg
    A_fun=@(x)(tensor_operator_apply(A,x));
    Pinv_fun=@(x)(tensor_operator_apply(Pinv,x));
    [x,flag,info.relres,info.iter,resvec]=pcg(A_fun,b,1e-12,100,Pinv_fun);
    t=tic;
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
    cmptime=toc(t);
    
    sigma_X=svd(reshape(x,tensor_size(F))); %#ok<NASGU>
    last.r=r;
    last.N=N;
    last.M=M;
else
    disp( 'reusing model' );

end

trunc.eps=eps;
trunc.k_max=inf;
trunc.show_reduction=false;

options={'reltol', reltol,'maxiter', maxiter, 'abstol', abstol, 'verbosity', inf };
options=[options, {'trunc', trunc, 'trunc_mode', trunc_mode}];
options=[options, {'stag_steps', stag_steps, 'upratio_delta', upratio_delta, 'dynamic_eps', dynamic_eps}];

t=tic;
[X,flag,info]=generalized_solve_simple( A, F, 'Minv', Pinv, options{:}, 'solution', x   );
tt=toc(t);

if exist('x','var') && ~isempty(x)
    curr_err=norm( x-tensor_to_vector( X ) )/gvector_norm(x);
else
    curr_err=nan;
end
