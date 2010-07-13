function ylim_extend( ha, interval )

lim=get( ha, 'ylim' );
lmin=min( [lim(:); interval(:)] );
lmax=max( [lim(:); interval(:)] );
set( ha, 'ylim', [lmin, lmax] );

%if mode