function Minv=stochastic_preconditioner_deterministic( A, use_lu )

if nargin<2
    use_lu=true;
end

R=tensor_operator_order( A );
Minv=cell( 1, R );
for i=1:R
    Minv{i}=operator_from_matrix( A{1,i}, true, 'use_lu', use_lu );
end
