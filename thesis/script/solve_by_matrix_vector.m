Fi_vec=tensor_to_vector( Fi );

if ~exist('Ki_mat', 'var')
    tic; fprintf( 'Creating matrix (%dx%d): ', prod(tensor_operator_size(Ki)) );
    Ki_mat=tensor_operator_to_matrix(Ki);
    toc;
end
solver_stats_start
Ui_vec=Ki_mat\Fi_vec;
U_vec=apply_boundary_conditions_solution( Ui_vec, G, P_I, P_B );
solver_stats_end

solution_vec2mat;
solution_mat2ten;

Ui_true=Ui;
U_true=U;

