info=struct();
info.param_str_map={
    'dist', '$value$';
    };
info=process_param( 'N', info );
info=process_param( 'geom', info );
info=process_param( 'dist', info );
info=process_param( 'dist_param', info );
info=process_param( 'dist_shift', info );
info=process_param( 'dist_scale', info );

info=process_param( 'solver', info, '$value$' );
info=process_param( 'reltol', info );
info=process_param( 'trunc_mode', info );
info=process_param( 'orth_mode', info );
info=process_param( 'eps_mode', info );
info=process_param( 'eps', info );

build_model_1d;
solve_pcg_1d;

relerr=trunc_mode;
num_prec=orth_mode;
num_iter=info.base;
rank=1;

