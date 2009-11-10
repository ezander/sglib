if ~exist('model_base', 'var') || ~exist('solver_base', 'var') || ~exist('res_base', 'var')
   error( 'Params not correctly initialized. Please run "all_params.m" or set manually... ' );
end

build_model_target=sprintf( './mat/model-%s.mat', model_base );
build_model_params=sprintf( './mat/model_params-%s.mat', model_base );
plot_model_target=sprintf( './mat/plot-%s.mat', model_base );
solve_model_target=sprintf( './mat/solve-%s.mat', res_base );
solve_model_params=sprintf( './mat/solver_params-%s.mat', res_base );
plot_results_target=sprintf( './mat/results-%s.mat', res_base );



build={
    'build_model',  build_model_target, {build_model_params};
    'plot_model',   plot_model_target, {};
    };
autoloader2( build );

build={
    'solve_model',  solve_model_target, {solve_model_params, build_model_target};
    'plot_results', plot_results_target, {};
    };
autoloader2( build );
