function untested=munit_test_coverage

stats=munit_stats('get');
prefix=munit_options('get', 'prefix');

nocheck={'Contents', 'startup', 'testsuite' };

files=dir(sprintf( '%s/*.m', pwd ));
if nargout
    untested={};
end
for i=1:length(files)
    file=files(i);
    [path,name]=fileparts(file.name); %#ok
    fname=name;
    if ~strncmp( fname, prefix, length(prefix) ) && ~contains( nocheck, fname )
        found=contains( stats.tested_functions, fname );
        if ~found
            if nargout==0
                disp(fname);
            else
                untested={untested{:}, fname};
            end
        end
        if false
            fprintf( '%g: %s\n', found, fname);
        end
    end
end

function bool=contains( cellarr, str )
match=strmatch( str, cellarr, 'exact' );
bool=~isempty(match);
