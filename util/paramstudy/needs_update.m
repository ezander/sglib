function bool=needs_update( target, dependencies )

bool=false;
if ~strncmp( fliplr(target), fliplr('.mat'), 4 )
    target=[target, '.mat'];
end

if ~exist( target, 'file' )
    bool=true;
    return;
end

if ischar(dependencies)
    dependencies={dependencies};
end

n=length(dependencies);
for i=1:n
    dep=dependencies{i};
    if filedate(dep)>filedate(target)
        disp(['Needs rebuild: ', dep, ' => ', target]);
        bool=true;
        return;
    end
end


