function [x,flag,relres,iter,resvec]=textbook_pcg( A, b, tol, maxiter, M )
tol=get_base_param('tol', 1e-6, 'caller' );
maxiter=get_base_param('maxiter', 100, 'caller' );
M=get_base_param('M', speye(size(A)), 'caller' );
x=zeros(size(b));

norm_r0=norm(b);
tolb=tol*norm_r0;
r=b-A*x;
flag=1;
resvec=[norm_r0];
for iter=1:maxiter
    z=M\r;
    rho=r'*z;
    if iter==1
        p=z;
    else
        beta=rho/rho_old;
        p=z+beta*p;
    end
    q=A*p;
    alpha=rho/(p'*q);
    x=x+alpha*p;
    r=r-alpha*q;
    
    resvec(end+1)=norm(r); %#ok<AGROW>
    if norm(r)<tolb
        flag=0;
        break;
    end
    
    rho_old=rho;
end
relres=norm(r)/norm_r0;
