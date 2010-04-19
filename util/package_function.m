function package_function( fun, exportdir )

if nargin<2
    exportdir=getenv('HOME');
end
if nargin<1
    disp('No filename given' );
    return
end

[path,fun,ext]=fileparts(which(fun));
filename=[fun '.m'];


deps=find_deps( fun );

for i=1:length(deps)
    n=strfind( deps{i}, filename );
    if ~isempty(n)
        if n+length(filename)==length(deps{i})+1
            f=deps{i};
            deps(i)=[];
            deps=[{f}; deps];
            break;
        end
    end
end

disp(['Writing to: ', fullfile( exportdir, filename )] );
fid=fopen( fullfile( exportdir, filename ), 'w' );

for i=1:length(deps)
    disp(['   ', deps{i}] );
    if i~=1
        fprintf( fid, '\n%%Source: %s\n', deps{i});
    end
    fid2=fopen(deps{i},'r');
    s=fread( fid2, inf, '*char' )';
    fclose(fid2);
    
    fprintf( fid, '%s\n\n', s);
end

fclose(fid);
