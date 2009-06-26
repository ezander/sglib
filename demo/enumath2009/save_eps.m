function save_eps( basename, topic );

filename=sprintf( '%s_%s.eps', basename, topic );
print( filename, '-depsc2' );
