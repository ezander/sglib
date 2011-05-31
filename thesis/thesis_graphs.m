%file_patterns={'sparsity/show_*', 'mc/show_*', 'kl/show_*', 'pce/show_*',
%'solution/show_*', 'ranfield/show_*'};
file_patterns={
    % Chapter 1: Introduction
    % Section 1.1: Summary
    'ranfield/show_mesh_and_sample',...
    % Chapter 6: Results
    % Section 6.1: Models
    %  - plot input random fields 
    'ranfield/show_input_random_fields', ...
    %  - plot the meshes used 
    'models/show_geometry', ...
    };


create_all_figures( file_patterns, 'recreate_all', false, 'ask', true, 'default_exec', true );
