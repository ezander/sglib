function b=apply_linear_operator( A, x )

if nargin<2
    x=[];
end
sizeonly=isempty( x );

if isnumeric(A)
    % assume A is a matrix 
    if sizeonly
        b=size(A);
    else
        b=A*x;
    end
elseif isfunction(A)
    % A is an operator (size query must be handled by A)
    b=funcall( A, x );
else
    error( 'apply_linear_operator:type', 'linear operator is neither a matrix nor a function' );
end
