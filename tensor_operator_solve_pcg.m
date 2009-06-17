function [X,flag,relres,iter,info]=tensor_operator_solve_pcg( A, F, varargin )

options=varargin2options( varargin{:} );
[M,options]=get_option( options, 'M', [] );
[abstol,options]=get_option( options, 'abstol', 1e-5 );
[reltol,options]=get_option( options, 'reltol', 1e-5 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_options,options]=get_option( options, 'truncate_options', {} );
check_unsupported_options( options, mfilename );


null_vector=@tensor_null;
add=@tensor_add;
prec_solve=@tensor_operator_solve_elementary;
apply_operator=@tensor_operator_apply;
if isnumeric(F)
    truncate=@tensor_truncate;
    inner_prod=@(a,b)(a'*b);
    vec_norm=@norm;
else
    truncate=@tensor_truncate;
    inner_prod=@tensor_scalar_product;
    vec_norm=@tensor_norm;
end

iter=0;
flag=0;

Xc=null_vector(F);
Rc=add( F, apply_operator( A, Xc ), -1);
Zc=prec_solve( M, Rc );
Pc=Zc;

initres=vec_norm( Rc );

while true
    alpha=inner_prod(Rc,Zc)/inner_prod(Pc,apply_operator(A,Pc));
    Xn=add(Xc,Pc,alpha);
    Rn=add(Rc,apply_operator(A,Pc),-alpha);
    if vec_norm(Rn)<0.0001; break; end
    Zn=prec_solve(M,Rn);
    beta=inner_prod(Rn,Zn)/inner_prod(Rc,Zc);
    Pn=add(Zn,Pc,beta);
    
    % truncate all iteration variables
    Xc=truncate( Xn, truncate_options );
    Pc=truncate( Pn, truncate_options );
    Rc=truncate( Rn, truncate_options );
    Zc=truncate( Zn, truncate_options );

    % increment and check iteration counter
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end

    
    if false && mod(iter,100)==0
        keyboard
    end
end
X=truncate( Xn, truncate_options );

relres=vec_norm( Rc )/initres;
info=struct();

