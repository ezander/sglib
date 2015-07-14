function [x,flag,iter]=minfind_quasi_newton(func, x0, H0, varargin)

options=varargin2options(varargin,mfilename);
[maxiter, options]=get_option(options,'maxiter',100);
[abstol, options]=get_option(options,'abstol',1e-6);
[output_func, options]=get_option(options,'output_func',[]);
[verbosity, options]=get_option(options,'verbosity',0);
[line_search_func, options]=get_option(options, 'line_search_func', @line_search_armijo);
[line_search_opts, options]=get_option(options, 'line_search_opts', {});
[mode, options]=get_option(options, 'update_mode', 'BFGS');

check_unsupported_options(options);

x=x0;
H=H0;

flag=1;
[y, dy] = funcall(func, x);
tol=abstol*max(1,tensor_norm(dy));
for iter=1:maxiter
    p = -(H * dy);
    if isempty(line_search_func)
        alpha = 1;
        xn = tensor_add(x, p, alpha);
        [yn, dyn] = funcall(func, xn);
    else
        [alpha, xn, yn, dyn] = funcall(line_search_func, func, x, p, y, dy, line_search_opts); %#ok<ASGLU>
    end
    if ~isempty(output_func)
        funcall(output_func, x, xn);
    end
    
    s = tensor_add(xn, x, -1);
    yy = tensor_add(dyn, dy, -1);
    if isa(H, 'UpdatableOperator')
        H = H.update(yy, s);
    elseif isnumeric(H)
        if( norm(yy)==0 && norm(s)==0 )
            break;
        end
        [~, H] = qn_matrix_update(mode, [], H, yy, s);
        if any(isnan(H))
            %keyboard;
        end
    else
        error('sglib:minfind_quasi_newton', 'Cannot update H. Unknown type');
    end
    
    
    x = xn;
    y = yn;
    dy = dyn;
    if verbosity>0
        strvarexpand('minfind_quasi_newton: iter=$iter$, y=$y$, ||dy||=$tensor_norm(dy)$, alpha=$alpha$, $eig(H)$');
    end
    if tensor_norm(dy)<tol
        flag=0;
        break;
    end
    
    %%%%%%%%%%%%%%%%%%%%cheating: added by Noemi
    if any(isnan(H))
        flag=0;
        disp('Non were find in Hessian approx')
        break;
    end
    %%%%%%%%%%%%%%
end    

if flag
    info.method=mfilename;
    info.flag=flag;
    info.iter=iter;
    info.reltol=tol;
    info.maxiter=maxiter;
    info.relres=tensor_norm(dy)/tol;
    tensor_solver_message(info);
end