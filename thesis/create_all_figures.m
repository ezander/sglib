function create_all_figures( recreate_all )

global sglib_figdir

persistent ran_successful

if nargin>=1 && recreate_all
    ran_successful={};
end



sglib_figdir=fullfile( getenv('HOME'), 'projects/docs/stochastics/thesis/figures' );

root=get_mfile_path;
file_patterns={'mc/show_*', 'kl/show_*', 'pce/show_*', 'solution/show_*', 'ranfield/show_*'};

clc
clf
for i=1:length(file_patterns)
    pattern=file_patterns{i};
    pattern=fullfile(root,pattern);
    path=fileparts(pattern);
    s=dir(pattern);
    for j=1:length(s)
        filename=fullfile( path, s(j).name );
        if strmatch(filename, ran_successful, 'exact')
            fprintf( 'Skipping: %s\n', filename );
            continue;
        else
            fprintf( 'Running: %s\n', filename );
        end
        
        try
            run( filename );
            ran_successful=[ran_successful {filename}];
        catch
            fprintf( '==> Error in %s\n', makehyperlink( filename, filename, 'file' ) );
        end
        drawnow;
    end
end
