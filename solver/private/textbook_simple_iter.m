function [x,flag,relres,iter,resvec]=textbook_simple_iter( A, b, tol, maxiter, M )
tol=get_base_param('tol', 1e-6, 'caller' );
maxiter=get_base_param('maxiter', 100, 'caller' );
M=get_base_param('M', speye(size(A)), 'caller' );

x=zeros(size(b));
r=b;
norm_r0=norm(b);
resvec=[];
resvec(end+1)=norm_r0;

flag=1;
tolb=tol*norm_r0;
for iter=1:maxiter
    x=x+M\r;
    r=b-A*x;
    
    resvec(end+1)=norm(r); %#ok<AGROW>
    if norm(r)<tolb
        flag=0;
        break;
    end
end
relres=norm(r)/norm_r0;
