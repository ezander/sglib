function b=apply_linear_operator( A, x )

sizeonly=ischar(x) && strcmp(x,'size');

if isnumeric(A)
    % assume A is a matrix 
    if sizeonly
        b=A*x;
    else
        b=size(A);
    end
elseif isfunction(A)
    % A is an operator (size query must be handled by A)
    b=funcall( A, x );
else
    error( 'apply_linear_operator:type', 'linear operator is neither a matrix nor a function' );
end
