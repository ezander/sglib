function obj=distribution_object( distribution, varargin )


pdf_func = str2func( [distribution '_pdf' ] );
cdf_func = str2func( [distribution '_cdf' ] );
stdnor_func = str2func( [distribution '_stdnor' ] );
moments_func = str2func( [distribution '_moments' ] );
params=varargin;

obj.params=params;
obj.pdf=@(x)(pdf_func(x,params{:}));
obj.cdf=@(x)(cdf_func(x,params{:}));
obj.stdnor=@(x)(stdnor_func(x,params{:}));
obj.moments=@()(moments_func(params{:}));
