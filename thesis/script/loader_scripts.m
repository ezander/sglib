function scripts=loader_scripts( model, exprefix )
scripts={model; 'define_geometry'; 'discretize_model'; 'setup_equation' };


prefix=fullfile(cache_file_base(), [mfilename, '_', script_name(model), '_']);
if nargin>=2
    prefix=[prefix exprefix];
end

makesavepath( prefix );

for i=1:size(scripts,1)
    target=[prefix, script_name(scripts{i,1}), '.mat'];
    scripts{i,2}=target;
end

function name=script_name( script )
if ischar(script)
    name=script;
else
    name=func2str(script);
end
