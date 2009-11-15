% this is purposefully a script
% all vars MUST be prefixed by NS_ (==no save) so they don't get in the way
NS_build=build;
if ~exist('NS_rebuild','var')
    NS_rebuild=false;
end
NS_last={};
NS_expr='^([^N]..|.[^S].|..[^_]|..?$)'; % match anything except stuff starting with NS_
NS_invexpr='^NS_'; % match anything starting with NS_

for NS_i=1:size(NS_build,1)
    NS_script=NS_build{NS_i,1};
    NS_target=NS_build{NS_i,2};
    NS_mdep=find_deps(NS_script);
    NS_dep={NS_last{:},NS_mdep{:}};
    if NS_rebuild || needs_update( NS_target, NS_dep )
        if ischar(NS_script)
            underline( ['Computing ', NS_target, ' (by ', NS_script, ')' ]);
            run( NS_script );
        else
            underline( ['Computing ', NS_target, ' (by ', func2str(NS_script), ')' ]);
            NS_script();
        end
        save( NS_target, '-v6', '-regexp', NS_expr );
    else
        underline( ['Loading ', NS_target]);
        system( strvarexpand( 'echo "Trying to load $NS_target$" >> autloader.log' ) );
        load( NS_target);
        system( strvarexpand( 'echo "Success." >> autloader.log' ) );
    end
    
    NS_last={NS_target,NS_last{:}};
end
clear( '-regexp', NS_invexpr );
