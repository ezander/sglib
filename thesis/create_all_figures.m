function create_all_figures( file_patterns, varargin )

global sglib_figdir

persistent ran_successful


options=varargin2options(varargin)
[recreate_all,options]=get_option( options, 'recreate_all', false );
[ask,options]=get_option( options, 'ask', true );
[default_exec,options]=get_option( options, 'default_exec', false );
check_unsupported_options(options,mfilename);

sglib_figdir=fullfile( getenv('HOME'), 'projects/docs/stochastics/thesis/figures' );

root=get_mfile_path;

clc
clf
for i=1:length(file_patterns)
    pattern=file_patterns{i};
    if ~strcmp(pattern(end),'*') && ~strcmp(pattern(end-1:end),'.m')
        pattern=[pattern, '.m'];
    end
    fprintf( 'Pattern: %s\n', pattern );
    pattern=fullfile(root,pattern);
    path=fileparts(pattern);
    s=dir(pattern);
    for j=1:length(s)
        filename=fullfile( path, s(j).name );
        if ~recreate_all && ~isempty(strmatch(filename, ran_successful, 'exact'))
            fprintf( 'Skipping: %s\n', filename );
            continue;
        else
            fprintf( 'Running: %s\n', filename );
        end
        
        if ask
            exec=true;
            while true;
                if default_exec
                    ans=lower(input(sprintf( 'Execute %s? [Ynxarh?]', filename ), 's' ));
                else
                    ans=lower(input(sprintf( 'Execute %s? [yNxarh?]', filename ), 's' ));
                end
                switch ans
                    case 'y'; exec=true; break;
                    case 'n'; exec=false; break;
                    case 'x'; return;
                    case 'a'; exec=true; ask=false; recreate_all=false; break;
                    case 'r'; exec=true; ask=false; recreate_all=true; break;
                    case ''; exec=default_exec; break;
                    case {'h','?'}; 
                        fprintf( 'y=yes, n=no, x=exit, a=yes for all, r=recreate all, h?=help\n' ); 
                        if default_exec
                            fprintf( 'default is: yes\n' );
                        else
                            fprintf( 'default is: no\n' );
                        end
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
