Fi_vec=tensor_to_vector( Fi );

if ~exist('Ki_mat', 'var')
    tic; fprintf( 'Creating matrix (%dx%d): ', prod(tensor_operator_size(Ki)) );
    Ki_mat=tensor_operator_to_matrix(Ki);
    toc;
end
tic; fprintf( 'Solving (direct): ' );
Ui_vec=Ki_mat\Fi_vec;
toc;

vector_to_tensor;

Ui_true=Ui;
U_true=U;

