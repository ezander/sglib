function Minv=stochastic_preconditioner_deterministic( A )

R=tensor_operator_order( A );
Minv=cell( 1, R );
for i=1:R
    Minv{i}=operator_from_matrix( A{1,i}, 'solve' );
end
