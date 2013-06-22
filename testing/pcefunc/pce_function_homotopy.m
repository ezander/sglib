function u_alpha=pce_function_homotopy( x_alpha, I_x, func_name, varargin )

options=varargin2options( varargin{:} );
[ode_solver,options]=get_option( options, 'ode_solver', @ode45 );
[x0,options]=get_option( options, 'x0', [] );
[u0,options]=get_option( options, 'u0', [] );
check_unsupported_options( options, mfilename );

if isempty(x0)~=isempty(u0)
    warning( 'pce_function:spec', 'x0 and u0 should be specified both (not only one of them, that''s risky)' );
end

switch func_name
    case 'exp'
        ode_func=@ode_exp_func;
        init_func=@exp;
    case {'ln', 'log' }
        ode_func=@ode_log_func;
        init_func=@log;
    case 'sqrt'
        ode_func=@ode_sqrt_func;
        init_func=@sqrt;
    otherwise
        error(['unknown function: ' func_name ]);
end


if isempty(x0) 
    x0=zeros(size(x_alpha));
    x0(:,1)=x_alpha(:,1);
end
if isempty(u0)
    u0=zeros(size(x0));
    u0(:,1)=init_func(x0(:,1));
end

sol=ode_solver( ode_func, [0 0.5 1], pce_to_colvec(u0), [], x_alpha, I_x, x0, u0 );
u_alpha=colvec_to_pce( sol.y(:,end), I_x );

function u=pce_to_colvec( u )
u=reshape(u,[],1);

function u=colvec_to_pce( u, I_x )
u=reshape(u,[],size(I_x,1));

function du=ode_exp_func(s,u,x_alpha,I_x,x0,u0)
s; u0; %#ok; don't complain about s and u0 being unused
% du=u*(x_alpha-x0);
u=colvec_to_pce( u, I_x );
tmp=x_alpha-x0;
du=pce_multiply( u, I_x, tmp, I_x, I_x );
du=pce_to_colvec( du );


function du=ode_log_func(s,u,x_alpha,I_x,x0,u0)
u; u0; %#ok; don't complain about s and u0 being unused
%du=(x_alpha-x0)/(x);
x=(1-s)*1+s*x_alpha;
tmp=x_alpha-x0;
du=pce_divide( x, I_x, tmp, I_x, I_x );
du=pce_to_colvec( du );



function du=ode_sqrt_func(s,u,x_alpha,I_x,x0,u0)
s; u0; %#ok; don't complain about s and u0 being unused
%du=(x_alpha-x0)/(2*u);
u=colvec_to_pce( u, I_x );
tmp=x_alpha-x0;
if 0
    du=pce_divide( 2*u, I_x, tmp, I_x, I_x );
else
    du=pce_divide( 2*u, I_x, 1, 0, I_x );
    du=pce_multiply( du, I_x, tmp, I_x, I_x );
end
du=pce_to_colvec( du );

