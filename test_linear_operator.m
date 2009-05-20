function test_linear_operator

%linear_operator_size
%linear_operator_apply
%linear_operator_solve
%linear_operator_compose


assert_set_function( 'apply_linear_operator' );


% there is not much point in bigger matrices here, just check that basic
% functionality works
M=[1, 2; 3, 4; 5, 10];
x=[1; 5];
y=M*x;

assert_equals( linear_operator_size( M ), [3,2], 'M_size' );
assert_equals( linear_operator_apply( M, x ), y, 'M' );

func={ @doit, {M}, {1} };
assert_equals( linear_operator_size( func ), [3,2], 'func_size' );
assert_equals( apply_linear_operator_apply( func, x ), y, 'func' );

func={ @apply_linear_operator, {M}, {1} };
assert_equals( linear_operator_size( func ), [3,2], 'rec_size' );
assert_equals( linear_operator_apply( func, x ), y, 'rec' );


function y=doit( M, x )
if isempty(x)
    y=size(M);
else
    y=M*x;
end


