if ~exist('model_base', 'var') || ~exist('solver_base', 'var') || ~exist('res_base', 'var')
   error( 'Params not correctly initialized. Please run "all_params.m" or set manually... ' );
end

build={
    'build_model',  sprintf( './mat/model-%s.mat', model_base ), {};
    'solve_model',  sprintf( './mat/solve-%s.mat', res_base ), {};
    'solve_model',  sprintf( './mat/solve-%s.mat', res_base ), {};
    'solve_model',  sprintf( './mat/solve-%s.mat', res_base ), {};
    'solve_model',  sprintf( './mat/solve-%s.mat', res_base ), {};
    'plot_results',  sprintf( './mat/results-%s.mat', res_base ), {};
    'plot_results',  sprintf( './mat/results-%s.mat', res_base ), {};
    };
autoloader2( build );


