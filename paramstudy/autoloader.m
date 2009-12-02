function autoloader( build, rebuild )

if nargin==0
    warning( 'autoloader should be called as a function now; using build-var from base workspace' );
    build=evalin('base',build');
end
if nargin<2
    rebuild=false;
end

last={};
toload='';

for i=1:size(build,1)
    script=build{i,1};
    target=build{i,2};
    script_deps=find_deps(script);
    all_deps={last{:},script_deps{:}};
    if rebuild || needs_update( target, all_deps )
        if ~isempty(toload)
            load_base(toload);
        end

        if isa(script, 'function_handle')
            cmd=func2str(script);
        else
            cmd=script;
        end
        underline( ['Computing ', target, ' (by ', cmd, ')' ]);
        evalin( 'base', cmd );
        
        save_base( target );
        toload='';
    else
        toload=target;
    end
    
    last={target,last{:}};
end
if ~isempty(toload)
    load_base(toload);
end


function load_base(filename)
underline( ['Loading ', filename]);
system( strvarexpand( 'echo "Trying to load $filename$" >> autoloader.log' ) );
cmd=sprintf('load(''%s'');', filename);
evalin('base',cmd);
system( strvarexpand( 'echo "Success." >> autoloader.log' ) );


function save_base(filename)
%underline( ['Saving ', filename]);
makesavepath( filename );
cmd=sprintf('save(''%s'', ''-v6'');', filename);
evalin('base',cmd);
