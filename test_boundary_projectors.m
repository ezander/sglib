function test_boundary_projectors

assert_set_function( 'boundary_projectors' );
[P_B,P_I]=boundary_projectors( [1,3,5], 8 );

assert_equals( P_B*P_B', eye(3), 'proj_V_B' );
assert_equals( P_I*P_I', eye(5), 'proj_V_I' );
assert_equals( P_B'*P_B+P_I'*P_I, eye(8), 'id' );

Q_B=P_B'*P_B;
Q_I=P_I'*P_I;
assert_equals( Q_B*Q_B, Q_B, 'proj_B' );
assert_equals( Q_I*Q_I, Q_I, 'proj_I' );

