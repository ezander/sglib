function filename_cmXXX=cache_model(model_cmXXX)

scripts_cmXXX=loader_scripts( model_cmXXX )
autoloader( scripts_cmXXX, false, 'caller' );
filename_cmXXX=scripts_cmXXX{end,2};
