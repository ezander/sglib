function K=load_kl_operator( name, version, mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type, varargin )

options=varargin2options( varargin{:} );
[silent,options]=get_option( options, 'silent', false );
[show_timings,options]=get_option( options, 'show_timings', true );
[use_waitbar,options]=get_option( options, 'use_waitbar', true );
check_unsupported_options( options, mfilename );

opt.silent=silent;
opt.show_timings=show_timings;
opt.use_waitbar=use_waitbar;
compute_operator_kl( opt );

op_filename=[name '.mat'];
K=cached_funcall(...
    @compute_operator_kl,...
    { mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type }, ...
    1,...
    op_filename, ...
    version );


function K=compute_operator_kl( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type )
persistent opt
if nargin==1 && isstruct(mu_r_j)
    opt=mu_r_j;
else
    if ~silent; fprintf( 'recomputing kl-operator: %s\n', type ); end
    if show_timings; tic; end
    K=stochastic_operator_kl_pce( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type, opt );
    if show_timings; toc; end
end