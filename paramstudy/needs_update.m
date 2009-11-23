function bool=needs_update( target, dependencies )

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

bool=false;

function num=filedate( file )
if ~exist(file)
    num=0;
else
    x=dir( file );
    num=datenum(x.date);
end
