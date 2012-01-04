function test_precondition_system

model_small_easy
%model_medium_easy

define_geometry
cache_script discretize_model
cache_script setup_equation
reltol=1e-12;
cache_script solve_by_standard_pcg
solution_vec2mat
solution_mat2ten

%%

% All output have to be small

%%
Ui_vec2=tensor_to_vector(Ui);
gvector_error(Ui_vec2,Ui_vec)
gvector_error( Fi_vec, tensor_to_vector(Fi), 'relerr', true )
gvector_error( Fi_vec, operator_apply( Ki, Ui_vec), 'relerr', true )

%%
F1 = operator_apply( Ki, Ui );

[Mi_inv2, Ki2, Fi2] = precondition_system( Mi, Mi_inv, Ki, Fi, 'basic' );
F2 = operator_apply( Ki2, Ui );
gvector_error( F1, F2, 'relerr', true )
gvector_error( Fi2, F2, 'relerr', true )

[Mi_inv2, Ki2, Fi2] = precondition_system( Mi, Mi_inv, Ki, Fi, 'inside' );
F2 = operator_apply( Ki2, Ui );
gvector_error( F1, F2, 'relerr', true )
gvector_error( Fi2, F2, 'relerr', true )

ilu_options={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
[Mi_inv2, Ki2, Fi2] = precondition_system( Mi, Mi_inv, Ki, Fi, 'ilu', ilu_options );
F2 = operator_apply( Ki2, Ui );
gvector_error( F1, F2, 'relerr', true )
gvector_error( Fi2, F2, 'relerr', true )

%%
[Mi_inv2, Ki2, Fi2] = precondition_system( Mi, Mi_inv, Ki, Fi, 'inside_res' );
F2 = operator_apply( Ki2, Ui );
gvector_error( Fi2, F2, 'relerr', true )

ilu_options={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
[Mi_inv2, Ki2, Fi2] = precondition_system( Mi, Mi_inv, Ki, Fi, 'ilu_res', ilu_options );
F2 = operator_apply( Ki2, Ui );
gvector_error( Fi2, F2, 'relerr', true )


%
F2 = operator_apply( Ki2, Ui );









%%
trunc.eps = 1e-4;
trunc.k_max=1000;
tr_func={@tensor_truncate_fixed, {trunc}, {2}};



disp('no residual')
% apply without truncation
Y1 = operator_apply(Ki, Ui);

% apply reverse with truncation
options={'pass_on', {'truncate_func', tr_func, 'reverse', true}};
Y2 = operator_apply(Ki, Ui, options{:});

% apply forward with truncation
options={'pass_on', {'truncate_func', tr_func, 'reverse', false}};
Y3 = operator_apply(Ki, Ui, options{:});

% apply reverse with truncation
options={'pass_on', {'truncate_func', tr_func, 'residual', false}};
Y4 = operator_apply(Ki, Ui, options{:});

options={'pass_on', {'truncate_func', tr_func}};
Y5 = operator_apply(Ki, Ui, options{:}, 'residual', false);

gvector_error( Y1, Y2, 'relerr', true )
gvector_error( Y1, Y3, 'relerr', true )
gvector_error( Y1, Y4, 'relerr', true )
gvector_error( Y1, Y5, 'relerr', true )


%%
disp('with residual')
% apply without truncation
Y1 = operator_apply(Ki, Ui, 'b', Fi, 'residual', true);

% apply reverse with truncation
options={'pass_on', {'truncate_func', tr_func, 'reverse', true}};
Y2 = operator_apply(Ki, Ui, 'b', Fi, options{:});

% apply forward with truncation
options={'pass_on', {'truncate_func', tr_func, 'reverse', false}};
Y3 = operator_apply(Ki, Ui, 'b', Fi, options{:});

% apply reverse with truncation
options={'pass_on', {'truncate_func', tr_func, 'residual', true}};
Y4 = operator_apply(Ki, Ui, 'b', Fi, 'residual', true, options{:});

options={'pass_on', {'truncate_func', tr_func}};
Y5 = operator_apply(Ki, Ui, 'b', Fi, options{:}, 'residual', true);

re = false;
gvector_error( Y1, Y2, 'relerr', re )
%gvector_error( Y3, Y2, 'relerr', re )
%gvector_error( Y4, Y2, 'relerr', re )
gvector_error( Y1, Y3, 'relerr', re )
gvector_error( Y1, Y4, 'relerr', re )
gvector_error( Y1, Y5, 'relerr', re )







function U=tensor_truncate_fixed( T, trunc, varargin )

U=tensor_truncate( T, 'eps', trunc.eps, 'k_max', trunc.k_max, varargin{:} );
%gvector_error( T, U, 'relerr', true )

if get_option( trunc, 'show_reduction', false )
    r1=tensor_rank(T);
    r2=tensor_rank(U);
    fprintf( 'fixd: %d->%d\n', r1, r2 );
    if r1>300
        keyboard;
    end
end
