function os = tensor_solver_message( info )

breakat = 60;

method = info.method;
flag = info.flag;
tol=info.reltol;
maxiter=info.maxiter;
iter=info.iter;
relres=info.relres;
if isfield(info, 'updvec')
    ratio=info.updvec(end);
end

% TODO: need to rewrite from scratch, so it can be put under GPL (this is a
% copy from the MathWorks code which can't be directly accessed.)

if flag~=0
    os = sprintf(['%s stopped at iteration %d without converging' ...
        ' to the desired tolerance %0.2g, '], method, iter, tol);
end

switch(flag)
    case 0
        if (iter == 0)
            if isnan(relres)
                os = sprintf(['The right hand side vector is all zero ' ...
                    'so ' method ' returned an all zero solution ' ...
                    'without iterating.']);
            else
                os = sprintf(['The initial guess has relative residual %0.2g' ...
                    ' which is within the desired tolerance %0.2g' ...
                    ' so ' method ' returned it without iterating.'], ...
                    relres,tol);
            end
        else
            os = sprintf([method ' converged at iteration %d to a solution' ...
                ' with relative residual %0.2g.'],iter,relres);
        end
    case -1
        os = [os sprintf('because the update ratio (%d) deviated too much from 1.', ratio)];
    case 1
        os = [os sprintf('because the maximum number of iterations (%d) was reached.', maxiter)];
    case 2
        os = [os sprintf(['because the system involving the' ...
            ' preconditioner was ill conditioned.'])];
    case 3
        os = [os sprintf('because the method stagnated.')];
    case 4
        os = [os sprintf(['because a scalar quantity became too' ...
            ' small or too large to continue computing.'])];
    case 5
        os = [os sprintf(['because the preconditioner' ...
            ' is not symmetric positive definite.'])];
end

if (flag ~= 0)
    os = [os sprintf([' The iterate returned (number %d)' ...
        ' has relative residual %0.2g.'],iter,relres)];
end

os=break_lines(os, breakat);

if nargout==0
    disp(os);
end


function str=break_lines(os, at)
delim=' ,.;:()[]';
str = '';
while ~isempty(os)
    if length(os)<=at
        str = [str os];
        break;
    end
    p = at;
    while isempty(strfind(delim, os(p)))
        p=p-1;
        if p==0; 
            p=at;
            break;
        end
    end
    str = sprintf('%s%s\n', str, os(1:p));
    os = os(p+1:end);
end



