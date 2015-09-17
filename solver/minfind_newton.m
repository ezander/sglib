function [x,flag,iter]=minfind_newton(func, x0, varargin)

options=varargin2options(varargin,mfilename);
[maxiter, options]=get_option(options,'maxiter',100);
[abstol, options]=get_option(options,'abstol',1e-6);
[output_func, options]=get_option(options,'output_func',[]);
[verbosity, options]=get_option(options,'verbosity',0);
check_unsupported_options(options);


x=x0;
[f, df, ddf] = funcall(func, x);
tol=abstol*max(1,tensor_norm(df));
flag=1;
for iter=1:maxiter
    p = -ddf\df;
    [alpha, xn, yn] = line_search_armijo(func, x, p, f, df, 'stretch', false);
    %alpha = 1;
    %xn = x + alpha * p;
    if ~isempty(output_func)
        funcall(output_func, x, xn);
    end
    x = xn;
    if verbosity>0
        strvarexpand('minfind_newton: iter=$iter$, f=$f$, alpha=$alpha$');
    end
    if norm(df)<tol
        flag=0;
        break;
    end
    [f, df, ddf] = funcall(func, x);
end    

