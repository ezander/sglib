function save_thesis_figure( handle, name, eps_params, png_params, latex_params )

if nargin<3
    eps_params={};
end
if nargin<4
    png_params={};
end
if nargin<5
    latex_params={};
end

if ischar(handle) && handle(1)=='$'
    orig_handle=handle;
    handle=findobj( 0, 'tag', handle );
    if length(handle)~=1
        hh=findobj( 0, 'tag', 'tempfig' );
        if isempty(hh)
            error( 'save_latex:string_handle', 'There should be one unique tag' );
        end
        close(hh);
        save_thesis_figure( orig_handle, name, eps_params, png_params, latex_params );
        return
    end
end
if ~ishandle( handle )
    save_thesis_figure( gca, handle, name, eps_params, png_params );
    return
end


figdir='/home/ezander/projects/docs/stochastics/thesis/figures/';
common_params={'figdir', figdir};

check_handle( handle, 'axes' );
[h_workaxis,h_workfig]=reparent_axes( handle );
set( h_workfig, 'renderer', 'painters' );

save_eps( h_workfig, name, common_params{:}, eps_params{:} );
save_png( h_workfig, name, common_params{:}, png_params{:} );
save_latex( h_workaxis, name, common_params{:}, latex_params{:} );

close( h_workfig );

