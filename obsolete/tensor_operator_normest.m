function d=tensor_operator_normest( A_0 )
d=normest(A_0{1})*normest(A_0{2});

function d=tensor_operator_condest( A_0 ) %#ok
d=condest(A_0{1})*condest(A_0{2});
