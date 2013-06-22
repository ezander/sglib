function [hn, hf]=reparent_axes( h, hf )

check_handle( h, 'axes' );

if nargin<2 || isempty(hf)
    hf=figure('visible', 'off');
    set( hf, 'tag', 'tempfig' );
end

hn=copyobj( h, hf );
set( hn, 'position', get(0,'defaultaxesposition') );
set( hn, 'PlotBoxAspectRatio', [1,1,1] );
set( hn, 'plotboxaspectratiomode', 'auto' );


lh=legend(h);
if ~isempty(lh)
    lhn=legend( hn, get( lh, 'String' ), 'interpreter', 'none' );
    for p={'Location', 'Orientation', 'Interpreter', 'Tag', 'Box', 'FontSize' }
        set( lhn, p{1}, get( lh, p{1} ) );
    end
end

map=colormap( h );
colormap( hn, map );