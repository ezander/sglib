% this is purposefully a script
% all vars MUST be prefixed by NS_ (==no save) so they don't get in the way
NS_build=build;
NS_last={};
NS_expr='^([^N]..|.[^S].|..[^_]|..?$)'; % match anything except stuff starting with NS_
NS_invexpr='^NS_'; % match anything starting with NS_
NS_toload='';

for NS_i=1:size(NS_build,1)
    NS_script=NS_build{NS_i,1};
    NS_target=NS_build{NS_i,2};
    NS_mdep=find_deps(NS_script);
    NS_dep={NS_last{:},NS_mdep{:}};
    if NS_rebuild || needs_update( NS_target, NS_dep )
        if ~isempty(NS_toload)
            underline( ['Loading ', NS_toload]);
            system( strvarexpand( 'echo "Trying to load $NS_target$" >> autloader.log' ) );
            load( NS_toload);
            system( strvarexpand( 'echo "Success." >> autloader.log' ) );
        end
        if ischar(NS_script)
            underline( ['Computing ', NS_target, ' (by ', NS_script, ')' ]);
            run( NS_script );
        else
            underline( ['Computing ', NS_target, ' (by ', func2str(NS_script), ')' ]);
            NS_script();
        end
        makesavepath( NS_target );
        save( NS_target, '-v6', '-regexp', NS_expr );
        NS_toload='';
    else
        NS_toload=NS_target;
    end
    
    NS_last={NS_target,NS_last{:}};
end
if ~isempty(NS_toload)
    underline( ['Loading ', NS_toload]);
    system( strvarexpand( 'echo "Trying to load $NS_target$" >> autloader.log' ) );
    load(NS_toload);
    system( strvarexpand( 'echo "Success." >> autloader.log' ) );
end


clear( '-regexp', NS_invexpr );
