function create_all_figures( recreate_all, ask )

global sglib_figdir

persistent ran_successful

if nargin<1 
    recreate_all=false;
end
if nargin<2
    ask=true;
end

if recreate_all
    ran_successful={};
end


sglib_figdir=fullfile( getenv('HOME'), 'projects/docs/stochastics/thesis/figures' );

root=get_mfile_path;
file_patterns={'sparsity/show_*', 'mc/show_*', 'kl/show_*', 'pce/show_*', 'solution/show_*', 'ranfield/show_*'};

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
        
        if ask
            exec=true;
            while true;
                ans=lower(input(sprintf( 'Execute %s? [yN]', filename ), 's' ));
                switch ans
                    case 'y'; exec=true; break;
                    case 'n'; exec=false; break;
                    case 'x'; return;
                    case ''; exec=false; break;
                end
            end
            if ~exec
                continue;
            end
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
