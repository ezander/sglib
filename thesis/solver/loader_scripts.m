function scripts=loader_scripts( model )
scripts={model; 'define_geometry'; 'discretize_model'; 'setup_equation' };

prefix=[cache_file_base(), mfilename, '_', model, '_'];
makesavepath( prefix );

for i=1:size(scripts,1)
    target=[prefix, scripts{i,1}, '.mat'];
    scripts{i,2}=target;
end
