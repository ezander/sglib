function K=load_kl_operator( name, version, mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type, varargin )

options=varargin2options( varargin{:} );
[silent,options]=get_option( options, 'silent', false );
[show_timings,options]=get_option( options, 'show_timings', true );
check_unsupported_options( options, mfilename );

compute_operator_kl( {silent, show_timings} );

op_filename=[name '.mat'];
K=cached_funcall(...
    @compute_operator_kl,...
    { mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type }, ...
    1,...
    op_filename, ...
    version );


function K=compute_operator_kl( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type )
persistent silent show_timings
if nargin==1 && iscell(mu_r_j)
    silent=mu_r_j{1};
    show_timings=mu_r_j{2};
else
    if ~silent; fprintf( 'recomputing kl-operator: %s', type ); end
    if show_timings; tic; end
    K=stochastic_operator_kl_pce( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type );
    if show_timings; toc; end
end