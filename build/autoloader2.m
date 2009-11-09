function autoloader2( build, last_target )

if nargin<2
    last_target='';
end
last={};
for i=1:size(build,1)
    script=build{i,1};
    target=build{i,2};
    mdep=depfun(script,'-toponly','-quiet');
    dep={which(script),last{:},mdep{:}};
    if needs_update( target, dep )
        underline(['Running ', script]);
        if isempty(target)
            post_run='';
        else
            post_run=sprintf('disp( ''--> Storing: %s''); save( ''%s'' );', target, target );
        end
        if isempty(last_target)
            pre_run='';
        else
            pre_run=sprintf('disp( ''--> Loading: %s''); load( ''%s'' ); post_run=''%s'';', last_target, last_target, strrep(post_run, '''', '''''') );
        end
        
        funcall( script, pre_run, post_run );
    else
        underline(['Nothing to be done for: ', script]);
    end
    
    last={target,last{:}};
    last_target=target;
end
