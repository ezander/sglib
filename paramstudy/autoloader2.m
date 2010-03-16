function autoloader2( build, last_target )

if nargin<2
    last_target='';
end
last={};
for i=1:size(build,1)
    script=build{i,1};
    target=build{i,2};
    if size(build,2)>=3
        extra_deps=build{i,3};
    else
        extra_deps={};
    end
    mdep=find_deps(script);
    dep={which(script),last{:},mdep{:},extra_deps{:}};
    if needs_update( target, dep )
        underline(['Running ', script]);
        post_run='';
        if ~isempty(target)
            post_run=[post_run sprintf('disp( ''--> Storing: %s'');', target )];
            post_run=[post_run sprintf('save( ''%s'' );', target )];
        end
        pre_run='';
        if ~isempty(last_target)
            pre_run=[pre_run sprintf('disp( ''--> Loading: %s''); ', last_target)];
            pre_run=[pre_run sprintf('load( ''%s'' );', last_target)];
        end
        for j=1:length(extra_deps)
            pre_run=[pre_run sprintf('disp( ''--> Loading: %s''); ', extra_deps{j})];
            pre_run=[pre_run sprintf('load( ''%s'' );', extra_deps{j})];
        end
        pre_run=[pre_run sprintf('post_run=''%s'';', strrep(post_run, '''', '''''') )];
        
        funcall( script, pre_run, post_run );
    else
        underline(['Nothing to be done for: ', script]);
    end
    
    last={target,last{:}};
    last_target=target;
end
