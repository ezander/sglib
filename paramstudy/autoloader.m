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
            underline( ['Loading ', toload]);
            system( strvarexpand( 'echo "Trying to load $target$" >> autloader.log' ) );
            load_base(toload);
            system( strvarexpand( 'echo "Success." >> autoloader.log' ) );
        end
        if ischar(script)
            underline( ['Computing ', target, ' (by ', script, ')' ]);
            run( script );
        else
            underline( ['Computing ', target, ' (by ', func2str(script), ')' ]);
            script();
        end
        makesavepath( target );
        save( target, '-v6', '-regexp', expr );
        toload='';
    else
        toload=target;
    end
    
    last={target,last{:}};
end
if ~isempty(toload)
    underline( ['Loading ', toload]);
    system( strvarexpand( 'echo "Trying to load $target$" >> autoloader.log' ) );
    load_base(toload);
    system( strvarexpand( 'echo "Success." >> autoloader.log' ) );
end



function load_base(filename)
cmd=sprintf('load(%s);', filename);
evalin('base',cmd);




%%
build=build;
if ~exist('rebuild','var')
    rebuild=false;
end
last={};
expr='^([^N]..|.[^S].|..[^_]|..?$)'; % match anything except stuff starting with 
invexpr='^'; % match anything starting with 
toload='';

for i=1:size(build,1)
    script=build{i,1};
    target=build{i,2};
    mdep=find_deps(script);
    dep={last{:},mdep{:}};
    if rebuild || needs_update( target, dep )
        if ~isempty(toload)
            underline( ['Loading ', toload]);
            system( strvarexpand( 'echo "Trying to load $target$" >> autloader.log' ) );
            load( toload);
            system( strvarexpand( 'echo "Success." >> autoloader.log' ) );
        end
        if ischar(script)
            underline( ['Computing ', target, ' (by ', script, ')' ]);
            run( script );
        else
            underline( ['Computing ', target, ' (by ', func2str(script), ')' ]);
            script();
        end
        makesavepath( target );
        save( target, '-v6', '-regexp', expr );
        toload='';
    else
        toload=target;
    end
    
    last={target,last{:}};
end
if ~isempty(toload)
    underline( ['Loading ', toload]);
    system( strvarexpand( 'echo "Trying to load $target$" >> autloader.log' ) );
    load(toload);
    system( strvarexpand( 'echo "Success." >> autloader.log' ) );
end


clear( '-regexp', invexpr );
