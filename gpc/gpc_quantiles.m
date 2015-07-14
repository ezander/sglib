function u_quantiles=gpc_quantiles(V_u, ui_alpha, varargin)

options=varargin2options(varargin);
[quantiles, options]=get_option(options, 'quantiles',[0.05, 0.95]);
[N, options]=get_option(options, 'N', 10000);
check_unsupported_options(options, mfilename);

samples=gpcgerm_sample(V_u, N);

u_samples=gpc_evaluate(ui_alpha, V_u, samples);
u_quantiles=quantile(u_samples', quantiles);

            