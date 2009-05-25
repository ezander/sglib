function M=linear_operator_compose( M2, M1, varargin )

options=varargin2options( varargin{:} );
[step_solve,options]=get_option( options, 'step_solve', true );
check_unsupported_options( options, mfilename );

if isnumeric(M1) && isnumeric(M2)
    M=M2*M1;
else
    s1=linear_operator_size( M1 );
    s2=linear_operator_size( M2 );
    
    if step_solve
        M={ [s2(1), s1(2)], {@apply_two, {M1, M2}, {1,2} }, {@solve_two, {M1, M2}, {1,2} } };
    else
        M={ [s2(1), s1(2)], {@apply_two, {M1, M2}, {1,2} } };
    end
end

function z=apply_two( M1, M2, x )
y=linear_operator_apply( M1, x );
z=linear_operator_apply( M2, y );

function x=solve_two( M1, M2, z )
y=linear_operator_solve( M2, z );
x=linear_operator_solve( M1, y );
