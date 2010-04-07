function create_all_figures

root=get_mfile_path;
file_patterns={'kl/show_kl_*', 'ranfield/show_*'};

clc
clf
for i=1:length(file_patterns)
    pattern=file_patterns{i};
    pattern=fullfile(root,pattern);
    path=fileparts(pattern);
    s=dir(pattern);
    for j=1:length(s)
        filename=fullfile( path, s(j).name );
        fprintf( 'Running: %s\n', filename );
        run( filename );
        drawnow;
    end
end

