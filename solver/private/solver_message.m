function os = solver_message( method, tol, maxiter, flag, iter, relres )

% TODO: need to rewrite from scratch, so it can be put under GPL (this is a
% copy from the MathWorks code which can't be directly accessed.)

if flag>0
    os = sprintf(['%s stopped at iteration %d without converging' ...
        ' to the desired tolerance %0.2g'], method, iter, tol);
end

switch(flag)

    case 0
        if (iter == 0)
            if isnan(relres)
                os = sprintf(['The right hand side vector is all zero ' ...
                    'so ' method '\nreturned an all zero solution ' ...
                    'without iterating.']);
            else
                os = sprintf(['The initial guess has relative residual %0.2g' ...
                    ' which is within\nthe desired tolerance %0.2g' ...
                    ' so ' method ' returned it without iterating.'], ...
                    relres,tol);
            end
        else
            os = sprintf([method ' converged at iteration %d to a solution' ...
                ' with relative residual %0.2g'],iter,relres);
        end
    case -1
        ratio=NaN;
        os = [os sprintf('\nbecause the update ratio (%d) deviated too much from 1.', ratio)];
       
    case 1
        os = [os sprintf('\nbecause the maximum number of iterations (%d) was reached.', maxiter)];
    case 2
        os = [os sprintf(['\nbecause the system involving the' ...
            ' preconditioner was ill conditioned.'])];
    case 3
        os = [os sprintf('\nbecause the method stagnated.')];
    case 4
        os = [os sprintf(['\nbecause a scalar quantity became too' ...
            ' small or too large to continue computing.'])];
    case 5
        os = [os sprintf(['\nbecause the preconditioner' ...
            ' is not symmetric positive definite.'])];
end

if (flag ~= 0)
    os = [os sprintf(['\nThe iterate returned (number %d)' ...
        ' has relative residual %0.2g'],iter,relres)];
    disp(os);
else
    disp(os);
end

