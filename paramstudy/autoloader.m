function autoloader( build, rebuild, ws )

if nargin==0
    warning( 'autoloader should be called as a function now; using build-var from base workspace' );
    build=evalin('base',build');
end
if nargin<2
    rebuild=false;
end
if nargin<3
    ws='base';
end

last={};
toload='';

for i=1:size(build,1)
    script=build{i,1};
    if size(build,2)<2
        target=['.cache/', script, '.mat'];
    else
        target=build{i,2};
    end
    script_deps=find_deps(script);
    all_deps=[last(:);script_deps(:)];
    if rebuild || needs_update( target, all_deps )
        if ~isempty(toload)
            loadcmd=load_ws(toload);
            evalin(ws,loadcmd);
            system( strvarexpand( 'echo "Success." >> autoloader.log' ) );
        end

        if isa(script, 'function_handle')
            cmd=func2str(script);
        else
            cmd=script;
        end
        underline( ['Computing ', target, ' (by ', cmd, ')' ]);
        evalin( ws, cmd );
        
        savecmd=save_ws( target );
        evalin(ws,savecmd);
        
        toload='';
    else
        toload=target;
    end
    
    last={target,last{:}};
end
if ~isempty(toload)
    loadcmd=load_ws(toload);
    evalin(ws,loadcmd);
    system( strvarexpand( 'echo "Success." >> autoloader.log' ) );
end


function cmd=load_ws(filename)
underline( ['Loading ', filename]);
system( strvarexpand( 'echo "Trying to load $filename$" >> autoloader.log' ) );
cmd=sprintf('load(''%s'');', filename);


function cmd=save_ws(filename)
%underline( ['Saving ', filename]);
makesavepath( filename );
cmd=sprintf('save(''%s'', ''-v6'');', filename);
