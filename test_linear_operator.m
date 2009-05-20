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
s=size(M);
linop1=linear_operator( M );
linop2={ size(M), {@mtimes, {M}, {1} } };
linop3={ linop2{:}, {@mldivide, {M}, {1} } };

assert_equals( linear_operator_size( M ), s, 'M_size' );
assert_equals( linear_operator_size( linop1 ), s, 'lo1_size' );
assert_equals( linear_operator_size( linop2 ), s, 'lo2_size' );
assert_equals( linear_operator_size( linop3 ), s, 'lo3_size' );

assert_equals( linear_operator_apply( M, x ), y, 'M_apply' );
assert_equals( linear_operator_apply( linop1, x ), y, 'lo1_apply' );
assert_equals( linear_operator_apply( linop2, x ), y, 'lo2_apply' );
assert_equals( linear_operator_apply( linop3, x ), y, 'lo3_apply' );


% compose




M=[1, 2, 3; 3, 4, 6; 5, 10, 14];
x=[1; 5; 7];
y=M*x;
s=size(M);
linop1=linear_operator( M );
linop2={ size(M), {@mtimes, {M}, {1} } };
linop3={ linop2{:}, {@mldivide, {M}, {1} } };

assert_equals( linear_operator_solve( M, y ), x, 'M_solve' );
assert_equals( linear_operator_solve( linop1, y ), x, 'lo1_solve' );
assert_equals( linear_operator_solve( linop2, y ), x, 'lo2_solve' );
assert_equals( linear_operator_solve( linop3, y ), x, 'lo3_solve' );

