function save_figure( name, params )

if nargin<2
    params={};
end

save_eps( name, params );
save_png( name, params );

