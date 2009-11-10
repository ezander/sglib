% this is purposefully a script
% all vars MUST be prefixed by NS_ (==no save) so they don't get in the way
NS_build=build;
NS_last={};
NS_expr='^([^N]..|.[^S].|..[^_]|..?$)'; % match anything except stuff starting with NS_
NS_invexpr='^NS_'; % match anything starting with NS_

for NS_i=1:size(NS_build,1)
    NS_script=NS_build{NS_i,1};
    NS_target=NS_build{NS_i,2};
    NS_mdep=find_deps(NS_script);
    NS_dep={NS_script,NS_last{:},NS_mdep{:}};
    if needs_update( NS_target, NS_dep )
        underline(['Running ', NS_script]);
        run( NS_script );
        save( NS_target, '-regexp', NS_expr );
    else
        underline( ['Loading ', NS_target]);
        load( NS_target );
    end
    
    NS_last={NS_target,NS_last{:}};
end
clear( '-regexp', NS_invexpr );
